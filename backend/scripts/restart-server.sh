#!/usr/bin/env bash
#
# Restart the compiled server, and REFUSE to continue unless the old one is
# actually gone.
#
#   bash scripts/restart-server.sh
#
# This exists because the obvious inline version is silently unreliable on
# Windows, and it cost three test runs in one day. The pattern was:
#
#   Stop-Process -Force ; sleep 2 ; Start-Process node dist/main.js
#
# Stop-Process does not always take effect before the next command, and
# when it does not, the NEW server dies instantly with EADDRINUSE while the
# OLD one keeps serving. Nothing about that is visible from the outside:
# the health check answers 200, the suites run, and they run against
# whatever build the old process was started with. A run measuring stale
# code is worse than a failed run, because it produces a number.
#
# So this polls until the port is genuinely free and exits non-zero if it
# is not. Never start a server without knowing the port was released.
set -u

cd "$(dirname "$0")/.." || exit 1

PORT="${PORT:-3000}"
API="${API:-http://localhost:$PORT/api/v1}"

port_pid() {
  netstat -ano 2>/dev/null | awk -v p=":$PORT" '$0 ~ p && /LISTENING/ { print $NF; exit }'
}

OLD=$(port_pid)
if [ -n "$OLD" ]; then
  printf 'stopping pid %s on port %s\n' "$OLD" "$PORT"
  # taskkill is more reliable here than Stop-Process, and /T takes the
  # children with it.
  taskkill //PID "$OLD" //F //T >/dev/null 2>&1 \
    || powershell -NoProfile -Command "Stop-Process -Id $OLD -Force -ErrorAction SilentlyContinue" >/dev/null 2>&1
fi

# Poll rather than sleep a fixed amount: the whole failure this guards
# against is assuming a kill completed.
for _ in $(seq 1 30); do
  [ -z "$(port_pid)" ] && break
  sleep 1
done

STILL=$(port_pid)
if [ -n "$STILL" ]; then
  printf 'REFUSING TO START: port %s is still held by pid %s.\n' "$PORT" "$STILL"
  printf 'Kill it by hand and re-run. Starting now would leave that process\n'
  printf 'serving while the new one dies with EADDRINUSE, and every suite\n'
  printf 'after it would silently measure whichever build it is running.\n'
  exit 1
fi

# The logs are recreated only once the old process has let go of them --
# on Windows an open handle makes rm fail silently, which is how a "fresh"
# log ended up carrying a previous run's errors.
rm -f server.log server.err.log
: > server.log
: > server.err.log

powershell -NoProfile -Command \
  "Start-Process node -ArgumentList 'dist/main.js' -WorkingDirectory (Get-Location) -RedirectStandardOutput server.log -RedirectStandardError server.err.log -WindowStyle Hidden"

for _ in $(seq 1 60); do
  curl -s -o /dev/null "$API/health" 2>/dev/null && break
  sleep 1
done

if ! curl -s -o /dev/null "$API/health" 2>/dev/null; then
  printf 'server did not become healthy; see server.err.log\n'
  tail -20 server.err.log
  exit 1
fi

NEW=$(port_pid)
printf 'server up on pid %s\n' "$NEW"

if [ -n "$OLD" ] && [ "$NEW" = "$OLD" ]; then
  printf 'REFUSING: the listener is still the OLD pid. The restart did nothing.\n'
  exit 1
fi

if grep -q "EADDRINUSE" server.err.log 2>/dev/null; then
  printf 'REFUSING: EADDRINUSE in server.err.log -- something else took the port.\n'
  exit 1
fi

# A run that measures a build older than the source is the thing this whole
# script exists to prevent, so say so here too.
if [ -n "$(find src -name '*.ts' -newer dist/main.js 2>/dev/null | head -1)" ]; then
  printf 'WARNING: source files are newer than dist/main.js -- run npm run build.\n'
fi
