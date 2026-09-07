#!/usr/bin/env bash
#
# Referral payout details: the UPI ID rewards are sent to, and the PAN tax
# is withheld against.
#
#   npm run build && node dist/main.js    # in another terminal
#   bash test/referrals-e2e.sh
#
# These columns -- upiIdEnc, upiHolderName, panEnc, panLast4 -- were
# modelled, documented as encrypted at rest, and written by nothing at all.
# CryptoService.maskUpi existed for them and had no caller anywhere in the
# codebase. This suite is what stops that being true again.
#
# The money-losing case here is not injection, it is a typo. A UPI address
# has no checksum: `sarthaq@okhdfcbank` is a perfectly well-formed address
# belonging to somebody else, and a transfer to it is irreversible. So the
# checks below lean hard on the two things that can actually prevent that
# -- refusing to carry a verification across a change of address, and
# refusing to change the address while a payout is already moving.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

cd "$(dirname "$0")/.." || exit 1

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

# Direct database access, used ONLY to stand up preconditions the product
# cannot yet produce for itself: there is no verification drop and no payout
# runner, so `upiVerified` and a QUEUED payout have to be placed by hand.
#
# That is deliberately not the same sin as the referral-code back door this
# suite replaced. There, the test manufactured the thing under test and so
# proved nothing about it. Here the thing under test is what the API does
# WHEN those states exist -- the manufactured part is the precondition, and
# every assertion below is about behaviour the API is responsible for.
db() {
  node -e '
    const fs = require("fs");
    for (const l of fs.readFileSync(".env", "utf8").split(/\r?\n/)) {
      const m = /^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
      if (m) process.env[m[1]] = m[2].replace(/^"|"$/g, "");
    }
    const { PrismaClient } = require("@prisma/client");
    const p = new PrismaClient();
    const [op, code] = process.argv.slice(1);
    (async () => {
      const acct = await p.referralAccount.findUnique({ where: { code } });
      if (!acct) { console.log("NOACCOUNT"); return; }
      if (op === "verify") {
        await p.referralAccount.update({
          where: { id: acct.id },
          data: { upiVerified: true, upiVerifiedAt: new Date() },
        });
        console.log("ok");
      } else if (op === "verify-pan" || op === "reject-pan") {
        await p.referralAccount.update({
          where: { id: acct.id },
          data: { panStatus: op === "verify-pan" ? "VERIFIED" : "REJECTED" },
        });
        console.log("ok");
      } else if (op === "read") {
        console.log(JSON.stringify(acct));
      } else if (op === "audit") {
        // Scoped to this account, so a previous run cannot make an empty
        // log look populated.
        const rows = await p.auditLog.findMany({
          where: { action: { startsWith: "referral." }, entityId: acct.id },
          orderBy: { createdAt: "desc" },
          take: 100,
        });
        console.log(JSON.stringify(rows, null, 1));
      } else if (op === "queue-payout") {
        await p.payout.create({ data: {
          referralAccountId: acct.id, grossPaise: 5000, netPaise: 5000,
          idempotencyKey: "test-" + Date.now() + "-" + Math.random().toString(36).slice(2),
          financialYear: "2026-2027", status: "QUEUED",
        } });
        console.log("ok");
      } else if (op === "clear-payouts") {
        await p.payout.deleteMany({ where: { referralAccountId: acct.id } });
        console.log("ok");
      }
    })().catch(e => console.log("ERR " + e.message)).finally(() => p.$disconnect());
  ' "$1" "$2"
}

put() {
  curl -s -o /tmp/ref-body.json -w "%{http_code}" -m 60 -X PUT "$API/me/referral/$1" \
    -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' -d "$2"
}

STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_REF="+9198302${STAMP}1"
P_OWN="+9198302${STAMP}2"

VPA1="sarthak@okhdfcbank"
MASK1="sa*****@okhdfcbank"
VPA2="newaddress@ybl"
VPA_TYPO="sarthaq@okhdfcbank"
MASK2="ne********@ybl"
PAN="ABCDE1234F"

