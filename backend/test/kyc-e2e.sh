#!/usr/bin/env bash
# Gym verification: what is accepted, what is refused, and what comes back.
#
#   node dist/main.js       # in one shell
#   bash test/kyc-e2e.sh    # in another
#
# The conditional rules are the reason this exists. "No GST means another
# proof" and "rented means a landlord's letter" are the kind of thing that
# reads correctly in a DTO and does nothing at runtime, and a reviewer
# would only find out when a file they needed was not there.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

field()  { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',{}).get('$2',''))" 2>/dev/null; }

STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_OWNER="+9198100${STAMP}1"

# Constructed, not real. The Aadhaar check digit is computed so the request
# gets past validation and exercises the service underneath.
AADHAAR="234567890124"
PAN="ABCDE1234F"
GSTIN="27ABCDE1234F1Z5"
GSTIN_OTHER_PAN="27ZZZZZ9999Z1Z5"

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

hdr "Setting up"
OWNER=$(login "$P_OWNER" "KYC Owner")
[ -n "$OWNER" ] && ok "owner signed in" || { bad "owner login" "no token"; exit 1; }

GYM=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' \
      -d "{\"name\":\"KYC Test Gym $STAMP\",\"addressLine1\":\"1 Test Road\",
           \"city\":\"Pune\",\"district\":\"Pune\",\"state\":\"Maharashtra\",
           \"pincode\":\"411001\",\"contactPhone\":\"$P_OWNER\",
           \"maxLeaveDaysPerMonth\":4}" | field id)
[ -n "$GYM" ] && ok "gym created" || { bad "gym create" "no id"; exit 1; }

# A URL that passes the storage rule without anything having been uploaded:
# this suite is about the verification rules, not about storage.
DOC="https://wnjncecaljylgekppqit.supabase.co/storage/v1/object/kyc-documents/$GYM/doc.pdf"

post_kyc() {
  curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GYM/kyc" \
    -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' -d "$1"
}
post_kyc_body() {
  curl -s -X POST "$API/gyms/$GYM/kyc" \
    -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' -d "$1"
}

hdr "Numbers that cannot be right"
CODE=$(post_kyc "{\"aadhaar\":\"234567890125\",\"pan\":\"$PAN\",\"premises\":\"OWNED\",\"gstin\":\"$GSTIN\"}")
[ "$CODE" = "400" ] && ok "an Aadhaar with a bad check digit is refused" \
                    || bad "bad aadhaar refused" "got HTTP $CODE"

CODE=$(post_kyc "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"NOTAPAN\",\"premises\":\"OWNED\",\"gstin\":\"$GSTIN\"}")
[ "$CODE" = "400" ] && ok "a malformed PAN is refused" || bad "bad pan refused" "got HTTP $CODE"

CODE=$(post_kyc "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"$PAN\",\"premises\":\"OWNED\",\"gstin\":\"$GSTIN_OTHER_PAN\"}")
[ "$CODE" = "400" ] && ok "a GSTIN whose embedded PAN disagrees is refused" \
                    || bad "gstin/pan mismatch refused" "got HTTP $CODE"

hdr "The conditional rules"
CODE=$(post_kyc "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"$PAN\",\"premises\":\"OWNED\"}")
[ "$CODE" = "400" ] && ok "no GST and no other proof is refused" \
                    || bad "missing alt proof refused" "got HTTP $CODE"

CODE=$(post_kyc "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"$PAN\",\"premises\":\"RENTED\",\"gstin\":\"$GSTIN\"}")
[ "$CODE" = "400" ] && ok "rented premises without a landlord NOC is refused" \
                    || bad "missing noc refused" "got HTTP $CODE"

CODE=$(post_kyc "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"$PAN\",\"premises\":\"OWNED\",\"altProofType\":\"UDYAM\",\"altProofUrl\":\"https://evil.test/proof.pdf\"}")
[ "$CODE" = "400" ] && ok "a document hosted somewhere else is refused" \
                    || bad "foreign doc url refused" "got HTTP $CODE"

hdr "A submission that is complete"
RESP=$(post_kyc_body "{\"aadhaar\":\"$AADHAAR\",\"pan\":\"$PAN\",\"premises\":\"RENTED\",\"gstin\":\"$GSTIN\",\"nocUrl\":\"$DOC\"}")
[ "$(echo "$RESP" | field submitted)" = "True" ] && ok "accepted" || bad "accepted" "$RESP"
[ "$(echo "$RESP" | field aadhaarStatus)" = "PENDING" ] && ok "Aadhaar is pending review" \
  || bad "aadhaar pending" "$(echo "$RESP" | field aadhaarStatus)"
[ "$(echo "$RESP" | field nocStatus)" = "PENDING" ] && ok "the NOC is pending review" \
  || bad "noc pending" "$(echo "$RESP" | field nocStatus)"

hdr "What comes back out"
GET=$(curl -s "$API/gyms/$GYM/kyc" -H "Authorization: Bearer $OWNER")
[ "$(echo "$GET" | field aadhaarLast4)" = "0124" ] && ok "only the last four of the Aadhaar" \
  || bad "aadhaar last4" "$(echo "$GET" | field aadhaarLast4)"
echo "$GET" | grep -q "$AADHAAR" \
  && bad "full Aadhaar leaked in the response" "$GET" \
  || ok "the full Aadhaar is never returned"
echo "$GET" | grep -qi 'aadhaarEnc' \
  && bad "ciphertext leaked in the response" "$GET" \
  || ok "nor is the ciphertext"

printf "\n"
if [ -n "$FAILED" ]; then
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
printf "\033[32mALL CHECKS PASSED\033[0m\n"
