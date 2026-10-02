#!/usr/bin/env bash
#
# Chat: standing groups, direct messages, and the two access rules that
# are easy to get wrong — nobody opens a chat with the owner except a
# manager, and staff stay out of the members-only group.
#
#   bash test/chat-e2e.sh

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

me() { curl -s "$API/auth/me" -H "Authorization: Bearer $1" | field id; }

role_id() { curl -s "$API/gyms/$2/roles" -H "Authorization: Bearer $1" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next((r['id'] for r in d if r['name']==sys.argv[1]), ''))" "$3"; }

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

add_staff() {
  local token="$1" gid="$2" phone="$3" name="$4" role="$5" lk
  lk=$(curl -s -X POST "$API/gyms/$gid/staff/lookup" -H "Authorization: Bearer $token" \
       -H 'Content-Type: application/json' -d "{\"phone\":\"$phone\"}")
  curl -s -X POST "$API/gyms/$gid/staff" -H "Authorization: Bearer $token" \
    -H 'Content-Type: application/json' -d "{
    \"challengeId\":\"$(echo "$lk" | field challengeId)\",\"phone\":\"$phone\",
    \"code\":\"$(echo "$lk" | field devCode)\",\"name\":\"$name\",
    \"roleId\":\"$role\"}" > /dev/null
}

# Four digits from the clock mixed with this shell's pid, so two runs
# starting in the same second do not mint the same phone numbers and then
# fight over the same test accounts. That collision produced a confusing
# half-hour of "failures" that were two regressions running at once.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_OWNER="+9198600${STAMP}1"
P_MANAGER="+9198600${STAMP}2"
P_TRAINER="+9198600${STAMP}3"
P_MEMBER="+9198600${STAMP}4"

hdr "Setup"
OWNER=$(login "$P_OWNER" "Chat Owner")
GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Chat Gym\",\"addressLine1\":\"7 Talk St\",\"state\":\"Delhi\",
           \"district\":\"New Delhi\",\"city\":\"New Delhi\",\"pincode\":\"110001\",
           \"contactPhone\":\"$P_OWNER\"}" | field id)
[ -n "$GID" ] && ok "gym created" || { bad "setup" "no gym"; exit 1; }
node test/tools/activate-gym.js "$GID" > /dev/null || { bad "setup" "could not activate the gym"; exit 1; }

MANAGER_ROLE=$(role_id "$OWNER" "$GID" Manager)
TRAINER_ROLE=$(role_id "$OWNER" "$GID" Trainer)
add_staff "$OWNER" "$GID" "$P_MANAGER" "The Manager" "$MANAGER_ROLE"
add_staff "$OWNER" "$GID" "$P_TRAINER" "The Trainer" "$TRAINER_ROLE"
add_member "$OWNER" "$GID" "$P_MEMBER" "The Member"
ok "manager, trainer and member added"

MANAGER=$(login "$P_MANAGER" "The Manager")
TRAINER=$(login "$P_TRAINER" "The Trainer")
MEMBER=$(login "$P_MEMBER" "The Member")
OWNER_ID=$(me "$OWNER")
MEMBER_ID=$(me "$MEMBER")
TRAINER_ID=$(me "$TRAINER")

hdr "Standing groups"
CONVS=$(curl -s "$API/gyms/$GID/chat/conversations" -H "Authorization: Bearer $MEMBER")
echo "$CONVS" | grep -q 'OFFICIAL_GROUP' && ok "member is in the everyone group" \
  || bad "official group" "$CONVS"
echo "$CONVS" | grep -q 'UNOFFICIAL_GROUP' && ok "member is in the members-only group" \
  || bad "unofficial group" "$CONVS"

STAFF_CONVS=$(curl -s "$API/gyms/$GID/chat/conversations" -H "Authorization: Bearer $TRAINER")
echo "$STAFF_CONVS" | grep -q 'OFFICIAL_GROUP' && ok "staff are in the everyone group" \
  || bad "staff official" "$STAFF_CONVS"
echo "$STAFF_CONVS" | grep -q 'UNOFFICIAL_GROUP' \
  && bad "leak" "staff can see the members-only group" \
  || ok "staff are NOT in the members-only group"

hdr "The owner rule"
BLOCKED=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/chat/direct" \
  -H "Authorization: Bearer $MEMBER" -H 'Content-Type: application/json' \
  -d "{\"userId\":\"$OWNER_ID\"}")
[ "$BLOCKED" = "403" ] && ok "a member cannot open a chat with the owner" \
  || bad "owner rule" "expected 403, got $BLOCKED"

T_BLOCKED=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/chat/direct" \
  -H "Authorization: Bearer $TRAINER" -H 'Content-Type: application/json' \
  -d "{\"userId\":\"$OWNER_ID\"}")
[ "$T_BLOCKED" = "403" ] && ok "nor can a trainer" || bad "owner rule staff" "got $T_BLOCKED"

MGR_CONV=$(curl -s -X POST "$API/gyms/$GID/chat/direct" -H "Authorization: Bearer $MANAGER" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$OWNER_ID\"}" | field id)
[ -n "$MGR_CONV" ] && ok "a manager can" || bad "manager to owner" "no conversation"

