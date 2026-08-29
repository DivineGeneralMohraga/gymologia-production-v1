#!/usr/bin/env bash
#
# The management paths the app's new screens drive: member detail, editing
# attendance, changing a role, editing the gym, and reversing a decision.
#
#   npm run start:dev          # in another terminal
#   bash test/crm-management-e2e.sh

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

field() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;d=json.load(sys.stdin);print(d.get('$1',{}).get('$2',''))" 2>/dev/null; }
first() { python -c "import sys,json;d=json.load(sys.stdin);print(d[0].get('$1','') if d else '')" 2>/dev/null; }

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

STAMP=$(date +%s | tail -c 5)
P_OWNER="+9198200${STAMP}1"
P_STAFF="+9198200${STAMP}2"
P_MEMBER="+9198200${STAMP}3"

hdr "Setup"
OWNER=$(login "$P_OWNER" "Owner Dev")
GYM=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' -d '{
  "name":"Bench Mark","addressLine1":"9 Link Road","state":"Maharashtra",
  "district":"Mumbai","city":"Mumbai","pincode":"400050",
  "contactPhone":"'"$P_OWNER"'","maxLeaveDaysPerMonth":3,"maxLeaveDaysPerMembership":10,
  "perks":["Sauna"]}')
GID=$(echo "$GYM" | field id)
[ -n "$GID" ] && ok "gym created" || { bad "setup" "$GYM"; exit 1; }

