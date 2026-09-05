#!/usr/bin/env bash
#
# Events and notifications, both sides.
#
#   bash test/events-notifications-e2e.sh
#
# The interesting cases are the ordering rules in the member feed and the
# three ways participation can be refused.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

field() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;d=json.load(sys.stdin);print(d.get('$1',{}).get('$2',''))" 2>/dev/null; }
count() { python -c "import sys,json;print(len(json.load(sys.stdin).get('$1',[])))" 2>/dev/null; }

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

add_member() {
  local token="$1" gid="$2" phone="$3" name="$4" lk
  lk=$(curl -s -X POST "$API/gyms/$gid/members/lookup" -H "Authorization: Bearer $token" \
       -H 'Content-Type: application/json' -d "{\"phone\":\"$phone\"}")
  curl -s -X POST "$API/gyms/$gid/members" -H "Authorization: Bearer $token" \
    -H 'Content-Type: application/json' -d "{
    \"challengeId\":\"$(echo "$lk" | field challengeId)\",\"phone\":\"$phone\",
    \"code\":\"$(echo "$lk" | field devCode)\",\"name\":\"$name\",
    \"planMonths\":6,\"maxLeaveDays\":4}" | field membershipId
}

# Four digits from the clock mixed with this shell's pid, so two runs
# starting in the same second do not mint the same phone numbers and then
# fight over the same test accounts. That collision produced a confusing
# half-hour of "failures" that were two regressions running at once.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_PRO="+9198500${STAMP}1"
P_BASIC="+9198500${STAMP}2"
P_MEMBER="+9198500${STAMP}3"
P_STRANGER="+9198500${STAMP}4"

hdr "Setup: one Pro gym, one unpaid gym"
PRO_OWNER=$(login "$P_PRO" "Pro Owner")
PRO_GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $PRO_OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Pro Events Gym\",\"addressLine1\":\"1 A Road\",\"state\":\"Goa\",
           \"district\":\"Margao\",\"city\":\"Margao\",\"pincode\":\"403601\",
           \"contactPhone\":\"$P_PRO\"}" | field id)
curl -s -X POST "$API/gyms/$PRO_GID/subscription/trial" -H "Authorization: Bearer $PRO_OWNER" > /dev/null
[ -n "$PRO_GID" ] && ok "Pro gym created and on a trial" || { bad "setup" "no gym"; exit 1; }

BASIC_OWNER=$(login "$P_BASIC" "Basic Owner")
BASIC_GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $BASIC_OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Unpaid Gym\",\"addressLine1\":\"2 B Road\",\"state\":\"Goa\",
           \"district\":\"Margao\",\"city\":\"Margao\",\"pincode\":\"403601\",
           \"contactPhone\":\"$P_BASIC\"}" | field id)
ok "unpaid gym created (no plan)"

MID=$(add_member "$BASIC_OWNER" "$BASIC_GID" "$P_MEMBER" "Feed Member")
[ -n "$MID" ] && ok "member joined the unpaid gym" || bad "member" "no id"

hdr "Hosting"
PRO_EVENT=$(curl -s -X POST "$API/gyms/$PRO_GID/events" -H "Authorization: Bearer $PRO_OWNER" \
  -H 'Content-Type: application/json' -d '{
  "title":"Open Deadlift Meet","description":"An open meet for anyone in Goa who lifts.",
  "howToParticipate":"Bring your own belt. Weigh-in at 8am.","prize":"Rs 10,000",
  "registrationLastDate":"2026-11-20","startsAt":"2026-11-25T09:00:00Z",
  "endsAt":"2026-11-25T17:00:00Z","publicListing":true,"allowNonMembers":true}')
PRO_EID=$(echo "$PRO_EVENT" | field id)
[ -n "$PRO_EID" ] && ok "Pro gym hosted a public event" || bad "host" "$PRO_EVENT"
[ "$(echo "$PRO_EVENT" | field publicListing)" = "True" ] \
  && ok "public listing granted on Pro" || bad "listing" "$PRO_EVENT"

BASIC_EVENT=$(curl -s -X POST "$API/gyms/$BASIC_GID/events" -H "Authorization: Bearer $BASIC_OWNER" \
  -H 'Content-Type: application/json' -d '{
  "title":"Members Only Circuit","description":"A circuit session for our own members.",
  "howToParticipate":"Just turn up in kit.",
  "registrationLastDate":"2026-11-20","startsAt":"2026-11-26T09:00:00Z",
  "endsAt":"2026-11-26T11:00:00Z","publicListing":true}')
