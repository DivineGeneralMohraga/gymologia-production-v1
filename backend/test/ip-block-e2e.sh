#!/usr/bin/env bash
# Attack detection that actually counters, through the real API.
#
#   node dist/main.js              # in one shell
#   bash test/ip-block-e2e.sh      # in another
#
# test/ip-block.spec.ts covers the policy on its own. This is the other
# half: that repeated probes really do earn a refusal from the running
# server, that the refusal is cheap and correct, and -- the part that
# matters most -- that it lands on nobody else.
#
# HOW THIS AVOIDS BLOCKING THE MACHINE IT RUNS ON
#
# Two things, and both are load-bearing. Loopback and the private ranges
# are exempt in the policy, so localhost could not be blocked even on
# purpose. And the addresses used here are sent in X-Forwarded-For, which
# main.ts honours via `app.set('trust proxy', 1)`, so the server attributes
# these requests to an address that does not exist rather than to this
# machine.
#
# That second mechanism is also a warning worth reading. It works because
# a client connecting directly can set X-Forwarded-For and choose its own
# apparent address -- which is exactly what an attacker would do to evade
# a block, or to get somebody else blocked. It is safe in the deployment
# this is built for, where a proxy sits in front and overwrites the header.
# Deployed with nothing in front, `trust proxy` must go to 0 or this
# defence works against you.
#
# The addresses are from TEST-NET-1/2/3 (RFC 5737), which exist for
# documentation and are not routable, so nothing here can inconvenience a
# real host.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()   { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad()  { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr()  { printf "\n\033[1m%s\033[0m\n" "$1"; }

# A fresh address per run, so a previous run's events cannot carry over
# inside the ten minute window and block before the probes are sent.
N=$(( ($$ + RANDOM) % 200 + 20 ))
ATTACKER="203.0.113.${N}"
BYSTANDER="198.51.100.${N}"
PROBER="192.0.2.${N}"

# A tautology in a query string. The sanitizer records it and lets the
# request through; five inside ten minutes is what earns the block.
PROBE="${API}/health?q=%27%20or%201%3D1"

code() { curl -s -o /dev/null -w "%{http_code}" "$@"; }

hdr "Before any of this, everyone is welcome"
[ "$(code -H "X-Forwarded-For: $ATTACKER" "$API/health")" = "200" ] \
  && ok "the address that is about to misbehave is not blocked yet" \
  || bad "clean start" "already blocked; pick a different run"

hdr "Five injection probes from one address"
ALLOWED=0
for i in 1 2 3 4 5; do
  C=$(code -H "X-Forwarded-For: $ATTACKER" "$PROBE")
  [ "$C" = "200" ] && ALLOWED=$((ALLOWED + 1))
done
[ "$ALLOWED" = "5" ] \
  && ok "each probe is answered, not rejected (detection observes, it does not guess)" \
  || bad "probes allowed" "only $ALLOWED of 5 were answered"

# Recording a security event is fire-and-forget so the request is not held
# up by telemetry, which means the block lands a moment after the fifth
# probe rather than during it. Wait for it rather than racing it.
BLOCKED=""
for _ in 1 2 3 4 5 6 7 8 9 10; do
  if [ "$(code -H "X-Forwarded-For: $ATTACKER" "$API/health")" = "429" ]; then
    BLOCKED=1
    break
  fi
  node -e 'setTimeout(()=>{},1000)' >/dev/null 2>&1 || true
done

hdr "What happens next"
[ -n "$BLOCKED" ] \
  && ok "a sixth, entirely innocent request from that address is refused" \
  || bad "block applied" "still answering after ten tries"

if [ -n "$BLOCKED" ]; then
  RESP=$(curl -s -D - -o /dev/null -H "X-Forwarded-For: $ATTACKER" "$API/health")
  echo "$RESP" | grep -qi '^retry-after: [0-9]' \
    && ok "and says when to come back, in a Retry-After header" \
    || bad "retry-after" "no usable Retry-After header in the response"
fi

hdr "Who is NOT caught by it"
[ "$(code -H "X-Forwarded-For: $BYSTANDER" "$API/health")" = "200" ] \
  && ok "a different address is unaffected" \
  || bad "bystander" "an unrelated address was refused"

[ "$(code "$API/health")" = "200" ] \
  && ok "this machine is not blocked, and cannot be" \
  || bad "loopback" "localhost was refused -- the exemption is broken"

# One probe is a maybe. The threshold exists so that a single odd string
# in a gym description does not cost somebody their afternoon.
C=$(code -H "X-Forwarded-For: $PROBER" "$PROBE")
[ "$C" = "200" ] && ok "one probe from a new address is answered" \
                 || bad "single probe" "got $C"
[ "$(code -H "X-Forwarded-For: $PROBER" "$API/health")" = "200" ] \
  && ok "and does not block it -- under the threshold is not blocked" \
  || bad "single probe blocked" "one event should never be enough"

printf "\n"
if [ -n "$FAILED" ]; then
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
printf "\033[32mALL CHECKS PASSED\033[0m\n"
