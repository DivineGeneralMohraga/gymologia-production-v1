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

# Git Bash's `date` ignores TZ=Asia/Kolkata and answers in GMT, which made
# every "Indian date" expectation below secretly a UTC one. node is already a
# dependency of this suite, and India has no daylight saving, so the offset
# is exact.
ist_day()   { node -e "console.log(new Date(Date.now()+330*60000).toISOString().slice(0,10))"; }
ist_month() { node -e "console.log(new Date(Date.now()+330*60000).toISOString().slice(0,8)+'01')"; }
ist_plus()  { node -e "console.log(new Date(Date.now()+330*60000+$1*86400000).toISOString().slice(0,10))"; }

# Four digits from the clock mixed with this shell's pid, so two runs
# starting in the same second do not mint the same phone numbers and then
# fight over the same test accounts. That collision produced a confusing
# half-hour of "failures" that were two regressions running at once.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
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
TODAY_IST=$(ist_month)
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

# The boundary case the checks above are too lenient to catch. The columns
# are `timestamp without time zone` holding UTC, so a single
# `col AT TIME ZONE 'Asia/Kolkata'` shifts -5:30 instead of +5:30 and files
# a 7:30am-IST join on the 1st under the PREVIOUS month. Mid-month data
# never crosses a boundary, so it passes either way -- this does not.
BOUNDARY_PHONE="+9197600${STAMP}7"
BLK=$(curl -s -X POST "$API/gyms/$GID/members/lookup" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d "{\"phone\":\"$BOUNDARY_PHONE\"}")
BMID=$(curl -s -X POST "$API/gyms/$GID/members" -H "Authorization: Bearer $OWNER" \
       -H 'Content-Type: application/json' -d "{
       \"challengeId\":\"$(echo "$BLK" | field challengeId)\",\"phone\":\"$BOUNDARY_PHONE\",
       \"code\":\"$(echo "$BLK" | field devCode)\",\"name\":\"Boundary Member\",
       \"planMonths\":1,\"maxLeaveDays\":2}" | field membershipId)

# 02:00 UTC on the 1st of this month == 07:30 IST the same morning.
FIRST_UTC=$(date -u +%Y-%m-01)
db "
  await p.membership.update({
    where:{id:process.argv[1]},
    data:{createdAt:new Date(process.argv[2] + 'T02:00:00.000Z')}});
" "$BMID" "$FIRST_UTC" > /dev/null

