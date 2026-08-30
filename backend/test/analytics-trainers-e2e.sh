#!/usr/bin/env bash
#
# Trainer categories, period-grouped analytics, and the member's own
# attendance -- the three things the spec asked for that had a table or a
# permission but no code behind them.
#
#   bash test/analytics-trainers-e2e.sh
#
# Run against the compiled build (node dist/main.js), never watch mode.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

field()  { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
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
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":29}")
  fi
  echo "$v" | nested tokens accessToken
}

# Adds a person to the gym, echoing the id the caller asked for.
add_member() {
  local tok="$1" gym="$2" phone="$3" name="$4" lk
  lk=$(curl -s -X POST "$API/gyms/$gym/members/lookup" -H "Authorization: Bearer $tok" \
       -H 'Content-Type: application/json' -d "{\"phone\":\"$phone\"}")
  curl -s -X POST "$API/gyms/$gym/members" -H "Authorization: Bearer $tok" \
    -H 'Content-Type: application/json' -d "{
      \"challengeId\":\"$(echo "$lk" | field challengeId)\",\"phone\":\"$phone\",
      \"code\":\"$(echo "$lk" | field devCode)\",\"name\":\"$name\",
      \"planMonths\":1,\"maxLeaveDays\":2}"
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

STAMP=$(date +%s | tail -c 5)
P_OWNER="+9197600${STAMP}1"
P_MEMBER="+9197600${STAMP}2"
P_TRAINER="+9197600${STAMP}3"

hdr "Setup"
OWNER=$(login "$P_OWNER" "Analytics Owner")
[ -n "$OWNER" ] && ok "owner signed in" || { bad "setup" "no token"; exit 1; }

GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Growth Gym\",\"addressLine1\":\"9 Chart Lane\",\"state\":\"Kerala\",
           \"district\":\"Kollam\",\"city\":\"Kollam\",\"pincode\":\"691001\",
           \"contactPhone\":\"$P_OWNER\"}" | field id)
[ -n "$GID" ] && ok "gym created" || { bad "setup" "no gym"; exit 1; }
curl -s -X POST "$API/gyms/$GID/subscription/trial" -H "Authorization: Bearer $OWNER" > /dev/null

hdr "Trainer categories"
CATS=$(curl -s "$API/gyms/$GID/trainer-categories" -H "Authorization: Bearer $OWNER")
COUNT=$(echo "$CATS" | python -c "import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$COUNT" = "2" ] && ok "a new gym starts with General and Personal" || bad "seed" "got $COUNT"