hdr "Roles endpoint (drives both pickers)"
ROLES=$(curl -s "$API/gyms/$GID/roles" -H "Authorization: Bearer $OWNER")
echo "$ROLES" | grep -q 'Trainer' && ok "roles listed" || bad "roles" "$ROLES"
# The owner outranks everyone, so only their own role is unassignable.
NOT_ASSIGNABLE=$(echo "$ROLES" | python -c "
import sys,json
d=json.load(sys.stdin)
print(','.join(r['name'] for r in d if not r['assignable']))" 2>/dev/null)
[ "$NOT_ASSIGNABLE" = "Owner" ] \
  && ok "owner cannot assign their own role, everything else is open" \
  || bad "assignable flags" "unassignable = $NOT_ASSIGNABLE"

TRAINER_ROLE=$(echo "$ROLES" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next((r['id'] for r in d if r['name']=='Trainer'), ''))" 2>/dev/null)
ADMIN_ROLE=$(echo "$ROLES" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next((r['id'] for r in d if r['name']=='Admin'), ''))" 2>/dev/null)

hdr "Staff role change"
LK=$(curl -s -X POST "$API/gyms/$GID/staff/lookup" -H "Authorization: Bearer $OWNER" \
     -H 'Content-Type: application/json' -d "{\"phone\":\"$P_STAFF\"}")
SID=$(curl -s -X POST "$API/gyms/$GID/staff" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{
      \"challengeId\":\"$(echo "$LK" | field challengeId)\",\"phone\":\"$P_STAFF\",
      \"code\":\"$(echo "$LK" | field devCode)\",\"name\":\"Staff Dev\",
      \"roleId\":\"$TRAINER_ROLE\"}" | field id)
[ -n "$SID" ] && ok "staff added as Trainer" || bad "add staff" "no id"

PROMOTED=$(curl -s -X PATCH "$API/gyms/$GID/staff/$SID" -H "Authorization: Bearer $OWNER" \
           -H 'Content-Type: application/json' -d "{\"roleId\":\"$ADMIN_ROLE\"}")
echo "$PROMOTED" | grep -q 'Admin' && ok "promoted Trainer to Admin" || bad "promote" "$PROMOTED"

hdr "Member management"
MLK=$(curl -s -X POST "$API/gyms/$GID/members/lookup" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{\"phone\":\"$P_MEMBER\"}")
MID=$(curl -s -X POST "$API/gyms/$GID/members" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{
      \"challengeId\":\"$(echo "$MLK" | field challengeId)\",\"phone\":\"$P_MEMBER\",
      \"code\":\"$(echo "$MLK" | field devCode)\",\"name\":\"Member Dev\",
      \"planMonths\":1,\"maxLeaveDays\":5,\"goal\":\"Get stronger\"}" | field membershipId)
[ -n "$MID" ] && ok "member added" || bad "add member" "no id"

BEFORE=$(curl -s "$API/gyms/$GID/members/$MID" -H "Authorization: Bearer $OWNER" | field daysRemaining)
AFTER=$(curl -s -X POST "$API/gyms/$GID/members/$MID/extend" -H "Authorization: Bearer $OWNER" \
        -H 'Content-Type: application/json' -d '{"months":2}' | field daysRemaining)
[ "$AFTER" -gt "$BEFORE" ] 2>/dev/null \
  && ok "extend added days ($BEFORE to $AFTER)" || bad "extend" "$BEFORE to $AFTER"

GOAL=$(curl -s -X PATCH "$API/gyms/$GID/members/$MID" -H "Authorization: Bearer $OWNER" \
       -H 'Content-Type: application/json' -d '{"goal":"Run a half marathon"}' | field goal)
[ "$GOAL" = "Run a half marathon" ] && ok "goal updated" || bad "goal" "got '$GOAL'"

hdr "Attendance correction"
MEMBER_USER=$(curl -s "$API/gyms/$GID/members/$MID" -H "Authorization: Bearer $OWNER" | nested user id)
REC=$(curl -s -X POST "$API/gyms/$GID/attendance" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{\"subjectType\":\"MEMBER\",\"subjectId\":\"$MID\"}")
RID=$(echo "$REC" | field id)
[ -n "$RID" ] && ok "marked present" || bad "mark" "$REC"

NO_REASON=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/gyms/$GID/attendance/$RID" \
            -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
            -d '{"status":"ABSENT"}')
[ "$NO_REASON" = "400" ] && ok "correction without a reason refused" \
  || bad "reason required" "expected 400, got $NO_REASON"

CORRECTED=$(curl -s -X PATCH "$API/gyms/$GID/attendance/$RID" -H "Authorization: Bearer $OWNER" \
            -H 'Content-Type: application/json' \
            -d '{"status":"ABSENT","reason":"Marked the wrong person"}')
echo "$CORRECTED" | grep -q 'ABSENT' && ok "correction with a reason accepted" \
  || bad "correct" "$CORRECTED"

HIST=$(curl -s "$API/gyms/$GID/attendance/subject/MEMBER/$MEMBER_USER" -H "Authorization: Bearer $OWNER")
echo "$HIST" | grep -q 'Marked the wrong person' && ok "reason kept on the record" \
  || bad "history" "$HIST"

hdr "Gym profile"
UPDATED=$(curl -s -X PATCH "$API/gyms/$GID" -H "Authorization: Bearer $OWNER" \
          -H 'Content-Type: application/json' \
          -d '{"description":"Powerlifting focused.","perks":["Sauna","Chalk allowed","Parking"]}')
echo "$UPDATED" | grep -q 'Chalk allowed' && ok "profile and perks replaced" || bad "update gym" "$UPDATED"

hdr "Leave reversal"
MEMBER=$(login "$P_MEMBER" "Member Dev")
LID=$(curl -s -X POST "$API/gyms/$GID/leave/request" -H "Authorization: Bearer $MEMBER" \
      -H 'Content-Type: application/json' \
      -d '{"subjectType":"MEMBER","fromDate":"2026-12-01","toDate":"2026-12-08"}' | field id)
[ -n "$LID" ] && ok "member requested 8 days (above the 3-day ceiling)" || bad "request" "no id"

D1=$(curl -s -X POST "$API/gyms/$GID/leave/$LID/decision" -H "Authorization: Bearer $OWNER" \
     -H 'Content-Type: application/json' -d '{"status":"APPROVED"}' | field status)
[ "$D1" = "APPROVED" ] && ok "owner approved" || bad "approve" "got $D1"

D2=$(curl -s -X POST "$API/gyms/$GID/leave/$LID/decision" -H "Authorization: Bearer $OWNER" \
     -H 'Content-Type: application/json' \
     -d '{"status":"DECLINED","note":"Approved by mistake"}' | field status)
[ "$D2" = "DECLINED" ] && ok "owner reversed their own approval" || bad "reverse" "got $D2"

OVERRIDES=$(curl -s "$API/gyms/$GID/leave?subjectType=MEMBER" -H "Authorization: Bearer $OWNER" \
            | python -c "
import sys,json
d=json.load(sys.stdin)
print(len(d[0].get('overrides',[])) if d else 0)" 2>/dev/null)
[ "$OVERRIDES" = "1" ] && ok "reversal recorded as an override" \
  || bad "override trail" "expected 1, got $OVERRIDES"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
