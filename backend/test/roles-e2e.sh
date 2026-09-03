#!/usr/bin/env bash
#
# Role management: creating roles, editing what they can do, deleting them,
# and re-ranking the hierarchy.
#
#   bash test/roles-e2e.sh
#
# The interesting checks are the refusals. This is the code that decides who
# can hand out authority, so most of what follows is trying to escalate and
# being told no.

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
        -d "{\"registrationToken\":\"$rt\",\"name\":\"$name\",\"age\":31}")
  fi
  echo "$v" | nested tokens accessToken
}

role_id() {
  python -c "
import sys,json
print(next((r['id'] for r in json.load(sys.stdin) if r['name']=='$1'), ''))" 2>/dev/null
}

hire() {
  local phone="$1" name="$2" role="$3" lk
  lk=$(curl -s -X POST "$API/gyms/$GID/staff/lookup" -H "Authorization: Bearer $OWNER" \
       -H 'Content-Type: application/json' -d "{\"phone\":\"$phone\"}")
  curl -s -X POST "$API/gyms/$GID/staff" -H "Authorization: Bearer $OWNER" \
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
P_OWNER="+9196500${STAMP}1"
P_MANAGER="+9196500${STAMP}2"
P_SALES="+9196500${STAMP}3"

hdr "Setup"
OWNER=$(login "$P_OWNER" "Roles Owner")
[ -n "$OWNER" ] && ok "owner signed in" || { bad "setup" "no token"; exit 1; }

GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Hierarchy Gym\",\"addressLine1\":\"4 Rank Road\",\"state\":\"Kerala\",
           \"district\":\"Thrissur\",\"city\":\"Thrissur\",\"pincode\":\"680001\",
           \"contactPhone\":\"$P_OWNER\"}" | field id)
[ -n "$GID" ] && ok "gym created" || { bad "setup" "no gym"; exit 1; }
curl -s -X POST "$API/gyms/$GID/subscription/trial" -H "Authorization: Bearer $OWNER" > /dev/null

