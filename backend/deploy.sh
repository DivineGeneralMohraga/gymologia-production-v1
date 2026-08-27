#!/usr/bin/env bash
#
# Update the Gymologia API on the EC2 box.
#
#   ssh ubuntu@13.232.161.2
#   cd /opt/gymologia && ./backend/deploy.sh
#
# Safe to run repeatedly. Pulls, rebuilds, restarts, and rolls back if the
# new container fails its health check.

set -euo pipefail

REPO_DIR="${REPO_DIR:-/opt/gymologia}"
ENV_FILE="${ENV_FILE:-/etc/gymologia/api.env}"
BRANCH="${BRANCH:-main}"
HEALTH_URL="${HEALTH_URL:-http://127.0.0.1:3000/api/v1/health}"

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
fail() { printf '\n\033[1;31mFAILED: %s\033[0m\n' "$*" >&2; exit 1; }

[ -f "$ENV_FILE" ] || fail "$ENV_FILE is missing. Create it before deploying (see DEPLOY-AWS.md)."

cd "$REPO_DIR" || fail "$REPO_DIR not found"

log "Current version"
git rev-parse --short HEAD

# Remember where we were, so a bad deploy can be undone.
PREVIOUS=$(git rev-parse HEAD)

log "Fetching $BRANCH"
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"
NEW=$(git rev-parse --short HEAD)
log "Now at $NEW"

cd "$REPO_DIR/backend"

log "Building the image"
docker compose build

log "Applying database migrations"
# Migrations run before the new code starts, in a throwaway container, so a
# failed migration stops the deploy instead of leaving the app running
# against a schema it does not understand.
docker compose run --rm --entrypoint sh api -c \
  'npx prisma migrate deploy' || fail "migration failed — nothing was restarted"

log "Restarting the API"
docker compose up -d --remove-orphans

log "Waiting for the health check"
for i in $(seq 1 30); do
  if curl -fsS -m 5 "$HEALTH_URL" >/dev/null 2>&1; then
    log "Healthy after ${i}0s"
    curl -fsS "$HEALTH_URL"; echo
    log "Deployed $NEW"
    docker image prune -f >/dev/null 2>&1 || true
    exit 0
  fi
  sleep 10
done

# Never leave a broken build serving traffic.
log "Health check never passed — rolling back to ${PREVIOUS:0:7}"
docker compose logs --tail 60 api || true
cd "$REPO_DIR"
git reset --hard "$PREVIOUS"
cd "$REPO_DIR/backend"
docker compose up -d --build
fail "rolled back to ${PREVIOUS:0:7}; see the logs above for why the new build did not come up"
