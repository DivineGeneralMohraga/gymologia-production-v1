#!/usr/bin/env bash
#
# The scheduled jobs. Without these, every "ends at" date in the system is
# decorative — this proves they are not.
#
#   bash test/maintenance-e2e.sh
#
# Rows are backdated directly in the database rather than waiting a month,
# then the same code the cron runs is invoked through the app context.

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

# Runs arbitrary Prisma against the same database the server uses.
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

STAMP=$(date +%s | tail -c 5)
P_OWNER="+9198400${STAMP}1"
P_MEMBER="+9198400${STAMP}2"

hdr "Setup"
OWNER=$(login "$P_OWNER" "Maint Owner")
GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Expiry Test Gym\",\"addressLine1\":\"3 Old Road\",\"state\":\"Kerala\",
           \"district\":\"Kochi\",\"city\":\"Kochi\",\"pincode\":\"682001\",
           \"contactPhone\":\"$P_OWNER\"}" | field id)
[ -n "$GID" ] && ok "gym created" || { bad "setup" "no gym"; exit 1; }

curl -s -X POST "$API/gyms/$GID/subscription/trial" -H "Authorization: Bearer $OWNER" > /dev/null
STATUS=$(curl -s "$API/gyms/$GID" -H "Authorization: Bearer $OWNER" | field status)
[ "$STATUS" = "ACTIVE" ] && ok "trial started, gym ACTIVE" || bad "trial" "status $STATUS"

MLK=$(curl -s -X POST "$API/gyms/$GID/members/lookup" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{\"phone\":\"$P_MEMBER\"}")
MID=$(curl -s -X POST "$API/gyms/$GID/members" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{
      \"challengeId\":\"$(echo "$MLK" | field challengeId)\",\"phone\":\"$P_MEMBER\",
      \"code\":\"$(echo "$MLK" | field devCode)\",\"name\":\"Expiring Member\",
      \"planMonths\":1,\"maxLeaveDays\":2}" | field membershipId)
[ -n "$MID" ] && ok "member added" || bad "member" "no id"

hdr "Before the jobs run"
FOUND=$(curl -s "$API/gyms/search?query=Expiry%20Test%20Gym" | python -c "
import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$FOUND" = "1" ] && ok "gym is listed in search" || bad "listing" "found $FOUND"

# Backdate both terms so they are in the past.
db "
  await p.gymSubscription.updateMany({
    where:{gymId:process.argv[1]},
    data:{endsAt:new Date(Date.now()-86400000)}});
  await p.membership.updateMany({
    where:{id:process.argv[2]},
    data:{endsAt:new Date(Date.now()-86400000)}});
" "$GID" "$MID"
ok "backdated the subscription and the membership by a day"

# Everything still claims to be active, because nothing has looked yet.
SUB_STATUS=$(db "
  const s = await p.gymSubscription.findFirst({where:{gymId:process.argv[1]}});
  console.log(s.status);
" "$GID" | tail -1)
[ "$SUB_STATUS" = "ACTIVE" ] && ok "expired subscription still reads ACTIVE (the bug)" \
  || bad "pre-state" "got $SUB_STATUS"

hdr "Run the jobs"
RESULT=$(npx ts-node scripts/run-maintenance.ts 2>/dev/null | tail -1)
echo "$RESULT" | grep -q 'subscriptions' && ok "maintenance ran" || bad "maintenance" "$RESULT"

hdr "After"
SUB_STATUS=$(db "
  const s = await p.gymSubscription.findFirst({where:{gymId:process.argv[1]}});
  console.log(s.status);
" "$GID" | tail -1)
[ "$SUB_STATUS" = "EXPIRED" ] && ok "subscription marked EXPIRED" || bad "sub expiry" "got $SUB_STATUS"

GYM_STATUS=$(curl -s "$API/gyms/$GID" -H "Authorization: Bearer $OWNER" | field status)
[ "$GYM_STATUS" = "SUSPENDED" ] && ok "gym dropped to SUSPENDED" || bad "gym status" "got $GYM_STATUS"

MEM_STATUS=$(db "
  const m = await p.membership.findUnique({where:{id:process.argv[1]}});
  console.log(m.status);
" "$MID" | tail -1)
[ "$MEM_STATUS" = "EXPIRED" ] && ok "membership marked EXPIRED" || bad "member expiry" "got $MEM_STATUS"

GONE=$(curl -s "$API/gyms/search?query=Expiry%20Test%20Gym" | python -c "
import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$GONE" = "0" ] && ok "lapsed gym no longer listed in search" || bad "delisting" "found $GONE"

# The CRM must keep working: locking an owner out of their own member list
# over a billing lapse would hold their data hostage.
CRM=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/members" -H "Authorization: Bearer $OWNER")
[ "$CRM" = "200" ] && ok "owner can still reach the CRM while suspended" \
  || bad "crm access" "got $CRM"

hdr "Idempotency"
SECOND=$(npx ts-node scripts/run-maintenance.ts 2>/dev/null | tail -1)
AGAIN=$(echo "$SECOND" | python -c "import sys,json;print(json.load(sys.stdin)['subscriptions'])" 2>/dev/null)
[ "$AGAIN" = "0" ] && ok "second run is a no-op" || bad "idempotency" "expired $AGAIN again"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
