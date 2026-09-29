#!/usr/bin/env bash
# The verification desk: queue, detail, approve and reject.
#
#   node dist/main.js              # in one shell
#   bash test/kyc-review-e2e.sh    # in another
#
# What matters here is who may look. Identity documents are the most
# sensitive thing on the platform, so the checks below are mostly about
# refusals: an ordinary account, a support agent, a rejection with no
# reason, and an approval of something already approved.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

field()  { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',{}).get('$2',''))" 2>/dev/null; }

login() {
  local phone="$1" name="$2" r cid code v rt
  r=$(curl -s -m 60 -X POST "$API/auth/otp/request" -H 'Content-Type: application/json' \
      -d "{\"phone\":\"$phone\",\"appClient\":\"MEMBER\"}")
  cid=$(echo "$r" | field challengeId)
  code=$(echo "$r" | field devCode)
  v=$(curl -s -m 60 -X POST "$API/auth/otp/verify" -H 'Content-Type: application/json' \
      -d "{\"challengeId\":\"$cid\",\"phone\":\"$phone\",\"code\":\"$code\",\"appClient\":\"MEMBER\"}")
  if [ "$(echo "$v" | field status)" = "NEW_USER" ]; then
    rt=$(echo "$v" | field registrationToken)
    v=$(curl -s -m 60 -X POST "$API/auth/register" -H 'Content-Type: application/json' \
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":33}")
  fi
  echo "$v" | nested tokens accessToken
}

db() { node -e "
  const fs=require('fs');
  for (const l of fs.readFileSync('.env','utf8').split(/\r?\n/)) {
    const m=/^([A-Z0-9_]+)=(.*)\$/.exec(l.trim());
    if (m) process.env[m[1]] = m[2].replace(/^\"|\"\$/g,'');
  }
  const {PrismaClient}=require('@prisma/client');
  const p=new PrismaClient();
  (async () => { $1 })().then(()=>p.\$disconnect()).catch(e=>{console.error(e.message);process.exit(1);});
" "$2" "$3"; }

STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_REVIEWER="+9195410${STAMP}1"
P_SUPPORT="+9195410${STAMP}2"
P_OWNER="+9198110${STAMP}3"

# These suites run against the live database, and below some of these
# accounts are made admin staff -- real-format phone numbers holding admin
# roles on the real admin app. Revoke every admin role they were given on
# the way out, however the suite ends.
revoke_admins() {
  db "await p.adminStaff.updateMany({
        where: { user: { phone: { in: process.argv.slice(1).filter(Boolean) } } },
        data: { status: 'REMOVED' } });" "$P_REVIEWER" "$P_SUPPORT" "$P_OWNER" > /dev/null 2>&1
}
trap revoke_admins EXIT

AADHAAR="234567890124"
PAN="ABCDE1234F"
GSTIN="27ABCDE1234F1Z5"

hdr "Setting up"
REVIEWER=$(login "$P_REVIEWER" "KYC Reviewer")
SUPPORT=$(login "$P_SUPPORT" "Support Agent")
OWNER=$(login "$P_OWNER" "Gym Owner")
[ -n "$REVIEWER" ] && [ -n "$SUPPORT" ] && [ -n "$OWNER" ] \
  && ok "three accounts signed in" || { bad "setup" "no tokens"; exit 1; }

GYM=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' \
      -d "{\"name\":\"Review Test Gym $STAMP\",\"addressLine1\":\"1 Test Road\",
           \"city\":\"Pune\",\"district\":\"Pune\",\"state\":\"Maharashtra\",
           \"pincode\":\"411001\",\"contactPhone\":\"$P_OWNER\",
           \"maxLeaveDaysPerMonth\":4}" | field id)
[ -n "$GYM" ] && ok "gym created" || { bad "gym create" "no id"; exit 1; }

SUB=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GYM/kyc" \
  -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
  -d "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"$PAN\",\"premises\":\"OWNED\",\"gstin\":\"$GSTIN\"}")
[ "$SUB" = "201" ] || [ "$SUB" = "200" ] && ok "documents submitted" \
  || bad "submit" "got HTTP $SUB"

hdr "Before anyone is a reviewer"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/kyc" -H "Authorization: Bearer $REVIEWER")
[ "$CODE" = "403" ] && ok "an ordinary account cannot open the queue" \
                    || bad "ordinary blocked" "got HTTP $CODE"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/kyc")
[ "$CODE" = "401" ] && ok "and neither can nobody" || bad "anon blocked" "got HTTP $CODE"

db "
  const u = await p.user.findUnique({where:{phone:process.argv[1]}});
  await p.adminStaff.create({data:{userId:u.id, role:'KYC_AGENT'}});
" "$P_REVIEWER" > /dev/null
db "
  const u = await p.user.findUnique({where:{phone:process.argv[1]}});
  await p.adminStaff.create({data:{userId:u.id, role:'CUSTOMER_SUPPORT'}});
" "$P_SUPPORT" > /dev/null
ok "one KYC agent and one support agent appointed"

hdr "Who may look at identity documents"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/kyc" -H "Authorization: Bearer $SUPPORT")
[ "$CODE" = "403" ] && ok "support cannot open the verification queue" \
                    || bad "support blocked" "got HTTP $CODE"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/kyc/$GYM" -H "Authorization: Bearer $SUPPORT")
[ "$CODE" = "403" ] && ok "nor one gym's documents" || bad "support detail blocked" "got HTTP $CODE"