NAMES=$(echo "$CATS" | python -c "
import sys,json;print(','.join(sorted(c['name'] for c in json.load(sys.stdin))))" 2>/dev/null)
[ "$NAMES" = "General,Personal" ] && ok "named as the spec lists them" || bad "names" "$NAMES"

AFTER=$(curl -s -X POST "$API/gyms/$GID/trainer-categories" -H "Authorization: Bearer $OWNER" \
        -H 'Content-Type: application/json' -d '{"name":"Rehab","allowsMultipleMembers":false}')
NEW=$(echo "$AFTER" | python -c "
import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$NEW" = "3" ] && ok "created a custom category" || bad "create" "got $NEW"

RID=$(echo "$AFTER" | python -c "
import sys,json;print(next(c['id'] for c in json.load(sys.stdin) if c['name']=='Rehab'))" 2>/dev/null)
[ -n "$RID" ] && ok "it comes back in the list" || bad "create" "no id"

# Case-insensitive clash: the database index is case-sensitive, so without
# the service check a gym ends up with two categories nobody can tell apart.
DUP=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/trainer-categories" \
      -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d '{"name":"rehab"}')
[ "$DUP" = "409" ] && ok "a differently-cased duplicate is refused" || bad "duplicate" "got $DUP"

REN=$(curl -s -X PATCH "$API/gyms/$GID/trainer-categories/$RID" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d '{"name":"Rehab & Recovery"}')
RENAMED=$(echo "$REN" | python -c "
import sys,json;d=json.load(sys.stdin);print(any(c['name']=='Rehab & Recovery' for c in d['categories']))" 2>/dev/null)
[ "$RENAMED" = "True" ] && ok "renamed" || bad "rename" "$REN"

hdr "Deleting a category people are in"
LK=$(curl -s -X POST "$API/gyms/$GID/staff/lookup" -H "Authorization: Bearer $OWNER" \
     -H 'Content-Type: application/json' -d "{\"phone\":\"$P_TRAINER\"}")
ROLES=$(curl -s "$API/gyms/$GID/roles" -H "Authorization: Bearer $OWNER")
TRAINER_ROLE=$(echo "$ROLES" | python -c "
import sys,json;print(next(r['id'] for r in json.load(sys.stdin) if r['name']=='Trainer'))" 2>/dev/null)

STAFF=$(curl -s -X POST "$API/gyms/$GID/staff" -H "Authorization: Bearer $OWNER" \
        -H 'Content-Type: application/json' -d "{
        \"challengeId\":\"$(echo "$LK" | field challengeId)\",\"phone\":\"$P_TRAINER\",
        \"code\":\"$(echo "$LK" | field devCode)\",\"name\":\"Rehab Trainer\",
        \"roleId\":\"$TRAINER_ROLE\",\"isTrainer\":true,\"trainerCategoryId\":\"$RID\"}")
SID=$(echo "$STAFF" | field id)
[ -n "$SID" ] && ok "trainer added into the category" || bad "add trainer" "$STAFF"

DEL=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
      "$API/gyms/$GID/trainer-categories/$RID" -H "Authorization: Bearer $OWNER")
[ "$DEL" = "409" ] && ok "deleting it is refused while a trainer is in it" || bad "delete guard" "got $DEL"

LISTED=$(curl -s "$API/gyms/$GID/trainer-categories" -H "Authorization: Bearer $OWNER" | python -c "
import sys,json;print(next(str(c['canDelete'])+':'+str(c['trainerCount'])
                           for c in json.load(sys.stdin) if c['id']=='$RID'))" 2>/dev/null)
[ "$LISTED" = "False:1" ] && ok "the list says so before you try" || bad "canDelete" "$LISTED"

# Move the trainer out, then the category goes.
curl -s -X PATCH "$API/gyms/$GID/staff/$SID" -H "Authorization: Bearer $OWNER" \
  -H 'Content-Type: application/json' \
  -d "{\"trainerCategoryId\":\"$(echo "$CATS" | python -c "
import sys,json;print(next(c['id'] for c in json.load(sys.stdin) if c['name']=='General'))")\"}" > /dev/null

DEL2=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
       "$API/gyms/$GID/trainer-categories/$RID" -H "Authorization: Bearer $OWNER")
[ "$DEL2" = "200" ] && ok "and deletes once it is empty" || bad "delete" "got $DEL2"

hdr "Who may change categories"
MEMBER_TOKEN=$(login "$P_MEMBER" "Chart Member")
MRES=$(add_member "$OWNER" "$GID" "$P_MEMBER" "Chart Member")
MID=$(echo "$MRES" | field membershipId)
[ -n "$MID" ] && ok "member added" || bad "member" "$MRES"

NOPERM=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/trainer-categories" \
         -H "Authorization: Bearer $MEMBER_TOKEN" -H 'Content-Type: application/json' \
         -d '{"name":"Sneaky"}')
[ "$NOPERM" = "403" ] && ok "a member cannot create one" || bad "member create" "got $NOPERM"

TRAINER_TOKEN=$(login "$P_TRAINER" "Rehab Trainer")
TNOPERM=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/trainer-categories" \
          -H "Authorization: Bearer $TRAINER_TOKEN" -H 'Content-Type: application/json' \
          -d '{"name":"Sneaky"}')
[ "$TNOPERM" = "403" ] && ok "nor can a trainer" || bad "trainer create" "got $TNOPERM"

hdr "Growth, grouped"
G=$(curl -s "$API/gyms/$GID/attendance/analytics/growth?unit=month&periods=6" \
    -H "Authorization: Bearer $OWNER")
BUCKETS=$(echo "$G" | python -c "import sys,json;print(len(json.load(sys.stdin)['buckets']))" 2>/dev/null)
[ "$BUCKETS" = "6" ] && ok "six months come back, empty ones included" || bad "buckets" "got $BUCKETS"

JOINED=$(echo "$G" | field totalJoined)
[ "$JOINED" = "1" ] && ok "the one join this month is counted" || bad "joined" "got $JOINED"

LAST=$(echo "$G" | python -c "
import sys,json;print(json.load(sys.stdin)['buckets'][-1]['joined'])" 2>/dev/null)
[ "$LAST" = "1" ] && ok "and lands in the current bucket, not an older one" || bad "bucket placement" "got $LAST"

# Buckets are cut on IST. A join made now must never land in yesterday's
# bucket, which is what UTC truncation does for the first 5.5 hours of a day.
TODAY_IST=$(TZ=Asia/Kolkata date +%Y-%m-01)
CURRENT=$(curl -s "$API/gyms/$GID/attendance/analytics/growth?unit=month&periods=1"           -H "Authorization: Bearer $OWNER" | python -c "
import sys,json;print(json.load(sys.stdin)['buckets'][-1]['period'])" 2>/dev/null)
[ "$CURRENT" = "$TODAY_IST" ] && ok "the newest bucket is the current Indian month"   || bad "timezone" "got $CURRENT, expected $TODAY_IST"

for U in day month year; do
  C=$(curl -s -o /dev/null -w "%{http_code}" \
      "$API/gyms/$GID/attendance/analytics/growth?unit=$U" -H "Authorization: Bearer $OWNER")
  [ "$C" = "200" ] && ok "grouping by $U works" || bad "unit $U" "got $C"
done

# -G --data-urlencode so the payload actually reaches the server; pasted raw
# into the URL, curl fails locally and the check proves nothing.
BADUNIT=$(curl -s -o /dev/null -w "%{http_code}" -G \
          "$API/gyms/$GID/attendance/analytics/growth" \
          --data-urlencode "unit=week'; DROP TABLE memberships;--" \
          -H "Authorization: Bearer $OWNER")
[ "$BADUNIT" = "400" ] && ok "an injected grouping unit is rejected outright" || bad "unit guard" "got $BADUNIT"

STILL=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/members" -H "Authorization: Bearer $OWNER")
[ "$STILL" = "200" ] && ok "and the memberships table is still there" || bad "post-injection" "got $STILL"

MEMBER_SEES=$(curl -s -o /dev/null -w "%{http_code}" \
  "$API/gyms/$GID/attendance/analytics/growth" -H "Authorization: Bearer $MEMBER_TOKEN")
[ "$MEMBER_SEES" = "403" ] && ok "a member cannot read gym analytics" || bad "analytics perms" "got $MEMBER_SEES"

hdr "A member's own attendance"
MINE=$(curl -s "$API/me/attendance" -H "Authorization: Bearer $MEMBER_TOKEN")
LEN=$(echo "$MINE" | python -c "import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$LEN" = "1" ] && ok "one entry, for the gym they belong to" || bad "me/attendance" "$MINE"

ZERO=$(echo "$MINE" | python -c "
import sys,json;d=json.load(sys.stdin)[0];print(d['present'],d['weekStreak'])" 2>/dev/null)
[ "$ZERO" = "0 0" ] && ok "nothing attended yet reads as zero, not an error" || bad "empty state" "$ZERO"

# Mark today present, then three earlier weeks, and check the streak logic.
curl -s -X POST "$API/gyms/$GID/attendance" -H "Authorization: Bearer $OWNER" \
  -H 'Content-Type: application/json' \
  -d "{\"subjectType\":\"MEMBER\",\"subjectId\":\"$MID\",\"status\":\"PRESENT\"}" > /dev/null

MINE2=$(curl -s "$API/me/attendance" -H "Authorization: Bearer $MEMBER_TOKEN")
P1=$(echo "$MINE2" | python -c "
import sys,json;d=json.load(sys.stdin)[0];print(d['present'],d['thisMonth'],d['weekStreak'])" 2>/dev/null)
[ "$P1" = "1 1 1" ] && ok "one visit shows as present, this month, one-week streak" || bad "after marking" "$P1"

MUSER=$(db "
  const m = await p.membership.findUnique({where:{id:process.argv[1]},select:{userId:true}});
  console.log(m.userId);
" "$MID" | tail -1)

# Backdate visits into the two previous weeks.
db "
  const gymId = process.argv[1], userId = process.argv[2];
  const mk = async (daysAgo) => {
    const d = new Date(); d.setHours(0,0,0,0); d.setDate(d.getDate() - daysAgo);
    await p.attendanceRecord.create({data:{
      gymId, subjectType:'MEMBER', subjectId:userId, date:d,
      status:'PRESENT', markedById:userId }});
  };
  await mk(7); await mk(14);
" "$GID" "$MUSER" > /dev/null

MINE3=$(curl -s "$API/me/attendance" -H "Authorization: Bearer $MEMBER_TOKEN")
STREAK=$(echo "$MINE3" | python -c "
import sys,json;print(json.load(sys.stdin)[0]['weekStreak'])" 2>/dev/null)
[ "$STREAK" = "3" ] && ok "three weeks running reads as a streak of 3" || bad "streak" "got $STREAK"

# A gap breaks it: a visit 5 weeks back must not extend the run.
db "
  const gymId = process.argv[1], userId = process.argv[2];
  const d = new Date(); d.setHours(0,0,0,0); d.setDate(d.getDate() - 35);
  await p.attendanceRecord.create({data:{
    gymId, subjectType:'MEMBER', subjectId:userId, date:d,
    status:'PRESENT', markedById:userId }});
" "$GID" "$MUSER" > /dev/null

MINE4=$(curl -s "$API/me/attendance" -H "Authorization: Bearer $MEMBER_TOKEN")
STREAK2=$(echo "$MINE4" | python -c "
import sys,json;print(json.load(sys.stdin)[0]['weekStreak'])" 2>/dev/null)
[ "$STREAK2" = "3" ] && ok "a visit across a gap does not extend it" || bad "streak gap" "got $STREAK2"

TOTAL=$(echo "$MINE4" | python -c "
import sys,json;print(json.load(sys.stdin)[0]['present'])" 2>/dev/null)
[ "$TOTAL" = "4" ] && ok "but it still counts toward the total" || bad "total" "got $TOTAL"

# The member's own record must not leak anyone else's.
OTHER=$(curl -s "$API/me/attendance" -H "Authorization: Bearer $OWNER" | python -c "
import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "$OTHER" = "0" ] && ok "an owner with no membership sees an empty list" || bad "leak" "got $OTHER"

hdr "Terms and Privacy"
# A store reviewer and anyone deciding whether to sign up must be able to
# read these without an account, so these calls carry no token.
INDEX=$(curl -s "$API/legal")
DOCS=$(echo "$INDEX" | python -c "
import sys,json;print(','.join(sorted(d['slug'] for d in json.load(sys.stdin)['documents'])))" 2>/dev/null)
[ "$DOCS" = "privacy,terms" ] && ok "both documents are listed" || bad "legal index" "$DOCS"

SUPPORT=$(echo "$INDEX" | field supportEmail)
[ "$SUPPORT" = "support@gymologia.com" ] && ok "the support address is the one in the spec" \
  || bad "support email" "$SUPPORT"

for DOC in terms privacy; do
  BODY=$(curl -s "$API/legal/$DOC" | python -c "
import sys,json;print(len(json.load(sys.stdin).get('body','')))" 2>/dev/null)
  [ "${BODY:-0}" -gt 1500 ] && ok "$DOC has real content ($BODY chars)" || bad "$DOC" "got $BODY chars"
done

MISSING=$(curl -s -o /dev/null -w "%{http_code}" "$API/legal/nonsense")
[ "$MISSING" = "404" ] && ok "an unknown document is a clean 404" || bad "unknown doc" "got $MISSING"

# Chat is encrypted at rest, not end to end. The policy has to say so
# plainly rather than implying a guarantee the software does not give.
HONEST=$(curl -s "$API/legal/privacy" | python -c "
import sys,json;print('NOT END-TO-END' in json.load(sys.stdin)['body'].upper())" 2>/dev/null)
[ "$HONEST" = "True" ] && ok "the privacy policy admits chat is not end-to-end" \
  || bad "encryption honesty" "$HONEST"

STATUS=$(curl -s "$API/me/legal" -H "Authorization: Bearer $MEMBER_TOKEN")
NEEDED=$(echo "$STATUS" | field reacceptanceRequired)
[ "$NEEDED" = "True" ] && ok "a fresh account has not accepted anything yet" \
  || bad "acceptance status" "$NEEDED"

ACCEPTED=$(curl -s -X POST "$API/me/legal/accept" -H "Authorization: Bearer $MEMBER_TOKEN" | field acceptedVersion)
[ -n "$ACCEPTED" ] && ok "accepting records the version, not just a yes" || bad "accept" "empty"

AFTER_ACCEPT=$(curl -s "$API/me/legal" -H "Authorization: Bearer $MEMBER_TOKEN")
DONE=$(echo "$AFTER_ACCEPT" | field reacceptanceRequired)
STAMPED=$(echo "$AFTER_ACCEPT" | field acceptedVersion)
[ "$DONE" = "False" ] && [ "$STAMPED" = "$ACCEPTED" ] \
  && ok "and it is not asked for again" || bad "after accept" "$DONE / $STAMPED"

ANON=$(curl -s -o /dev/null -w "%{http_code}" "$API/me/legal")
[ "$ANON" = "401" ] && ok "the acceptance record needs a signed-in account" || bad "anon accept" "got $ANON"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
