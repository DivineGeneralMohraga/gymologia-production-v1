#!/usr/bin/env bash
#
# Plans, the trial, referral discounts, and webhook security.
#
#   npm run start:dev          # in another terminal
#   bash test/payments-e2e.sh
#
# Cashfree sandbox creates real orders, so checkout is exercised for real.
# Activation is driven through the webhook with a correctly signed payload,
# which is the same path production takes.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

field() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;d=json.load(sys.stdin);print(d.get('$1',{}).get('$2',''))" 2>/dev/null; }

login() {
  local phone="$1" name="$2" r cid code v rt
  r=$(curl -s -m 60 -X POST "$API/auth/otp/request" -H 'Content-Type: application/json' \
      -d "{\"phone\":\"$phone\",\"appClient\":\"MEMBER\"}")
  cid=$(echo "$r" | field challengeId); code=$(echo "$r" | field devCode)
  v=$(curl -s -m 60 -X POST "$API/auth/otp/verify" -H 'Content-Type: application/json' \
      -d "{\"challengeId\":\"$cid\",\"phone\":\"$phone\",\"code\":\"$code\",\"appClient\":\"MEMBER\"}")
  if [ "$(echo "$v" | field status)" = "NEW_USER" ]; then
    rt=$(echo "$v" | field registrationToken)
    v=$(curl -s -m 60 -X POST "$API/auth/register" -H 'Content-Type: application/json' \
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":30}")
  fi
  echo "$v" | nested tokens accessToken
}

make_gym() {
  curl -s -X POST "$API/gyms" -H "Authorization: Bearer $1" -H 'Content-Type: application/json' \
    -d "{\"name\":\"$2\",\"addressLine1\":\"1 Test Road\",\"state\":\"Goa\",
         \"district\":\"Panaji\",\"city\":\"Panaji\",\"pincode\":\"403001\",
         \"contactPhone\":\"$3\"}" | field id
}

# Four digits from the clock mixed with this shell's pid, so two runs
# starting in the same second do not mint the same phone numbers and then
# fight over the same test accounts. That collision produced a confusing
# half-hour of "failures" that were two regressions running at once.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_A="+9198300${STAMP}1"
P_B="+9198300${STAMP}2"
P_REF="+9198300${STAMP}3"

hdr "Setup"
OWNER_A=$(login "$P_A" "Owner A")
GID_A=$(make_gym "$OWNER_A" "Trial Gym" "$P_A")
[ -n "$GID_A" ] && ok "gym created (DRAFT)" || { bad "setup" "no gym"; exit 1; }

hdr "Pricing"
Q=$(curl -s "$API/gyms/$GID_A/subscription/quote" -H "Authorization: Bearer $OWNER_A")
BASIC=$(echo "$Q" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next(p['amountPayablePaise'] for p in d['plans'] if p['plan']=='BASIC'))" 2>/dev/null)
PRO=$(echo "$Q" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next(p['amountPayablePaise'] for p in d['plans'] if p['plan']=='PRO'))" 2>/dev/null)
[ "$BASIC" = "59900" ] && ok "Basic is Rs 599" || bad "basic price" "got $BASIC"
[ "$PRO" = "119900" ] && ok "Pro is Rs 1199" || bad "pro price" "got $PRO"

# GST is inside the listed price, not added on top.
TAX=$(echo "$Q" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next(p['taxPaise'] for p in d['plans'] if p['plan']=='PRO'))" 2>/dev/null)
[ "$TAX" = "18290" ] && ok "GST reverse-calculated from the listed price" \
  || bad "gst" "expected 18290, got $TAX"

hdr "Free trial"
T=$(curl -s -X POST "$API/gyms/$GID_A/subscription/trial" -H "Authorization: Bearer $OWNER_A")
[ "$(echo "$T" | field plan)" = "PRO" ] && ok "trial grants PRO" || bad "trial" "$T"
[ "$(echo "$T" | field isTrial)" = "True" ] && ok "flagged as a trial" || bad "trial flag" "$T"