CURRENT_MONTH=$(ist_month)
BOUNDARY=$(curl -s "$API/gyms/$GID/attendance/analytics/growth?unit=month&periods=3" \
           -H "Authorization: Bearer $OWNER" | python -c "
import sys,json
d=json.load(sys.stdin)
print(sum(b['joined'] for b in d['buckets'] if b['period']=='$CURRENT_MONTH'))" 2>/dev/null)
[ "$BOUNDARY" = "2" ] && ok "a 7:30am-IST join on the 1st counts in that month, not the one before" \
  || bad "IST boundary" "got $BOUNDARY joins in $CURRENT_MONTH, expected 2"

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
# Seeded as UTC midnight of the Indian calendar day, which is how a @db.Date
# column stores it. Building local midnight instead lands a day early.
db "
  const gymId = process.argv[1], userId = process.argv[2];
  const istDay = (daysAgo) => {
    const ist = new Date(Date.now() + 330*60000);
    return new Date(Date.UTC(ist.getUTCFullYear(), ist.getUTCMonth(), ist.getUTCDate() - daysAgo));
  };
  const mk = async (daysAgo) => {
    await p.attendanceRecord.create({data:{
      gymId, subjectType:'MEMBER', subjectId:userId, date:istDay(daysAgo),
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
  const ist = new Date(Date.now() + 330*60000);
  const d = new Date(Date.UTC(ist.getUTCFullYear(), ist.getUTCMonth(), ist.getUTCDate() - 35));
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

hdr "Indian calendar days"
# Attendance dates used to be cut on UTC. A 5am session -- when a great many
# Indian gyms are busiest -- is 23:30 UTC the PREVIOUS day, so a Monday visit
# was recorded against Sunday. Worse, an 8am visit the same morning is a
# different UTC date, so the unique index stored two records for one day.
TODAY_IST=$(ist_day)
MARKED=$(curl -s "$API/gyms/$GID/attendance?subjectType=MEMBER" -H "Authorization: Bearer $OWNER" | python -c "
import sys,json
rows=json.load(sys.stdin)
print(sum(1 for r in rows if str(r.get('date',''))[:10]=='$TODAY_IST'))" 2>/dev/null)
[ "${MARKED:-0}" -ge 1 ] && ok "today's attendance is filed under today's Indian date" \
  || bad "IST attendance day" "no record on $TODAY_IST"

hdr "Engagement"
# A SECOND attending member, and the reason is the whole point of this
# section. With one, "count the distinct attendees" and "measure the length
# of the row array" both answer 1, so the check below would pass against
# either -- the exact shape of a check that cannot fail. With two present
# out of three active it is 67% the right way and 33% the wrong way.
P_MEMBER2="+9197600${STAMP}5"
login "$P_MEMBER2" "Second Member" > /dev/null
M2RES=$(add_member "$OWNER" "$GID" "$P_MEMBER2" "Second Member")
M2USER=$(echo "$M2RES" | nested user id)
[ -n "$M2USER" ] && ok "a second member joined" || bad "second member" "$M2RES"

curl -s -X POST "$API/gyms/$GID/attendance" -H "Authorization: Bearer $OWNER" \
  -H 'Content-Type: application/json' \
  -d "{\"subjectType\":\"MEMBER\",\"subjectId\":\"$M2USER\",\"status\":\"PRESENT\"}" > /dev/null

# engagedMembers used to be produced by fetching one row per attending
# member and taking the array's length. Counting it in the database instead
# is invisible to a test that only asks whether the rate is a percentage --
# which is what the admin suite asked, and why nothing caught the moment the
# rate started being computed from a different number than the count beside
# it. These two must agree with each other and with the members marked
# present above.
SUM=$(curl -s "$API/gyms/$GID/attendance/analytics" -H "Authorization: Bearer $OWNER")
ENGAGED=$(echo "$SUM" | python -c "import sys,json;print(json.load(sys.stdin)['engagedMembers'])" 2>/dev/null)
ACTIVE=$(echo "$SUM" | python -c "import sys,json;print(json.load(sys.stdin)['activeMembers'])" 2>/dev/null)
RATE=$(echo "$SUM" | python -c "import sys,json;print(json.load(sys.stdin)['engagementRate'])" 2>/dev/null)

[ -n "$ENGAGED" ] && [ "$ENGAGED" -ge 2 ] 2>/dev/null \
  && ok "engagedMembers counts the members who actually turned up ($ENGAGED)" \
  || bad "engagedMembers" "got '${ENGAGED:-<nothing>}', expected at least 2"

# Which of these two actually discriminates is worth being precise about,
# because I got it wrong first time. The COUNT above is the one that
# catches the bug: reverting the fix makes engagedMembers report 1 instead
# of 2 and that check fails. The consistency check below passes against the
# broken version -- 1 engaged of 3 active is 33%, which is perfectly
# self-consistent. It is not redundant, but it guards a different thing:
# that the count and the rate are never again computed from two different
# sources, which is what the original bug actually was.
if [ -n "$ENGAGED" ] && [ -n "$ACTIVE" ] && [ -n "$RATE" ]; then
  WANT=$(python -c "print(round(($ENGAGED/$ACTIVE)*100) if $ACTIVE else 0)" 2>/dev/null)
  [ "$RATE" = "$WANT" ] \
    && ok "engagementRate agrees with the count beside it ($RATE%)" \
    || bad "engagementRate" "reported $RATE, but $ENGAGED of $ACTIVE is $WANT"
else
  bad "engagementRate" "nothing to inspect: ${SUM:-<nothing>}"
fi

# Marking a second time the same Indian day must update the one record
# rather than create another under a different UTC date.
curl -s -X POST "$API/gyms/$GID/attendance" -H "Authorization: Bearer $OWNER" \
  -H 'Content-Type: application/json' \
  -d "{\"subjectType\":\"MEMBER\",\"subjectId\":\"$MID\",\"status\":\"PRESENT\"}" > /dev/null

DUPES=$(db "
  const rows = await p.attendanceRecord.groupBy({
    by:['date'],
    where:{gymId:process.argv[1], subjectId:process.argv[2]},
    _count:{_all:true}});
  console.log(Math.max(...rows.map(r=>r._count._all)));
" "$GID" "$MUSER" | tail -1)
[ "$DUPES" = "1" ] && ok "marking twice in one Indian day keeps one record" || bad "duplicate day" "got $DUPES"

# A date in the future is refused, and "future" is judged in Indian time.
TOMORROW=$(ist_plus 2)
if [ -n "$TOMORROW" ]; then
  FUTURE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/attendance" \
    -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
    -d "{\"subjectType\":\"MEMBER\",\"subjectId\":\"$MID\",\"date\":\"$TOMORROW\",\"status\":\"PRESENT\"}")
  [ "$FUTURE" = "400" ] && ok "a future date is refused" || bad "future date" "got $FUTURE"
fi

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
