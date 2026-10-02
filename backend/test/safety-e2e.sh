#!/usr/bin/env bash
#
# Blocking and reporting.
#
#   bash test/safety-e2e.sh
#
# A block button that writes a row and changes nothing else is worse than no
# button, because the person believes they are out of reach and they are
# not. So most of this suite is not "does the endpoint return 200" -- it is
# every route by which one person's words could still arrive: the history,
# the conversation list, the unread badge, the directory, a fresh direct
# conversation, and a group made specially to get around it.
#
# The other half is what a block must NOT do, which is tell anyone. If the
# blocked party can work out that they were blocked, the feature has moved
# the argument somewhere this app cannot see.

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
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":30}")
  fi
  echo "$v" | nested tokens accessToken
}

me() { curl -s "$API/auth/me" -H "Authorization: Bearer $1" | field id; }

# Same helper as admin-e2e. Used here for one thing only: promoting an
# account that is ALREADY signed in to admin staff. Logging in a fifth
# person instead would put this suite at the /auth/otp/request limit of
# five per minute, and the setup would start failing for reasons that have
# nothing to do with blocking or reporting.
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

add_member() {
  local token="$1" gid="$2" phone="$3" name="$4" lk
  lk=$(curl -s -X POST "$API/gyms/$gid/members/lookup" -H "Authorization: Bearer $token" \
       -H 'Content-Type: application/json' -d "{\"phone\":\"$phone\"}")
  curl -s -X POST "$API/gyms/$gid/members" -H "Authorization: Bearer $token" \
    -H 'Content-Type: application/json' -d "{
    \"challengeId\":\"$(echo "$lk" | field challengeId)\",\"phone\":\"$phone\",
    \"code\":\"$(echo "$lk" | field devCode)\",\"name\":\"$name\",
    \"age\":30,\"planMonths\":6,\"maxLeaveDays\":4}" > /dev/null
}

# Same collision guard as the other suites: two runs starting in the same
# second must not mint the same numbers and then fight over the accounts.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_OWNER="+9198611${STAMP}1"
P_ALICE="+9198611${STAMP}2"
P_BOB="+9198611${STAMP}3"
P_CAROL="+9198611${STAMP}4"

# These suites run against the live database, and below some of these
# accounts are made admin staff -- real-format phone numbers holding admin
# roles on the real admin app. Revoke every admin role they were given on
# the way out, however the suite ends.
revoke_admins() {
  db "await p.adminStaff.updateMany({
        where: { user: { phone: { in: process.argv.slice(1).filter(Boolean) } } },
        data: { status: 'REMOVED' } });" "$P_OWNER" "$P_ALICE" "$P_BOB" "$P_CAROL" > /dev/null 2>&1
}
trap revoke_admins EXIT

hdr "Setup"
OWNER=$(login "$P_OWNER" "Safety Owner")
GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Safety Gym\",\"addressLine1\":\"9 Quiet Rd\",\"state\":\"Delhi\",
           \"district\":\"New Delhi\",\"city\":\"New Delhi\",\"pincode\":\"110001\",
           \"contactPhone\":\"$P_OWNER\"}" | field id)
[ -n "$GID" ] && ok "gym created" || { bad "setup" "no gym"; exit 1; }
node test/tools/activate-gym.js "$GID" > /dev/null || { bad "setup" "could not activate the gym"; exit 1; }

add_member "$OWNER" "$GID" "$P_ALICE" "Alice"
add_member "$OWNER" "$GID" "$P_BOB" "Bob"
add_member "$OWNER" "$GID" "$P_CAROL" "Carol"

ALICE=$(login "$P_ALICE" "Alice")
BOB=$(login "$P_BOB" "Bob")
CAROL=$(login "$P_CAROL" "Carol")
ALICE_ID=$(me "$ALICE"); BOB_ID=$(me "$BOB"); CAROL_ID=$(me "$CAROL")
[ -n "$ALICE_ID" ] && [ -n "$BOB_ID" ] && ok "three members signed in" \
  || { bad "setup" "missing ids"; exit 1; }