ROLES=$(curl -s "$API/gyms/$GID/roles" -H "Authorization: Bearer $OWNER")
COUNT=$(echo "$ROLES" | python -c "import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
[ "${COUNT:-0}" -ge 5 ] && ok "default roles seeded ($COUNT)" || bad "seed" "got $COUNT"

MANAGER_ROLE=$(echo "$ROLES" | role_id Manager)
SALES_ROLE=$(echo "$ROLES" | role_id "Sales Staff")
OWNER_ROLE=$(echo "$ROLES" | role_id Owner)
[ -n "$MANAGER_ROLE" ] && [ -n "$SALES_ROLE" ] && ok "found Manager and Sales Staff" \
  || bad "roles" "manager=$MANAGER_ROLE sales=$SALES_ROLE"

hdr "The catalogue"
CAT=$(curl -s "$API/gyms/$GID/roles/permissions" -H "Authorization: Bearer $OWNER")
# Not GROUPS: that is a bash special variable holding the caller's group
# ids, so assigning to it does not take and the check reads a system value.
GROUP_COUNT=$(echo "$CAT" | python -c "
import sys,json;print(len(json.load(sys.stdin)['groups']))" 2>/dev/null)
[ "${GROUP_COUNT:-0}" -ge 6 ] && ok "permissions come back grouped ($GROUP_COUNT groups)"   || bad "catalogue" "$GROUP_COUNT"

# Every grantable permission must appear, or it could never be given to
# anybody through the app.
LISTED=$(echo "$CAT" | python -c "
import sys,json
d=json.load(sys.stdin)
print(sum(len(g['permissions']) for g in d['groups']))" 2>/dev/null)
[ "${LISTED:-0}" -ge 33 ] && ok "every permission is listed ($LISTED)" || bad "coverage" "$LISTED"

# DELETE_GYM is checked against the gym's owner record, never against a role.
NEVER=$(echo "$CAT" | python -c "
import sys,json
d=json.load(sys.stdin)
print(next(p['neverGrantable'] for g in d['groups'] for p in g['permissions']
           if p['permission']=='DELETE_GYM'))" 2>/dev/null)
[ "$NEVER" = "True" ] && ok "deleting the gym is marked ungrantable to anyone" || bad "DELETE_GYM" "$NEVER"

hdr "Creating a role"
NEW=$(curl -s -X POST "$API/gyms/$GID/roles" -H "Authorization: Bearer $OWNER" \
      -H 'Content-Type: application/json' -d '{
        "name":"Front Desk","level":60,
        "permissions":["MARK_ATTENDANCE_MEMBER","ADD_MEMBER"]}')
FD=$(echo "$NEW" | field id)
[ -n "$FD" ] && ok "owner created a role" || bad "create" "$NEW"

PERMS=$(echo "$NEW" | python -c "
import sys,json;print(len(json.load(sys.stdin)['permissions']))" 2>/dev/null)
[ "$PERMS" = "2" ] && ok "with exactly the permissions asked for" || bad "perms" "got $PERMS"

DUP=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
      -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
      -d '{"name":"front desk","level":61}')
[ "$DUP" = "409" ] && ok "a differently-cased duplicate name is refused" || bad "duplicate" "got $DUP"

SELF=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
       -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
       -d '{"name":"Co-Owner","level":0}')
[ "$SELF" = "400" ] && ok "rank 0 is out of range and refused at the edge" || bad "rank 0" "got $SELF"

# Owner is level 0 and Manager is 10, and Manager is a super role holding
# every permission. A custom role slotted between them would outrank a role
# that can do everything, which is not a hierarchy anyone can reason about.
ABOVE_MGR=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles"             -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json'             -d '{"name":"Super Manager","level":5}')
[ "$ABOVE_MGR" = "403" ] && ok "nor one slotted above the Manager role"   || bad "above manager" "got $ABOVE_MGR"

UNGRANTABLE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
              -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
              -d '{"name":"Destroyer","level":70,"permissions":["DELETE_GYM"]}')
[ "$UNGRANTABLE" = "403" ] && ok "even the owner cannot grant DELETE_GYM to a role" \
  || bad "DELETE_GYM grant" "got $UNGRANTABLE"

hdr "No escalation"
hire "$P_MANAGER" "The Manager" "$MANAGER_ROLE"
hire "$P_SALES" "Sales Person" "$SALES_ROLE"
MANAGER=$(login "$P_MANAGER" "The Manager")
SALES=$(login "$P_SALES" "Sales Person")
[ -n "$MANAGER" ] && [ -n "$SALES" ] && ok "manager and sales staff signed in" || bad "hire" "no tokens"

# Sales Staff holds three permissions and none of the role ones.
SALES_CREATE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
               -H "Authorization: Bearer $SALES" -H 'Content-Type: application/json' \
               -d '{"name":"Sales Deputy","level":80}')
[ "$SALES_CREATE" = "403" ] && ok "sales staff cannot create a role" || bad "sales create" "got $SALES_CREATE"

SALES_CAT=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/roles/permissions" \
            -H "Authorization: Bearer $SALES")
[ "$SALES_CAT" = "403" ] && ok "nor read the permission catalogue" || bad "sales catalogue" "got $SALES_CAT"

# A manager holds everything, so give the new role to someone who does not.
# Front Desk gets ADD_ROLES but not MANAGE_STAFF, then tries to hand out
# MANAGE_STAFF -- the escalation the whole model exists to stop.
curl -s -X PATCH "$API/gyms/$GID/roles/$FD" -H "Authorization: Bearer $OWNER" \
  -H 'Content-Type: application/json' \
  -d '{"permissions":["MARK_ATTENDANCE_MEMBER","ADD_MEMBER","ADD_ROLES","EDIT_PERMISSIONS"]}' > /dev/null

P_DESK="+9196500${STAMP}4"
hire "$P_DESK" "Desk Person" "$FD"
DESK=$(login "$P_DESK" "Desk Person")
[ -n "$DESK" ] && ok "front desk person signed in" || bad "desk" "no token"

ESCALATE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
           -H "Authorization: Bearer $DESK" -H 'Content-Type: application/json' \
           -d '{"name":"Shadow Admin","level":75,"permissions":["MANAGE_STAFF"]}')
