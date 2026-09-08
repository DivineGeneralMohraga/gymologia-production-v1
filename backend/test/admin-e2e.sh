#!/usr/bin/env bash
#
# The internal console.
#
#   bash test/admin-e2e.sh
#
# These are the only endpoints that read across gyms, so the boundary is the
# point: a valid app session must not be enough, and an internal role must
# only reach what it covers.

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

# Four digits from the clock mixed with this shell's pid, so two runs
# starting in the same second do not mint the same phone numbers and then
# fight over the same test accounts. That collision produced a confusing
# half-hour of "failures" that were two regressions running at once.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_ADMIN="+9195400${STAMP}1"
P_SUPPORT="+9195400${STAMP}2"
P_CIVILIAN="+9195400${STAMP}3"

hdr "Setup"
ADMIN=$(login "$P_ADMIN" "Platform Owner")
CIVILIAN=$(login "$P_CIVILIAN" "Ordinary Person")
[ -n "$ADMIN" ] && [ -n "$CIVILIAN" ] && ok "two ordinary accounts signed in" \
  || { bad "setup" "no tokens"; exit 1; }

hdr "The boundary"
# Both are ordinary app accounts at this point. Neither may reach admin.
BEFORE=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/me" -H "Authorization: Bearer $ADMIN")
[ "$BEFORE" = "403" ] && ok "an ordinary account cannot reach the console" || bad "boundary" "got $BEFORE"

ANON=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/dashboard")
[ "$ANON" = "401" ] && ok "and neither can nobody" || bad "anon" "got $ANON"

