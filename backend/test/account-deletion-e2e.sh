#!/usr/bin/env bash
#
# Deleting your account.
#
#   bash test/account-deletion-e2e.sh
#
# Google Play requires this of any app offering account creation, in the app
# and from a web link. So the first thing checked is that the web page answers
# at all, without a token, because that URL goes in the Data safety form and a
# reviewer will open it.
#
# The rest is the part that matters more than the paperwork: that the wipe
# actually wipes. It is easy to write a deletion that sets a flag and leaves
# the name, the number, the messages and the UPI handle sitting in the
# database -- and impossible to notice, because every screen stops showing
# them. So this reads the rows back DIRECTLY, not through the API, and fails
# if anything identifying survived.

API="${API:-http://localhost:3000/api/v1}"
WEB="${WEB:-http://localhost:3000}"
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
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":30,\"email\":\"$3\"}")
  fi
  echo "$v" | nested tokens accessToken
}

me() { curl -s "$API/auth/me" -H "Authorization: Bearer $1" | field id; }

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
P_OWNER="+9198622${STAMP}1"
P_LEAVER="+9198622${STAMP}2"

hdr "The web page Play requires"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -m 15 "$WEB/delete-account")
[ "$CODE" = "200" ] && ok "answers without a token" || bad "web page" "got $CODE"

PAGE=$(curl -s -m 15 "$WEB/delete-account")
echo "$PAGE" | grep -qi "delete your gymologia account" && ok "and says what it is for" \
  || bad "web page copy" "unexpected body"

# It must say what survives. A deletion page that implies everything vanishes,
# while payment rows are kept for tax law, is a promise the code cannot keep.
echo "$PAGE" | grep -qi "books of account" \
  && ok "and is honest that payment records are kept" \
  || bad "web page honesty" "no mention of retained records"

hdr "Setup"
LEAVER=$(login "$P_LEAVER" "Departing Person" "leaver@example.com")
LEAVER_ID=$(me "$LEAVER")
[ -n "$LEAVER_ID" ] && ok "an account to delete" || { bad "setup" "no token"; exit 1; }

hdr "Before the button"
PREVIEW=$(curl -s "$API/me/deletion/preview" -H "Authorization: Bearer $LEAVER")
GRACE=$(echo "$PREVIEW" | field graceDays)
[ "$GRACE" = "30" ] && ok "the preview states the grace period" || bad "preview" "$PREVIEW"

STATUS=$(curl -s "$API/me/deletion" -H "Authorization: Bearer $LEAVER" | field pending)
[ "$STATUS" = "False" ] && ok "nothing is scheduled yet" || bad "status" "got $STATUS"

hdr "A gym owner is stopped"
OWNER=$(login "$P_OWNER" "Gym Owner" "owner@example.com")
GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Deletion Gym\",\"addressLine1\":\"1 Exit Rd\",\"state\":\"Delhi\",
           \"district\":\"New Delhi\",\"city\":\"New Delhi\",\"pincode\":\"110001\",
           \"contactPhone\":\"$P_OWNER\"}" | field id)
[ -n "$GID" ] && ok "owner has a gym" || bad "setup" "no gym"

OWNER_PREVIEW=$(curl -s "$API/me/deletion/preview" -H "Authorization: Bearer $OWNER")
echo "$OWNER_PREVIEW" | grep -q 'OWNS_GYM' \
  && ok "the preview warns them BEFORE they tap anything" \
  || bad "preview blockers" "$OWNER_PREVIEW"

REFUSED=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/me/deletion" \
  -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' -d '{}')
[ "$REFUSED" = "409" ] && ok "and the request is refused" \
  || bad "owner blocker" "expected 409, got $REFUSED -- members would lose their gym"

hdr "Requesting"
REQ=$(curl -s -X POST "$API/me/deletion" -H "Authorization: Bearer $LEAVER" \
  -H 'Content-Type: application/json' -d '{"via":"APP"}')
WHEN=$(echo "$REQ" | field scheduledFor)
[ -n "$WHEN" ] && ok "scheduled for $WHEN" || bad "request" "$REQ"

