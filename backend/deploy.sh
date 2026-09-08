#!/usr/bin/env bash
#
# Update the Gymologia API on the EC2 box.
#
#   ssh ubuntu@65.0.75.45
#   cd /opt/gymologia && ./backend/deploy.sh
#
# Safe to run repeatedly. Pulls, installs, builds, migrates, restarts, and
# rolls back to the previous commit if the new build does not come healthy.

set -euo pipefail

REPO_DIR="${REPO_DIR:-/opt/gymologia}"
ENV_FILE="${ENV_FILE:-/etc/gymologia/api.env}"
SERVICE="${SERVICE:-gymologia}"
BRANCH="${BRANCH:-main}"
HEALTH_URL="${HEALTH_URL:-http://127.0.0.1:3000/api/v1/health}"

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m    %s\033[0m\n' "$*"; }
fail() { printf '\n\033[1;31mFAILED: %s\033[0m\n' "$*" >&2; exit 1; }

# Deploy whatever is already on disk instead of fetching it.
#
# The normal path fetches origin/$BRANCH and resets to it. That is the right
# way round when there IS a remote; it stopped being possible when the
# GitHub repository began answering "Repository not found", which blocks the
# deploy at its first real step regardless of anything else being ready.
#
# With --no-pull you put the code on the box yourself -- rsync, scp, a
# tarball -- and this script does the rest: install, generate, build,
# migrate, restart, health-gate.
#
# READ THIS BEFORE USING IT. A no-pull deploy CANNOT BE ROLLED BACK. The
# rollback below works by resetting to the commit that was checked out
# before the fetch, and without a fetch there is no earlier state to return
# to: the working tree already is the new code. The script says so at the
# point it would otherwise have rolled back, rather than running a reset
# that quietly does nothing and reporting success.
SKIP_PULL="${SKIP_PULL:-}"
for arg in "$@"; do
  case "$arg" in
    --no-pull) SKIP_PULL=1 ;;
    *) fail "unknown argument: $arg" ;;
  esac
done

# ── Preflight ─────────────────────────────────────────────────────────
[ -f "$ENV_FILE" ] || fail "$ENV_FILE is missing. See backend/DEPLOY-AWS.md."
command -v node >/dev/null || fail "node is not installed. See backend/DEPLOY-AWS.md."

# systemd injects $ENV_FILE when it starts the service, but this script is
# not systemd. `prisma migrate deploy` runs here, in a plain shell, and
# reads DATABASE_URL and DIRECT_URL from its own environment — so the file
# has to be loaded explicitly or the migration step fails with
# "Environment variable not found: DIRECT_URL".
log "Loading $ENV_FILE"
if [ -r "$ENV_FILE" ]; then
  set -a; . "$ENV_FILE"; set +a
else
  # Root-owned and unreadable by this user: read it through sudo instead.
  ENV_CONTENT=$(sudo cat "$ENV_FILE") || fail "cannot read $ENV_FILE"
  set -a; eval "$ENV_CONTENT"; set +a
  unset ENV_CONTENT
fi
[ -n "${DATABASE_URL:-}" ] || fail "DATABASE_URL is not set in $ENV_FILE"
[ -n "${DIRECT_URL:-}" ]   || fail "DIRECT_URL is not set in $ENV_FILE"

NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]')
if [ "$NODE_MAJOR" -lt 20 ]; then
  fail "Node $NODE_MAJOR is too old — this build needs 20 or newer (24 is what it was tested on)."
fi
[ "$NODE_MAJOR" -lt 24 ] && warn "Node $NODE_MAJOR detected; the build is tested on 24."

cd "$REPO_DIR" || fail "$REPO_DIR not found"

# Where to return to if this goes wrong.
#
# Only meaningful when there is a git checkout to return TO. With --no-pull
# the code got here by rsync, scp or a tarball and there may be no .git at
# all -- which is exactly the situation --no-pull was added for, so asking
# git for a commit first killed the script before it did any work. The
# rollback paths below already refuse to run under --no-pull for the same
# reason, so nothing is lost by not having it.
if git rev-parse --git-dir >/dev/null 2>&1; then
  PREVIOUS=$(git rev-parse HEAD)
  log "Currently at $(git rev-parse --short HEAD)"
else
  PREVIOUS=""
  [ -n "$SKIP_PULL" ] || fail "$REPO_DIR is not a git checkout. Use --no-pull."
  warn "No git checkout here; nothing records which commit is being deployed."