[ "$ESCALATE" = "403" ] && ok "cannot grant a permission you do not hold yourself" \
  || bad "escalation" "got $ESCALATE"

ALLOWED=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
          -H "Authorization: Bearer $DESK" -H 'Content-Type: application/json' \
          -d '{"name":"Desk Junior","level":80,"permissions":["ADD_MEMBER"]}')
[ "$ALLOWED" = "201" ] && ok "but can grant one you do hold" || bad "allowed grant" "got $ALLOWED"

UPRANK=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
         -H "Authorization: Bearer $DESK" -H 'Content-Type: application/json' \
         -d '{"name":"Desk Senior","level":10,"permissions":["ADD_MEMBER"]}')
[ "$UPRANK" = "403" ] && ok "and cannot mint a role more senior than itself" || bad "uprank" "got $UPRANK"

# Reception sits at 60. A role at 60 would be its equal, and equals do not
# outrank each other -- so its holder could staff the new role and sidestep
# the hierarchy that constrains them.
PEER=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/gyms/$GID/roles" \
       -H "Authorization: Bearer $DESK" -H 'Content-Type: application/json' \
       -d '{"name":"Desk Equal","level":60,"permissions":["ADD_MEMBER"]}')
[ "$PEER" = "403" ] && ok "nor one at its own rank" || bad "peer role" "got $PEER"

hdr "Editing a role"
STRIP=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/gyms/$GID/roles/$MANAGER_ROLE" \
        -H "Authorization: Bearer $DESK" -H 'Content-Type: application/json' \
        -d '{"permissions":["ADD_MEMBER"]}')
[ "$STRIP" = "403" ] && ok "a junior cannot rewrite a senior role" || bad "strip senior" "got $STRIP"

OWNER_EDIT=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/gyms/$GID/roles/$OWNER_ROLE" \
             -H "Authorization: Bearer $MANAGER" -H 'Content-Type: application/json' \
             -d '{"name":"Boss"}')
[ "$OWNER_EDIT" = "403" ] && ok "a manager cannot rename the Owner role" || bad "owner edit" "got $OWNER_EDIT"

RENAMED=$(curl -s -X PATCH "$API/gyms/$GID/roles/$FD" -H "Authorization: Bearer $OWNER" \
          -H 'Content-Type: application/json' -d '{"name":"Reception"}' | field name)
[ "$RENAMED" = "Reception" ] && ok "the owner can rename a custom role" || bad "rename" "$RENAMED"

# Narrowing a role is as much an exercise of authority as widening it.
SUPER_NARROW=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/gyms/$GID/roles/$MANAGER_ROLE" \
               -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
               -d '{"permissions":["ADD_MEMBER"]}')
[ "$SUPER_NARROW" = "403" ] && ok "even the owner cannot narrow the Manager role" \
  || bad "narrow super" "got $SUPER_NARROW"

hdr "Deleting a role"
SYSTEM_DEL=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/gyms/$GID/roles/$SALES_ROLE" \
             -H "Authorization: Bearer $OWNER")
[ "$SYSTEM_DEL" = "403" ] && ok "a default role cannot be deleted" || bad "system delete" "got $SYSTEM_DEL"

OCCUPIED=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/gyms/$GID/roles/$FD" \
           -H "Authorization: Bearer $OWNER")
[ "$OCCUPIED" = "409" ] && ok "nor one that people are still in" || bad "occupied delete" "got $OCCUPIED"