hdr "The queue"
# "No full Aadhaar anywhere in it" is trivially true of an empty response,
# so each of these pairs a positive assertion with the negative one. The
# positive check is what makes the negative one mean something: without it
# a crashed request prints a reassuring green line about privacy holding
# while having examined nothing at all.
# Page through the queue rather than grepping the first page.
#
# The queue is oldest-first -- correct, the longest wait gets reviewed
# first -- and pages at 25. This suite creates a submission and then looks
# for it, so its record is always the NEWEST and therefore always on the
# LAST page. It passed for weeks because there were fewer than 25 waiting,
# and it failed the day the twenty-sixth arrived. Nothing about the product
# changed on that day.
#
# The claim being tested is "a reviewer can find this submission in the
# queue", not "it happens to be on the first page", so the check now looks
# everywhere a reviewer could look.
queue_page() {
  curl -s -m 60 "$API/admin/kyc?take=100&skip=$1" -H "Authorization: Bearer $REVIEWER"
}

Q=""
QTOTAL=0
SKIP=0
while : ; do
  PAGE=$(queue_page "$SKIP")
  QTOTAL=$(echo "$PAGE" | field total)
  # Guard the loop on the response being usable at all: a failed request
  # would otherwise scroll past as "not found on this page" forever.
  case "$QTOTAL" in ''|*[!0-9]*) break ;; esac
  Q="$Q$PAGE"
  case "$PAGE" in *"$GYM"*) break ;; esac
  SKIP=$((SKIP + 100))
  [ "$SKIP" -ge "$QTOTAL" ] && break
done

[ "$QTOTAL" -gt 0 ] 2>/dev/null \
  && ok "the review queue answers with $QTOTAL waiting" \
  || bad "queue" "no usable queue response: ${Q:-<nothing>}"

case "$Q" in
  *"$GYM"*) ok "and the submission is somewhere in it" ;;
  *) bad "queue" "own submission not found across $QTOTAL rows" ;;
esac
echo "$Q" | grep -q "$GYM" \
  && { echo "$Q" | grep -q "$AADHAAR" && bad "full Aadhaar in the queue" "$Q" \
                                      || ok "with no full Aadhaar anywhere in it"; } \
  || bad "queue privacy" "nothing to inspect: ${Q:-<nothing>}"

D=$(curl -s "$API/admin/kyc/$GYM" -H "Authorization: Bearer $REVIEWER")
[ "$(echo "$D" | field aadhaarLast4)" = "0124" ] && ok "detail shows the last four" \
  || bad "detail last4" "$(echo "$D" | field aadhaarLast4)"
[ "$(echo "$D" | field aadhaarLast4)" = "0124" ] \
  && { echo "$D" | grep -q "$AADHAAR" && bad "full Aadhaar in the detail" "$D" \
                                     || ok "and never the whole number"; } \
  || bad "detail privacy" "nothing to inspect: ${D:-<nothing>}"

hdr "Deciding"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/kyc/$GYM/decision" \
  -H "Authorization: Bearer $REVIEWER" -H 'Content-Type: application/json' \
  -d '{"decision":"REJECT"}')
[ "$CODE" = "400" ] && ok "a rejection with no reason is refused" \
                    || bad "reason required" "got HTTP $CODE"

CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/kyc/$GYM/decision" \
  -H "Authorization: Bearer $REVIEWER" -H 'Content-Type: application/json' \
  -d '{"decision":"REJECT","reason":"blurry"}')
[ "$CODE" = "400" ] && ok "and so is a reason too short to act on" \
                    || bad "reason length" "got HTTP $CODE"

R=$(curl -s -X POST "$API/admin/kyc/$GYM/decision" \
  -H "Authorization: Bearer $REVIEWER" -H 'Content-Type: application/json' \
  -d '{"decision":"REJECT","reason":"The electricity bill is not in the same name as the PAN."}')
[ -n "$(echo "$R" | field rejectionReason)" ] && ok "a rejection carries its reason" \
  || bad "rejection" "$R"

OWNER_VIEW=$(curl -s "$API/gyms/$GYM/kyc" -H "Authorization: Bearer $OWNER")
echo "$OWNER_VIEW" | grep -q "not in the same name" \
  && ok "and the owner is told what to fix" || bad "owner sees reason" "$OWNER_VIEW"

A=$(curl -s -X POST "$API/admin/kyc/$GYM/decision" \
  -H "Authorization: Bearer $REVIEWER" -H 'Content-Type: application/json' \
  -d '{"decision":"APPROVE"}')
[ -n "$(echo "$A" | field verifiedAt)" ] && ok "approving records when and by whom" \
  || bad "approve" "$A"

CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/kyc/$GYM/decision" \
  -H "Authorization: Bearer $REVIEWER" -H 'Content-Type: application/json' \
  -d '{"decision":"APPROVE"}')
[ "$CODE" = "400" ] && ok "deciding twice is refused" || bad "double decide" "got HTTP $CODE"

CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GYM/kyc" \
  -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
  -d "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"$PAN\",\"premises\":\"OWNED\",\"gstin\":\"$GSTIN\"}")
[ "$CODE" = "400" ] && ok "and a verified gym cannot quietly resubmit" \
                    || bad "resubmit after verify" "got HTTP $CODE"

hdr "The trail"
LOGGED=$(db "
  const n = await p.auditLog.count({ where: { action: { in: ['gym.kyc.approve','gym.kyc.reject'] } } });
  console.log(n);
" | tail -1)
[ "${LOGGED:-0}" -ge 2 ] && ok "both decisions are in the audit log" \
                         || bad "audit" "got $LOGGED"

printf "\n"
if [ -n "$FAILED" ]; then
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
printf "\033[32mALL CHECKS PASSED\033[0m\n"
