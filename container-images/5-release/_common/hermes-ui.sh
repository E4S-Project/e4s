#!/bin/bash
# Start the Hermes dashboard on loopback and show it in Firefox (for the VNC/Guacamole desktop).
#
# SECURITY: the dashboard hands its session token to any client that can GET "/", and the UI can
# run tools as the dashboard's user. So (a) each user gets their own randomly chosen free port,
# recorded in their private HERMES_HOME, and (b) we only reuse a running dashboard if the pid we
# started is still alive AND owned by us -- never because "something answers" on a fixed port.
# On a multi-user host sharing the network namespace (e.g. Singularity), other local users can
# still reach the port; use a single-user container or a private network namespace there.
#   HERMES_DASHBOARD_PORT   force a specific port instead of a random one
set -eu

eval "$(E4S_HERMES_PRINT_HOME=1 /etc/e4s/hermes-wrapper.sh)"
STATE="$HERMES_HOME/dashboard"        # holds "<pid> <port>"; HERMES_HOME is mode 0700
LOG="$HERMES_HOME/logs/dashboard.log"
mkdir -p "$HERMES_HOME/logs"

# First run: Hermes can't do anything until a provider/model is set up, and its own check for that
# (_has_any_provider_configured) is what the CLI uses. If it says "not configured", run the
# interactive `hermes model` picker in a terminal first, then continue to the dashboard.
# Set HERMES_SKIP_SETUP=1 to skip. If the check itself fails to run we skip rather than block.
configured=$(E4S_HERMES_WRAPPED=1 /opt/hermes/.venv/bin/python -c \
  'from hermes_cli.main import _has_any_provider_configured as f; print("yes" if f() else "no")' 2>/dev/null || echo unknown)
if [ -z "${HERMES_SKIP_SETUP:-}" ] && [ "$configured" = no ]; then
  setup_cmd='echo "Welcome to Hermes. Choose an AI provider and model to get started."; echo; hermes model'
  if command -v xfce4-terminal >/dev/null 2>&1; then
    xfce4-terminal --disable-server --title "Hermes setup: choose a model" -x bash -c "$setup_cmd; echo; read -rp 'Press Enter to close...' _"
  elif command -v xterm >/dev/null 2>&1; then
    xterm -T "Hermes setup: choose a model" -e bash -c "$setup_cmd; echo; read -rp 'Press Enter to close...' _"
  fi
fi

pid="" port=""
if [ -f "$STATE" ]; then read -r pid port < "$STATE" || true; fi
if [ -n "$pid" ] && [ -O "/proc/$pid" ] && curl -fsS -o /dev/null "http://127.0.0.1:$port/" 2>/dev/null; then
  :
else
  port="${HERMES_DASHBOARD_PORT:-$(python3 -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1])' 2>/dev/null || echo $((20000 + RANDOM % 20000)))}"
  nohup hermes dashboard --host 127.0.0.1 --port "$port" --no-open --skip-build >>"$LOG" 2>&1 &
  echo "$! $port" > "$STATE"
  for _ in $(seq 120); do curl -fsS -o /dev/null "http://127.0.0.1:$port/" 2>/dev/null && break; sleep 0.5; done
fi
exec firefox --new-window "http://127.0.0.1:$port/"