hdr "Setup"
TOK=$(login "$P_REF" "Referrer")
[ -n "$TOK" ] || { bad "setup" "no token"; exit 1; }
CODE=$(curl -s "$API/me/referral" -H "Authorization: Bearer $TOK" | field code)
[ -n "$CODE" ] && ok "referral account exists, code $CODE" \
               || { bad "setup" "no referral code"; exit 1; }

BEFORE=$(curl -s "$API/me/referral" -H "Authorization: Bearer $TOK" \
         | python -c "import sys,json;print(json.load(sys.stdin)['payout']['upiIdMasked'])" 2>/dev/null)
[ "$BEFORE" = "None" ] && ok "a new account has no payout address" \
                       || bad "clean start" "got $BEFORE"

hdr "Setting a payout address"
C=$(put payout-method "{\"upiId\":\"Sarthak@OKHDFCBANK\",\"holderName\":\"  Sarthak   Sharma \"}")
B=$(cat /tmp/ref-body.json)
[ "$C" = "200" ] && ok "a referrer can set their UPI ID" || bad "set upi" "HTTP $C"

M=$(echo "$B" | field upiIdMasked)
[ "$M" = "$MASK1" ] && ok "the address comes back masked ($M)" || bad "mask" "got $M"

# Case is not significant in a VPA, so it is lowercased before storage --
# otherwise one address is two rows depending on how it was typed.
#
# Each negative below is gated on the positive check above it, the way the
# Aadhaar checks in kyc-review-e2e are. "The uppercase did not survive" and
# "the raw address is not in here" are both trivially true of an empty
# response, so ungated they would print a reassuring green line about
# privacy holding while having examined nothing at all -- inside a run that
# is already failing, next to the strongest privacy claim in the feature.
[ "$M" = "$MASK1" ] \
  && { echo "$B" | grep -qF "OKHDFCBANK" && bad "normalisation" "uppercase survived" \
                                         || ok "the address is normalised to lower case"; } \
  || bad "normalisation" "nothing to inspect: ${B:-<nothing>}"

N=$(echo "$B" | field upiHolderName)
[ "$N" = "Sarthak Sharma" ] && ok "the holder name is trimmed and collapsed" || bad "name" "got '$N'"

# The whole point of a masked handle is that the address does not come back.
[ "$M" = "$MASK1" ] \
  && { echo "$B" | grep -qF "$VPA1" && bad "leak" "the raw address is in the response" \
                                    || ok "the raw address is never returned"; } \
  || bad "leak" "nothing to inspect: ${B:-<nothing>}"

V=$(echo "$B" | field upiVerified)
[ "$V" = "False" ] && ok "a freshly set address is not verified" || bad "verified" "got $V"

