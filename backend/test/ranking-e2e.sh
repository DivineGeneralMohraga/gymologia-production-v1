#!/usr/bin/env bash
#
# Search ranking: where a gym sits in Gymologia's results.
#
#   bash test/ranking-e2e.sh
#
# The check that matters is the last one. A reported position that does not
# match what search actually returns is worse than no position at all, so
# the two are compared directly rather than each being trusted on its own.

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
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":34}")
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
" "$2" "$3" "$4"; }

make_gym() {
  curl -s -X POST "$API/gyms" -H "Authorization: Bearer $1" -H 'Content-Type: application/json' \
    -d "{\"name\":\"$2\",\"addressLine1\":\"1 Rank Street\",\"state\":\"$RANK_STATE\",
         \"district\":\"$RANK_DISTRICT\",\"city\":\"$RANK_CITY\",\"pincode\":\"682011\",
         \"contactPhone\":\"$3\"}" | field id
}

# Four digits from the clock mixed with this shell's pid, so two runs
# starting in the same second do not mint the same phone numbers and then
# fight over the same test accounts. That collision produced a confusing
# half-hour of "failures" that were two regressions running at once.
STAMP=$(printf '%04d' $(( ($$ + RANDOM + $(date +%s)) % 10000 )))
P1="+9194300${STAMP}1"
P2="+9194300${STAMP}2"
P3="+9194300${STAMP}3"

# A district of its own, so gyms from other runs cannot change the order.
RANK_STATE="Kerala"
RANK_DISTRICT="RankTest${STAMP}"
RANK_CITY="RankCity${STAMP}"

hdr "Setup"
O1=$(login "$P1" "Rank Owner One")
O2=$(login "$P2" "Rank Owner Two")
O3=$(login "$P3" "Rank Owner Three")
[ -n "$O1" ] && [ -n "$O2" ] && [ -n "$O3" ] && ok "three owners signed in" \
  || { bad "setup" "no tokens"; exit 1; }

G1=$(make_gym "$O1" "Alpha Fitness" "$P1")
G2=$(make_gym "$O2" "Beta Fitness" "$P2")
G3=$(make_gym "$O3" "Gamma Fitness" "$P3")
[ -n "$G1" ] && [ -n "$G2" ] && [ -n "$G3" ] && ok "three gyms created in one district" \
  || { bad "setup" "gyms $G1 $G2 $G3"; exit 1; }

# These suites run against the live database, and below these gyms become
# verified Pro gyms -- i.e. listed in the real app's gym browser. Take them
# back out of public search on the way out, however the suite ends.
unlist() {
  db "await p.gym.updateMany({ where: { id: { in: process.argv.slice(1).filter(Boolean) } },
        data: { publicListing: false } });" "$G1" "$G2" "$G3" > /dev/null 2>&1
}
trap unlist EXIT

for T in "$O1:$G1" "$O2:$G2" "$O3:$G3"; do
  curl -s -X POST "$API/gyms/${T#*:}/subscription/trial" \
    -H "Authorization: Bearer ${T%%:*}" > /dev/null
done
ok "all three on a trial"

hdr "A Basic gym is not ranked"
# The trial deliberately grants PRO so an owner can see the search listing
# they are being asked to pay for -- so a trial gym IS ranked. Drop one to
# Basic to exercise the other branch.
db "
  await p.gymSubscription.updateMany({ where: { gymId: process.argv[1] }, data: { plan: 'BASIC' } });
" "$G1" > /dev/null

BASIC=$(curl -s "$API/gyms/$G1/ranking" -H "Authorization: Bearer $O1")
LISTED=$(echo "$BASIC" | field listed)
[ "$LISTED" = "False" ] && ok "a gym without Pro is not ranked" || bad "basic listed" "$BASIC"

REASON=$(echo "$BASIC" | field reason)
case "$REASON" in
  *Pro*) ok "and is told it needs Pro, rather than shown a rank it lacks" ;;
  *) bad "reason" "$REASON" ;;
esac

hdr "Pro gyms get a position"
# Promote all three to PRO and give them distinct ratings, so the expected
# order is unambiguous: Beta 4.8, Gamma 4.5, Alpha 4.2.
db "
  const ids = process.argv.slice(1);
  const ratings = { [ids[0]]: '4.2', [ids[1]]: '4.8', [ids[2]]: '4.5' };
  for (const id of ids) {
    await p.gymSubscription.updateMany({ where: { gymId: id }, data: { plan: 'PRO' } });
    // Search also requires verified KYC.
    await p.gymKyc.upsert({ where: { gymId: id },
      create: { gymId: id, aadhaarStatus: 'VERIFIED', panStatus: 'VERIFIED', verifiedAt: new Date() },
      update: { aadhaarStatus: 'VERIFIED', panStatus: 'VERIFIED', verifiedAt: new Date() } });
    await p.gym.update({ where: { id },
      data: { ratingAverage: ratings[id], ratingCount: 10, publicListing: true } });
  }
" "$G1" "$G2" "$G3" > /dev/null
ok "promoted to Pro with distinct ratings"

R2=$(curl -s "$API/gyms/$G2/ranking" -H "Authorization: Bearer $O2")
[ "$(echo "$R2" | field listed)" = "True" ] && ok "the top-rated gym is ranked" || bad "pro listed" "$R2"