# A conversation and a message BEFORE any block, because the interesting
# case is the thread that already exists. A block that only stops new
# conversations leaves every current one running.
DM=$(curl -s -X POST "$API/gyms/$GID/chat/direct" -H "Authorization: Bearer $BOB" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$ALICE_ID\"}" | field id)
MSG_ID=$(curl -s -X POST "$API/gyms/$GID/chat/conversations/$DM/messages" \
  -H "Authorization: Bearer $BOB" -H 'Content-Type: application/json' \
  -d '{"body":"UNWANTED MESSAGE FROM BOB"}' | field id)
[ -n "$MSG_ID" ] && ok "Bob messaged Alice before the block" || bad "setup dm" "no message"

# Alice can see it now. If this fails, everything below proves nothing.
BEFORE=$(curl -s "$API/gyms/$GID/chat/conversations/$DM/messages" -H "Authorization: Bearer $ALICE")
echo "$BEFORE" | grep -q 'UNWANTED MESSAGE' && ok "and Alice can read it" \
  || bad "baseline" "Alice cannot see the message before blocking: $BEFORE"

hdr "Blocking"
B=$(curl -s -X POST "$API/me/blocks" -H "Authorization: Bearer $ALICE" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$BOB_ID\",\"reason\":\"kept messaging\"}")
[ "$(echo "$B" | field blocked)" = "True" ] && ok "Alice blocked Bob" || bad "block" "$B"

# Twice is the same state as once.
AGAIN=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/me/blocks" \
  -H "Authorization: Bearer $ALICE" -H 'Content-Type: application/json' \
  -d "{\"userId\":\"$BOB_ID\"}")
[ "$AGAIN" = "201" ] || [ "$AGAIN" = "200" ] && ok "blocking twice is not an error" \
  || bad "idempotent block" "got $AGAIN"

SELF=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/me/blocks" \
  -H "Authorization: Bearer $ALICE" -H 'Content-Type: application/json' \
  -d "{\"userId\":\"$ALICE_ID\"}")
[ "$SELF" = "400" ] && ok "blocking yourself is refused" || bad "self block" "got $SELF"

hdr "What the block actually does"
AFTER=$(curl -s "$API/gyms/$GID/chat/conversations/$DM/messages" -H "Authorization: Bearer $ALICE")
echo "$AFTER" | grep -q 'UNWANTED MESSAGE' \
  && bad "history" "Alice can still read the blocked message" \
  || ok "the message is gone from Alice's history"

# The other direction. Bob does not get to keep watching Alice either --
# hiding only one side leaves the person who blocked still being read.
BOB_VIEW=$(curl -s "$API/gyms/$GID/chat/conversations" -H "Authorization: Bearer $BOB")
echo "$BOB_VIEW" | python -c "
import sys, json
convs = json.load(sys.stdin)
print('yes' if any(c['id'] == sys.argv[1] for c in convs) else 'no')" "$DM" 2>/dev/null | grep -q '^no$' \
  && ok "and the thread is gone from Bob's list too" \
  || bad "one-sided" "Bob still sees the conversation"

ALICE_LIST=$(curl -s "$API/gyms/$GID/chat/conversations" -H "Authorization: Bearer $ALICE")
echo "$ALICE_LIST" | grep -q 'UNWANTED MESSAGE' \
  && bad "preview leak" "the blocked message shows as a preview in the list" \
  || ok "no preview of it in the conversation list"

UNREAD=$(echo "$ALICE_LIST" | python -c "
import sys, json
print(sum(c['unread'] for c in json.load(sys.stdin)))" 2>/dev/null)
[ "${UNREAD:-1}" = "0" ] && ok "no unread badge for a message she cannot open" \
  || bad "unread badge" "got $UNREAD -- a badge for hidden messages is a badge that never clears"

SEND_BACK=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  "$API/gyms/$GID/chat/conversations/$DM/messages" -H "Authorization: Bearer $BOB" \
  -H 'Content-Type: application/json' -d '{"body":"Are you ignoring me?"}')
[ "$SEND_BACK" = "403" ] && ok "Bob cannot send into the existing thread" \
  || bad "send" "expected 403, got $SEND_BACK"

REOPEN=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/chat/direct" \
  -H "Authorization: Bearer $BOB" -H 'Content-Type: application/json' \
  -d "{\"userId\":\"$ALICE_ID\"}")
