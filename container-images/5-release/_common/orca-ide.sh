#!/bin/bash
# orca-ide -- E4S front end for the Orca IDE.
# Installed as /usr/local/bin/orca-ide so it precedes the package's /usr/bin/orca-ide, which is the
# stock Orca CLI shim and is left untouched (this script runs it).
#
#   orca-ide                 start the GUI with the E4S settings below, in the foreground
#   orca-ide open [args...]  same, but detached (output goes to the log); args go to the GUI, as the
#                            desktop entry's %U does. `open -h|--help` still shows the CLI's help.
#   orca-ide <anything else> the stock Orca CLI, e.g. `orca-ide status`
# The CLI is pointed at the same profile as the GUI, and CLI commands that start the app use `open`.
#
# Persistent state (first match wins):
#   1. $ORCA_CONTAINER_HOME     explicit override, e.g. a bind-mounted host directory
#   2. $E4S_PERSIST_DIR/orca    shared E4S persistent-data root
#   3. $HOME/.e4s/${E4S_IID}-${E4S_VERSION}/orca    Default image-specific E4S persistent state.
# If it cannot be created and written this fails with an error; there is no silent fallback to a
# non-persistent location.
#
# The Orca profile is <state>/profile. The GUI and the CLI are both given that same path, via
# ORCA_USER_DATA_PATH (CLI and GUI) and --user-data-dir (GUI), so `orca-ide status` etc. look where the
# running GUI is. XDG_*_HOME is NOT redirected, so terminals and agents started from Orca keep the
# user's normal ~/.config, ~/.local and ~/.cache. An inherited ORCA_USER_DATA_PATH is ignored:
# Singularity/Apptainer pass the host environment through and we must not touch the host's own Orca
# profile. Use ORCA_CONTAINER_HOME to choose the location.
#
# Network filesystems (NFS/Lustre/GPFS) and very long paths are a poor place for an Electron profile
# (file locks, unix sockets), so a warning is printed for a profile that is not a short path on a local
# filesystem. XDG_RUNTIME_DIR is kept only if it is a short path on a local filesystem, else a private
# per-user directory under /tmp is used for it.
#
# GUI defaults suit the software-rendered VNC/Guacamole desktop. Arguments given after `open` come
# later on the command line and win over these defaults, e.g. `orca-ide open --password-store=gnome-libsecret`.
#   --password-store=basic   Chromium's own keyring-less store. It avoids the "choose a password for the
#                            new keyring" prompt, but secrets Orca saves (tokens, API keys) are then kept
#                            unencrypted -- only obfuscated -- under the state directory. That directory
#                            is mode 0700, so keep it on private storage. Where a secret service
#                            (gnome-keyring/kwallet) runs, pass --password-store=gnome-libsecret.
#   --no-sandbox             added only when running as root; otherwise pass it yourself where the
#                            setuid chrome-sandbox cannot work (e.g. Apptainer without user namespaces).
# GUI output goes to <state>/orca.log unless it is a foreground launch from a terminal. Warnings are
# printed on the terminal first and repeated in the log.
set -eu

APP=/opt/Orca
GUI=$APP/orca-ide
CLI=$APP/resources/bin/orca-ide     # what the package's /usr/bin/orca-ide points at
SELF=$(readlink -f "$0")

# Local filesystem types, as hermes-wrapper.sh uses.
is_local() { case "$(stat -f -c %T "$1" 2>/dev/null)" in ext*|xfs|btrfs|tmpfs|overlay*|zfs) ;; *) return 1 ;; esac; }

mode=cli detach=
case "${1-}" in
  "") mode=gui ;;
  open) case "${2-}" in -h|--help) ;; *) mode=gui detach=1; shift ;; esac ;;
esac

if [ -n "${ORCA_CONTAINER_HOME:-}" ]; then
  state=$ORCA_CONTAINER_HOME
elif [ -n "${E4S_PERSIST_DIR:-}" ]; then
  state=$E4S_PERSIST_DIR/orca
else
  : "${HOME:?orca-ide: HOME is not set}"
  : "${E4S_IID:?orca-ide: E4S_IID is not set}"
  : "${E4S_VERSION:?orca-ide: E4S_VERSION is not set}"
  state=$HOME/.e4s/${E4S_IID}-${E4S_VERSION}/orca
fi
if ! { ( umask 077; mkdir -p "$state/profile" ) 2>/dev/null && [ -w "$state/profile" ]; }; then
  echo "orca-ide: ERROR: cannot create or write the persistent state directory $state" >&2
  echo "orca-ide: Set ORCA_CONTAINER_HOME (or E4S_PERSIST_DIR) to a writable directory, e.g. a bind mount." >&2
  exit 1
fi
chmod 700 "$state" 2>/dev/null || true

export ORCA_USER_DATA_PATH=$state/profile

if [ "$mode" = cli ]; then
  export ORCA_OPEN_COMMAND="$SELF open"
  exec "$CLI" "$@"
fi

[ -x "$GUI" ] || { echo "orca-ide: Orca is not installed at $GUI" >&2; exit 1; }
[ -n "${DISPLAY:-}" ] || { echo "orca-ide: DISPLAY is not set; the Orca GUI needs an X11 display." >&2; exit 1; }

warnings=()

runtime=${XDG_RUNTIME_DIR:-}
if [ -z "$runtime" ] || [ ! -d "$runtime" ] || [ ! -w "$runtime" ] || [ "${#runtime}" -gt 60 ] || ! is_local "$runtime"; then
  runtime=${TMPDIR:-/tmp}/orca-runtime-$(id -u)
  if ! { ( umask 077; mkdir -p "$runtime" ) 2>/dev/null && [ -O "$runtime" ] && [ -w "$runtime" ]; }; then
    echo "orca-ide: ERROR: cannot create a runtime directory at $runtime" >&2
    exit 1
  fi
fi

export XDG_RUNTIME_DIR=$runtime
export LIBGL_ALWAYS_SOFTWARE=1 ELECTRON_OZONE_PLATFORM_HINT=x11
unset ELECTRON_RUN_AS_NODE     # set by the CLI shim, which would make the GUI binary run as plain Node

opts=()
case " $* " in
  *" --password-store="*) ;;
  *) opts+=(--password-store=basic)
     warnings+=("using --password-store=basic: secrets Orca saves are not encrypted (see $SELF).") ;;
esac
opts+=(--disable-gpu-sandbox --disable-gpu --use-gl=swiftshader --ozone-platform=x11 --disable-dev-shm-usage
       --user-data-dir="$ORCA_USER_DATA_PATH")
[ "$(id -u)" -eq 0 ] && opts+=(--no-sandbox)

for w in "${warnings[@]}"; do echo "orca-ide: WARNING: $w" >&2; done

if [ -n "$detach" ] || [ ! -t 2 ]; then
  log=$state/orca.log
  [ "$(stat -c %s "$log" 2>/dev/null || echo 0)" -gt 5242880 ] && mv -f "$log" "$log.old"
  exec >>"$log" 2>&1
  for w in "${warnings[@]}"; do echo "orca-ide: WARNING: $w"; done
fi

if [ -n "$detach" ]; then
  setsid -f "$GUI" "${opts[@]}" "$@" </dev/null
else
  exec "$GUI" "${opts[@]}" "$@"
fi
