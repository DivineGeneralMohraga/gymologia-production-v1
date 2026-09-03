#!/usr/bin/env bash
#
# End-to-end walk through the CRM against a running server.
#
#   npm run start:dev          # in another terminal
#   bash test/crm-e2e.sh
#
# Exercises the paths that are easy to get subtly wrong: permission
# boundaries, leave ceilings, and trainer assignment. Uses throwaway
# numbers in a range no real handset will hold.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

# Pull one field out of a JSON object without needing jq installed.
field() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;d=json.load(sys.stdin);print(d.get('$1',{}).get('$2',''))" 2>/dev/null; }

# Log a number in, registering it the first time. Prints an access token.
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
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":30}")
  fi
  echo "$v" | nested tokens accessToken
}

# Read a seeded id straight from the database, the way a UI would read it
# from the roles endpoint.
db_id() {
  node -e '
    const fs=require("fs");
    for (const l of fs.readFileSync(".env","utf8").split(/\r?\n/)) {
      const m=/^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
      if (m) process.env[m[1]] = m[2].replace(/^"|"$/g,"");
    }
    const {PrismaClient}=require("@prisma/client");
    const p=new PrismaClient();
    const [model,gymId,name]=process.argv.slice(1);
    p[model].findFirst({where:{gymId,name}})
      .then(r=>{ console.log(r ? r.id : ""); return p.$disconnect(); })
      .catch(()=>{ console.log(""); process.exit(0); });
  ' "$1" "$2" "$3"
}

# Four digits from the clock mixed with this shell's pid, so two runs
# starting in the same second do not mint the same phone numbers and then
# fight over the same test accounts. That collision produced a confusing
# half-hour of "failures" that were two regressions running at once.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_OWNER="+9198100${STAMP}1"
P_TRAINER="+9198100${STAMP}2"
P_MEMBER="+9198100${STAMP}3"
P_OUTSIDER="+9198100${STAMP}4"

hdr "Setup"
OWNER=$(login "$P_OWNER" "Owner Raj")
[ -n "$OWNER" ] && ok "owner signed in" || { bad "owner login" "no token"; exit 1; }

GYM=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' -d '{
  "name":"Apex Strength","addressLine1":"12 MG Road","state":"Karnataka",
  "district":"Bengaluru","city":"Bengaluru","pincode":"560001",
  "contactPhone":"'"$P_OWNER"'","maxLeaveDaysPerMonth":4,"maxLeaveDaysPerMembership":10}')
GID=$(echo "$GYM" | field id)
[ -n "$GID" ] && ok "gym created with seeded roles" || { bad "gym create" "$GYM"; exit 1; }

echo "$GYM" | grep -qE '"isGymOwner": ?true' \
  && ok "creator resolved as owner" || bad "owner context" "missing isGymOwner"

TRAINER_ROLE=$(db_id role "$GID" Trainer)
CATEGORY=$(db_id trainerCategory "$GID" General)
[ -n "$TRAINER_ROLE" ] && ok "Trainer role seeded" || bad "role seeding" "not found"
[ -n "$CATEGORY" ] && ok "General trainer category seeded" || bad "category seeding" "not found"

hdr "Adding staff"
LK=$(curl -s -X POST "$API/gyms/$GID/staff/lookup" -H "Authorization: Bearer $OWNER" \
     -H 'Content-Type: application/json' -d "{\"phone\":\"$P_TRAINER\"}")
echo "$LK" | grep -qE '"exists": ?false' \
  && ok "lookup reveals nothing about an unknown number" || bad "lookup" "$LK"

