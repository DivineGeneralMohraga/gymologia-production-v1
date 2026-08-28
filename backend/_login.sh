#!/usr/bin/env bash
# Logs a phone number in (registering it if new) and prints the access token.
API=http://localhost:3000/api/v1
PHONE="$1"; NAME="${2:-Test User}"
R=$(curl -s -m 60 -X POST $API/auth/otp/request -H 'Content-Type: application/json' -d "{\"phone\":\"$PHONE\",\"appClient\":\"MEMBER\"}")
CID=$(echo "$R" | python -c "import sys,json;print(json.load(sys.stdin).get('challengeId',''))")
CODE=$(echo "$R" | python -c "import sys,json;print(json.load(sys.stdin).get('devCode',''))")
V=$(curl -s -m 60 -X POST $API/auth/otp/verify -H 'Content-Type: application/json' -d "{\"challengeId\":\"$CID\",\"phone\":\"$PHONE\",\"code\":\"$CODE\",\"appClient\":\"MEMBER\"}")
STATUS=$(echo "$V" | python -c "import sys,json;print(json.load(sys.stdin).get('status',''))")
if [ "$STATUS" = "NEW_USER" ]; then
  RT=$(echo "$V" | python -c "import sys,json;print(json.load(sys.stdin)['registrationToken'])")
  V=$(curl -s -m 60 -X POST $API/auth/register -H 'Content-Type: application/json' -d "{\"registrationToken\":\"$RT\",\"name\":\"$NAME\",\"age\":28}")
fi
echo "$V" | python -c "import sys,json;print(json.load(sys.stdin)['tokens']['accessToken'])"
