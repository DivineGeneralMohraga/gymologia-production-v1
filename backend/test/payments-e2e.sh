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

STAMP=$(date +%s | tail -c 5)
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
REF_USER=$(curl -s "$API/auth/me" -H "Authorization: Bearer $REFERRER" | field id)
CODE=$(node -e '
  const fs=require("fs");
  for (const l of fs.readFileSync(".env","utf8").split(/\r?\n/)) {
    const m=/^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
    if (m) process.env[m[1]] = m[2].replace(/^"|"$/g,"");
  }
  const {PrismaClient}=require("@prisma/client");
  const p=new PrismaClient();
  const code = "TEST" + Math.random().toString(36).slice(2,8).toUpperCase();
  p.referralAccount.create({data:{userId:process.argv[1], code}})
    .then(r=>{ console.log(r.code); return p.$disconnect(); })
    .catch(e=>{ console.log(""); process.exit(0); });
' "$REF_USER")
[ -n "$CODE" ] && ok "referral account created ($CODE)" || bad "referral setup" "no code"

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