# Thirty days out, not immediate. A wipe with no way back turns a bad moment
# into a permanent loss.
DAYS=$(python -c "
import sys, datetime
w = datetime.datetime.fromisoformat('$WHEN'.replace('Z','+00:00'))
now = datetime.datetime.now(datetime.timezone.utc)
print(round((w - now).total_seconds() / 86400))" 2>/dev/null)
[ "$DAYS" = "30" ] && ok "thirty days away, not immediate" || bad "grace" "got $DAYS days"

# Asking twice must not quietly push the date out.
AGAIN=$(curl -s -X POST "$API/me/deletion" -H "Authorization: Bearer $LEAVER" \
  -H 'Content-Type: application/json' -d '{}')
[ "$(echo "$AGAIN" | field scheduledFor)" = "$WHEN" ] \
  && ok "asking twice returns the same date, it does not extend it" \
  || bad "double request" "date moved: $(echo "$AGAIN" | field scheduledFor)"

# The account still works. That is the whole point of a grace period.
STILL=$(curl -s -o /dev/null -w "%{http_code}" "$API/auth/me" -H "Authorization: Bearer $LEAVER")
[ "$STILL" = "200" ] && ok "the account still works meanwhile" || bad "grace access" "got $STILL"

hdr "Changing your mind"
CANCEL=$(curl -s -X DELETE "$API/me/deletion" -H "Authorization: Bearer $LEAVER" | field cancelled)
[ "$CANCEL" = "True" ] && ok "the deletion is cancelled" || bad "cancel" "got $CANCEL"

AFTER=$(curl -s "$API/me/deletion" -H "Authorization: Bearer $LEAVER" | field pending)
[ "$AFTER" = "False" ] && ok "and nothing is scheduled any more" || bad "cancel status" "got $AFTER"

TWICE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/me/deletion" \
  -H "Authorization: Bearer $LEAVER")
[ "$TWICE" = "200" ] && ok "cancelling twice is not an error" || bad "double cancel" "got $TWICE"

hdr "The wipe"
# Re-request, then run the job with the clock wound forward rather than
# waiting thirty days.
curl -s -X POST "$API/me/deletion" -H "Authorization: Bearer $LEAVER" \
  -H 'Content-Type: application/json' -d '{}' > /dev/null

# Something identifying to look for afterwards, written through the real API.
db "
  await p.bodyMetric.create({data:{userId:process.argv[1], weightKg:81.5, heightCm:176}});
" "$LEAVER_ID" > /dev/null

db "
  await p.user.update({where:{id:process.argv[1]}, data:{deletionScheduledFor:new Date(Date.now()-1000)}});
" "$LEAVER_ID" > /dev/null

# Drive the service the way the cron does, in-process.
WIPED=$(node -e "
  const fs=require('fs');
  for (const l of fs.readFileSync('.env','utf8').split(/\r?\n/)) {
    const m=/^([A-Z0-9_]+)=(.*)\$/.exec(l.trim());
    if (m) process.env[m[1]] = m[2].replace(/^\"|\"\$/g,'');
  }
  const {PrismaClient}=require('@prisma/client');
  const p=new PrismaClient();
  (async () => {
    // The wipe, exercised through the compiled service rather than
    // reimplemented here -- a test that writes its own version of the
    // deletion proves only that the test can delete things.
    const { AccountDeletionService } = require('./dist/account/account-deletion.service');
    const { CryptoService } = require('./dist/common/crypto/crypto.service');
    const { AuditService } = require('./dist/common/audit/audit.service');
    // CryptoService calls getOrThrow, not get. Stubbing the wrong method
    // failed at construction with a message that looked nothing like the
    // cause, so this throws on an unknown key rather than returning
    // undefined and failing later somewhere less obvious.
    const KEYS = {
      'crypto.encryptionKey': 'ENCRYPTION_KEY',
      'crypto.otpPepper': 'OTP_PEPPER',
    };
    const cfg = {
      get: (k, d) => process.env[KEYS[k]] ?? d,
      getOrThrow: (k) => {
        const v = process.env[KEYS[k]];
        if (!v) throw new Error('test stub has no value for ' + k);
        return v;
      },
    };
    const crypto = new CryptoService(cfg);
    const audit = new AuditService(p);
    const svc = new AccountDeletionService(p, crypto, audit);
    const n = await svc.runDue();
    console.log(n);
  })().then(()=>p.\$disconnect()).catch(e=>{console.error('ERR '+e.message);process.exit(1);});
" 2>&1 | tail -1)
# At least one, not exactly one. The database is shared with every other
# suite and with earlier runs of this one, so any account left due by a run
# that failed part-way is correctly swept up by the same pass. Pinning an
# exact number here fails on a job doing its job. That THIS account was
# wiped is what the next section establishes, row by row.
[ "${WIPED:-0}" -ge 1 ] 2>/dev/null && ok "the job anonymised $WIPED account(s)"   || bad "runDue" "got: $WIPED"

hdr "What actually survived"
# Read the row directly. Through the API everything looks deleted whether or
# not it was, because every screen stops showing it.
LEFT=$(db "
  const u = await p.user.findUnique({where:{id:process.argv[1]}});
  const metrics = await p.bodyMetric.count({where:{userId:process.argv[1]}});
  const sessions = await p.session.count({where:{userId:process.argv[1]}});
  console.log(JSON.stringify({
    phone: u.phone, name: u.name, email: u.email, age: u.age,
    anonymised: u.anonymisedAt !== null, metrics, sessions,
  }));
" "$LEAVER_ID" | tail -1)

echo "$LEFT" | python -c "
import sys, json
d = json.load(sys.stdin)
checks = [
  ('the phone number is gone',      not d['phone'].startswith('+91')),
  ('the real number is unlinked',   d['phone'].startswith('del-')),
  ('the name is gone',              d['name'] == 'Deleted account'),
  ('the email is gone',             d['email'] is None),
  ('the age is gone',               d['age'] is None),
  ('health data is gone',           d['metrics'] == 0),
  ('sessions are revoked',          d['sessions'] == 0),
  ('the row is marked anonymised',  d['anonymised']),
]
for label, passed in checks:
    print(('PASS ' if passed else 'FAIL ') + label)
" | while read -r verdict label; do
  [ "$verdict" = "PASS" ] && ok "$label" || bad "$label" "still present"
done

# The number must be free. A returning person gets a new account with no
# history, which is what having deleted the old one ought to mean.
# The number signed in at the start, and on a fast run that can be inside
# the per-number resend cooldown -- wait it out as a person would.
for _ in 1 2 3; do
  REUSE=$(curl -s -m 60 -X POST "$API/auth/otp/request" -H 'Content-Type: application/json' \
          -d "{\"phone\":\"$P_LEAVER\",\"appClient\":\"MEMBER\"}")
  WAIT=$(echo "$REUSE" | grep -oE 'wait [0-9]+s' | grep -oE '[0-9]+')
  [ -z "$WAIT" ] && break
  sleep $((WAIT + 1))
done
RCID=$(echo "$REUSE" | field challengeId); RCODE=$(echo "$REUSE" | field devCode)
RV=$(curl -s -m 60 -X POST "$API/auth/otp/verify" -H 'Content-Type: application/json' \
     -d "{\"challengeId\":\"$RCID\",\"phone\":\"$P_LEAVER\",\"code\":\"$RCODE\",\"appClient\":\"MEMBER\"}")
[ "$(echo "$RV" | field status)" = "NEW_USER" ] \
  && ok "the number is free, and signing up again makes a NEW account" \
  || bad "phone reuse" "expected NEW_USER, got $(echo "$RV" | field status)"

# The deletion record outlives the account, so support can answer somebody
# asking what became of their data.
RECORD=$(db "
  const n = await p.accountDeletion.count({where:{userId:process.argv[1], completedAt:{not:null}}});
  console.log(n);
" "$LEAVER_ID" | tail -1)
[ "${RECORD:-0}" -ge 1 ] 2>/dev/null && ok "a completed deletion record is kept" \
  || bad "record" "got $RECORD"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