GYM_STATUS=$(curl -s "$API/gyms/$GID_A" -H "Authorization: Bearer $OWNER_A" | field status)
[ "$GYM_STATUS" = "ACTIVE" ] && ok "gym left DRAFT" || bad "gym status" "got $GYM_STATUS"

AGAIN=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID_A/subscription/trial" \
        -H "Authorization: Bearer $OWNER_A")
[ "$AGAIN" = "409" ] && ok "second trial on the same gym refused" || bad "re-trial" "got $AGAIN"

# The trial is per person, so a second gym owned by the same person cannot
# start another one.
GID_A2=$(make_gym "$OWNER_A" "Second Gym" "$P_A")
SECOND=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID_A2/subscription/trial" \
         -H "Authorization: Bearer $OWNER_A")
[ "$SECOND" = "409" ] && ok "trial is once per person, not per gym" \
  || bad "trial per person" "got $SECOND"

hdr "Referral codes"
REFERRER=$(login "$P_REF" "Referrer")

# Ask the product for the code, the way a referrer would.
#
# This used to reach past the API and INSERT a referral_accounts row with
# Prisma, because there was no other way to get one -- and that back door
# is exactly what hid the gap. Redeeming a code was tested and worked;
# nothing in the product could issue one, so the discount was unreachable
# for every real user while this suite reported it working. A test that
# manufactures the thing under test proves the half it did not manufacture.
CODE=$(curl -s "$API/me/referral" -H "Authorization: Bearer $REFERRER" | field code)
[ -n "$CODE" ] && ok "a referrer can get their own code from the API ($CODE)" \
                || bad "referral setup" "no code came back"

AGAIN=$(curl -s "$API/me/referral" -H "Authorization: Bearer $REFERRER" | field code)
[ "$AGAIN" = "$CODE" ] && ok "and asking twice returns the same one" \
                       || bad "code stability" "first $CODE then $AGAIN"

# The spec excludes gym owners from the referral programme, and someone can
# register a gym after signing up -- so the rule has to hold here and not
# only at login.
OWNER_REF=$(curl -s -o /dev/null -w "%{http_code}" "$API/me/referral" \
            -H "Authorization: Bearer $OWNER_A")
[ "$OWNER_REF" = "403" ] && ok "a gym owner is refused a referral account" \
                         || bad "owner referral" "got HTTP $OWNER_REF, expected 403"

OWNER_B=$(login "$P_B" "Owner B")
GID_B=$(make_gym "$OWNER_B" "Paying Gym" "$P_B")

QD=$(curl -s "$API/gyms/$GID_B/subscription/quote?referralCode=$CODE" -H "Authorization: Bearer $OWNER_B")
DISCOUNTED=$(echo "$QD" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next(p['amountPayablePaise'] for p in d['plans'] if p['plan']=='PRO'))" 2>/dev/null)
[ "$DISCOUNTED" = "107910" ] && ok "10% off applied (Rs 1079.10)" \
  || bad "discount" "expected 107910, got $DISCOUNTED"