BASIC_EID=$(echo "$BASIC_EVENT" | field id)
[ "$(echo "$BASIC_EVENT" | field publicListing)" = "False" ] \
  && ok "public listing refused on an unpaid gym" || bad "basic listing" "$BASIC_EVENT"
echo "$BASIC_EVENT" | grep -q 'listingNote' && ok "and the response says why" \
  || bad "listing note" "no explanation returned"

NO_START=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/gyms/$PRO_GID/events/$PRO_EID" \
  -H "Authorization: Bearer $PRO_OWNER" -H 'Content-Type: application/json' \
  -d '{"startsAt":"2027-01-01T09:00:00Z"}')
[ "$NO_START" = "400" ] && ok "the start time cannot be edited" || bad "start lock" "got $NO_START"

TITLE=$(curl -s -X PATCH "$API/gyms/$PRO_GID/events/$PRO_EID" -H "Authorization: Bearer $PRO_OWNER" \
  -H 'Content-Type: application/json' -d '{"title":"Open Deadlift Meet 2026"}' | field title)
[ "$TITLE" = "Open Deadlift Meet 2026" ] && ok "the title can" || bad "edit" "got $TITLE"

hdr "The member feed"
MEMBER=$(login "$P_MEMBER" "Feed Member")
FEED=$(curl -s "$API/events" -H "Authorization: Bearer $MEMBER")
MINE=$(echo "$FEED" | count myGyms)
GLOBAL=$(echo "$FEED" | count global)
[ "$MINE" = "1" ] && ok "own gym's event appears even though the gym is unpaid" \
  || bad "my gyms" "got $MINE"
[ "$GLOBAL" -ge 1 ] 2>/dev/null && ok "the Pro gym's event appears in the national feed" \
  || bad "global" "got $GLOBAL"

STRANGER=$(login "$P_STRANGER" "Stranger")

# Check the status before the shape, because the two checks below both
# passed for the wrong reason for weeks. This endpoint answered 500 for a
# member with no gym -- the feed built a `notIn: ['']` sentinel and Prisma
# refused to read an empty string as a UUID -- and an error body has no
# `myGyms` key, so counting it gave 0 and "sees nothing under their own
# gyms" reported PASS. The grep for a leaked title found nothing in the
# error body either, so that passed too. A member with no membership is
# precisely who the national feed is for.
S_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API/events" -H "Authorization: Bearer $STRANGER")
[ "$S_CODE" = "200" ] \
  && ok "a member with no gym can open the events feed at all" \
  || bad "stranger feed" "got HTTP $S_CODE"

S_FEED=$(curl -s "$API/events" -H "Authorization: Bearer $STRANGER")
[ "$S_CODE" = "200" ] && [ "$(echo "$S_FEED" | count myGyms)" = "0" ] \
  && ok "a stranger sees nothing under their own gyms" || bad "stranger mine" "not empty"
# And the national feed is not empty for them, which is the other half of
# "it works": an endpoint that returns an empty list for everybody would
# also have satisfied every check above.
[ "$(echo "$S_FEED" | count global)" -ge "1" ] \
  && ok "and does see the public feed" \
  || bad "stranger global" "the national feed came back empty"
echo "$S_FEED" | grep -q "Members Only Circuit" \
  && bad "leak" "unpaid gym's event reached the public feed" \
  || ok "the unpaid gym's event stays off the public feed"

hdr "Participation"
JOINED=$(curl -s -X POST "$API/events/$PRO_EID/participate" -H "Authorization: Bearer $STRANGER")
[ "$(echo "$JOINED" | field registered)" = "True" ] \
  && ok "a non-member can enter an event that allows them" || bad "join" "$JOINED"

BLOCKED=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/events/$BASIC_EID/participate" \
  -H "Authorization: Bearer $STRANGER")
[ "$BLOCKED" = "403" ] && ok "a non-member is refused a members-only event" \
  || bad "members only" "got $BLOCKED"

OUT=$(curl -s -X DELETE "$API/events/$PRO_EID/participate" -H "Authorization: Bearer $STRANGER")
[ "$(echo "$OUT" | field registered)" = "False" ] && ok "and can withdraw" || bad "withdraw" "$OUT"