# The same trap once more, and this one is easy to miss: an empty list and
# a failed parse both produce an empty string, and "it no longer mentions
# UPI" is true of both. Gated on the list still naming the PAN, which is
# what proves it was read at all.
STILL=$(echo "$B" | python -c "
import sys,json;print('|'.join(json.load(sys.stdin)['youStillNeedTo']))" 2>/dev/null)
echo "$STILL" | grep -q "PAN" \
  && { echo "$STILL" | grep -q "UPI" && bad "todo list" "still asks for a UPI ID" \
                                     || ok "the outstanding list drops the UPI ID once it is set"; } \
  || bad "todo list" "nothing to inspect: ${STILL:-<nothing>}"

G=$(curl -s "$API/me/referral" -H "Authorization: Bearer $TOK" | nested payout upiIdMasked)
[ "$G" = "$MASK1" ] && ok "and it is there on the next read" || bad "persistence" "got $G"

hdr "Addresses that must be refused"
for pair in \
  "sarthak|no @ at all" \
  "a@b@ybl|two @" \
  ".sarthak@ybl|leading dot" \
  "sarthak.@ybl|trailing dot" \
  "sar thak@ybl|a space" \
  "sarthak@y|a one-character handle" \
  "@ybl|no identifier" \
  "|empty"
do
  V_BAD="${pair%%|*}"; WHY="${pair##*|}"
  C=$(put payout-method "{\"upiId\":\"$V_BAD\",\"holderName\":\"Sarthak Sharma\"}")
  [ "$C" = "400" ] && ok "refused: $WHY" || bad "refuse $WHY" "got HTTP $C"
done

# A two-character identifier is valid and must NOT be refused. The first
# version of this regex rejected it -- one- and three-character identifiers
# passed and two-character ones did not -- which is the failure that locks a
# real referrer out of their own money.
C=$(put payout-method '{"upiId":"ab@axl","holderName":"Sarthak Sharma"}')
[ "$C" = "200" ] && ok "accepted: a two-character identifier is a real address" \
                 || bad "two-char identifier" "got HTTP $C, expected 200"

hdr "Names that must be refused"
C=$(put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"Robert'); DROP TABLE users;--\"}")
[ "$C" = "400" ] && ok "refused: a name full of punctuation" || bad "name refusal" "got HTTP $C"

C=$(put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"X\"}")
[ "$C" = "400" ] && ok "refused: a one-character name" || bad "short name" "got HTTP $C"

# Whitelist validation: a client must not be able to hand itself the flag
# that says its address was verified.
C=$(put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"Sarthak Sharma\",\"upiVerified\":true}")
[ "$C" = "400" ] && ok "refused: smuggling upiVerified into the body" || bad "mass assignment" "got HTTP $C"

hdr "PAN"
C=$(put pan '{"pan":"abcde1234f"}')
B=$(cat /tmp/ref-body.json)
[ "$C" = "200" ] && ok "a referrer can set their PAN" || bad "set pan" "HTTP $C"

L=$(echo "$B" | field panLast4)
[ "$L" = "234F" ] && ok "lower case is normalised and only the last four kept" || bad "panLast4" "got $L"

S=$(echo "$B" | field panStatus)
[ "$S" = "PENDING" ] && ok "status is PENDING, not VERIFIED -- nothing has checked it" \
                     || bad "panStatus" "got $S"

[ "$L" = "234F" ] \
  && { echo "$B" | grep -qF "$PAN" && bad "pan leak" "the full PAN is in the response" \
                                   || ok "the full PAN is never returned"; } \
  || bad "pan leak" "nothing to inspect: ${B:-<nothing>}"

C=$(put pan '{"pan":"ABCD1234F"}')
[ "$C" = "400" ] && ok "refused: a malformed PAN" || bad "bad pan" "got HTTP $C"

# A PAN verification must behave like the UPI one. The first version of
# this endpoint forced PENDING on every write, so opening the form and
# pressing save cost somebody their verification. Nothing could reach that
# difference -- nothing sets a PAN to VERIFIED -- which is exactly why it
# would have sat there until PAN verification was built and then been wrong.
[ "$(db verify-pan "$CODE")" = "ok" ] || bad "precondition" "could not mark the PAN verified"
C=$(put pan "{\"pan\":\"$PAN\"}")
S=$(cat /tmp/ref-body.json | field panStatus)
[ "$S" = "VERIFIED" ] && ok "re-sending the same PAN keeps its verification" \
                      || bad "pan idempotent" "status became $S"

C=$(put pan '{"pan":"ZZZZZ9999Z"}')
S=$(cat /tmp/ref-body.json | field panStatus)
[ "$S" = "PENDING" ] && ok "a different PAN goes back to PENDING" \
                     || bad "pan changed" "status is $S"

# A rejected PAN sent again is a request for another look, which is how gym
# KYC resubmission already behaves.
[ "$(db reject-pan "$CODE")" = "ok" ] || bad "precondition" "could not reject the PAN"
C=$(put pan '{"pan":"ZZZZZ9999Z"}')
S=$(cat /tmp/ref-body.json | field panStatus)
[ "$S" = "PENDING" ] && ok "and resubmitting a rejected PAN asks for review again" \
                     || bad "pan rejected" "status is $S"

# Put the real one back so the later checks read what they expect.
put pan "{\"pan\":\"$PAN\"}" > /dev/null

hdr "Encrypted at rest"
# Guarded so this cannot pass on nothing: "the plaintext is not in the row"
# is trivially true of a row that was never read, which is exactly how the
# chat encryption check passed against a dropped connection.
ROW=$(db read "$CODE")
case "$ROW" in
  ERR*|NOACCOUNT|"") bad "row read" "could not read the row: $ROW" ;;
  *)
    ok "referral_accounts row read straight from the database"
    echo "$ROW" | grep -q '"upiIdEnc":"' && ok "upiIdEnc is populated" \
                                         || bad "upiIdEnc" "column is empty"
    echo "$ROW" | grep -q '"panEnc":"'   && ok "panEnc is populated" \
                                         || bad "panEnc" "column is empty"
    echo "$ROW" | grep -qF "$PAN" && bad "pan at rest" "the PAN is in the row in clear" \
                                  || ok "the PAN is not in the row in clear"
    ;;