BOGUS=$(curl -s "$API/gyms/$GID_B/subscription/quote?referralCode=NOPE1234" \
        -H "Authorization: Bearer $OWNER_B" | python -c "
import sys,json;print(json.load(sys.stdin)['referral']['valid'])" 2>/dev/null)
[ "$BOGUS" = "False" ] && ok "unknown code reported invalid" || bad "bogus code" "got $BOGUS"

hdr "Checkout"
CO=$(curl -s -X POST "$API/gyms/$GID_B/subscription/checkout" -H "Authorization: Bearer $OWNER_B" \
     -H 'Content-Type: application/json' -d "{\"plan\":\"PRO\",\"referralCode\":\"$CODE\"}")
SUB_ID=$(echo "$CO" | field subscriptionId)
ORDER_ID=$(echo "$CO" | field orderId)
SESSION=$(echo "$CO" | field paymentSessionId)
[ -n "$SESSION" ] && ok "Cashfree order created, session returned" || bad "checkout" "$CO"
[ "$(echo "$CO" | field amountPayablePaise)" = "107910" ] \
  && ok "charged the discounted amount" || bad "checkout amount" "$CO"

hdr "Webhook security"
FORGED=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/webhooks/cashfree" \
         -H 'Content-Type: application/json' \
         -H 'x-webhook-signature: not-a-real-signature' \
         -H 'x-webhook-timestamp: 1234567890' \
         -d "{\"type\":\"PAYMENT_SUCCESS_WEBHOOK\",\"data\":{\"order\":{\"order_id\":\"$ORDER_ID\",\"order_amount\":1079.10}}}")
[ "$FORGED" = "200" ] && ok "forged webhook answered 200 (not retried)" \
  || bad "forged response" "got $FORGED"

STILL_PENDING=$(curl -s "$API/gyms/$GID_B/subscription" -H "Authorization: Bearer $OWNER_B" | python -c "
import sys,json;d=json.load(sys.stdin);print('none' if d['current'] is None else d['current']['status'])" 2>/dev/null)
[ "$STILL_PENDING" = "none" ] && ok "forged webhook did NOT activate the plan" \
  || bad "forgery blocked" "status is $STILL_PENDING"

hdr "Genuine webhook"
SIGNED=$(node -e '
  const fs=require("fs"), crypto=require("crypto");
  for (const l of fs.readFileSync(".env","utf8").split(/\r?\n/)) {
    const m=/^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
    if (m) process.env[m[1]] = m[2].replace(/^"|"$/g,"");
  }
  const secret = process.env.CASHFREE_WEBHOOK_SECRET || process.env.CASHFREE_CLIENT_SECRET;
  const ts = String(Math.floor(Date.now()/1000));
  const body = JSON.stringify({
    type: "PAYMENT_SUCCESS_WEBHOOK",
    data: {
      order: { order_id: process.argv[1], order_amount: 1079.10, order_status: "PAID" },
      payment: { cf_payment_id: 987654321, payment_status: "SUCCESS",
                 payment_amount: 1079.10, payment_group: "upi" },
    },
  });
  const sig = crypto.createHmac("sha256", secret).update(ts + body).digest("base64");
  console.log(JSON.stringify({ts, sig, body}));
' "$ORDER_ID")

TS=$(echo "$SIGNED" | python -c "import sys,json;print(json.load(sys.stdin)['ts'])")
SIG=$(echo "$SIGNED" | python -c "import sys,json;print(json.load(sys.stdin)['sig'])")
echo "$SIGNED" | python -c "import sys,json;sys.stdout.write(json.load(sys.stdin)['body'])" > /tmp/hook.json

HOOK=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/webhooks/cashfree" \
       -H 'Content-Type: application/json' \
       -H "x-webhook-signature: $SIG" -H "x-webhook-timestamp: $TS" \
       --data-binary @/tmp/hook.json)
[ "$HOOK" = "200" ] && ok "signed webhook accepted" || bad "signed webhook" "got $HOOK"

ACTIVE=$(curl -s "$API/gyms/$GID_B/subscription" -H "Authorization: Bearer $OWNER_B" | python -c "
import sys,json;d=json.load(sys.stdin);print('none' if d['current'] is None else d['current']['status'])" 2>/dev/null)
[ "$ACTIVE" = "ACTIVE" ] && ok "plan activated by the signed webhook" \
  || bad "activation" "status is $ACTIVE"

LISTED=$(curl -s "$API/gyms/$GID_B/subscription" -H "Authorization: Bearer $OWNER_B" | python -c "
import sys,json;d=json.load(sys.stdin);print(d['current']['listedInSearch'])" 2>/dev/null)
[ "$LISTED" = "True" ] && ok "PRO plan makes the gym listable" || bad "listing" "got $LISTED"

REPLAY=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/webhooks/cashfree" \
         -H 'Content-Type: application/json' \
         -H "x-webhook-signature: $SIG" -H "x-webhook-timestamp: $TS" \
         --data-binary @/tmp/hook.json)
REWARDS=$(node -e '
  const fs=require("fs");
  for (const l of fs.readFileSync(".env","utf8").split(/\r?\n/)) {
    const m=/^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
    if (m) process.env[m[1]] = m[2].replace(/^"|"$/g,"");
  }
  const {PrismaClient}=require("@prisma/client");
  const p=new PrismaClient();
  p.referralRedemption.count({where:{subscriptionId:process.argv[1]}})
    .then(n=>{ console.log(n); return p.$disconnect(); });
' "$SUB_ID")
[ "$REWARDS" = "1" ] && ok "replayed webhook did not double-reward the referrer" \
  || bad "idempotency" "expected 1 redemption, got $REWARDS"

# And the referrer can now SEE it. Everything above proves a redemption row
# exists in the database; this proves the person who earned it is told. The
# row is produced by the product here -- a real checkout, a real signed
# webhook -- rather than inserted by the test, which is the only way this
# check means anything.
hdr "What the referrer is shown"
EARN=$(curl -s "$API/me/referral/earnings" -H "Authorization: Bearer $REFERRER")
COUNT=$(echo "$EARN" | python -c "
import sys, json
print(len(json.load(sys.stdin)['items']))" 2>/dev/null)
[ "$COUNT" = "1" ] && ok "the reward appears in the referrer's own list" \
                   || bad "earnings list" "got $COUNT rows -- $EARN"

ROW=$(echo "$EARN" | python -c "
import sys, json
i = json.load(sys.stdin)['items'][0]
print('%s|%s|%s' % (i['gymName'], i['rewardPaise'], i['status']))" 2>/dev/null)

case "$ROW" in
  "Paying Gym - "*) ok "named after the gym that used the code" ;;
  *) bad "gym name" "got $ROW" ;;
esac
case "$ROW" in
  *"|5000|"*) ok "for the flat 5000 paise reward" ;;
  *) bad "reward" "got $ROW" ;;
esac
case "$ROW" in
  *"|PENDING") ok "held PENDING until the refund window closes" ;;
  *) bad "status" "got $ROW" ;;
esac

# What the gym paid is the gym's business. The referrer's reward is flat
# and is theirs; the discount is a fraction of somebody else's invoice.
echo "$EARN" | grep -q discountPaise \
  && bad "leak" "the earnings list exposes what the gym paid" \
  || ok "and says nothing about what that gym was charged"

TOTALS=$(curl -s "$API/me/referral" -H "Authorization: Bearer $REFERRER" | python -c "
import sys, json
d = json.load(sys.stdin)
print('%s|%s' % (d['timesRedeemed'], d['earnings']['pendingPaise']))" 2>/dev/null)
[ "$TOTALS" = "1|5000" ] && ok "and the running totals agree with the list" \
                         || bad "totals" "got $TOTALS"

# The boundary, with real data: exactly one reward, asked for one page of
# one. `hasMore` has to be FALSE. Inferring it from a full page -- which is
# what `rows.length === limit` does -- gets this exact case wrong and tells
# a referrer that rewards are hidden when the screen is showing all of them.
# The endpoint fetches one row more than it returns instead, so the answer
# comes from looking rather than from a coincidence.
EXACT=$(curl -s "$API/me/referral/earnings?limit=1" -H "Authorization: Bearer $REFERRER" | python -c "
import sys, json
d = json.load(sys.stdin)
print('%s|%s|%s' % (len(d['items']), d['returned'], d['hasMore']))" 2>/dev/null)
[ "$EXACT" = "1|1|False" ] \
  && ok "a page that is exactly full is not reported as truncated" \
  || bad "hasMore boundary" "got $EXACT, expected 1|1|False"

hdr "Taking it out"

# Direct database access for ONE thing only: moving the reward from PENDING
# to ELIGIBLE, which in the product is the maintenance job noticing the
# refund window has closed. Waiting seven days inside a test is not an
# option, and the alternative -- having the test create the reward too --
# is the back door this suite already removed once.
#
# Everything asserted below is behaviour the API is responsible for. The
# manufactured part is only the passage of time.
refdb() {
  node -e '
    const fs = require("fs");
    for (const l of fs.readFileSync(".env", "utf8").split(/\r?\n/)) {
      const m = /^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
      if (m) process.env[m[1]] = m[2].replace(/^"|"$/g, "");
    }
    const { PrismaClient } = require("@prisma/client");
    const p = new PrismaClient();
    const [op, sub] = process.argv.slice(1);
    (async () => {
      const r = await p.referralRedemption.findUnique({ where: { subscriptionId: sub } });
      if (!r) { console.log("NOREDEMPTION"); return; }
      if (op === "clear") {
        await p.referralRedemption.update({
          where: { id: r.id },
          data: { status: "ELIGIBLE", eligibleAt: new Date() },
        });
        console.log("ok");
      } else if (op === "verify-upi") {
        await p.referralAccount.update({
          where: { id: r.referralAccountId },
          data: { upiVerified: true, upiVerifiedAt: new Date() },
        });
        console.log("ok");
      } else if (op === "drop-payouts") {
        await p.referralRedemption.updateMany({
          where: { referralAccountId: r.referralAccountId },
          data: { payoutId: null, status: "ELIGIBLE" },
        });
        await p.payout.deleteMany({ where: { referralAccountId: r.referralAccountId } });
        console.log("ok");
      } else if (op === "read") {
        console.log(JSON.stringify(r));
      }
    })().catch(e => console.log("ERR " + e.message)).finally(() => p.$disconnect());
  ' "$1" "$2"
}

withdrawable() {
  curl -s -m 60 "$API/me/referral" -H "Authorization: Bearer $REFERRER" | python -c "
import sys, json
w = json.load(sys.stdin).get('withdrawable') or {}
print('%s|%s|%s|%s|%s' % (w.get('grossPaise'), w.get('verifyFeePaise'),
                          w.get('netPaise'), w.get('tdsPaise'), w.get('canWithdraw')))" 2>/dev/null
}

# Nothing has cleared yet: the reward is still held against a refund.
W=$(withdrawable)
[ "$W" = "0|1000|0|0|False" ] \
  && ok "a reward still held against a refund is not withdrawable" \
  || bad "withdrawable" "got $W, expected 0|1000|0|0|False"


C=$(curl -s -o /tmp/wd.json -w "%{http_code}" -X POST "$API/me/referral/withdraw" \
    -H "Authorization: Bearer $REFERRER")
[ "$C" = "400" ] && ok "and withdrawing an uncleared reward is refused" \
                 || bad "premature withdraw" "got HTTP $C -- $(cat /tmp/wd.json)"

# An address is needed before any of this means anything.
curl -s -o /dev/null -X PUT "$API/me/referral/payout-method" \
  -H "Authorization: Bearer $REFERRER" -H 'Content-Type: application/json' \
  -d '{"upiId":"payout.test@okhdfcbank","holderName":"Payout Test"}'
# And the reason says it is clearing rather than that they have earned
# nothing. Those are different things to be told, and only one of them
# is discouraging for the wrong reason.
WHY=$(curl -s -m 60 "$API/me/referral" -H "Authorization: Bearer $REFERRER" | python -c "
import sys, json
print((json.load(sys.stdin).get('withdrawable') or {}).get('blockedBy', [''])[0])" 2>/dev/null)
[ "$WHY" = "Your rewards are still clearing" ] \
  && ok "and told it is clearing, not that nothing was ever earned" \
  || bad "blocked reason" "got: $WHY"

[ "$(refdb clear "$SUB_ID")" = "ok" ] || bad "precondition" "could not clear the reward"

W=$(withdrawable)
[ "$W" = "5000|1000|4000|0|True" ] \
  && ok "once it clears, 50 rupees less the 10 rupee check is withdrawable" \
  || bad "withdrawable after clearing" "got $W, expected 5000|1000|4000|0|True"

C=$(curl -s -o /tmp/wd.json -w "%{http_code}" -X POST "$API/me/referral/withdraw" \
    -H "Authorization: Bearer $REFERRER")
[ "$C" = "201" ] && ok "the withdrawal is accepted" || bad "withdraw" "HTTP $C -- $(cat /tmp/wd.json)"

# Piped rather than opened by path. Bash's /tmp here is a Windows temp
# directory that native python cannot resolve, so open('/tmp/...') threw,
# 2>/dev/null swallowed it, and the check reported "got " with no clue why.
# Every other check in this suite pipes for exactly this reason.
PAY=$(cat /tmp/wd.json | python -c "
import sys, json
d = json.load(sys.stdin)
print('%s|%s|%s|%s|%s' % (d.get('grossPaise'), d.get('verifyFeePaise'),
                          d.get('netPaise'), d.get('tdsPaise'), d.get('status')))" 2>/dev/null)
[ "$PAY" = "5000|1000|4000|0|QUEUED" ] \
  && ok "for 50 gross, 10 fee, 40 net, queued" || bad "payout figures" "got $PAY"

# The whole point of asking the owner rather than guessing: nothing is
# withheld for tax at these amounts, and the row says so rather than
# leaving it to be inferred from a missing field.
[ "$(cat /tmp/wd.json | field tdsPaise)" = "0" ] \
  && ok "and no tax withheld -- 400 referrals a year would be needed first" \
  || bad "tds" "expected 0"

# Asking twice must not pay twice.
C=$(curl -s -o /tmp/wd2.json -w "%{http_code}" -X POST "$API/me/referral/withdraw" \
    -H "Authorization: Bearer $REFERRER")
[ "$C" = "409" ] && ok "a second request while one is moving is refused" \
                 || bad "double withdraw" "got HTTP $C -- $(cat /tmp/wd2.json)"
[ "$(cat /tmp/wd2.json | field code)" = "PAYOUT_IN_FLIGHT" ] \
  && ok "with the code the app translates" || bad "in-flight code" "$(cat /tmp/wd2.json)"

# And the reward is now spoken for, so there is nothing left to take.
W=$(withdrawable)
[ "$W" = "0|1000|0|0|False" ] \
  && ok "the reward is attached to that payout and no longer withdrawable" \
  || bad "withdrawable after" "got $W, expected 0|1000|0|0|False"

H=$(curl -s "$API/me/referral/withdrawals" -H "Authorization: Bearer $REFERRER" | python -c "
import sys, json
i = json.load(sys.stdin)['items']
print('%s|%s' % (len(i), i[0]['netPaise'] if i else ''))" 2>/dev/null)
[ "$H" = "1|4000" ] && ok "and it appears in the withdrawal history" || bad "history" "got $H"

# The fee follows the verification, not the calendar. An address that has
# been checked is not charged for again -- and one that has not, is.
[ "$(refdb drop-payouts "$SUB_ID")" = "ok" ] || bad "cleanup" "could not clear payouts"
[ "$(refdb verify-upi "$SUB_ID")" = "ok" ] || bad "precondition" "could not mark verified"
W=$(withdrawable)
[ "$W" = "5000|0|5000|0|True" ] \
  && ok "a verified address pays no fee, and the whole 50 arrives" \
  || bad "verified fee" "got $W, expected 5000|0|5000|0|True"

rm -f /tmp/wd.json /tmp/wd2.json

hdr "Search listing"
sleep 1
FOUND=$(curl -s "$API/gyms/search?query=Paying%20Gym" | python -c "
import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$FOUND" -ge 1 ] 2>/dev/null && ok "paid PRO gym now appears in member search" \
  || bad "search" "found $FOUND"

NOT_FOUND=$(curl -s "$API/gyms/search?query=Second%20Gym" | python -c "
import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$NOT_FOUND" = "0" ] && ok "unpaid gym stays out of search" || bad "unpaid listing" "found $NOT_FOUND"

rm -f /tmp/hook.json
printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
