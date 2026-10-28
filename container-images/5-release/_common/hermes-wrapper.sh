#!/bin/bash
# `hermes` launcher for E4S images (installed as /usr/local/bin/hermes -> /etc/e4s/hermes-wrapper.sh).
#
# Picks a per-user HERMES_HOME, seeds it once per image version, then runs the real hermes.
# /opt/hermes is read-only/shared; every mutable file lives under HERMES_HOME.
#
# HERMES_HOME selection (first match wins):
#   1. HERMES_CONTAINER_HOME            explicit override (e.g. a bind-mounted host directory)
#   2. E4S_PERSIST_DIR/hermes           shared E4S persistent-data root, if set
#   3. ${XDG_DATA_HOME:-$HOME/.local/share}/e4s-hermes
# A HERMES_HOME inherited from the host shell is deliberately ignored: Singularity/Apptainer
# passes the host environment through and we must not touch the user's host-side Hermes data.
# Under Singularity/Apptainer, $HOME is normally bind-mounted from the host, so (3) persists
# in a dedicated e4s-hermes directory that never collides with a host ~/.hermes. With
# --contain/--no-home or a read-only $HOME, bind-mount a host directory and point
# HERMES_CONTAINER_HOME at it; otherwise this falls back to a throwaway directory in
# ${TMPDIR:-/tmp} and warns that nothing will persist.
# E4S_HERMES_WRAPPED stops hermes re-invoking itself (profiles) from re-resolving the home.

if [ -z "${E4S_HERMES_WRAPPED:-}" ]; then
  if [ -n "${HERMES_CONTAINER_HOME:-}" ]; then
    home="$HERMES_CONTAINER_HOME"
  elif [ -n "${E4S_PERSIST_DIR:-}" ]; then
    home="$E4S_PERSIST_DIR/hermes"
  else
    home="${XDG_DATA_HOME:-$HOME/.local/share}/e4s-hermes"
  fi
  if ! { ( umask 077; mkdir -p "$home" ) 2>/dev/null && [ -w "$home" ]; }; then
    fallback="${TMPDIR:-/tmp}/e4s-hermes-$(id -un)"
    echo "[hermes] WARNING: $home is not writable; using $fallback (data will NOT persist)." >&2
    echo "[hermes] Bind-mount a host directory and set HERMES_CONTAINER_HOME to keep your work." >&2
    ( umask 077; mkdir -p "$fallback" ) || { echo "[hermes] cannot create $fallback" >&2; exit 1; }
    home="$fallback"
  elif [ -n "${APPTAINER_CONTAINER:-}${SINGULARITY_CONTAINER:-}" ] \
       && [ -z "${HERMES_CONTAINER_HOME:-}${E4S_PERSIST_DIR:-}" ] \
       && case "$(stat -f -c %T "$home" 2>/dev/null)" in tmpfs|overlay*) true ;; *) false ;; esac; then
    echo "[hermes] WARNING: $home is on a container-local filesystem; data will be lost on exit." >&2
    echo "[hermes] Bind-mount a host directory and set HERMES_CONTAINER_HOME to keep your work." >&2
  fi
  export E4S_HERMES_WRAPPED=1
  export HERMES_HOME="$home"
fi

if [ -n "${E4S_HERMES_PRINT_HOME:-}" ]; then   # used by hermes-ui.sh
  printf 'export HERMES_HOME=%q E4S_HERMES_WRAPPED=1\n' "$HERMES_HOME"
  exit 0
fi

export PYTHONDONTWRITEBYTECODE=1   # /opt/hermes is read-only for users; bytecode is precompiled
export HERMES_RUNTIME_DIR=/opt/hermes/tools
export PLAYWRIGHT_BROWSERS_PATH=/opt/hermes/tools
export HERMES_WEB_DIST=/opt/hermes/hermes_cli/web_dist
export HERMES_TUI_DIR=/opt/hermes/ui-tui
export HERMES_PYTHON=/opt/hermes/.venv/bin/python
if [ -z "${AGENT_BROWSER_EXECUTABLE_PATH:-}" ] && [ -r /etc/hermes/agent-browser-executable-path ]; then
  AGENT_BROWSER_EXECUTABLE_PATH="$(cat /etc/hermes/agent-browser-executable-path)"
  export AGENT_BROWSER_EXECUTABLE_PATH
fi

if ! grep -qx "$(cat /etc/hermes/e4s-ref)" "$HERMES_HOME/.e4s-init-done" 2>/dev/null; then
  /etc/e4s/hermes-init.sh >&2 || echo "[hermes] init reported errors (continuing)" >&2
fi
exec /opt/hermes/.venv/bin/hermes "$@"