esac

hdr "What reached the audit log"
# The response and the stored row were both checked above. The audit log is
# the third place these values could leak, and it is the one with the widest
# readership -- every admin holding the log viewer opens it, not just whoever
# reviews payouts. It is also the place where over-redacting does damage: if
# the masked handle is scrubbed too, the trail can no longer answer the one
# question it exists for, which is what address somebody switched to.
AUDIT=$(db audit "$CODE")
case "$AUDIT" in
  ERR*|NOACCOUNT|"") bad "audit read" "could not read the log: $AUDIT" ;;
  *)
    ROWS=$(echo "$AUDIT" | python -c "import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
    [ "${ROWS:-0}" -gt 0 ] 2>/dev/null \
      && ok "$ROWS referral.* audit rows were written" \
      || { bad "audit rows" "none written -- the audit call never landed"; ROWS=0; }

    if [ "${ROWS:-0}" -gt 0 ]; then
      echo "$AUDIT" | grep -qF "$VPA1" \
        && bad "audit leak" "the raw address is in the audit log" \
        || ok "the raw address is not in the audit log"
      echo "$AUDIT" | grep -qF "$PAN" \
        && bad "audit leak" "the full PAN is in the audit log" \
        || ok "the full PAN is not in the audit log"
      # Over-redaction is a failure too, not a safe default.
      echo "$AUDIT" | grep -qF "$MASK1" \
        && ok "but the masked handle did survive, so the trail is still readable" \
        || bad "over-redacted" "the masked handle was scrubbed as well"
      echo "$AUDIT" | grep -q '"actorId": *null' \
        && bad "actor" "a row does not say who did it" \
        || ok "every row names who did it"
    fi
    ;;
esac

hdr "A verification never survives a change of address"
# upiVerified means "the drop came back with a name matching the claimed
# one" -- a statement about ONE address and ONE name. Carrying it across a
# change would let somebody verify an address they control, swap in another,
# and inherit a verified flag onto an account nobody ever checked.
put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"Sarthak Sharma\"}" > /dev/null
[ "$(db verify "$CODE")" = "ok" ] || bad "precondition" "could not mark the address verified"

C=$(put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"Sarthak Sharma\"}")
V=$(cat /tmp/ref-body.json | field upiVerified)
[ "$V" = "True" ] && ok "re-sending the same address keeps the verification" \
                  || bad "idempotent set" "verification was cleared, got $V"

C=$(put payout-method "{\"upiId\":\"$VPA2\",\"holderName\":\"Sarthak Sharma\"}")
V=$(cat /tmp/ref-body.json | field upiVerified)
M=$(cat /tmp/ref-body.json | field upiIdMasked)
[ "$V" = "False" ] && ok "changing the address clears the verification" \
                   || bad "reset on change" "still $V"
[ "$M" = "$MASK2" ] && ok "and the new address is the one on record" || bad "new mask" "got $M"

# The case that actually discriminates. VPA1 and VPA_TYPO differ by one
# character and mask to the SAME string, so an implementation that compared
# masked handles instead of decrypting would see no change here and keep the
# verification -- while the money now goes to a different person's account.
# Every other check in this section passes against that bug; this one does
# not, which is the only reason it is worth writing.
put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"Sarthak Sharma\"}" > /dev/null
[ "$(db verify "$CODE")" = "ok" ] || bad "precondition" "could not re-verify"
C=$(put payout-method "{\"upiId\":\"$VPA_TYPO\",\"holderName\":\"Sarthak Sharma\"}")
V=$(cat /tmp/ref-body.json | field upiVerified)
M=$(cat /tmp/ref-body.json | field upiIdMasked)
[ "$M" = "$MASK1" ] && ok "a one-character typo masks identically ($M)" \
                    || bad "typo mask" "expected $MASK1, got $M"
[ "$V" = "False" ] && ok "and it still clears the verification -- masks are not compared" \
                   || bad "mask-comparison bug" "a typo into another account kept the verification"

# The name is half of what was verified, so changing it invalidates the
# result just as the address does.
[ "$(db verify "$CODE")" = "ok" ] || bad "precondition" "could not re-verify"
C=$(put payout-method "{\"upiId\":\"$VPA2\",\"holderName\":\"Someone Else\"}")
V=$(cat /tmp/ref-body.json | field upiVerified)
[ "$V" = "False" ] && ok "changing only the holder name clears it too" \
                   || bad "reset on name change" "still $V"

hdr "Nothing moves while money is moving"
[ "$(db queue-payout "$CODE")" = "ok" ] || bad "precondition" "could not queue a payout"

C=$(put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"Sarthak Sharma\"}")
[ "$C" = "409" ] && ok "the address cannot be changed with a payout in flight" \
                 || bad "in-flight guard" "got HTTP $C, expected 409"

C=$(put pan '{"pan":"ABCDE1234F"}')
[ "$C" = "409" ] && ok "nor can the PAN tax is withheld against" \
                 || bad "in-flight guard (pan)" "got HTTP $C, expected 409"

# The app has this sentence in ten languages and picks its own by the code.
# Without one it would show the server's English on the screen where
# somebody sets where their money goes -- and the only thing that refusal
# has to do is be understood.
[ "$(field code < /tmp/ref-body.json)" = "PAYOUT_IN_FLIGHT" ] \
  && ok "and the refusal names itself so the app can translate it" \
  || bad "in-flight code" "$(cat /tmp/ref-body.json)"

# And the guard lifts once the payout is gone, rather than locking the
# account permanently -- a refusal you cannot get out of is its own bug.
[ "$(db clear-payouts "$CODE")" = "ok" ] || bad "cleanup" "could not clear payouts"
C=$(put payout-method "{\"upiId\":\"$VPA1\",\"holderName\":\"Sarthak Sharma\"}")
[ "$C" = "200" ] && ok "and it lifts once the payout has settled" || bad "guard release" "got HTTP $C"

hdr "The rewards behind the totals"

get_earn() {
  curl -s -o /tmp/ref-earn.json -w "%{http_code}" -m 60 \
    "$API/me/referral/earnings$1" -H "Authorization: Bearer $TOK"
}

C=$(get_earn "")
E=$(cat /tmp/ref-earn.json)
[ "$C" = "200" ] && ok "a referrer can list their rewards" || bad "earnings" "HTTP $C"
[ "$(echo "$E" | field returned)" = "0" ] \
  && ok "and one who has referred nobody gets an empty list" \
  || bad "empty list" "$E"
[ "$(echo "$E" | field hasMore)" = "False" ] \
  && ok "with hasMore false rather than absent" || bad "hasMore" "$E"

# `?limit=20` arrives as the STRING "20". The global pipe runs with
# enableImplicitConversion off, so without @Type(() => Number) this fails
# @IsInt and the screen shows a validation error for a parameter the user
# never typed. This is the check that a working limit works for the right
# reason.
C=$(get_earn "?limit=1")
[ "$C" = "200" ] && ok "a numeric limit survives arriving as a string" \
                 || bad "limit coercion" "HTTP $C -- $(cat /tmp/ref-earn.json)"

for LIM in 0 101 -1 abc 1.5; do
  C=$(get_earn "?limit=$LIM")
  [ "$C" = "400" ] && ok "limit=$LIM is refused" || bad "limit=$LIM" "got HTTP $C"
done

C=$(get_earn "?offset=10")
[ "$C" = "400" ] && ok "an unexpected query parameter is refused, not ignored" \
                 || bad "whitelist" "got HTTP $C"

C=$(curl -s -o /dev/null -w "%{http_code}" -m 60 "$API/me/referral/earnings")
[ "$C" = "401" ] && ok "a stranger cannot list somebody's rewards" \
                 || bad "anon earnings" "got HTTP $C"

hdr "The sentence that gets forwarded"

share() {
  if [ -z "$1" ]; then
    curl -s -m 60 "$API/me/referral" -H "Authorization: Bearer $TOK" | field shareText
  else
    curl -s -m 60 "$API/me/referral" -H "Authorization: Bearer $TOK" \
      -H "Accept-Language: $1" | field shareText
  fi
}

EN=$(share "")
case "$EN" in
  *"$CODE"*) ok "the share text carries the code" ;;
  *) bad "share text" "code missing from: $EN" ;;