FLAGGED=$(curl -s "$API/gyms/$GID/roles" -H "Authorization: Bearer $OWNER" | python -c "
import sys,json
print(next(str(r['deletable']) for r in json.load(sys.stdin) if r['id']=='$FD'))" 2>/dev/null)
[ "$FLAGGED" = "False" ] && ok "and the list says so before you try" || bad "deletable flag" "$FLAGGED"

JUNIOR=$(curl -s "$API/gyms/$GID/roles" -H "Authorization: Bearer $OWNER" | role_id "Desk Junior")
EMPTY_DEL=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/gyms/$GID/roles/$JUNIOR" \
            -H "Authorization: Bearer $OWNER")
[ "$EMPTY_DEL" = "200" ] && ok "an empty custom role deletes" || bad "delete" "got $EMPTY_DEL"

hdr "Hierarchy"
EXTRA=$(curl -s -X POST "$API/gyms/$GID/roles" -H "Authorization: Bearer $OWNER" \
        -H 'Content-Type: application/json' \
        -d '{"name":"Cleaner","level":90}' | field id)
[ -n "$EXTRA" ] && ok "a second custom role to reorder against" || bad "extra" "no id"

REORDER=$(curl -s -X PUT "$API/gyms/$GID/roles/hierarchy" -H "Authorization: Bearer $OWNER" \
          -H 'Content-Type: application/json' -d "{\"roleIds\":[\"$EXTRA\",\"$FD\"]}")
ORDER=$(echo "$REORDER" | python -c "
import sys,json
rs={r['id']:r['level'] for r in json.load(sys.stdin)['roles']}
print('yes' if rs['$EXTRA'] < rs['$FD'] else 'no')" 2>/dev/null)
[ "$ORDER" = "yes" ] && ok "reordering puts Cleaner above Reception" || bad "reorder" "$ORDER"

SYS_REORDER=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$API/gyms/$GID/roles/hierarchy" \
              -H "Authorization: Bearer $OWNER" -H 'Content-Type: application/json' \
              -d "{\"roleIds\":[\"$MANAGER_ROLE\",\"$FD\"]}")
[ "$SYS_REORDER" = "403" ] && ok "default roles keep their place" || bad "system reorder" "got $SYS_REORDER"

DESK_REORDER=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$API/gyms/$GID/roles/hierarchy" \
               -H "Authorization: Bearer $DESK" -H 'Content-Type: application/json' \
               -d "{\"roleIds\":[\"$EXTRA\"]}")
[ "$DESK_REORDER" = "403" ] && ok "and reordering needs its own permission" || bad "desk reorder" "got $DESK_REORDER"

hdr "Isolation"
P_OTHER="+9196500${STAMP}5"
OTHER=$(login "$P_OTHER" "Other Owner")
OTHER_GID=$(curl -s -X POST "$API/gyms" -H "Authorization: Bearer $OTHER" -H 'Content-Type: application/json' \
      -d "{\"name\":\"Other Gym\",\"addressLine1\":\"1 Elsewhere\",\"state\":\"Kerala\",
           \"district\":\"Kannur\",\"city\":\"Kannur\",\"pincode\":\"670001\",
           \"contactPhone\":\"$P_OTHER\"}" | field id)

CROSS=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/gyms/$OTHER_GID/roles/$FD" \
        -H "Authorization: Bearer $OTHER" -H 'Content-Type: application/json' \
        -d '{"name":"Stolen"}')
[ "$CROSS" = "404" ] && ok "a role id from another gym is not found" || bad "cross-gym" "got $CROSS"

OUTSIDER=$(curl -s -o /dev/null -w "%{http_code}" "$API/gyms/$GID/roles" \
           -H "Authorization: Bearer $OTHER")
[ "$OUTSIDER" = "403" ] && ok "an outsider cannot read this gym's roles" || bad "outsider" "got $OUTSIDER"

printf "\n"
if [ -z "$FAILED" ]; then
  printf "\033[32mALL CHECKS PASSED\033[0m\n"; exit 0
else
  printf "\033[31mSOME CHECKS FAILED\033[0m\n"; exit 1
fi
