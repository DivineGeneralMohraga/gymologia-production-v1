#!/usr/bin/env bash
# Asset URLs must live in our own storage -- checked through the real API.
#
#   node dist/main.js                 # in one shell
#   bash test/storage-url-e2e.sh      # in another
#
# test/storage-url.spec.ts covers the predicate on its own. This is the
# other half: that the constraint is actually wired to the endpoints, and
# that a hostile URL comes back a 400 rather than being stored and later
# served to somebody's phone.

API="${API:-http://localhost:3000/api/v1}"
FAILED=""

ok()  { printf "  \033[32mPASS\033[0m  %s\n" "$1"; }
bad() { printf "  \033[31mFAIL\033[0m  %s -- %s\n" "$1" "$2"; FAILED=1; }
hdr() { printf "\n\033[1m%s\033[0m\n" "$1"; }

field()  { python -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
nested() { python -c "import sys,json;print(json.load(sys.stdin).get('$1',{}).get('$2',''))" 2>/dev/null; }

# Throwaway number in the same range the other suites use. An Indian mobile
# has to start 6-9, so a made-up prefix is refused by validation long before
# it reaches the check this file is about.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
PHONE="+9198100${STAMP}7"

# Same shape as the other suites: the OTP request carries the app it came
# from, and a number seen for the first time needs a registration step.
login() {
  local phone="$1" r cid code v rt
  r=$(curl -s -m 60 -X POST "$API/auth/otp/request" -H 'Content-Type: application/json' \
      -d "{\"phone\":\"$phone\",\"appClient\":\"MEMBER\"}")
  cid=$(echo "$r" | field challengeId)
  code=$(echo "$r" | field devCode)
  v=$(curl -s -m 60 -X POST "$API/auth/otp/verify" -H 'Content-Type: application/json' \
      -d "{\"challengeId\":\"$cid\",\"phone\":\"$phone\",\"code\":\"$code\",\"appClient\":\"MEMBER\"}")
  if [ "$(echo "$v" | field status)" = "NEW_USER" ]; then
    rt=$(echo "$v" | field registrationToken)
    v=$(curl -s -m 60 -X POST "$API/auth/register" -H 'Content-Type: application/json' \
        -d "{\"registrationToken\":\"$rt\",\"name\":\"URL Test\",\"age\":30}")
  fi
  echo "$v" | nested tokens accessToken
}

hdr "Signing in"
TOKEN=$(login "$PHONE")
[ -n "$TOKEN" ] && ok "signed in" || { bad "login" "no token"; exit 1; }

# One gym body, one image URL swapped in each time.
try_gym() {
  curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms" \
    -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
    -d "{\"name\":\"URL Test Gym $STAMP\",\"addressLine1\":\"1 Test Road\",
         \"city\":\"Pune\",\"district\":\"Pune\",\"state\":\"Maharashtra\",
         \"pincode\":\"411001\",\"contactPhone\":\"$PHONE\",
         \"maxLeaveDaysPerMonth\":4,\"imageUrls\":[\"$1\"]}"
}

hdr "Hostile asset URLs are refused"
for url in \
  "http://attacker.example/tracker.png" \
  "https://evil.test/kyc-phish.html" \
  "http://169.254.169.254/latest/meta-data/" \
  "https://myproject.supabase.co@evil.test/storage/v1/object/a.png" \
  "http://myproject.supabase.co/storage/v1/object/public/a.png"
do
  CODE=$(try_gym "$url")
  if [ "$CODE" = "400" ]; then
    ok "refused $url"
  else
    bad "refused $url" "got HTTP $CODE, expected 400"
  fi
done

printf "\n"
if [ -n "$FAILED" ]; then
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
printf "\033[32mALL CHECKS PASSED\033[0m\n"
