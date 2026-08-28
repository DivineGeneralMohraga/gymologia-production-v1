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
PREVIOUS=$(git rev-parse HEAD)
log "Currently at $(git rev-parse --short HEAD)"

# ── Pull ──────────────────────────────────────────────────────────────
log "Fetching $BRANCH"
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"
log "Now at $(git rev-parse --short HEAD)"

build_and_start() {
  cd "$REPO_DIR/backend"

  log "Installing dependencies"
  # `npm ci` wipes node_modules and installs exactly what the lockfile
  # says. Dev dependencies are needed here because the TypeScript build
  # runs on the box.
  npm ci --no-audit --no-fund

  log "Generating the Prisma client"
  npx prisma generate

  log "Compiling"
  npm run build

  log "Applying database migrations"
  # Before the restart, so a failed migration stops the deploy instead of
  # leaving the API running against a schema it does not understand.
  npx prisma migrate deploy
}

if ! build_and_start; then
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
    log "Deployed $(git -C "$REPO_DIR" rev-parse --short HEAD)"
    exit 0
  fi
  sleep 5
done

# ── Rollback ──────────────────────────────────────────────────────────
log "Health check never passed — rolling back to ${PREVIOUS:0:7}"
journalctl -u "$SERVICE" -n 60 --no-pager || true

cd "$REPO_DIR"
git reset --hard "$PREVIOUS"
cd "$REPO_DIR/backend"
npm ci --no-audit --no-fund && npx prisma generate && npm run build
sudo systemctl restart "$SERVICE"

warn "Rolled back. Note that migrations are NOT undone — if this deploy ran one,"
warn "the old code is now running against the newer schema."
fail "rolled back to ${PREVIOUS:0:7}; see the log above for why it did not come up"