[ "$REOPEN" = "403" ] && ok "nor open a new one" || bad "reopen" "expected 403, got $REOPEN"

# The obvious way around a block: make a group and put them both in it.
GROUP=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/chat/groups" \
  -H "Authorization: Bearer $BOB" -H 'Content-Type: application/json' \
  -d "{\"name\":\"Just us\",\"userIds\":[\"$ALICE_ID\"]}")
[ "$GROUP" = "403" ] && ok "and cannot make a group with her in it" \
  || bad "group workaround" "expected 403, got $GROUP"

DIR=$(curl -s "$API/gyms/$GID/chat/directory" -H "Authorization: Bearer $ALICE")
echo "$DIR" | grep -q "$BOB_ID" && bad "directory" "Bob is still listed for Alice" \
  || ok "Bob is absent from Alice's directory"

# Symmetrical on purpose: if Alice vanished from Bob's list but he stayed on
# hers, the shape of the list would tell him which way the block went.
BOB_DIR=$(curl -s "$API/gyms/$GID/chat/directory" -H "Authorization: Bearer $BOB")
echo "$BOB_DIR" | grep -q "$ALICE_ID" && bad "directory" "Alice is still listed for Bob" \
  || ok "and Alice is absent from Bob's"

hdr "What the block must not say"
# Bob is never told. The refusals he gets must not confirm a block, or the
# silence is worthless and the argument moves off the platform.
BOB_MSG=$(curl -s -X POST "$API/gyms/$GID/chat/direct" -H "Authorization: Bearer $BOB" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$ALICE_ID\"}" | field message)
echo "$BOB_MSG" | grep -qi 'block' \
  && bad "disclosure" "the refusal shown to Bob says 'block': $BOB_MSG" \
  || ok "the refusal Bob sees does not mention blocking"

BOB_BLOCKS=$(curl -s "$API/me/blocks" -H "Authorization: Bearer $BOB")
echo "$BOB_BLOCKS" | grep -q "$ALICE_ID" \
  && bad "disclosure" "Bob's block list reveals that Alice blocked him" \
  || ok "his own block list does not reveal hers"

# Alice, by contrast, is told plainly -- she needs to know to undo it.
ALICE_MSG=$(curl -s -X POST "$API/gyms/$GID/chat/direct" -H "Authorization: Bearer $ALICE" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$BOB_ID\"}" | field message)
echo "$ALICE_MSG" | grep -qi 'blocked this person' \
  && ok "but Alice is told plainly that she blocked him" \
  || bad "blocker message" "unhelpful: $ALICE_MSG"

MY_BLOCKS=$(curl -s "$API/me/blocks" -H "Authorization: Bearer $ALICE")
echo "$MY_BLOCKS" | grep -q "$BOB_ID" && ok "and he is in her block list" \
  || bad "block list" "$MY_BLOCKS"

hdr "Reporting"
R=$(curl -s -X POST "$API/me/reports" -H "Authorization: Bearer $ALICE" \
  -H 'Content-Type: application/json' -d "{
  \"reportedUserId\":\"$BOB_ID\",\"category\":\"HARASSMENT\",\"messageId\":\"$MSG_ID\",
  \"conversationId\":\"$DM\",\"gymId\":\"$GID\",
  \"details\":\"He kept messaging me after I asked him to stop.\"}")
[ -n "$(echo "$R" | field id)" ] && ok "Alice filed a report" || bad "report" "$R"

# The response must say that a report is not a block, because believing
# otherwise is the commonest way a person is let down by one.
echo "$R" | field message | grep -qi 'block' \
  && ok "and is told that reporting is not blocking" || bad "report copy" "$(echo "$R" | field message)"

DUP=$(curl -s -X POST "$API/me/reports" -H "Authorization: Bearer $ALICE" \
  -H 'Content-Type: application/json' -d "{
  \"reportedUserId\":\"$BOB_ID\",\"category\":\"HARASSMENT\",\"messageId\":\"$MSG_ID\",
  \"details\":\"Same message again.\"}")
echo "$DUP" | field message | grep -qi 'already' \
  && ok "reporting the same message twice is absorbed, not duplicated" \
  || bad "duplicate report" "$DUP"

