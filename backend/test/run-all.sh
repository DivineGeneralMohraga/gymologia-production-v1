#!/usr/bin/env bash
#
# Every suite, in order, with a correct tally.
#
#   bash test/run-all.sh
#
# Run against the compiled build:
#
#   npm run build && node dist/main.js
#
# Never against `npm run start:dev` -- watch mode restarts the server when a
# file changes, and editing anything mid-run produces a scatter of failures
# that look like regressions and are not.
#
# The cooldown between suites is not padding. /auth/otp/request is rate
# limited to 5 per minute per IP, which is correct for a login endpoint and
# means seven suites back to back exhaust the quota and fail at setup with a
# 401 that has nothing to do with the code under test.

set -u

SUITES="
crm-e2e
crm-management-e2e
payments-e2e
events-notifications-e2e
maintenance-e2e
chat-e2e
analytics-trainers-e2e
"

API="${API:-http://localhost:3000/api/v1}"
OUT="${OUT:-/tmp}"
COOLDOWN="${COOLDOWN:-65}"

cd "$(dirname "$0")/.." || exit 1

if [ "$(curl -s -o /dev/null -w '%{http_code}' "$API/health")" != "200" ]; then
  printf "\033[31mNo server on %s.\033[0m Start it with: npm run build && node dist/main.js\n" "$API"
  exit 1
fi

TOTAL=0
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

  # Count the check lines, not every line containing PASS. Matching the
  # colour reset that follows the word is what separates a real check from
  # the suite's own "ALL CHECKS PASSED" banner, which would otherwise add
  # one to every suite's total.
  # `grep -c` already prints 0 and exits 1 when nothing matches, so adding
  # `|| echo 0` appends a SECOND zero and the arithmetic below dies on the
  # two-line result. Swallow the exit status rather than adding to output.
  passes=$(grep -cE 'PASS.\[0m  ' "$OUT/$suite.out" 2>/dev/null) || true
  fails=$(grep -cE 'FAIL.\[0m  ' "$OUT/$suite.out" 2>/dev/null) || true
  passes=${passes:-0}
  fails=${fails:-0}

  TOTAL=$((TOTAL + passes))
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
  printf "\033[32m%s checks passed across 7 suites.\033[0m\n" "$TOTAL"
  exit 0
fi

printf "\033[31m%s passed, %s failed.\033[0m Look at:%s\n" "$TOTAL" "$FAILED" "$BROKEN"
for suite in $BROKEN; do
  printf "\n\033[1m%s\033[0m\n" "$suite"
  grep -E 'FAIL' "$OUT/$suite.out" | head -10
done
exit 1
