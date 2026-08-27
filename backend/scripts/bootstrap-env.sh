#!/usr/bin/env bash
#
# Build /etc/gymologia/api.env for the new backend.
#
#   sudo /opt/gymologia/backend/scripts/bootstrap-env.sh [path-to-old-.env]
#
# Carries the working credentials over from the v1 backend's .env — the
# database URLs, MSG91 and Cashfree — and generates the four crypto secrets
# fresh. Prints what it could not fill in.
#
# Nothing interactive: safe to run from a pasted block.

set -euo pipefail

OUT="${OUT:-/etc/gymologia/api.env}"
OLD_ENV="${1:-}"

log()  { printf '\033[1;36m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m !  %s\033[0m\n' "$*"; }
fail() { printf '\033[1;31mFAILED: %s\033[0m\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || fail "run with sudo — $OUT is root-owned"

# ── Locate the old .env ───────────────────────────────────────────────
if [ -z "$OLD_ENV" ]; then
  log "Looking for the v1 backend's .env"
  for candidate in \
    /home/ubuntu/gymologia/backend/.env \
    /home/ubuntu/backend/.env \
    /opt/gymologia-v1/backend/.env \
    /srv/gymologia/backend/.env
  do
    [ -f "$candidate" ] && OLD_ENV="$candidate" && break
  done
  # Fall back to asking the running process where it lives.
  if [ -z "$OLD_ENV" ]; then
    PID=$(ss -tlnp 2>/dev/null | grep -oP ':4000\s.*pid=\K[0-9]+' | head -1 || true)
    if [ -n "$PID" ] && [ -e "/proc/$PID/cwd" ]; then
      CWD=$(readlink -f "/proc/$PID/cwd")
      [ -f "$CWD/.env" ] && OLD_ENV="$CWD/.env"
    fi
  fi
fi

if [ -n "$OLD_ENV" ] && [ -f "$OLD_ENV" ]; then
  log "Reading $OLD_ENV"
else
  warn "No old .env found — every value will need filling in by hand."
  OLD_ENV=""
fi

# Reads one key out of the old file without sourcing it, so a stray command
# substitution in there cannot execute as root.
old() {
  [ -z "$OLD_ENV" ] && { printf ''; return; }
  sed -nE "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*//p" "$OLD_ENV" \
    | head -1 | sed -E 's/^"(.*)"$/\1/; s/^'\''(.*)'\''$/\1/'
}

gen()    { node -e 'console.log(require("crypto").randomBytes(48).toString("base64url"))'; }
genhex() { node -e 'console.log(require("crypto").randomBytes(32).toString("hex"))'; }

command -v node >/dev/null || fail "node is required to generate secrets"

# ── Carry over ────────────────────────────────────────────────────────
DB_URL=$(old DATABASE_URL)
DIRECT=$(old DIRECT_URL)
MSG91_KEY=$(old MSG91_AUTH_KEY)
MSG91_WIDGET=$(old MSG91_WIDGET_ID)
MSG91_TOKEN=$(old MSG91_WIDGET_TOKEN)
CF_ID=$(old CASHFREE_CLIENT_ID)
CF_SECRET=$(old CASHFREE_CLIENT_SECRET)
CF_ENV=$(old CASHFREE_ENV)
CF_PAYOUT_ID=$(old CASHFREE_PAYOUT_CLIENT_ID)
CF_PAYOUT_SECRET=$(old CASHFREE_PAYOUT_CLIENT_SECRET)
SMTP_HOST=$(old SMTP_HOST)
SMTP_PORT=$(old SMTP_PORT)
SMTP_USER=$(old SMTP_USER)
SMTP_PASS=$(old SMTP_PASS)

# The v1 direct URL points at db.<ref>.supabase.co:5432, which is IPv6-only
# and unreachable from a default EC2 instance — migrations would fail. The
# session pooler is the IPv4 equivalent and handles DDL.
if printf '%s' "$DIRECT" | grep -q 'db\..*\.supabase\.co:5432'; then
  warn "Old DIRECT_URL uses the IPv6-only endpoint; rewriting to the session pooler."
  REF=$(printf '%s' "$DIRECT" | sed -nE 's#.*@db\.([a-z0-9]+)\.supabase\.co.*#\1#p')
  PW=$(printf '%s' "$DIRECT" | sed -nE 's#postgresql://postgres:([^@]+)@.*#\1#p')
  REGION=$(printf '%s' "$DB_URL" | sed -nE 's#.*@aws-0-([a-z0-9-]+)\.pooler.*#\1#p')
  REGION="${REGION:-ap-southeast-1}"
  if [ -n "$REF" ] && [ -n "$PW" ]; then
    DIRECT="postgresql://postgres.${REF}:${PW}@aws-0-${REGION}.pooler.supabase.com:5432/postgres"
  fi
fi

[ -z "$CF_ENV" ] && CF_ENV=production

# Sandbox Cashfree credentials mean this cannot be a live deployment, so
# default the stage to staging rather than writing a file that refuses to
# boot. An operator going live flips both together.
if [ "$CF_ENV" = "production" ]; then STAGE=production; else STAGE=staging; fi

mkdir -p "$(dirname "$OUT")"

# ── Write ─────────────────────────────────────────────────────────────
# systemd parses this file itself, not through a shell: no `export`, no
# spaces around `=`, and no inline comments after a value.
cat > "$OUT" <<EOF
# Gymologia API — production environment
# Generated $(date -u +%Y-%m-%dT%H:%M:%SZ)

NODE_ENV=production
# staging  — sandbox payment credentials allowed, webhook secret optional.
# production — everything enforced. Switch to this before taking real money.
APP_STAGE=${STAGE}
PORT=3000
API_PREFIX=api/v1

# Transaction pooler for runtime, session pooler for migrations.
DATABASE_URL="${DB_URL}"
DIRECT_URL="${DIRECT}"

# Generated fresh. ENCRYPTION_KEY decrypts KYC numbers and UPI handles —
# if it is lost or changed, those rows are unreadable forever.
JWT_ACCESS_SECRET=$(gen)
JWT_REFRESH_SECRET=$(gen)
JWT_ACCESS_TTL=15m
JWT_REFRESH_TTL=30d
ENCRYPTION_KEY=$(genhex)
OTP_PEPPER=$(gen)

# With WIDGET_ID and WIDGET_TOKEN both set, OTP delivery uses MSG91's
# widget API and its DLT-approved template. Without the token it falls
# back to the direct API, which needs a template of our own.
MSG91_AUTH_KEY=${MSG91_KEY}
MSG91_WIDGET_ID=${MSG91_WIDGET}
MSG91_WIDGET_TOKEN=${MSG91_TOKEN}
MSG91_OTP_TTL_SECONDS=300
MSG91_OTP_LENGTH=6

CASHFREE_ENV=${CF_ENV}
CASHFREE_CLIENT_ID=${CF_ID}
CASHFREE_CLIENT_SECRET=${CF_SECRET}
CASHFREE_WEBHOOK_SECRET=
CASHFREE_PAYOUT_CLIENT_ID=${CF_PAYOUT_ID}
CASHFREE_PAYOUT_CLIENT_SECRET=${CF_PAYOUT_SECRET}
CASHFREE_VERIFY_CLIENT_ID=
CASHFREE_VERIFY_CLIENT_SECRET=

SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
SUPABASE_ANON_KEY=

SUPPORT_EMAIL=support@gymologia.com
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT:-587}
SMTP_USER=${SMTP_USER}
SMTP_PASS=${SMTP_PASS}