esac
case "$EN" in
  *"10%"*) ok "and says what the gym owner gets out of it" ;;
  *) bad "share text" "no discount in: $EN" ;;
esac

# Every supported language, because a locale added to SUPPORTED_LOCALES
# without a line in share-text.ts would otherwise put the word "undefined"
# in front of a gym owner.
SHARES=""
for L in en hi bn ta te mr ml kn gu pa; do
  T=$(share "$L")
  case "$T" in
    *"$CODE"*) ok "$L: answered, and the code is still Latin script" ;;
    *) bad "$L share text" "got: $T" ;;
  esac
  SHARES="$SHARES$T
"
done

DISTINCT=$(printf '%s' "$SHARES" | sort -u | grep -c .)
[ "$DISTINCT" = "10" ] \
  && ok "all ten languages differ -- none is a copy of another" \
  || bad "translations" "only $DISTINCT distinct strings across ten languages"

# Different is not the same as translated: a typo'd English line would pass
# the distinctness check above. The script itself has to be there.
HI=$(share hi)
if printf '%s' "$HI" | python -c "
import sys
t = sys.stdin.buffer.read().decode('utf-8')
sys.exit(0 if any('\u0900' <= c <= '\u097f' for c in t) else 1)"; then
  ok "the Hindi one is in Devanagari, not merely different"
