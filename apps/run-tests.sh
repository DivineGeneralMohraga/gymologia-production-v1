#!/usr/bin/env bash
#
# Every Flutter test in every app.
#
#   bash apps/run-tests.sh
#
# Exits 0 only when every check passed, 1 on any failure -- both verified by
# breaking a test deliberately, because a runner that cannot report a
# failure is worse than no runner at all.
#
# Do NOT read that status through a pipe. `bash apps/run-tests.sh | tail -5`
# gives you tail's exit code, which is always 0, and a failing run then
# sails through whatever follows the `&&`. That is the same trap already
# written down in backend/test/unit-specs.sh, and it caught this script's
# own author on the day it was written.
#
# This exists because the tests were there and nothing ran them. The member
# app has had a widget test since its login screen was written; the referral
# app added fifty-seven more. `backend/test/run-all.sh` covers the API and
# only the API, so all of that sat in the repository being no evidence of
# anything, which is the same failure as a function with no caller -- it
# looks like coverage and behaves like a comment.
#
# Deliberately NOT folded into run-all.sh. That script needs a compiled
# server on a port and spends eighteen minutes waiting out OTP rate limits;
# these need a Dart toolchain and no server at all. Two jobs with nothing in
# common share a runner only until the day one of them has to be skipped.
#
# The two totals are also kept apart on purpose. An API check that a gym
# owner cannot read somebody's earnings and a unit test that fifty rupees
# formats as "₹50" are both worth having and are not the same evidence; one
# number covering both would be a number that means less than either.
set -u

cd "$(dirname "$0")" || exit 1

APPS="gymologia gymologia_admin gymologia_referral"

ok()   { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad()  { printf "  \033[31mFAIL\033[0m  %s\n" "$1"; }
hdr()  { printf "\n\033[1m%s\033[0m\n" "$1"; }

if ! command -v flutter >/dev/null 2>&1; then
  printf '\033[31mflutter is not on PATH.\033[0m\n'
  exit 1
fi

TOTAL=0
FAILED=0
RAN=0
SKIPPED=""

for app in $APPS; do
  if [ ! -d "$app/test" ]; then
    # Said out loud rather than passed over. An app with no tests is a fact
    # about this run, and a silent skip is how "all green" comes to mean
    # "nothing ran".
    SKIPPED="$SKIPPED $app"
    continue
  fi

  # `ls` on a glob that matches nothing still exits non-zero in some shells
  # and prints an error in others, so count with find.
  count=$(find "$app/test" -name '*_test.dart' | wc -l | tr -d ' ')
  if [ "$count" = "0" ]; then
    SKIPPED="$SKIPPED $app"
    continue
  fi

  hdr "$app"
  out="${TMPDIR:-/tmp}/flutter-test-$app.out"

  # --reporter=compact keeps the running tally on one line; the machine
  # readable summary is the last line either way.
  (cd "$app" && flutter test --reporter=expanded) > "$out" 2>&1
  code=$?

  # The expanded reporter prints "+N" as it goes and "+N -M" on failure.
  # Take the LAST such line: it is the final tally, and an earlier one is a
  # partial count that would understate a passing run.
  summary=$(grep -oE '\+[0-9]+( -[0-9]+)?' "$out" | tail -1)
  passes=$(printf '%s' "$summary" | grep -oE '^\+[0-9]+' | tr -d '+')
  fails=$(printf '%s' "$summary" | grep -oE '\-[0-9]+' | tr -d '-')
  passes=${passes:-0}
  fails=${fails:-0}

  TOTAL=$((TOTAL + passes))
  FAILED=$((FAILED + fails))
  RAN=$((RAN + 1))

  if [ "$code" = "0" ] && [ "$fails" = "0" ]; then
    ok "$passes checks"
  else
    bad "$passes passed, $fails failed -- see $out"
    # The failing assertions, not the whole log: enough to know what broke
    # without scrolling past a hundred lines of compilation noise.
    grep -E '^\s*(Expected|Actual|.*\[E\])' "$out" | head -12 | sed 's/^/        /'
  fi
done

printf "\n"
[ -n "$SKIPPED" ] && printf 'no tests in:%s\n' "$SKIPPED"

if [ "$RAN" = "0" ]; then
  # Zero suites passing is not the same as everything passing, and the
  # difference has to survive being read quickly.
  printf '\033[31mNo test suites ran at all.\033[0m\n'
  exit 1
fi

printf '%d checks across %d app(s)\n' "$TOTAL" "$RAN"
if [ "$FAILED" = "0" ]; then
  printf '\033[32mALL CHECKS PASSED\033[0m\n'
  exit 0
fi
printf '\033[31m%d FAILED\033[0m\n' "$FAILED"
exit 1
