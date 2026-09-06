#!/usr/bin/env bash
#
# The test account: one phone number that signs in with a fixed code.
#
#   bash test/auth-e2e.sh
#
# This exists because that credential works in PRODUCTION. It is what Play's
# reviewers and testers use, so it cannot be removed, and it is therefore
# permanently reachable by anyone who learns the number. The checks below
# are weighted almost entirely towards what it must NOT do.
#
# The property that matters: the test account changes only where the digits
# come from. It does not add a branch that accepts a code without checking
# it. A test challenge is hashed, expired, attempt-counted and single-used
# exactly like any other, and `verify` cannot tell the two apart -- so if
# any of the refusals below stop holding, the bypass has become real.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

cd "$(dirname "$0")/.." || exit 1

field() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }

request() {
  curl -s -m 60 -X POST "$API/auth/otp/request" -H 'Content-Type: application/json' \
    -d "{\"phone\":\"$1\",\"appClient\":\"MEMBER\"}"
}
verify_code() {
  curl -s -o /tmp/auth-body.json -w "%{http_code}" -m 60 -X POST "$API/auth/otp/verify" \
    -H 'Content-Type: application/json' \
    -d "{\"challengeId\":\"$1\",\"phone\":\"$2\",\"code\":\"$3\",\"appClient\":\"MEMBER\"}"
}

hdr "Configuration"
# Read from .env rather than hardcoded: the whole point is that this is
# configuration, and a copy of the code in the test would pass while the
# deployment had a different one.
PHONE=$(grep "^TEST_ACCOUNT_PHONE=" .env 2>/dev/null | cut -d= -f2 | tr -d '\r')
OTP=$(grep "^TEST_ACCOUNT_OTP=" .env 2>/dev/null | cut -d= -f2 | tr -d '\r')

# Deliberately a failure rather than a skip. A skip here is a check that
# cannot fail, and this suite exists precisely to guard a credential that
# is supposed to be present.
if [ -z "$PHONE" ] || [ -z "$OTP" ]; then
  bad "test account configured" "TEST_ACCOUNT_PHONE/OTP absent from .env"
  printf "\n\033[31mSOME CHECKS FAILED\033[0m\n"
  exit 1
fi
ok "test account is configured"

case "$OTP" in
  123456|000000|111111|654321) bad "code is not guessable" "the code is a well-known sequence" ;;
  *) ok "the code is not one of the obvious sequences" ;;
esac

hdr "It signs in"
R=$(request "$PHONE")
CID=$(echo "$R" | field challengeId)
[ -n "$CID" ] && ok "a challenge was issued for the test number" || bad "issue" "$R"

# No SMS is sent for this number, so nothing should claim a delivery
# failure either -- the caller is told the code is on its way as usual.
DELIVERED=$(echo "$R" | field delivered)
[ "$DELIVERED" = "True" ] && ok "and it reports delivered without sending an SMS" \
                          || bad "delivered" "got '$DELIVERED'"

hdr "What it must still refuse"
# If any of these start passing, the fixed code has become a bypass rather
# than a fixed code.
C=$(verify_code "$CID" "$PHONE" "111111")
[ "$C" = "400" ] && ok "a wrong code on the test number is refused" || bad "wrong code" "got HTTP $C"

# `rev` is not on this box, and the first version of this line used it:
# the substitution came back EMPTY, the empty code was refused, and the
# check reported PASS having never sent the reversed digits at all. It
# passed for the wrong reason, and the only sign was a stderr line nothing
# was reading. Built with python, which these suites already depend on, and
# asserted to be a real transformation before it is used.
REVERSED=$(python -c "print('$OTP'[::-1])" 2>/dev/null)
if [ -n "$REVERSED" ] && [ "$REVERSED" != "$OTP" ] && [ ${#REVERSED} -eq ${#OTP} ]; then
  C=$(verify_code "$CID" "$PHONE" "$REVERSED")
  [ "$C" = "400" ] && ok "so is the right digits in the wrong order"                    || bad "reversed code" "got HTTP $C"
else
  # A palindromic code cannot be reversed into a different one, so say that
  # rather than quietly testing nothing.
  bad "reversed code" "could not build a distinct reversal of the code"
fi

# The one that matters most: the fixed code must be worth nothing anywhere
# else. The allowlist is exact equality on a single number.
OTHER="+9198${RANDOM}${RANDOM}0"
OTHER="${OTHER:0:13}"
R2=$(request "$OTHER")
C2=$(echo "$R2" | field challengeId)
if [ -n "$C2" ]; then
  C=$(verify_code "$C2" "$OTHER" "$OTP")
  [ "$C" = "400" ] \
    && ok "the test code is refused on every other number" \
    || bad "ALLOWLIST BROKEN" "the test code signed in as $OTHER (HTTP $C)"
else
  bad "other number" "no challenge issued: $R2"
fi

hdr "And then it works"
# The SAME challenge as the refusals above, deliberately.
#
# The first version asked for a second code here, and that made the suite
# fail whenever it ran twice inside fifteen minutes: a number may request
# five codes per fifteen minutes, and two requests per run plus a standalone
# run beforehand exhausts it. It failed in the full run having passed on its
# own, which is the worst way to find out.
#
# A wrong code only increments the attempt counter; it does not consume the
# challenge. Two wrong guesses leave three of the five attempts, so the
# correct code can be checked against the challenge already issued. One
# request per run, no waiting, and the same assertions.
C=$(verify_code "$CID" "$PHONE" "$OTP")
STATUS=$(python -c "import sys,json;print(json.load(open('/tmp/auth-body.json')).get('status',''))" 2>/dev/null)
if [ "$C" = "200" ] || [ "$C" = "201" ]; then
  ok "the fixed code signs the test account in (HTTP $C, status ${STATUS:-session})"
else
  bad "test code" "got HTTP $C"
fi

# Single-use, like any other challenge: the code that just worked must not
# work again against the consumed challenge.
C=$(verify_code "$CID" "$PHONE" "$OTP")
[ "$C" = "400" ] && ok "and the challenge is single-use, as any other is"                  || bad "replay" "the consumed challenge accepted the code again (HTTP $C)"


rm -f /tmp/auth-body.json
printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