else
  bad "hi" "no Devanagari in: $HI"
fi

TA=$(share ta)
if printf '%s' "$TA" | python -c "
import sys
t = sys.stdin.buffer.read().decode('utf-8')
sys.exit(0 if any('\u0b80' <= c <= '\u0bff' for c in t) else 1)"; then
  ok "and the Tamil one is in Tamil script"
else
  bad "ta" "no Tamil script in: $TA"
fi

# A real Accept-Language is a weighted list. Reading the first entry and
# stopping would serve English to somebody who plainly asked for Marathi.
W=$(share "en;q=0.5,mr;q=0.9")
MR=$(share mr)
[ "$W" = "$MR" ] && ok "a weighted header picks the highest q, not the first entry" \
                 || bad "weighted header" "got: $W"

FR=$(share "fr-FR,fr;q=0.9")
[ "$FR" = "$EN" ] && ok "an unsupported language falls back to English" \
                  || bad "fallback" "got: $FR"

hdr "Who may not do this at all"
OWN=$(login "$P_OWN" "Owner")
GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWN" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Referral Test Gym\",\"addressLine1\":\"1 Test Road\",\"state\":\"Goa\",
           \"district\":\"Panaji\",\"city\":\"Panaji\",\"pincode\":\"403001\",
           \"contactPhone\":\"$P_OWN\"}" | field id)
[ -n "$GID" ] && ok "a gym was created for the owner check" || bad "setup" "no gym"

C=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$API/me/referral/payout-method" \
    -H "Authorization: Bearer $OWN" -H 'Content-Type: application/json' \
    -d "{\"upiId\":\"$VPA1\",\"holderName\":\"Gym Owner\"}")
[ "$C" = "403" ] && ok "a gym owner cannot set a payout address" || bad "owner" "got HTTP $C"

C=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$API/me/referral/pan" \
    -H "Authorization: Bearer $OWN" -H 'Content-Type: application/json' -d '{"pan":"ABCDE1234F"}')
[ "$C" = "403" ] && ok "nor a PAN" || bad "owner pan" "got HTTP $C"

C=$(curl -s -o /dev/null -w "%{http_code}" "$API/me/referral/earnings" \
    -H "Authorization: Bearer $OWN")
[ "$C" = "403" ] && ok "nor read an earnings list they cannot have" \
                 || bad "owner earnings" "got HTTP $C"