# A refused attempt is worth recording: it is either curiosity or a stolen
# token, and both are things you want to see afterwards.
LOGGED=$(db "
  const n = await p.securityEvent.count({
    where:{ type:'PERMISSION_DENIED', details:{ path:['scope'], equals:'admin' } }});
  console.log(n);
" | tail -1)
[ "${LOGGED:-0}" -ge 1 ] && ok "the refusal is written to the security log" || bad "security log" "got $LOGGED"

# Promote the first account the way the bootstrap does.
db "
  const u = await p.user.findUnique({where:{phone:process.argv[1]}});
  await p.adminStaff.create({data:{userId:u.id, role:'OWNER'}});
" "$P_ADMIN" > /dev/null
ok "promoted one account to admin OWNER"

hdr "Who am I"
ME=$(curl -s "$API/admin/me" -H "Authorization: Bearer $ADMIN")
ROLE=$(echo "$ME" | field role)
[ "$ROLE" = "OWNER" ] && ok "the console reports the internal role" || bad "whoami" "$ROLE"

CIV=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/me" -H "Authorization: Bearer $CIVILIAN")
[ "$CIV" = "403" ] && ok "the other account still cannot" || bad "still out" "got $CIV"

hdr "Dashboard"
DASH=$(curl -s "$API/admin/dashboard" -H "Authorization: Bearer $ADMIN")
USERS=$(echo "$DASH" | python -c "
import sys,json;print(json.load(sys.stdin)['people']['total'])" 2>/dev/null)
[ "${USERS:-0}" -ge 2 ] && ok "counts people across the platform ($USERS)" || bad "dashboard" "$USERS"

SHAPE=$(echo "$DASH" | python -c "
import sys,json
d=json.load(sys.stdin)
print(','.join(sorted(d.keys())))" 2>/dev/null)
[ "$SHAPE" = "gyms,installs,members,people,support" ] && ok "with gyms, members and the support queue" \
  || bad "dashboard shape" "$SHAPE"

RATE=$(echo "$DASH" | python -c "
import sys,json
m=json.load(sys.stdin)['members']
print('ok' if 0 <= m['engagementRate'] <= 100 else m['engagementRate'])" 2>/dev/null)
[ "$RATE" = "ok" ] && ok "engagement is a percentage, not a ratio" || bad "engagement" "$RATE"

hdr "Adding internal staff"
LK=$(curl -s -X POST "$API/admin/staff/lookup" -H "Authorization: Bearer $ADMIN" \
     -H 'Content-Type: application/json' -d "{\"phone\":\"$P_SUPPORT\"}")
CID=$(echo "$LK" | field challengeId)
CODE=$(echo "$LK" | field devCode)
[ -n "$CID" ] && ok "a code goes to the number being added" || bad "lookup" "$LK"

# Never signed in, so there is no account to promote yet.
TOO_EARLY=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/staff" \
            -H "Authorization: Bearer $ADMIN" -H 'Content-Type: application/json' \
            -d "{\"challengeId\":\"$CID\",\"phone\":\"$P_SUPPORT\",\"code\":\"$CODE\",
                 \"role\":\"CUSTOMER_SUPPORT\"}")
[ "$TOO_EARLY" = "400" ] && ok "a number that never signed in cannot be made staff" \
  || bad "unsigned" "got $TOO_EARLY"

SUPPORT=$(login "$P_SUPPORT" "Support Person")

# The refusal above happened before the code was verified, so it was never
# consumed and the same one still works. Asking for a second would hit the
# per-number resend cooldown anyway.
ADDED=$(curl -s -X POST "$API/admin/staff" -H "Authorization: Bearer $ADMIN" \
        -H 'Content-Type: application/json' -d "{
          \"challengeId\":\"$CID\",\"phone\":\"$P_SUPPORT\",
          \"code\":\"$CODE\",\"role\":\"CUSTOMER_SUPPORT\"}")

# len() on an error object counts its keys, so a failed add would pass a
# bare length check. Insist it is actually a list.
COUNT=$(echo "$ADDED" | python -c "
import sys,json
d=json.load(sys.stdin)
print(len(d) if isinstance(d, list) else -1)" 2>/dev/null)
[ "${COUNT:-0}" -ge 2 ] && ok "added once they have an account" || bad "add staff" "$ADDED"

MASKED=$(echo "$ADDED" | python -c "
import sys,json
print('yes' if all('*' in s['phone'] for s in json.load(sys.stdin)) else 'no')" 2>/dev/null)
[ "$MASKED" = "yes" ] && ok "phone numbers are masked in the console" || bad "masking" "$MASKED"

hdr "What a support role reaches"
S_ME=$(curl -s "$API/admin/me" -H "Authorization: Bearer $SUPPORT" | field role)
[ "$S_ME" = "CUSTOMER_SUPPORT" ] && ok "support can open the console" || bad "support login" "$S_ME"

S_STAFF=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/staff" -H "Authorization: Bearer $SUPPORT")
[ "$S_STAFF" = "403" ] && ok "but cannot see the internal team" || bad "support staff" "got $S_STAFF"

S_LOGS=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/logs/security" -H "Authorization: Bearer $SUPPORT")
[ "$S_LOGS" = "403" ] && ok "nor read the security log" || bad "support logs" "got $S_LOGS"

S_TICKETS=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/tickets" -H "Authorization: Bearer $SUPPORT")
[ "$S_TICKETS" = "200" ] && ok "and can read the support queue, which is the job" \
  || bad "support tickets" "got $S_TICKETS"

S_BLOCKS=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/security/blocks" -H "Authorization: Bearer $SUPPORT")
[ "$S_BLOCKS" = "403" ] && ok "and cannot see or lift address blocks" \
  || bad "support blocks" "got $S_BLOCKS, expected 403"

hdr "Seeing and undoing an automatic block"
# An automatic decision nobody can inspect or reverse is the wrong kind, so
# these exist for the operator who has to answer "why can this gym not
# reach the app?" The list is per-instance and in memory, so this checks
# the shape of the answer rather than a particular address being in it.
BLOCKS=$(curl -s "$API/admin/security/blocks" -H "Authorization: Bearer $ADMIN")
echo "$BLOCKS" | grep -q '"blocks"' && echo "$BLOCKS" | grep -q '"count"' \
  && ok "an admin can list what is currently refused" \
  || bad "list blocks" "$BLOCKS"

# 198.51.100.0/24 is TEST-NET-2, reserved for documentation, so this can
# never name a real host.
LIFT=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
       "$API/admin/security/blocks/198.51.100.201" -H "Authorization: Bearer $ADMIN")
[ "$LIFT" = "404" ] && ok "lifting a block that is not there is a 404, not a cheerful 200" \
  || bad "lift missing block" "got $LIFT, expected 404"

# NOTE: this section must stay ABOVE "Guarding the last owner".
# That section removes $ADMIN from the platform and promotes
# $SUPPORT to OWNER, so below it the two tokens mean the opposite
# of what they read as here.
hdr "The payout desk"

# A queued payout to look at. Raised by hand because getting a real one here
# would mean running the whole subscription and referral chain inside the
# admin suite -- payments-e2e already proves that path end to end. What is
# under test here is who may open this desk and what it does when asked to
# send, neither of which depends on how the payout came to exist.
PAYOUT_ID=$(db "
  const acct = await p.referralAccount.create({ data: {
    user: { create: { phone: '+9199999' + String(Date.now()).slice(-5), name: 'Payout Desk', age: 30 } },
    code: 'PD' + String(Date.now()).slice(-6),
    upiIdMasked: 'pa*****@okhdfcbank',
    upiHolderName: 'Payout Desk',
    upiVerified: false,
  } });
  const out = await p.payout.create({ data: {
    referralAccountId: acct.id, grossPaise: 5000, netPaise: 4000,
    verifyFeePaise: 1000, status: 'QUEUED',
    idempotencyKey: 'desk-' + Date.now(), financialYear: '2026-2027',
  } });
  console.log(out.id);
")
[ -n "$PAYOUT_ID" ] && ok "a queued payout exists to look at" || bad "setup" "no payout"

Q=$(curl -s "$API/admin/payouts" -H "Authorization: Bearer $ADMIN")
[ -n "$(echo "$Q" | field total)" ] && ok "an owner can open the payout desk" || bad "desk" "$Q"

# The queue must never show a full payment address, on a screen opened by
# staff who have no business reading one.
echo "$Q" | grep -q "upiIdMasked" \
  && { echo "$Q" | grep -qE '"upiIdMasked":"[a-z0-9._-]+@' \
         && bad "queue privacy" "an unmasked address is in the payout queue" \
         || ok "and sees masked addresses only"; } \
  || bad "queue privacy" "nothing to inspect: $Q"

# Said up front rather than left as an unexplained queue of held money.
BLOCKED=$(echo "$Q" | field blockedReason)
case "$BLOCKED" in
  *Verification*) ok "and is told why nothing can be sent yet" ;;
  *) bad "blockedReason" "got: $BLOCKED" ;;
esac

# The check that matters most: asked to send, it refuses and changes
# NOTHING. Charging ten rupees for a check that never ran and then paying
# an unverified address is the failure this whole design exists to avoid.
RUN=$(curl -s -X POST "$API/admin/payouts/$PAYOUT_ID/run" -H "Authorization: Bearer $ADMIN")
[ "$(echo "$RUN" | field outcome)" = "REFUSED" ] \
  && ok "asked to send, it refuses" || bad "run" "$RUN"

STILL=$(db "
  const out = await p.payout.findUnique({ where: { id: process.argv[1] } });
  console.log(out ? out.status : 'GONE');
" "$PAYOUT_ID")
[ "$STILL" = "QUEUED" ] \
  && ok "and leaves the payout QUEUED -- the money is still owed" \
  || bad "run side effect" "status is now $STILL"

# Customer support has no business here at all.
SUP=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/payouts" -H "Authorization: Bearer $SUPPORT")
[ "$SUP" = "403" ] && ok "customer support cannot open the payout desk" \
                   || bad "support payouts" "got HTTP $SUP"

CIV=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/payouts" -H "Authorization: Bearer $CIVILIAN")
[ "$CIV" = "403" ] && ok "nor can an ordinary account" || bad "civilian payouts" "got HTTP $CIV"

hdr "Guarding the last owner"
# Identify both records through /admin/me rather than picking the first row
# with a matching role. The database keeps admins from previous runs, so
# "the first OWNER" is somebody else's and every check below would act on
# the wrong person and pass for the wrong reason.
OWNER_ID=$(curl -s "$API/admin/me" -H "Authorization: Bearer $ADMIN" | field adminId)
SUPPORT_ID=$(curl -s "$API/admin/me" -H "Authorization: Bearer $SUPPORT" | field adminId)
[ -n "$OWNER_ID" ] && [ -n "$SUPPORT_ID" ] && ok "identified both admin records"   || bad "identify" "owner=$OWNER_ID support=$SUPPORT_ID"

SELF_EDIT=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/admin/staff/$OWNER_ID" \
            -H "Authorization: Bearer $ADMIN" -H 'Content-Type: application/json' \
            -d '{"role":"ADMIN"}')
[ "$SELF_EDIT" = "403" ] && ok "nobody edits their own admin record" || bad "self edit" "got $SELF_EDIT"

# Promote support to owner, then the original may be demoted -- but not
# before, or the console locks everyone out.
SUPPORT_OWNER=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/admin/staff/$SUPPORT_ID" \
                -H "Authorization: Bearer $ADMIN" -H 'Content-Type: application/json' \
                -d '{"role":"OWNER"}')
[ "$SUPPORT_OWNER" = "200" ] && ok "an owner can appoint another owner" || bad "appoint" "got $SUPPORT_OWNER"

NOT_OWNER=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/admin/staff/$OWNER_ID" \
            -H "Authorization: Bearer $SUPPORT" -H 'Content-Type: application/json' \
            -d '{"status":"REMOVED"}')
[ "$NOT_OWNER" = "200" ] && ok "and the new owner can act on the old one" || bad "new owner" "got $NOT_OWNER"

GONE=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/me" -H "Authorization: Bearer $ADMIN")
[ "$GONE" = "403" ] && ok "a removed admin loses access immediately" || bad "removed" "got $GONE"

LAST=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/admin/staff/$OWNER_ID" \
       -H "Authorization: Bearer $SUPPORT" -H 'Content-Type: application/json' \
       -d '{"role":"ADMIN"}')
ONLY_OWNER=$(curl -s -X PATCH "$API/admin/staff/$SUPPORT_ID" \
             -H "Authorization: Bearer $SUPPORT" -H 'Content-Type: application/json' \
             -d '{"role":"ADMIN"}' -o /dev/null -w "%{http_code}")
[ "$ONLY_OWNER" = "403" ] && ok "the last owner cannot demote themselves" \
  || bad "last owner" "got $ONLY_OWNER"

# By this point the first owner has been removed and the support account
# was promoted, so it is the one holding OWNER now.
OWNER_TOKEN="$SUPPORT"

hdr "Support queue"
TICKET=$(curl -s -X POST "$API/me/support" -H "Authorization: Bearer $CIVILIAN" \
         -H 'Content-Type: application/json' \
         -d "{\"subject\":\"Cannot open my gym\",
              \"message\":\"The app shows a blank screen after login.\",
              \"contactPhone\":\"$P_CIVILIAN\",\"urgent\":true}")
TID=$(echo "$TICKET" | field id)
[ -n "$TID" ] && ok "a member raised a ticket" || bad "ticket" "$TICKET"

QUEUE=$(curl -s "$API/admin/tickets?status=OPEN" -H "Authorization: Bearer $SUPPORT")
FOUND=$(echo "$QUEUE" | python -c "
import sys,json
print('yes' if any(t['id']=='$TID' for t in json.load(sys.stdin)['items']) else 'no')" 2>/dev/null)
[ "$FOUND" = "yes" ] && ok "it appears in the queue" || bad "queue" "$FOUND"

TPHONE=$(echo "$QUEUE" | python -c "
import sys,json
print(next(t['contactPhone'] for t in json.load(sys.stdin)['items'] if t['id']=='$TID'))" 2>/dev/null)
case "$TPHONE" in
  *'*'*) ok "with the reporter's number masked" ;;
  *) bad "ticket masking" "$TPHONE" ;;
esac

CLAIM=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/tickets/$TID/claim" \
        -H "Authorization: Bearer $SUPPORT")
[ "$CLAIM" = "201" ] && ok "support claimed it" || bad "claim" "got $CLAIM"

RESOLVE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/tickets/$TID/resolve" \
          -H "Authorization: Bearer $SUPPORT" -H 'Content-Type: application/json' \
          -d '{"note":"Cleared app data, member can log in."}')
[ "$RESOLVE" = "201" ] && ok "and resolved it with a note" || bad "resolve" "got $RESOLVE"

TWICE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/tickets/$TID/resolve" \
        -H "Authorization: Bearer $SUPPORT" -H 'Content-Type: application/json' \
        -d '{"note":"again"}')
[ "$TWICE" = "409" ] && ok "resolving twice is refused" || bad "double resolve" "got $TWICE"

hdr "Announcements"
SIZE=$(curl -s "$API/admin/broadcast/audience?audience=ALL_MEMBERS" \
       -H "Authorization: Bearer $OWNER_TOKEN")
N=$(echo "$SIZE" | field recipients)
[ -n "$N" ] && ok "an audience can be sized before sending ($N people)" || bad "audience size" "$SIZE"

# A gym-scoped audience is not a platform audience. Sending GYM_EVERYONE
# here would mean "every gym's everyone", which is not what the caller means.
GYM_AUD=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/broadcast" \
          -H "Authorization: Bearer $OWNER_TOKEN" -H 'Content-Type: application/json' \
          -d '{"title":"Hello","body":"Testing the wrong audience","audience":"GYM_EVERYONE"}')
[ "$GYM_AUD" = "400" ] && ok "a gym-scoped audience is refused here" || bad "gym audience" "got $GYM_AUD"

# The count the sender agreed to must be the count that goes out.
STALE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/broadcast" \
        -H "Authorization: Bearer $OWNER_TOKEN" -H 'Content-Type: application/json' \
        -d "{\"title\":\"Stale confirm\",\"body\":\"This should be refused.\",
             \"audience\":\"ALL_MEMBERS\",\"expectedRecipients\":999999}")
[ "$STALE" = "409" ] && ok "a stale recipient count refuses the send" || bad "stale count" "got $STALE"

SENT=$(curl -s -X POST "$API/admin/broadcast" -H "Authorization: Bearer $OWNER_TOKEN" \
       -H 'Content-Type: application/json' \
       -d "{\"title\":\"Scheduled maintenance\",\"body\":\"The app will be briefly unavailable on Sunday morning.\",
            \"audience\":\"ALL_MEMBERS\",\"expectedRecipients\":$N}")
SENT_TO=$(echo "$SENT" | field sentTo)
[ "$SENT_TO" = "$N" ] && ok "and the right count agrees, so it goes out" || bad "broadcast" "$SENT"

HIST=$(curl -s "$API/admin/broadcast" -H "Authorization: Bearer $OWNER_TOKEN" | python -c "
import sys,json
d=json.load(sys.stdin)
print('yes' if any(n['title']=='Scheduled maintenance' for n in d) else 'no')" 2>/dev/null)
[ "$HIST" = "yes" ] && ok "it appears in what Gymologia has announced" || bad "history" "$HIST"

# ALL_REFERRERS went from always-empty to real without a line of this code
# changing. It resolved to nobody for as long as nothing in the product
# could create a referral account; asking for your own code creates one
# now, so the audience quietly became live and nothing re-checked it. Every
# platform audience is sized here rather than only the one that was
# convenient at the time.
for AUD in ALL_MEMBERS ALL_STAFF ALL_OWNERS ALL_REFERRERS EVERYONE; do
  A=$(curl -s "$API/admin/broadcast/audience?audience=$AUD" -H "Authorization: Bearer $OWNER_TOKEN")
  AN=$(echo "$A" | field recipients)
  case "$AN" in
    ''|*[!0-9]*) bad "audience $AUD" "not a number: ${A:-<nothing>}" ;;
    *)           ok "$AUD sizes to $AN" ;;
  esac
done

# And the one that just went live must actually find somebody. This suite
# enrols its own referrer rather than relying on one another suite happened
# to leave behind: a check that passes on residue from a neighbour is not
# testing this endpoint.
BEFORE_REF=$(curl -s "$API/admin/broadcast/audience?audience=ALL_REFERRERS" \
             -H "Authorization: Bearer $OWNER_TOKEN" | field recipients)
CODE=$(curl -s "$API/me/referral" -H "Authorization: Bearer $CIVILIAN" | field code)
[ -n "$CODE" ] && ok "an ordinary person took a referral code ($CODE)" \
               || bad "referral enrol" "no code came back"

AFTER_REF=$(curl -s "$API/admin/broadcast/audience?audience=ALL_REFERRERS" \
            -H "Authorization: Bearer $OWNER_TOKEN" | field recipients)
if [ -n "$BEFORE_REF" ] && [ -n "$AFTER_REF" ] 2>/dev/null; then
  [ "$AFTER_REF" -gt "$BEFORE_REF" ] 2>/dev/null \
    && ok "and ALL_REFERRERS grew to include them ($BEFORE_REF then $AFTER_REF)" \
    || bad "ALL_REFERRERS" "stayed at $AFTER_REF -- the audience that resolved to nobody still does"
else
  bad "ALL_REFERRERS" "nothing to inspect: '${BEFORE_REF:-<nothing>}' then '${AFTER_REF:-<nothing>}'"
fi

# Support staff must not be able to message the whole platform.
S_CAST=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/admin/broadcast" \
         -H "Authorization: Bearer $CIVILIAN" -H 'Content-Type: application/json' \
         -d '{"title":"x","body":"should not send","audience":"EVERYONE"}')
[ "$S_CAST" = "403" ] && ok "someone outside the console cannot broadcast" || bad "outsider broadcast" "got $S_CAST"

hdr "Logs"
AUDIT=$(curl -s "$API/admin/logs/audit?limit=5" -H "Authorization: Bearer $OWNER_TOKEN")
ENTRIES=$(echo "$AUDIT" | python -c "
import sys,json;print(len(json.load(sys.stdin)['items']))" 2>/dev/null)
[ "${ENTRIES:-0}" -ge 1 ] && ok "the audit log reads back ($ENTRIES of $(echo "$AUDIT" | field total))" \
  || bad "audit" "$ENTRIES"

ADMIN_ACTIONS=$(curl -s "$API/admin/logs/audit?action=admin." -H "Authorization: Bearer $OWNER_TOKEN" | python -c "
import sys,json
d=json.load(sys.stdin)
print('yes' if all(i['action'].startswith('admin.') for i in d['items']) and d['items'] else 'no')" 2>/dev/null)
[ "$ADMIN_ACTIONS" = "yes" ] && ok "and filters by action, so admin work is auditable on its own" \
  || bad "audit filter" "$ADMIN_ACTIONS"

SEC=$(curl -s "$API/admin/logs/security?severity=HIGH&limit=5" -H "Authorization: Bearer $OWNER_TOKEN")
SEV=$(echo "$SEC" | python -c "
import sys,json
d=json.load(sys.stdin)
print('yes' if all(i['severity']=='HIGH' for i in d['items']) else 'no')" 2>/dev/null)
[ "$SEV" = "yes" ] && ok "the security log filters by severity" || bad "severity filter" "$SEV"

# An out-of-range page size is refused at the edge rather than silently
# reinterpreted, so a caller is never quietly given something else.
OVER=$(curl -s -o /dev/null -w "%{http_code}" "$API/admin/logs/audit?limit=500"        -H "Authorization: Bearer $OWNER_TOKEN")
[ "$OVER" = "400" ] && ok "an out-of-range page size is refused" || bad "cap" "got $OVER"

CAP=$(curl -s "$API/admin/logs/audit?limit=200" -H "Authorization: Bearer $OWNER_TOKEN" | python -c "
import sys,json;print(len(json.load(sys.stdin)['items']))" 2>/dev/null)
[ "${CAP:-999}" -le 200 ] && ok "and the largest allowed page is bounded" || bad "page size" "got $CAP"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