PLAN_BASIC_PAISE=59900
PLAN_PRO_PAISE=119900
TRIAL_DAYS=7
REFERRAL_REWARD_PAISE=5000
REFERRAL_DISCOUNT_PERCENT=10
UPI_VERIFY_DEDUCTION_PAISE=1000
MAX_MEMBER_LEAVE_DAYS_DEFAULT=30
EOF

chmod 600 "$OUT"

# deploy.sh has to read this too — it loads the file itself for the
# migration step, since it is not systemd. Owned by the deploy user, still
# unreadable by anyone else; systemd runs as root and can read it either way.
DEPLOY_USER=$(stat -c '%U' /opt/gymologia 2>/dev/null || echo ubuntu)
chown "$DEPLOY_USER:$DEPLOY_USER" "$OUT" 2>/dev/null || true

log "Wrote $OUT (stage: $STAGE, owner: $DEPLOY_USER)"

# ── Report ────────────────────────────────────────────────────────────
MISSING=""
[ -z "$DB_URL" ]     && MISSING="$MISSING DATABASE_URL"
[ -z "$DIRECT" ]     && MISSING="$MISSING DIRECT_URL"
[ -z "$MSG91_KEY" ]  && MISSING="$MISSING MSG91_AUTH_KEY"
[ -z "$CF_ID" ]      && MISSING="$MISSING CASHFREE_CLIENT_ID"
[ -z "$CF_SECRET" ]  && MISSING="$MISSING CASHFREE_CLIENT_SECRET"

printf '\n'
if [ -n "$MISSING" ]; then
  warn "Carried over nothing for:$MISSING"
  warn "Fill these in before deploying:  sudo nano $OUT"
else
  log "All required values carried over."
fi

if [ -z "$MSG91_TOKEN" ]; then
  warn "MSG91_WIDGET_TOKEN is empty — OTP falls back to the direct API,"
  warn "which India will not deliver without your own DLT template."
  warn "The v1 backend used the widget; find its token and set it here."
fi

if [ "$STAGE" = "staging" ]; then
  warn "APP_STAGE=staging: sandbox payments, webhook secret not required."
  warn "Set APP_STAGE=production and real Cashfree keys before going live."
elif [ -z "$(old CASHFREE_WEBHOOK_SECRET)" ]; then
  warn "CASHFREE_WEBHOOK_SECRET is empty and APP_STAGE=production."
  warn "The app will REFUSE TO BOOT — get it from the Cashfree dashboard."
fi

printf '\n'
log "Review with:  sudo cat $OUT"
