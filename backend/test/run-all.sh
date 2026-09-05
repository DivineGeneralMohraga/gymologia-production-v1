#!/usr/bin/env bash
#
# Every suite, in order, with a correct tally.
#
#   bash test/run-all.sh
#
# Run against the compiled build. Start it DETACHED, or it dies with the
# shell that launched it and every suite after that fails at setup looking
# like a real regression:
#
#   npm run build
#   powershell -c "Start-Process node -ArgumentList 'dist/main.js' #     -WorkingDirectory (Get-Location) -RedirectStandardOutput server.log #     -WindowStyle Hidden"
#
# On a normal Unix host, `nohup node dist/main.js &` does the same job.
#
# Never against `npm run start:dev` -- watch mode restarts the server when a
# file changes, and editing anything mid-run produces a scatter of failures
# that look like regressions and are not.
#
# The cooldown between suites is not padding. /auth/otp/request is rate
# limited to 5 per minute per IP, which is correct for a login endpoint and
# means seven suites back to back exhaust the quota and fail at setup with a
# 401 that has nothing to do with the code under test.
#
# THIS RUN TAKES ABOUT HALF AN HOUR. Thirteen cooldowns are fourteen minutes
# on their own, before a single request is sent. Start it in the background
# and let it finish; do not run it inside anything that will time out and
# kill the process group. That happened once: the run was killed at the ten
# minute mark, the server -- a child of the same shell -- was killed with
# it, and payments-e2e stopped mid-suite looking exactly like a regression
# in the security change that had just been made. It was not. Detaching the
# server, as the block above says, is half the fix; the other half is not
# putting a thirty minute job on a ten minute leash.

set -u

SUITES="
unit-specs
ip-block-e2e
crm-e2e
crm-management-e2e
payments-e2e
events-notifications-e2e
maintenance-e2e
chat-e2e
analytics-trainers-e2e
roles-e2e
admin-e2e
ranking-e2e
kyc-e2e
kyc-review-e2e
uploads-e2e
storage-url-e2e
"

API="${API:-http://localhost:3000/api/v1}"
OUT="${OUT:-/tmp}"
COOLDOWN="${COOLDOWN:-65}"

cd "$(dirname "$0")/.." || exit 1

if [ "$(curl -s -o /dev/null -w '%{http_code}' "$API/health")" != "200" ]; then
  printf "\033[31mNo server on %s.\033[0m Start it with: npm run build && node dist/main.js\n" "$API"
  exit 1
fi

# Refuse to start while another run is in progress. Two regressions against
# one database fight over the same accounts and produce failures that look
# like real regressions -- that cost a confusing debugging cycle once, and a
# stale lock directory is far cheaper than repeating it.
LOCK="${OUT}/gymologia-e2e.lock"
if ! mkdir "$LOCK" 2>/dev/null; then
  printf '%s\n' 'Another run is already going.'
  printf 'If that is wrong, remove %s and try again.\n' "$LOCK"
  exit 1
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT INT TERM

TOTAL=0
# Counted rather than written down: the summary said "10 suites" for as
# long as there happened to be ten, and went quietly wrong the moment four
# more were added. A number in a report should come from the thing it
# reports on.
RAN=0
FAILED=0
BROKEN=""
FIRST=1

for suite in $SUITES; do
  [ -z "$suite" ] && continue

  # Cooldown before each suite except the first, so the OTP quota has
  # recovered by the time the suite tries to sign anybody in.
  if [ "$FIRST" = "0" ]; then
    sleep "$COOLDOWN"
  fi
  FIRST=0

  printf "\033[1m%s\033[0m ... " "$suite"
  bash "test/$suite.sh" > "$OUT/$suite.out" 2>&1
  code=$?

  # Count the check lines, not every line containing PASS. What separates a
  # real check from the suite's own "ALL CHECKS PASSED" banner is the
  # indent: a check is two spaces in, the banner starts at column 0.
  #
  # Colour is optional here on purpose. The shell suites print PASS wrapped
  # in escape codes; the TypeScript specs print it plain. Keying the count
  # on the colour reset -- as this did -- scored every plain-text spec zero
  # while it sat there passing, which is a quiet undercount and exactly the
  # kind of number this runner exists to get right.
  #
  # `grep -c` already prints 0 and exits 1 when nothing matches, so adding
  # `|| echo 0` appends a SECOND zero and the arithmetic below dies on the
  # two-line result. Swallow the exit status rather than adding to output.
  passes=$(grep -cE '^  (.\[32m)?PASS(.\[0m)?  ' "$OUT/$suite.out" 2>/dev/null) || true
  fails=$(grep -cE '^  (.\[31m)?FAIL(.\[0m)?  ' "$OUT/$suite.out" 2>/dev/null) || true
  passes=${passes:-0}
  fails=${fails:-0}

  TOTAL=$((TOTAL + passes))
  RAN=$((RAN + 1))
  FAILED=$((FAILED + fails))

  if [ "$code" = "0" ] && [ "$fails" = "0" ]; then
    printf "\033[32m%s passed\033[0m\n" "$passes"
  else
    printf "\033[31m%s passed, %s FAILED\033[0m  (%s/%s.out)\n" \
      "$passes" "$fails" "$OUT" "$suite"
    BROKEN="$BROKEN $suite"
  fi
done

printf "\n"
if [ "$FAILED" = "0" ] && [ -z "$BROKEN" ]; then
  printf "\033[32m%s checks passed across %s suites.\033[0m\n" "$TOTAL" "$RAN"
  exit 0
fi

printf "\033[31m%s passed, %s failed.\033[0m Look at:%s\n" "$TOTAL" "$FAILED" "$BROKEN"
for suite in $BROKEN; do
  printf "\n\033[1m%s\033[0m\n" "$suite"
  grep -E 'FAIL' "$OUT/$suite.out" | head -10
done
exit 1
