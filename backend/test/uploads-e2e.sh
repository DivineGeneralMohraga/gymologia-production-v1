#!/usr/bin/env bash
# Signed uploads, through the real API.
#
#   node dist/main.js            # in one shell
#   bash test/uploads-e2e.sh     # in another
#
# Written to be honest in both states of the world. With
# SUPABASE_SERVICE_ROLE_KEY set, a sign request returns a URL and this
# checks its shape. Without it, the only correct answer is a 503 saying so,
# and that is checked too -- a server that cannot sign must say that
# plainly rather than hand back a URL that will fail later on the phone.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()   { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad()  { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
skip() { printf "  \033[33mSKIP\033[0m  %s\n" "$1"; }
hdr()  { printf "\n\033[1m%s\033[0m\n" "$1"; }

field()  { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',{}).get('$2',''))" 2>/dev/null; }

STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P_OWNER="+9198100${STAMP}1"
P_OTHER="+9198100${STAMP}2"

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
OWNER=$(login "$P_OWNER" "Upload Owner")
[ -n "$OWNER" ] && ok "owner signed in" || { bad "owner login" "no token"; exit 1; }

GYM=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' \
      -d "{\"name\":\"Upload Test Gym $STAMP\",\"addressLine1\":\"1 Test Road\",
           \"city\":\"Pune\",\"district\":\"Pune\",\"state\":\"Maharashtra\",
           \"pincode\":\"411001\",\"contactPhone\":\"$P_OWNER\",
           \"maxLeaveDaysPerMonth\":4}" | field id)
[ -n "$GYM" ] && ok "gym created" || { bad "gym create" "no id"; exit 1; }

sign() {
  curl -s -X POST "$API/gyms/$GYM/uploads/sign" \
    -H "Authorization: Bearer $1" -H 'Content-Type: application/json' \
    -d "{\"kind\":\"$2\",\"contentType\":\"$3\"}"
}
sign_code() {
  curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GYM/uploads/sign" \
    -H "Authorization: Bearer $1" -H 'Content-Type: application/json' \
    -d "{\"kind\":\"$2\",\"contentType\":\"$3\"}"
}

hdr "What is refused before storage is ever reached"
CODE=$(sign_code "$OWNER" "GYM_IMAGE" "application/x-msdownload")
[ "$CODE" = "400" ] && ok "an executable content type is refused" \
                    || bad "executable refused" "got HTTP $CODE"

CODE=$(sign_code "$OWNER" "GYM_IMAGE" "application/pdf")
[ "$CODE" = "400" ] && ok "a PDF is refused for a gym photo" \
                    || bad "pdf as photo refused" "got HTTP $CODE"

CODE=$(sign_code "$OWNER" "NOT_A_KIND" "image/png")
[ "$CODE" = "400" ] && ok "an unknown asset kind is refused" \
                    || bad "unknown kind refused" "got HTTP $CODE"

hdr "Someone with no standing at this gym"
OTHER=$(login "$P_OTHER" "Passer By")
CODE=$(sign_code "$OTHER" "GYM_IMAGE" "image/png")
[ "$CODE" = "403" ] && ok "a stranger cannot ask for an upload URL" \
                    || bad "stranger refused" "got HTTP $CODE, expected 403"

hdr "Signing"
RESP=$(sign "$OWNER" "GYM_IMAGE" "image/png")
CODE=$(sign_code "$OWNER" "GYM_IMAGE" "image/png")
if [ "$CODE" = "503" ]; then
  skip "storage is not configured on this server (SUPABASE_SERVICE_ROLE_KEY)"
  skip "set it and re-run to check the signed URL itself"
elif [ "$CODE" = "200" ] || [ "$CODE" = "201" ]; then
  UP=$(echo "$RESP" | field uploadUrl)
  ASSET=$(echo "$RESP" | field assetUrl)
  PATH_=$(echo "$RESP" | field path)
  echo "$UP" | grep -q '^https://.*/storage/v1/object/upload/sign/gym-images/' \
    && ok "upload URL points at the gym-images bucket" \
    || bad "upload URL" "$UP"
  echo "$UP" | grep -q 'token=' && ok "and carries a token" || bad "token" "$UP"
  echo "$ASSET" | grep -q "^https://.*/storage/v1/object/public/gym-images/$GYM/" \
    && ok "asset URL is public and inside this gym's folder" \
    || bad "asset URL" "$ASSET"
  echo "$PATH_" | grep -q "^$GYM/" \
    && ok "path is scoped to the gym, so one gym cannot overwrite another" \
    || bad "path scoping" "$PATH_"

  KRESP=$(sign "$OWNER" "KYC_DOCUMENT" "application/pdf")
  KASSET=$(echo "$KRESP" | field assetUrl)
  echo "$KASSET" | grep -q '/storage/v1/object/kyc-documents/' \
    && echo "$KASSET" | grep -qv '/object/public/' \
    && ok "a KYC document is not given a public URL" \
    || bad "kyc privacy" "$KASSET"
else
  bad "sign" "got HTTP $CODE, expected 201 or 503"
fi

printf "\n"
if [ -n "$FAILED" ]; then
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
printf "\033[32mALL CHECKS PASSED\033[0m\n"