# A report that pins someone else's words on an innocent account would be
# invisible to the reviewer, who cannot read the message to check.
WRONG=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/me/reports" \
  -H "Authorization: Bearer $ALICE" -H 'Content-Type: application/json' -d "{
  \"reportedUserId\":\"$CAROL_ID\",\"category\":\"SPAM\",\"messageId\":\"$MSG_ID\",
  \"details\":\"Blaming Carol for a message Bob sent.\"}")
[ "$WRONG" = "400" ] && ok "a message cannot be pinned on the wrong account" \
  || bad "attribution" "expected 400, got $WRONG"

SELF_R=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/me/reports" \
  -H "Authorization: Bearer $ALICE" -H 'Content-Type: application/json' -d "{
  \"reportedUserId\":\"$ALICE_ID\",\"category\":\"OTHER\",\"details\":\"Reporting myself.\"}")
[ "$SELF_R" = "400" ] && ok "reporting yourself is refused" || bad "self report" "got $SELF_R"

THIN=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/me/reports" \
  -H "Authorization: Bearer $ALICE" -H 'Content-Type: application/json' -d "{
  \"reportedUserId\":\"$BOB_ID\",\"category\":\"OTHER\",\"details\":\"bad\"}")
[ "$THIN" = "400" ] && ok "and a report with no substance is refused" \
  || bad "details length" "expected 400, got $THIN -- the server cannot read the message, so this text is the whole case"

MINE=$(curl -s "$API/me/reports" -H "Authorization: Bearer $ALICE")
echo "$MINE" | grep -q 'HARASSMENT' && ok "Alice can see what she reported" || bad "my reports" "$MINE"

hdr "The review queue is staff-only"
NOT_ADMIN=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/reports" \
  -H "Authorization: Bearer $ALICE")
[ "$NOT_ADMIN" = "403" ] && ok "an ordinary member cannot read the queue" \
  || bad "admin guard" "expected 403, got $NOT_ADMIN"

NO_AUTH=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/reports")
[ "$NO_AUTH" = "401" ] && ok "and neither can an anonymous caller" \
  || bad "anon" "expected 401, got $NO_AUTH"

hdr "The review desk"
# The gym owner, already signed in above, becomes platform support. The
# report Alice filed has to be readable and resolvable by a person, or the
# form she filled in was theatre.
#
# BEFORE the unblocking section on purpose. The detail check below asserts
# that a reviewer can see how many people have blocked this account, and
# that count is one only while Alice's block stands.
db "
  const u = await p.user.findUnique({where:{phone:process.argv[1]}});
  await p.adminStaff.create({data:{userId:u.id, role:'CUSTOMER_SUPPORT'}});
" "$P_OWNER" > /dev/null

