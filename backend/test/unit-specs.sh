#!/usr/bin/env bash
# The checks that need no server, gathered so they actually run.
#
#   bash test/unit-specs.sh
#
# These three were standalone scripts that nothing invoked. `npm test` runs
# jest, which does not pick them up; run-all.sh runs test/*.sh, which they
# are not. So they ran when somebody remembered, and the Aadhaar Verhoeff
# check -- the one that decides whether a gym owner's verification is
# accepted or rejected -- had no automatic run at all.
#
# They are quick and need nothing running, so this goes first in the suite
# list: if a format check or a URL rule is broken, there is no point
# spending half an hour on the API before finding out.

cd "$(dirname "$0")/.." || exit 1

SPECS="india-ids storage-url exercise-translations"
FAILED=""

for spec in $SPECS; do
  printf "\n\033[1m%s\033[0m\n" "$spec"
  npx ts-node --transpile-only "test/$spec.spec.ts" 2>&1 | sed '/^$/d;/^ALL /d;/CHECKS FAILED/d'
  # The spec's own exit code, not sed's. `cmd | sed` reports the exit
  # status of sed, which is always 0, so a failing spec would pass here.
  [ "${PIPESTATUS[0]}" = "0" ] || FAILED="$FAILED $spec"
done

printf "\n"
if [ -n "$FAILED" ]; then
  printf "\033[31mSOME CHECKS FAILED\033[0m in:%s\n" "$FAILED"; exit 1
fi
printf "\033[32mALL CHECKS PASSED\033[0m\n"