PARTS=$(curl -s "$API/gyms/$PRO_GID/events/$PRO_EID/participants" -H "Authorization: Bearer $PRO_OWNER")
echo "$PARTS" | grep -q 'participants' && ok "the host can see the sign-up list" \
  || bad "participants" "$PARTS"

hdr "Notifications"
BEFORE=$(curl -s "$API/me/notifications/unread" -H "Authorization: Bearer $MEMBER" | field unread)
SENT=$(curl -s -X POST "$API/gyms/$BASIC_GID/notifications" -H "Authorization: Bearer $BASIC_OWNER" \
  -H 'Content-Type: application/json' -d '{
  "title":"Closed Sunday","body":"We are closed this Sunday for floor repairs.",
  "audience":"GYM_MEMBERS"}')
[ "$(echo "$SENT" | field sentTo)" -ge 1 ] 2>/dev/null \
  && ok "announcement sent to members" || bad "send" "$SENT"

AFTER=$(curl -s "$API/me/notifications/unread" -H "Authorization: Bearer $MEMBER" | field unread)
[ "$AFTER" -gt "$BEFORE" ] 2>/dev/null && ok "the member's unread count went up" \
  || bad "unread" "$BEFORE then $AFTER"

INBOX=$(curl -s "$API/me/notifications" -H "Authorization: Bearer $MEMBER")
echo "$INBOX" | grep -q "Closed Sunday" && ok "it is in their inbox" || bad "inbox" "$INBOX"
echo "$INBOX" | grep -q "Unpaid Gym" && ok "attributed to the sending gym" || bad "attribution" "no gym name"

# Scoped to the gym's announcement rather than counting the whole inbox.
# This used to assert the stranger's inbox was empty, which stopped being
# true the moment every new account started receiving the two onboarding
# messages -- and "empty" was never what the check meant. What it is for is
# that a gym's announcement reaches that gym's members and nobody else.
STRANGER_INBOX=$(curl -s "$API/me/notifications" -H "Authorization: Bearer $STRANGER")
echo "$STRANGER_INBOX" | grep -q "Closed Sunday" \
  && bad "fan-out scope" "a non-member received the gym's announcement" \
  || ok "a non-member of that gym did not receive its announcement"

hdr "What a brand new account is told"
# The spec asks for two default messages every user is sent: that there is
# an owner/staff side to the app, and that referring earns money. They used
# to be cards on the settings screen, which is a different thing -- a card
# is found by somebody already looking. These arrive in the inbox, where
# the header badge brings the reader to them.
NEW_INBOX=$(curl -s "$API/me/notifications" -H "Authorization: Bearer $STRANGER")
echo "$NEW_INBOX" | grep -q 'gymologia://settings/mode' \
  && ok "a new account is told about owner/staff mode" \
  || bad "onboarding staff msg" "$NEW_INBOX"
echo "$NEW_INBOX" | grep -q 'gymologia://referral' \
  && ok "and about earning by referring" \
  || bad "onboarding referral msg" "$NEW_INBOX"
# The deep link is the identifier the app localises against, so it matters
# more than the stored English text and is what these assert on.
echo "$NEW_INBOX" | grep -q '"from": *"Gymologia"' \
  && ok "both are attributed to Gymologia, not a gym" \
  || bad "onboarding attribution" "$NEW_INBOX"

RID=$(curl -s "$API/me/notifications" -H "Authorization: Bearer $MEMBER" | python -c "
import sys,json;d=json.load(sys.stdin);print(d['items'][0]['id'] if d['items'] else '')" 2>/dev/null)
READ=$(curl -s -X PATCH "$API/me/notifications/$RID/read" -H "Authorization: Bearer $MEMBER" | field unread)
[ "$READ" -lt "$AFTER" ] 2>/dev/null && ok "marking one read drops the badge" || bad "mark read" "got $READ"

NO_PERM=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$BASIC_GID/notifications" \
  -H "Authorization: Bearer $MEMBER" -H 'Content-Type: application/json' \
  -d '{"title":"Hello","body":"From a member who should not be able to."}')
[ "$NO_PERM" = "403" ] && ok "a member cannot send announcements" || bad "perm" "got $NO_PERM"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