# The refusal has to be machine-readable, not just readable.
#
# This sentence is the entire screen for a gym owner and the only thing
# they will ever see from us -- so the app carries it in all ten languages
# and picks its own by this code. Matching on the English would break the
# first time the wording improved, and could not tell this 403 apart from
# the suspended-account one that shares its status.
BODY=$(curl -s "$API/me/referral" -H "Authorization: Bearer $OWN")
[ "$(echo "$BODY" | field code)" = "REFERRAL_OWNER_EXCLUDED" ] \
  && ok "and the refusal names itself, so the app can translate it" \
  || bad "error code" "$BODY"

# The login path enforces the same rule and has to answer the same way --
# it is one sentence in the app, not two, and it is the path a real gym
# owner actually hits.
#
# This costs a wait, and the wait is the point. `$P_OWN` was signed in a
# moment ago to create the gym, and a number may only be sent a code every
# thirty seconds. The first version of this check ignored that, got an
# empty challenge id, and failed with a validation error about a field the
# test never filled in -- which looks nothing like the cooldown that
# actually caused it. So the delay is read off the server's own answer
# rather than slept blind, and the suite says out loud that it is waiting.
otp_request() {
  curl -s -m 60 -X POST "$API/auth/otp/request" -H 'Content-Type: application/json' \
    -d "{\"phone\":\"$1\",\"appClient\":\"$2\"}"
}

LOGIN=$(otp_request "$P_OWN" REFERRAL)
WAIT=$(echo "$LOGIN" | python -c "
import sys, json, re
try:
    d = json.load(sys.stdin)
except Exception:
    print(0); raise SystemExit
if d.get('challengeId'):
    print(0)
else:
    m = re.search(r'(\d+)s', str(d.get('message', '')))
    print(int(m.group(1)) + 2 if m else 0)" 2>/dev/null)

if [ "${WAIT:-0}" -gt 0 ] 2>/dev/null; then
  printf '  ..    waiting %ss for the per-number resend cooldown\n' "$WAIT"
  sleep "$WAIT"
  LOGIN=$(otp_request "$P_OWN" REFERRAL)
fi

LCID=$(echo "$LOGIN" | field challengeId); LCODE=$(echo "$LOGIN" | field devCode)
[ -n "$LCID" ] && [ -n "$LCODE" ] \
  && ok "a fresh referral-app challenge was issued to a gym owner" \
  || bad "referral challenge" "$LOGIN"

LV=$(curl -s -m 60 -X POST "$API/auth/otp/verify" -H 'Content-Type: application/json' \
     -d "{\"challengeId\":\"$LCID\",\"phone\":\"$P_OWN\",\"code\":\"$LCODE\",\"appClient\":\"REFERRAL\"}")
[ "$(echo "$LV" | field statusCode)" = "403" ] \
  && ok "and a correct code still does not let them in" \
  || bad "referral login" "$LV"
[ "$(echo "$LV" | field code)" = "REFERRAL_OWNER_EXCLUDED" ] \
  && ok "with the same code the referral endpoints use" || bad "login code" "$LV"

# The member app is where this person belongs, and $OWN is a live token
# from exactly that login a few checks ago. A rule that turned an owner
# away everywhere would be a worse bug than the one it guards against, and
# this says so without spending another code.
[ "$(curl -s -o /dev/null -w "%{http_code}" "$API/auth/me" -H "Authorization: Bearer $OWN")" = "200" ] \
  && ok "while the same owner's member session still works" || bad "member session" "refused"

# The code is added deliberately, one refusal at a time. If it started
# appearing on everything it would become a second, unversioned API that
# nobody maintains -- so an ordinary validation failure must not carry one.
PLAIN=$(curl -s "$API/me/referral/earnings?limit=0" -H "Authorization: Bearer $TOK")
[ -z "$(echo "$PLAIN" | field code)" ] \
  && ok "and an ordinary 400 carries no code at all" || bad "code leak" "$PLAIN"

C=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$API/me/referral/payout-method" \
    -H 'Content-Type: application/json' -d "{\"upiId\":\"$VPA1\",\"holderName\":\"Nobody\"}")
[ "$C" = "401" ] && ok "and a stranger with no token is refused" || bad "anon" "got HTTP $C"

rm -f /tmp/ref-body.json /tmp/ref-earn.json
printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