fi

# ── Pull ──────────────────────────────────────────────────────────────
if [ -n "$SKIP_PULL" ]; then
  warn "--no-pull: deploying the working tree as it stands, not fetching."
  warn "This deploy CANNOT be rolled back automatically."
  if ! git diff --quiet 2>/dev/null || [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    warn "The working tree has uncommitted changes. That is allowed here,"
    warn "but it means nothing records what was deployed."
  fi
else
  log "Fetching $BRANCH"
  git fetch origin "$BRANCH"     || fail "could not fetch origin/$BRANCH. If the remote is unreachable, put the code on the box yourself and re-run with --no-pull."
  git reset --hard "origin/$BRANCH"
  log "Now at $(git rev-parse --short HEAD)"
fi

build_and_start() {
  cd "$REPO_DIR/backend" || return 1

  log "Installing dependencies"
  # `npm ci` wipes node_modules and installs exactly what the lockfile says.
  #
  # --include=dev is not optional and not a style choice. This script sources
  # $ENV_FILE a few lines up, because `prisma migrate deploy` needs
  # DATABASE_URL -- and that file sets NODE_ENV=production, which npm reads
  # as "omit devDependencies". The nest CLI is a devDependency, so without
  # this flag the compile below fails with `sh: 1: nest: not found` on a box
  # that has 365MB of node_modules sitting right there.
  npm ci --no-audit --no-fund --include=dev || return 1

  log "Generating the Prisma client"
  npx prisma generate || return 1

  log "Compiling"
  npm run build || return 1

  # Proof, not inference. `npm run build` exiting 0 is not the same as the
  # entry point existing, and the thing systemd is about to run is this file.
  [ -f dist/main.js ] || { warn "build produced no dist/main.js"; return 1; }

  log "Applying database migrations"
  # Before the restart, so a failed migration stops the deploy instead of
  # leaving the API running against a schema it does not understand.
  npx prisma migrate deploy || return 1
}

# Every step inside build_and_start ends in `|| return 1` because bash
# TURNS OFF errexit inside a function used as an `if` condition -- the
# `set -euo pipefail` at the top of this file does not reach in here. Before
# that was true of the code rather than just the comment, a failed compile
# followed by a successful migration returned 0 from this function and the
# service was restarted with no build at all.
if ! build_and_start; then
  if [ -n "$SKIP_PULL" ]; then
    warn "Build failed. There is nothing to roll back to: --no-pull means the"
    warn "working tree already was the new code. The running service was not"
    warn "restarted, so it is still serving the previous build."
    fail "build failed; service left untouched, no rollback possible"
  fi
  log "Build failed — rolling back to ${PREVIOUS:0:7}"
  cd "$REPO_DIR" && git reset --hard "$PREVIOUS"
  fail "build failed; the running service was left untouched"
fi

log "Restarting $SERVICE"
sudo systemctl restart "$SERVICE"

# ── Health gate ───────────────────────────────────────────────────────
log "Waiting for the health check"
for i in $(seq 1 20); do
  if curl -fsS -m 5 "$HEALTH_URL" >/dev/null 2>&1; then
    printf '\n'
    curl -fsS "$HEALTH_URL"; printf '\n'
    if [ -n "$PREVIOUS" ]; then
      log "Deployed $(git -C "$REPO_DIR" rev-parse --short HEAD)"
    else
      log "Deployed the working tree (no git checkout to name a commit)"
    fi
    exit 0
  fi
  sleep 5
done

# ── Rollback ──────────────────────────────────────────────────────────
journalctl -u "$SERVICE" -n 60 --no-pager || true

if [ -n "$SKIP_PULL" ]; then
  warn "Health check never passed, and --no-pull leaves nothing to return to."
  warn "The service is running the new build and is NOT healthy. Restore the"
  warn "previous code on the box by hand and re-run."
  fail "unhealthy after deploy; no rollback possible with --no-pull"
fi

log "Health check never passed — rolling back to ${PREVIOUS:0:7}"
cd "$REPO_DIR"
git reset --hard "$PREVIOUS"
cd "$REPO_DIR/backend"
npm ci --no-audit --no-fund && npx prisma generate && npm run build
sudo systemctl restart "$SERVICE"

warn "Rolled back. Note that migrations are NOT undone — if this deploy ran one,"
warn "the old code is now running against the newer schema."
fail "rolled back to ${PREVIOUS:0:7}; see the log above for why it did not come up"