# The owner starting it is what unlocks the reply, and it does so simply by
# making the conversation exist.
OWNER_CONV=$(curl -s -X POST "$API/gyms/$GID/chat/direct" -H "Authorization: Bearer $OWNER" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$MEMBER_ID\"}" | field id)
[ -n "$OWNER_CONV" ] && ok "the owner can message anyone" || bad "owner outbound" "none"

REPLY=$(curl -s -X POST "$API/gyms/$GID/chat/conversations/$OWNER_CONV/messages" \
  -H "Authorization: Bearer $MEMBER" -H 'Content-Type: application/json' \
  -d '{"body":"Thanks for reaching out."}' | field id)
[ -n "$REPLY" ] && ok "and the member can reply once he has" || bad "reply" "no message"

hdr "Messaging"
DM=$(curl -s -X POST "$API/gyms/$GID/chat/direct" -H "Authorization: Bearer $MEMBER" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$TRAINER_ID\"}" | field id)
[ -n "$DM" ] && ok "member opened a chat with their trainer" || bad "dm" "none"

SENT=$(curl -s -X POST "$API/gyms/$GID/chat/conversations/$DM/messages" \
  -H "Authorization: Bearer $MEMBER" -H 'Content-Type: application/json' \
  -d '{"body":"Can we move Thursday to Friday?"}')
[ "$(echo "$SENT" | field body)" = "Can we move Thursday to Friday?" ] \
  && ok "message sent and read back intact" || bad "send" "$SENT"

# Opening the same pair again must land on the same conversation, or every
# message would start a new thread.
SAME=$(curl -s -X POST "$API/gyms/$GID/chat/direct" -H "Authorization: Bearer $TRAINER" \
  -H 'Content-Type: application/json' -d "{\"userId\":\"$MEMBER_ID\"}" | field id)
[ "$SAME" = "$DM" ] && ok "reopening finds the same conversation" \
  || bad "duplicate" "$SAME vs $DM"

UNREAD=$(curl -s "$API/gyms/$GID/chat/conversations" -H "Authorization: Bearer $TRAINER" | python -c "
import sys,json
d=json.load(sys.stdin)
print(sum(c['unread'] for c in d))" 2>/dev/null)
[ "$UNREAD" -ge 1 ] 2>/dev/null && ok "the trainer has an unread count" || bad "unread" "got $UNREAD"

curl -s "$API/gyms/$GID/chat/conversations/$DM/messages" -H "Authorization: Bearer $TRAINER" > /dev/null
AFTER=$(curl -s "$API/gyms/$GID/chat/conversations" -H "Authorization: Bearer $TRAINER" | python -c "
import sys,json
d=json.load(sys.stdin)
print(sum(c['unread'] for c in d))" 2>/dev/null)
[ "$AFTER" -lt "$UNREAD" ] 2>/dev/null && ok "reading clears it" || bad "mark read" "$UNREAD then $AFTER"

hdr "Encryption at rest"
STORED=$(node -e '
  const fs=require("fs");
  for (const l of fs.readFileSync(".env","utf8").split(/\r?\n/)) {
    const m=/^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
    if (m) process.env[m[1]] = m[2].replace(/^"|"$/g,"");
  }
  const {PrismaClient}=require("@prisma/client");
  const p=new PrismaClient();
  p.message.findFirst({where:{conversationId:process.argv[1]},orderBy:{createdAt:"desc"}})
    .then(m=>{ console.log(JSON.stringify({c:m.ciphertext.slice(0,20), n:m.nonce})); return p.$disconnect(); });
' "$DM")
# Establish that the row was actually read before drawing any conclusion
# from its contents. "The plaintext is not in there" is trivially true of
# an empty string, so when the helper above failed -- a dropped database
# connection was enough -- this reported that message bodies were safely
# encrypted while having looked at nothing at all. The most reassuring
# check in the suite was the one that could not fail.
echo "$STORED" | grep -q '"c":' \
  && ok "the stored row was read back" \
  || { bad "read stored row" "helper returned: ${STORED:-<nothing>}"; STORED=""; }

if [ -n "$STORED" ]; then
  echo "$STORED" | grep -q 'Thursday' \
    && bad "plaintext" "the message body is readable in the database" \
    || ok "the body is not stored in plain text"
  echo "$STORED" | grep -q 'v1-server' \
    && ok "and is stamped with the scheme that wrote it" || bad "scheme stamp" "$STORED"
fi

hdr "Access"
OUTSIDER=$(login "+9198600${STAMP}9" "Outsider")
NO_ACCESS=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/chat/conversations" \
  -H "Authorization: Bearer $OUTSIDER")
[ "$NO_ACCESS" = "403" ] && ok "someone outside the gym sees nothing" \
  || bad "outsider" "got $NO_ACCESS"

PEEK=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/chat/conversations/$DM/messages" \
  -H "Authorization: Bearer $MANAGER")
[ "$PEEK" = "403" ] && ok "a manager cannot read someone else's direct messages" \
  || bad "dm privacy" "got $PEEK"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