ADD=$(curl -s -X POST "$API/gyms/$GID/staff" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{
      \"challengeId\":\"$(echo "$LK" | field challengeId)\",\"phone\":\"$P_TRAINER\",
      \"code\":\"$(echo "$LK" | field devCode)\",\"name\":\"Trainer Anu\",
      \"roleId\":\"$TRAINER_ROLE\",\"isTrainer\":true,\"trainerCategoryId\":\"$CATEGORY\"}")
SID=$(echo "$ADD" | field id)
[ -n "$SID" ] && ok "trainer added" || bad "add staff" "$ADD"

hdr "Adding a member"
MLK=$(curl -s -X POST "$API/gyms/$GID/members/lookup" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{\"phone\":\"$P_MEMBER\"}")
MEM=$(curl -s -X POST "$API/gyms/$GID/members" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{
      \"challengeId\":\"$(echo "$MLK" | field challengeId)\",\"phone\":\"$P_MEMBER\",
      \"code\":\"$(echo "$MLK" | field devCode)\",\"name\":\"Member Vikram\",
      \"planMonths\":3,\"maxLeaveDays\":8,\"assignedTrainerId\":\"$SID\",
      \"goal\":\"Bulk up to 80kg\"}")
MID=$(echo "$MEM" | field membershipId)
[ -n "$MID" ] && ok "member added with trainer and goal" || bad "add member" "$MEM"

MLK2=$(curl -s -X POST "$API/gyms/$GID/members/lookup" -H "Authorization: Bearer $OWNER" \
       -H 'Content-Type: application/json' -d '{"phone":"+919810099999"}')
CEIL=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/members" \
       -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' -d "{
       \"challengeId\":\"$(echo "$MLK2" | field challengeId)\",\"phone\":\"+919810099999\",
       \"code\":\"$(echo "$MLK2" | field devCode)\",\"name\":\"Ceiling Test\",
       \"planMonths\":1,\"maxLeaveDays\":99}")
[ "$CEIL" = "400" ] && ok "leave allowance above the gym ceiling refused" \
  || bad "membership ceiling" "expected 400, got $CEIL"

hdr "Permission boundaries"
TRAINER=$(login "$P_TRAINER" "Trainer Anu")
C=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/staff/lookup" \
    -H "Authorization: Bearer $TRAINER" -H 'Content-Type: application/json' -d '{"phone":"+919810011111"}')
[ "$C" = "403" ] && ok "trainer cannot add staff" || bad "trainer add staff" "expected 403, got $C"

C=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/attendance?subjectType=MEMBER" \
    -H "Authorization: Bearer $TRAINER")
[ "$C" = "200" ] && ok "trainer can view member attendance" || bad "trainer view" "expected 200, got $C"

C=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/attendance?subjectType=STAFF" \
    -H "Authorization: Bearer $TRAINER")
[ "$C" = "403" ] && ok "trainer cannot view staff attendance" || bad "trainer staff view" "expected 403, got $C"

OUTSIDER=$(login "$P_OUTSIDER" "Random Person")
C=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/members" -H "Authorization: Bearer $OUTSIDER")
[ "$C" = "403" ] && ok "a stranger cannot read the member list" || bad "outsider" "expected 403, got $C"

hdr "Attendance"
MK=$(curl -s -X POST "$API/gyms/$GID/attendance" -H "Authorization: Bearer $TRAINER" \
     -H 'Content-Type: application/json' -d "{\"subjectType\":\"MEMBER\",\"subjectId\":\"$MID\"}")
echo "$MK" | grep -q 'PRESENT' && ok "trainer marked a member present" || bad "mark" "$MK"

C=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/attendance" \
    -H "Authorization: Bearer $TRAINER" -H 'Content-Type: application/json' \
    -d "{\"subjectType\":\"STAFF\",\"subjectId\":\"$SID\"}")
[ "$C" = "403" ] && ok "trainer cannot mark staff attendance" || bad "staff mark" "expected 403, got $C"

hdr "Leave"
MEMBER=$(login "$P_MEMBER" "Member Vikram")
L1=$(curl -s -X POST "$API/gyms/$GID/leave/request" -H "Authorization: Bearer $MEMBER" \
     -H 'Content-Type: application/json' \
     -d '{"subjectType":"MEMBER","fromDate":"2026-10-01","toDate":"2026-10-03","reason":"Travel"}')
[ "$(echo "$L1" | field status)" = "AUTO_APPROVED" ] \
  && ok "3 days inside both ceilings auto-approved" || bad "auto-approve" "$L1"

L2=$(curl -s -X POST "$API/gyms/$GID/leave/request" -H "Authorization: Bearer $MEMBER" \
     -H 'Content-Type: application/json' \
     -d '{"subjectType":"MEMBER","fromDate":"2026-11-01","toDate":"2026-11-09","reason":"Long trip"}')
[ "$(echo "$L2" | field status)" = "PENDING" ] \
  && ok "9 days above the monthly ceiling escalated to PENDING" || bad "escalation" "$L2"

C=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/leave/$(echo "$L2" | field id)/decision" \
    -H "Authorization: Bearer $TRAINER" -H 'Content-Type: application/json' -d '{"status":"APPROVED"}')
[ "$C" = "403" ] && ok "trainer cannot approve leave" || bad "leave perm" "expected 403, got $C"

C=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/leave/$(echo "$L2" | field id)/decision" \
    -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' -d '{"status":"APPROVED"}')
[ "$C" = "201" ] || [ "$C" = "200" ] && ok "owner approved the escalated request" \
  || bad "owner approve" "got $C"

hdr "Member app"
MM=$(curl -s "$API/me/memberships" -H "Authorization: Bearer $MEMBER")
echo "$MM" | grep -q "Apex Strength" && ok "member sees their membership" || bad "memberships" "$MM"

curl -s -X POST "$API/me/metrics" -H "Authorization: Bearer $MEMBER" \
  -H 'Content-Type: application/json' -d '{"weightKg":72.5,"heightCm":178}' > /dev/null
MT=$(curl -s "$API/me/metrics" -H "Authorization: Bearer $MEMBER")
echo "$MT" | grep -qE '"checkInDue": ?false' \
  && ok "check-in recorded and the monthly prompt cleared" || bad "metrics" "$MT"

PROG=$(curl -s "$API/gyms/$GID/members/$MID/progress" -H "Authorization: Bearer $OWNER")
echo "$PROG" | grep -q 'Bulk up' && ok "staff can see progress while consent stands" || bad "progress" "$PROG"

curl -s -X PATCH "$API/me/memberships/$MID/monitoring" -H "Authorization: Bearer $MEMBER" \
  -H 'Content-Type: application/json' -d '{"allow":false}' > /dev/null
C=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/members/$MID/progress" -H "Authorization: Bearer $OWNER")
[ "$C" = "403" ] && ok "member revoking consent blocks even the owner" \
  || bad "consent revocation" "expected 403, got $C"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"
  exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"
  exit 1
fi