RID=$(echo "$R" | field id)
QUEUE=$(curl -s "$API/admin/reports?status=OPEN" -H "Authorization: Bearer $OWNER")
IN_QUEUE=$(echo "$QUEUE" | python -c "
import sys, json
items = json.load(sys.stdin)['items']
print('yes' if any(i['id'] == sys.argv[1] for i in items) else 'no')" "$RID" 2>/dev/null)
[ "$IN_QUEUE" = "yes" ] && ok "the report is in the queue" || bad "queue" "$QUEUE"

# Customer support is the role most likely to be told "senior staff only",
# and doing that is how a harassment report waits a week.
echo "$QUEUE" | grep -q 'kept messaging me' \
  && ok "and customer support can read what the reporter wrote" \
  || bad "details" "the reporter's account is not in the queue payload"

DETAIL=$(curl -s "$API/admin/reports/$RID" -H "Authorization: Bearer $OWNER")
BLOCKS=$(echo "$DETAIL" | python -c "
import sys, json
print(json.load(sys.stdin)['context']['peopleWhoHaveBlockedThisAccount'])" 2>/dev/null)
[ "${BLOCKS:-0}" -ge 1 ] 2>/dev/null \
  && ok "the detail carries how many people blocked him ($BLOCKS)" \
  || bad "context" "expected at least Alice's block, got ${BLOCKS:-none}"

# The body is withheld from this desk, and the reviewer is told so --
# one who thinks it failed to load goes looking for a way to open it.
#
# The note must NOT say the message is unreadable by the service. It is
# not: the server holds the key and ChatService decrypts bodies on every
# read. A reviewer told otherwise repeats it to somebody who relies on it,
# which is how a comfortable falsehood ends up in a privacy policy.
NOTE=$(echo "$DETAIL" | python -c "
import sys, json
m = json.load(sys.stdin).get('message') or {}
note = (m.get('bodyNote') or '').lower()
withheld = m.get('body') is None and 'not shown' in note
overclaims = 'cannot be read' in note or 'no key' in note
print('said' if withheld and not overclaims else 'over' if overclaims else 'no')" 2>/dev/null)
[ "$NOTE" = "said" ] \
  && ok "and says the body is withheld here, without overclaiming" \
  || bad "encryption note" "got: $NOTE"

# A decision with no note is not a decision anybody can act on later.
NO_NOTE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/reports/$RID/resolve" \
  -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
  -d '{"status":"DISMISSED","actionTaken":""}')
[ "$NO_NOTE" = "400" ] && ok "resolving without saying what was done is refused" \
  || bad "empty note" "expected 400, got $NO_NOTE"

BACKWARDS=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/reports/$RID/resolve" \
  -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
  -d '{"status":"OPEN","actionTaken":"putting it back"}')
[ "$BACKWARDS" = "400" ] && ok "and so is moving one back to open" \
  || bad "reopen" "expected 400, got $BACKWARDS"

DONE=$(curl -s -X POST "$API/admin/reports/$RID/resolve" -H "Authorization: Bearer $OWNER" \
  -H 'Content-Type: application/json' \
  -d '{"status":"ACTIONED","actionTaken":"Warned by phone."}')
[ "$(echo "$DONE" | field status)" = "ACTIONED" ] && ok "a decision is recorded" \
  || bad "resolve" "$DONE"

# Alice sees the outcome, and nothing more. What was decided about somebody
# else's account is not hers to read.
HERS=$(curl -s "$API/me/reports" -H "Authorization: Bearer $ALICE")
echo "$HERS" | grep -q 'ACTIONED' && ok "the reporter sees that it was actioned" \
  || bad "reporter view" "$HERS"
echo "$HERS" | grep -q 'Warned by phone' \
  && bad "leak" "the reviewer's note is visible to the reporter" \
  || ok "but not the reviewer's note about him"

hdr "Unblocking"
U=$(curl -s -X DELETE "$API/me/blocks/$BOB_ID" -H "Authorization: Bearer $ALICE")
[ "$(echo "$U" | field blocked)" = "False" ] && ok "Alice unblocked Bob" || bad "unblock" "$U"

TWICE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/me/blocks/$BOB_ID" \
  -H "Authorization: Bearer $ALICE")
[ "$TWICE" = "200" ] && ok "unblocking twice is not an error" || bad "idempotent unblock" "got $TWICE"

RESTORED=$(curl -s "$API/gyms/$GID/chat/conversations/$DM/messages" -H "Authorization: Bearer $ALICE")
echo "$RESTORED" | grep -q 'UNWANTED MESSAGE' \
  && ok "the history comes back -- blocking hid it, it did not delete it" \
  || bad "unblock restore" "the message did not come back: $RESTORED"

NOW_SENDS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  "$API/gyms/$GID/chat/conversations/$DM/messages" -H "Authorization: Bearer $BOB" \
  -H 'Content-Type: application/json' -d '{"body":"Sorry about before."}')
[ "$NOW_SENDS" = "201" ] && ok "and Bob can message her again" \
  || bad "unblock send" "expected 201, got $NOW_SENDS"

hdr "Blocks are the person's, not the gym's"
# Somebody who leaves a gym and joins another must not find the person they
# escaped waiting for them there.
curl -s -X POST "$API/me/blocks" -H "Authorization: Bearer $CAROL" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$BOB_ID\"}" > /dev/null
CAROL_BLOCKS=$(curl -s "$API/me/blocks" -H "Authorization: Bearer $CAROL")
echo "$CAROL_BLOCKS" | grep -q "$BOB_ID" \
  && ok "a block is held against the account, not a membership" \
  || bad "scope" "$CAROL_BLOCKS"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