pos_in() {
  echo "$1" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next((s['position'] for s in d['scopes'] if s['scope']=='$2'), ''))" 2>/dev/null
}
out_of() {
  echo "$1" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next((s['outOf'] for s in d['scopes'] if s['scope']=='$2'), ''))" 2>/dev/null
}

[ "$(pos_in "$R2" district)" = "1" ] && ok "4.8 ranks first in the district" \
  || bad "beta district" "got $(pos_in "$R2" district)"

R3=$(curl -s "$API/gyms/$G3/ranking" -H "Authorization: Bearer $O3")
[ "$(pos_in "$R3" district)" = "2" ] && ok "4.5 ranks second" || bad "gamma" "got $(pos_in "$R3" district)"

R1=$(curl -s "$API/gyms/$G1/ranking" -H "Authorization: Bearer $O1")
[ "$(pos_in "$R1" district)" = "3" ] && ok "4.2 ranks third" || bad "alpha" "got $(pos_in "$R1" district)"

[ "$(out_of "$R1" district)" = "3" ] && ok "and all three are counted in the district" \
  || bad "outOf" "got $(out_of "$R1" district)"

hdr "Scopes"
SCOPES=$(echo "$R1" | python -c "
import sys,json;print(','.join(s['scope'] for s in json.load(sys.stdin)['scopes']))" 2>/dev/null)
[ "$SCOPES" = "city,district,state,india" ] && ok "city, district, state and all-India" \
  || bad "scopes" "$SCOPES"

# The state holds every district, so the field can only be larger.
STATE_TOTAL=$(out_of "$R1" state)
DIST_TOTAL=$(out_of "$R1" district)
[ "${STATE_TOTAL:-0}" -ge "${DIST_TOTAL:-0}" ] && ok "the state field is at least as large as the district" \
  || bad "scope nesting" "state $STATE_TOTAL < district $DIST_TOTAL"

INDIA_TOTAL=$(out_of "$R1" india)
[ "${INDIA_TOTAL:-0}" -ge "${STATE_TOTAL:-0}" ] && ok "and all-India at least as large as the state" \
  || bad "india nesting" "india $INDIA_TOTAL < state $STATE_TOTAL"

hdr "Ties break on how many ratings back them up"
db "
  await p.gym.update({ where: { id: process.argv[1] },
    data: { ratingAverage: '4.8', ratingCount: 99 } });
" "$G1" > /dev/null

R1B=$(curl -s "$API/gyms/$G1/ranking" -H "Authorization: Bearer $O1")
[ "$(pos_in "$R1B" district)" = "1" ] && ok "equal rating with more ratings takes first" \
  || bad "tiebreak" "got $(pos_in "$R1B" district)"

R2B=$(curl -s "$API/gyms/$G2/ranking" -H "Authorization: Bearer $O2")
[ "$(pos_in "$R2B" district)" = "2" ] && ok "and the thinner record drops to second" \
  || bad "tiebreak 2" "got $(pos_in "$R2B" district)"

hdr "The position matches what search actually returns"
# The whole feature is worthless if these two disagree, so compare them
# rather than trusting either on its own.
ORDER=$(curl -s "$API/gyms/search?district=$RANK_DISTRICT&limit=20" | python -c "
import sys,json
rows=json.load(sys.stdin)
print(','.join(r['id'] for r in rows))" 2>/dev/null)

for PAIR in "$G1:$O1" "$G2:$O2" "$G3:$O3"; do
  GID="${PAIR%%:*}"; TOK="${PAIR##*:}"
  ACTUAL=$(python -c "
ids='$ORDER'.split(',')
print(ids.index('$GID')+1 if '$GID' in ids else 'missing')" 2>/dev/null)
  # Each gym's own owner, because a rival is refused. An earlier version of
  # this loop used one token for all three, so the reported position came
  # back empty and was never actually compared against anything.
  CLAIMED=$(pos_in "$(curl -s "$API/gyms/$GID/ranking" -H "Authorization: Bearer $TOK")" district)
  [ -n "$CLAIMED" ] && [ "$CLAIMED" = "$ACTUAL" ] \
    && ok "search position $ACTUAL matches the reported position" \
    || bad "search vs reported" "search $ACTUAL, reported ${CLAIMED:-none}"
done

hdr "Who may see it"
MEMBER_PHONE="+9194300${STAMP}4"
MEMBER=$(login "$MEMBER_PHONE" "Curious Member")
OUTSIDER=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$G1/ranking" \
           -H "Authorization: Bearer $MEMBER")
[ "$OUTSIDER" = "403" ] && ok "someone outside the gym cannot see its position" \
  || bad "outsider" "got $OUTSIDER"

RIVAL=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$G1/ranking" \
        -H "Authorization: Bearer $O2")
[ "$RIVAL" = "403" ] && ok "nor can a competing gym's owner" || bad "rival" "got $RIVAL"

hdr "Delisting"
db "
  await p.gym.update({ where: { id: process.argv[1] }, data: { publicListing: false } });
" "$G1" > /dev/null

OFF=$(curl -s "$API/gyms/$G1/ranking" -H "Authorization: Bearer $O1")
[ "$(echo "$OFF" | field listed)" = "False" ] && ok "switching off public listing removes the rank" \
  || bad "delist" "$OFF"

OFF_REASON=$(echo "$OFF" | field reason)
case "$OFF_REASON" in
  *listing*) ok "and names public listing as the reason, not the plan" ;;
  *) bad "delist reason" "$OFF_REASON" ;;
esac

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
