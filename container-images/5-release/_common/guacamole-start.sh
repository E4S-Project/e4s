#!/bin/bash
# Guacamole + Tomcat + VNC launcher (user-level, localhost-only).
#
# Gives a remote user a desktop in their local browser over an SSH tunnel.
# Works on plain hosts and inside containers (Docker, Singularity/Apptainer),
# with the software supplied by the OS, spack, or anything else on PATH.
#
# VNC handling on a shared host (decided on every run from who owns the port):
#   - port free     -> launch our own session
#   - port is mine  -> use it, leave it running on exit
#   - port foreign  -> refuse (it's someone else's desktop) unless VNC_ALLOW_FOREIGN=1
#
# VNC launch modes:
#   host     `vncserver :N -localhost`, using your normal VNC config.
#   isolated (auto in Singularity/Apptainer/Docker, or VNC_ISOLATE=1)
#            runs Xvnc directly with a private config dir ($VNC_CONFIG_DIR): its own
#            password file, X cookie and a generated Xfce xstartup. Your ~/.vnc and
#            ~/.config are never read or written.
#
# VNC password policy:
#   - host mode: the VNC password file is only READ (to verify the password stored in
#     Guacamole's config). It is written only if you opt in with VNC_WRITE_PASSWD=1
#     (create if missing; overwrite-with-backup only after an interactive prompt).
#   - isolated mode: the private password file is script-owned, so it is created
#     automatically (a random password is generated if you leave the prompt empty).
#
# State location (everything this script creates lives under GUAC_STATE_DIR):
#   - default is $HOME (-> ~/.guacamole, ~/tomcat-runtime)
#   - under Singularity/Apptainer the default moves OFF $HOME (which is bind-mounted
#     from the host) to ${TMPDIR:-/tmp}/guacamole-<user>. Use `--contain`/`--no-home`
#     or `--writable-tmpfs` to keep that inside the container, or point
#     GUAC_STATE_DIR at a bind-mounted directory to persist the setup between runs.
#
# Optional environment variables:
#   GUAC_STATE_DIR         root for all generated state (see above)
#   SHOW_PUBLIC_IP=1       look up the public IP via ifconfig.me for the SSH hint (off by default)
#   SSH_HOST=<name/ip>     host to show in the SSH tunnel hint (default: detected LAN IP)
#   SSH_USER=<login>       user to show in the SSH tunnel hint (default: omitted when running as
#                          root or in Docker/Podman, so ssh uses your own default login)
#   SSH_OPTS=<options>     extra ssh options to show in the hint, e.g. "-J bastion.example.org"
#   EXPECTED_GUAC_VERSION  expected guacd version (default 1.6.0)
#   VNC_ALLOW_FOREIGN=1    allow connecting to a VNC port owned by another user
#   VNC_WRITE_PASSWD=1     host mode: allow writing the VNC password file (see above)
#   TOMCAT_SYS_HOME        Tomcat install dir (auto: $CATALINA_HOME, spack, /usr/share/tomcat*, /opt/tomcat*)
#   TOMCAT_CONF_SRC        Tomcat config dir  (auto: /etc/<name> counterpart, else $TOMCAT_SYS_HOME/conf)
#   WAR_PATH               Guacamole WAR (auto: /usr/share/guacamole, spack guacamole-client)
#   (also auto-detected: java via PATH/JAVA_HOME/spack, guacd via PATH/spack guacamole-server)
#   VNC_ISOLATE            auto (default) | 0 | 1
#   VNC_CONFIG_DIR         private VNC dir for isolated mode (default $GUAC_HOME/vnc)
#   VNC_SESSION_CMD        desktop command for isolated mode (default startxfce4)
#   VNC_GEOMETRY           isolated-mode screen size (default 1920x1080)
#   VNC_XVNC_ARGS          extra Xvnc arguments for isolated mode
set -eu
umask 077

case "${1:-}" in
    -h|--help) sed -n '2,/^set -eu/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit 0 ;;
esac

# ==============================================================================
# Environment detection
# ==============================================================================
IN_APPTAINER=0
if [ -n "${APPTAINER_CONTAINER:-}${SINGULARITY_CONTAINER:-}" ]; then IN_APPTAINER=1; fi
IN_CONTAINER=$IN_APPTAINER
if [ -e /.dockerenv ] || [ -e /run/.containerenv ]; then IN_CONTAINER=1; fi

if [ -z "${VNC_ISOLATE:-}" ]; then
    VNC_ISOLATE=$IN_CONTAINER
fi

# ==============================================================================
# Configuration
# ==============================================================================
spack_prefix() {
    command -v spack >/dev/null 2>&1 || return 1
    spack location -i "$1" 2>/dev/null | tail -n1
}

has_tomcat() { [ -f "$1/bin/bootstrap.jar" ] && [ -f "$1/bin/tomcat-juli.jar" ]; }

if [ -z "${TOMCAT_SYS_HOME:-}" ]; then
    for d in "${CATALINA_HOME:-}" "$(spack_prefix tomcat || true)" \
             /usr/share/tomcat /usr/share/tomcat9 /opt/tomcat9 /opt/tomcat; do
        if [ -n "$d" ] && has_tomcat "$d"; then TOMCAT_SYS_HOME="$d"; break; fi
    done
    TOMCAT_SYS_HOME="${TOMCAT_SYS_HOME:-/usr/share/tomcat}"
fi

if [ -z "${TOMCAT_CONF_SRC:-}" ]; then
    if [ -f "/etc/$(basename "$TOMCAT_SYS_HOME")/server.xml" ]; then
        TOMCAT_CONF_SRC="/etc/$(basename "$TOMCAT_SYS_HOME")"
    elif [ -f "$TOMCAT_SYS_HOME/conf/server.xml" ]; then
        TOMCAT_CONF_SRC="$TOMCAT_SYS_HOME/conf"
    else
        TOMCAT_CONF_SRC=/etc/tomcat
    fi
fi

if [ -z "${WAR_PATH:-}" ]; then
    gp=$(spack_prefix guacamole-client || true)
    war_candidates=(/usr/share/guacamole/guacamole.war)
    if [ -n "$gp" ]; then
        # spack builds it at guacamole/target/; doc/*/target holds example WARs we must not pick
        war_candidates+=("$gp"/guacamole/target/guacamole-*.war "$gp"/guacamole*.war "$gp"/webapps/guacamole*.war)
    fi
    for f in "${war_candidates[@]}"; do
        if [ -f "$f" ]; then WAR_PATH="$f"; break; fi
    done
    unset war_candidates
    WAR_PATH="${WAR_PATH:-/usr/share/guacamole/guacamole.war}"
fi

if [ -z "${GUAC_STATE_DIR:-}" ]; then
    if [ "$IN_APPTAINER" = "1" ]; then
        GUAC_STATE_DIR="${TMPDIR:-/tmp}/guacamole-$(id -un)"
    else
        GUAC_STATE_DIR="$HOME"
    fi
fi
if [ "$GUAC_STATE_DIR" != "$HOME" ]; then
    mkdir -p "$GUAC_STATE_DIR"
    if [ ! -O "$GUAC_STATE_DIR" ]; then
        echo "Error: $GUAC_STATE_DIR is not owned by $(whoami); refusing to use it." >&2
        exit 1
    fi
    chmod 700 "$GUAC_STATE_DIR"
fi

TOMCAT_BASE="$GUAC_STATE_DIR/tomcat-runtime"
GUAC_HOME="$GUAC_STATE_DIR/.guacamole"
EXPECTED_GUAC_VERSION="${EXPECTED_GUAC_VERSION:-1.6.0}"
VNC_CONFIG_DIR="${VNC_CONFIG_DIR:-$GUAC_HOME/vnc}"

# java: use PATH, else JAVA_HOME, else a spack JDK (spack load of guacamole-server alone doesn't provide one)
if ! command -v java >/dev/null 2>&1; then
    for d in "${JAVA_HOME:-}" "$(spack_prefix openjdk || true)" "$(spack_prefix java || true)"; do
        if [ -n "$d" ] && [ -x "$d/bin/java" ]; then
            PATH="$d/bin:$PATH"; export PATH
            break
        fi
    done
fi

# guacd: use PATH, else spack's guacamole-server (installs to sbin/, which spack load leaves off PATH)
GUACD_BIN=$(command -v guacd 2>/dev/null || true)
GUACD_LIBDIR=""
if [ -z "$GUACD_BIN" ]; then
    gs=$(spack_prefix guacamole-server || true)
    if [ -n "$gs" ]; then
        for f in "$gs/sbin/guacd" "$gs/bin/guacd"; do
            if [ -x "$f" ]; then GUACD_BIN="$f"; GUACD_LIBDIR="$gs/lib"; break; fi
        done
    fi
fi

# Debian/Ubuntu name the TigerVNC tools tigervncserver / tigervncpasswd
VNCPASSWD_BIN=$(command -v vncpasswd 2>/dev/null || command -v tigervncpasswd 2>/dev/null || true)
VNCSERVER_BIN=$(command -v vncserver 2>/dev/null || command -v tigervncserver 2>/dev/null || true)

# Host mode: find the user's existing password file
get_vnc_passwd_file() {
    local f
    for f in "$HOME/.vnc/passwd" "$HOME/.config/vnc/passwd" "$HOME/.config/tigervnc/passwd" \
             "$HOME/.turbovnc/passwd" "/etc/vnc/passwd" "/etc/tigervnc/passwd"; do
        if [ -s "$f" ]; then
            echo "$f"
            return 0
        fi
    done
    return 1
}

if [ "$VNC_ISOLATE" = "1" ]; then
    mkdir -p "$GUAC_HOME" "$VNC_CONFIG_DIR"
    chmod 700 "$GUAC_HOME" "$VNC_CONFIG_DIR"
    VNC_PASSWD_FILE="$VNC_CONFIG_DIR/passwd"       # may not exist yet
else
    VNC_PASSWD_FILE="$(get_vnc_passwd_file || true)"
fi

# May this script write the VNC password file?
can_write_passwd() {
    [ "$VNC_ISOLATE" = "1" ] || [ "${VNC_WRITE_PASSWD:-0}" = "1" ]
}

# ==============================================================================
# Cleanup: only tears down what THIS run started
# ==============================================================================
STARTED_VNC_DISPLAY=""     # host mode: vncserver display (e.g. :2)
XVNC_PID=""                # isolated mode: Xvnc
SESSION_PID=""             # isolated mode: desktop session (own process group)
STARTED_GUACD_PID=""
TOMCAT_PID=""

cleanup() {
    rc=$?                      # preserve the real exit status
    trap - EXIT INT TERM
    set +e

    if [ -n "$TOMCAT_PID" ] || [ -n "$STARTED_VNC_DISPLAY" ] || [ -n "$XVNC_PID" ] \
       || [ -n "$STARTED_GUACD_PID" ]; then
        echo
        echo "================================================="
        echo " Shutting down what this script started..."
        echo "================================================="
    fi

    if [ -n "$TOMCAT_PID" ] && kill -0 "$TOMCAT_PID" 2>/dev/null; then
        kill "$TOMCAT_PID" 2>/dev/null
        wait "$TOMCAT_PID" 2>/dev/null
    fi
    if [ -n "$SESSION_PID" ]; then
        kill -TERM -- "-$SESSION_PID" 2>/dev/null || kill -TERM "$SESSION_PID" 2>/dev/null
    fi
    if [ -n "$XVNC_PID" ] && kill -0 "$XVNC_PID" 2>/dev/null; then
        kill "$XVNC_PID" 2>/dev/null
        wait "$XVNC_PID" 2>/dev/null
        rm -f "$VNC_CONFIG_DIR/Xauthority"
    fi
    if [ -n "$STARTED_VNC_DISPLAY" ]; then
        "$VNCSERVER_BIN" -kill "$STARTED_VNC_DISPLAY" >/dev/null 2>&1
    fi
    if [ -n "$STARTED_GUACD_PID" ] && kill -0 "$STARTED_GUACD_PID" 2>/dev/null; then
        kill "$STARTED_GUACD_PID" 2>/dev/null
        wait "$STARTED_GUACD_PID" 2>/dev/null
    fi

    exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# ==============================================================================
# Helpers
# ==============================================================================
is_port_listening() {
    (echo > "/dev/tcp/127.0.0.1/$1") >/dev/null 2>&1
}

# Listening on any address/family? (uses ss when available)
port_in_use() {
    if command -v ss >/dev/null 2>&1; then
        [ -n "$(ss -ltn "sport = :$1" 2>/dev/null | tail -n +2)" ]
    else
        is_port_listening "$1"
    fi
}

# ss only reveals the owning process for sockets owned by the current user,
# so a visible users:(( ... )) field means the listener is ours.
port_owned_by_me() {
    command -v ss >/dev/null 2>&1 || return 1
    ss -ltnp "sport = :$1" 2>/dev/null | tail -n +2 | grep -q 'users:(('
}

# Prints: free | mine | foreign
vnc_port_state() {
    if ! port_in_use "$1"; then
        echo free
    elif port_owned_by_me "$1"; then
        echo mine
    else
        echo foreign
    fi
}

# Is X display $1 taken? Checks the socket/lock files and, because abstract sockets
# live in the network namespace (shared with the host under docker --network host
# and Singularity), the abstract X socket too.
x_display_taken() {
    [ -e "/tmp/.X11-unix/X$1" ] && return 0
    [ -e "/tmp/.X$1-lock" ] && return 0
    if command -v ss >/dev/null 2>&1 \
       && ss -lxn 2>/dev/null | grep -qE "/tmp/\.X11-unix/X$1([[:space:]]|\$)"; then
        return 0
    fi
    return 1
}

# Print the first display number >= $1 whose port and X display are both unused
find_free_display() {
    local n=${1:-1} p
    while [ "$n" -le 99 ]; do
        p=$((5900 + n))
        if [ "$(vnc_port_state "$p")" = "free" ] && ! x_display_taken "$n"; then
            echo "$n"
            return 0
        fi
        n=$((n + 1))
    done
    return 1
}

is_valid_port() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;
    esac
    [ "$1" -ge 1024 ] && [ "$1" -le 65535 ]
}

# Check a plaintext password against the VNC password file (read-only).
# Returns 0 = match, 1 = mismatch, 2 = cannot tell (no vncpasswd binary / no file).
vnc_passwd_check() {
    [ -n "$VNCPASSWD_BIN" ] || return 2
    [ -n "$VNC_PASSWD_FILE" ] && [ -s "$VNC_PASSWD_FILE" ] || return 2
    if cmp -s <(printf '%s\n' "$1" | "$VNCPASSWD_BIN" -f | head -c 8) <(head -c 8 "$VNC_PASSWD_FILE"); then
        return 0
    fi
    return 1
}

# Write the VNC password file. Only called when can_write_passwd is true.
write_vnc_passwd() {
    [ -n "$VNC_PASSWD_FILE" ] || VNC_PASSWD_FILE="$HOME/.vnc/passwd"
    mkdir -p "$(dirname "$VNC_PASSWD_FILE")"
    chmod 700 "$(dirname "$VNC_PASSWD_FILE")"
    printf '%s\n' "$1" | "$VNCPASSWD_BIN" -f > "$VNC_PASSWD_FILE"
    chmod 600 "$VNC_PASSWD_FILE"
}

random_vnc_password() {
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8
}

vnc_passwd_missing_exit() {
    echo "ERROR: no VNC password file found, and this script launches only password-protected sessions." >&2
    if [ "$VNC_ISOLATE" = "1" ]; then
        echo "       Isolated mode uses its own private file, NOT ~/.vnc/passwd: $VNC_PASSWD_FILE" >&2
        if [ -z "$VNCPASSWD_BIN" ]; then
            echo "       'vncpasswd' is not installed (Ubuntu: apt-get install tigervnc-tools); install it and re-run." >&2
        else
            echo "       Re-run first-time setup (delete $GUAC_HOME/user-mapping.xml) or create it with:" >&2
            echo "         $VNCPASSWD_BIN \"$VNC_PASSWD_FILE\"" >&2
        fi
    else
        echo "       Run '${VNCPASSWD_BIN:-vncpasswd}', then re-run this script, or re-run with VNC_WRITE_PASSWD=1" >&2
        echo "       to let the script create it. (looked in ~/.vnc, ~/.config/vnc, ~/.config/tigervnc," >&2
        echo "       ~/.turbovnc, /etc/vnc, /etc/tigervnc)" >&2
    fi
    exit 1
}

# Tools needed to launch our own VNC session; exits with a clear message otherwise.
XVNC_BIN=""
require_vnc_binaries() {
    local missing=0 first
    if [ "$VNC_ISOLATE" = "1" ]; then
        XVNC_BIN=$(command -v Xvnc 2>/dev/null || command -v Xtigervnc 2>/dev/null || true)
        if [ -z "$XVNC_BIN" ]; then
            echo "ERROR: Xvnc (or Xtigervnc) not found in PATH." >&2; missing=1
        fi
        if ! command -v xauth >/dev/null 2>&1; then
            echo "ERROR: 'xauth' not found (needed to lock the X display to your user)." >&2; missing=1
        fi
        first=${VNC_SESSION_CMD:-startxfce4}; first=${first%% *}
        if ! command -v "$first" >/dev/null 2>&1; then
            echo "ERROR: desktop command '$first' not found in PATH (set VNC_SESSION_CMD)." >&2; missing=1
        fi
    else
        if [ -z "$VNCSERVER_BIN" ]; then
            echo "ERROR: neither 'vncserver' nor 'tigervncserver' found in PATH." >&2; missing=1
        fi
    fi
    # We'll need vncpasswd to create the password file we're allowed to write
    if [ -z "$VNCPASSWD_BIN" ] && can_write_passwd \
       && { [ -z "$VNC_PASSWD_FILE" ] || [ ! -s "$VNC_PASSWD_FILE" ]; }; then
        echo "ERROR: 'vncpasswd' not found, so the VNC password file can't be created." >&2
        echo "       Ubuntu: apt-get install tigervnc-tools   (the server package doesn't include it)." >&2
        missing=1
    fi
    [ "$missing" -eq 0 ] || exit 1
}

# Binaries plus an existing password file (used right before launching).
require_vnc_ready() {
    require_vnc_binaries
    if [ -z "$VNC_PASSWD_FILE" ] || [ ! -s "$VNC_PASSWD_FILE" ]; then
        vnc_passwd_missing_exit
    fi
}

# Generated only in isolated mode, inside VNC_CONFIG_DIR. Never overwritten once it exists.
write_xstartup() {
    cat > "$1" <<'XEOF'
#!/bin/sh
# Generated by guac-start.sh. Private to this script's VNC config dir; edit freely
# (it is not overwritten). Desktop config/cache/state is kept under this directory.
unset SESSION_MANAGER DBUS_SESSION_BUS_ADDRESS
D="$(dirname "$0")"
mkdir -p "$D/xdg/config/autostart" "$D/xdg/config" "$D/xdg/cache" "$D/xdg/data" "$D/xdg/state" "$D/run"
chmod 700 "$D/run"
export XDG_CONFIG_HOME="$D/xdg/config" XDG_CACHE_HOME="$D/xdg/cache"
export XDG_DATA_HOME="$D/xdg/data" XDG_STATE_HOME="$D/xdg/state"
export XDG_RUNTIME_DIR="$D/run"
export XDG_SESSION_TYPE=x11

# Disable graphical PolicyKit agents in this non-logind VNC session.
for system_entry in \
    /etc/xdg/autostart/*polkit*.desktop \
    /etc/xdg/autostart/*policykit*.desktop
do
    [ -f "$system_entry" ] || continue

    entry_name="$(basename "$system_entry")"

    printf '%s\n' \
        '[Desktop Entry]' \
        'Type=Application' \
        'Name=PolicyKit Authentication Agent' \
        'Hidden=true' \
        > "$XDG_CONFIG_HOME/autostart/$entry_name"
done

SESSION_CMD="${VNC_SESSION_CMD:-startxfce4}"
if command -v dbus-run-session >/dev/null 2>&1; then
    exec dbus-run-session -- $SESSION_CMD
elif command -v dbus-launch >/dev/null 2>&1; then
    exec dbus-launch --exit-with-session $SESSION_CMD
else
    exec $SESSION_CMD
fi
XEOF
    chmod 700 "$1"
}

# Isolated mode: Xvnc started directly (no vncserver wrapper, no ~/.vnc), plus xstartup.
launch_isolated_vnc() {
    local n=$1 port=$2 xa="$VNC_CONFIG_DIR/Xauthority" xstartup="$VNC_CONFIG_DIR/xstartup" cookie i
    local -a args

    [ -x "$xstartup" ] || write_xstartup "$xstartup"

    # X authority cookie so other local users can't attach to this display
    rm -f "$xa"
    cookie=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
    if ! xauth -f "$xa" add ":$n" . "$cookie" >/dev/null 2>&1; then
        echo "ERROR: xauth could not create $xa." >&2
        exit 1
    fi
    chmod 600 "$xa"

    args=(":$n" -rfbport "$port" -localhost -SecurityTypes VncAuth -rfbauth "$VNC_PASSWD_FILE"
          -auth "$xa" -nolisten tcp -geometry "${VNC_GEOMETRY:-1920x1080}" -depth 24
          -desktop "guacamole:$n ($(whoami))")
    [ -d /etc/X11/fontpath.d ] && args+=(-fp "catalogue:/etc/X11/fontpath.d")


# Xvnc uses Mesa software rendering in headless VNC desktops. Some CUDA
# installations also register NVIDIA's EGL vendor. Loading that vendor while
# Xvnc initializes its software-rendered display can cause libnvidia-egl-gbm
# to abort instead of falling back to Mesa.
#
# Restrict EGL vendor discovery for Xvnc itself to Mesa. Do not assume a
# particular manifest filename or a single distro-specific installation path.
find_mesa_egl_vendor()
{
    local manifest
    local dir
    local IFS
    local -a search_dirs=()

    # Honor additional GLVND vendor directories supplied by the environment.
    # Do not reuse __EGL_VENDOR_LIBRARY_FILENAMES: it may select NVIDIA.
    if [ -n "${__EGL_VENDOR_LIBRARY_DIRS:-}" ]; then
        IFS=:
        read -r -a search_dirs <<< "$__EGL_VENDOR_LIBRARY_DIRS"
    fi

    search_dirs+=(
        /etc/glvnd/egl_vendor.d
        /usr/share/glvnd/egl_vendor.d
        /usr/local/etc/glvnd/egl_vendor.d
        /usr/local/share/glvnd/egl_vendor.d
    )

    for dir in "${search_dirs[@]}"; do
        [ -d "$dir" ] || continue

        for manifest in "$dir"/*.json; do
            [ -f "$manifest" ] || continue

            if grep -Eq \
                '"library_path"[[:space:]]*:[[:space:]]*"([^"]*/)?libEGL_mesa\.so(\.[0-9]+)*"' \
                "$manifest"
            then
                printf '%s\n' "$manifest"
                return 0
            fi
        done
    done

    return 1
}

    if [ -n "${VNC_MESA_EGL_VENDOR:-}" ]; then
        if [ ! -f "$VNC_MESA_EGL_VENDOR" ]; then
            echo "ERROR: VNC_MESA_EGL_VENDOR does not name a file:" >&2
            echo "       $VNC_MESA_EGL_VENDOR" >&2
            exit 1
        fi

    MESA_EGL_VENDOR=$VNC_MESA_EGL_VENDOR
    elif ! MESA_EGL_VENDOR=$(find_mesa_egl_vendor); then
        echo "ERROR: Could not locate the Mesa EGL vendor manifest." >&2
        echo "       Set VNC_MESA_EGL_VENDOR to its full path." >&2
        exit 1
    fi

    # Override vendor discovery for Xvnc only. This assignment replaces any
    # inherited __EGL_VENDOR_LIBRARY_FILENAMES value
    __EGL_VENDOR_LIBRARY_FILENAMES="$MESA_EGL_VENDOR" \
    "$XVNC_BIN" "${args[@]}" ${VNC_XVNC_ARGS:-} \
    >"$VNC_CONFIG_DIR/xvnc.log" 2>&1 &

    XVNC_PID=$!

    for i in $(seq 1 15); do
        port_in_use "$port" && break
        kill -0 "$XVNC_PID" 2>/dev/null || break
        sleep 1
    done
    if ! port_in_use "$port"; then
        echo "ERROR: Xvnc did not come up on port $port. Last log lines:" >&2
        tail -n 10 "$VNC_CONFIG_DIR/xvnc.log" >&2 || true
        exit 1
    fi

    # Desktop session in its own process group so cleanup can stop the whole tree
    if command -v setsid >/dev/null 2>&1; then
        DISPLAY=":$n" XAUTHORITY="$xa" setsid "$xstartup" >"$VNC_CONFIG_DIR/session.log" 2>&1 &
    else
        DISPLAY=":$n" XAUTHORITY="$xa" "$xstartup" >"$VNC_CONFIG_DIR/session.log" 2>&1 &
    fi
    SESSION_PID=$!
    sleep 3
    if ! kill -0 "$SESSION_PID" 2>/dev/null; then
        SESSION_PID=""
        echo "ERROR: the desktop session exited immediately. Last log lines:" >&2
        tail -n 10 "$VNC_CONFIG_DIR/session.log" >&2 || true
        exit 1
    fi
}

get_http_port() {
    python3 - "$TOMCAT_BASE/conf/server.xml" <<'PYEOF'
import sys
import xml.etree.ElementTree as ET
for c in ET.parse(sys.argv[1]).getroot().iter('Connector'):
    if c.get('address') == '127.0.0.1':
        print(c.get('port'))
        break
PYEOF
}

set_http_port() {
    python3 - "$TOMCAT_BASE/conf/server.xml" "$1" <<'PYEOF'
import sys
import xml.etree.ElementTree as ET
path, port = sys.argv[1], sys.argv[2]
tree = ET.parse(path)
for c in tree.getroot().iter('Connector'):
    if c.get('address') == '127.0.0.1':
        c.set('port', port)
        break
tree.write(path, encoding='utf-8', xml_declaration=True)
PYEOF
}

get_vnc_port() {
    python3 - "$GUAC_HOME/user-mapping.xml" <<'PYEOF'
import sys
import xml.etree.ElementTree as ET
for p in ET.parse(sys.argv[1]).getroot().iter('param'):
    if p.get('name') == 'port':
        print((p.text or '').strip())
        break
PYEOF
}

get_guac_vnc_password() {
    python3 - "$GUAC_HOME/user-mapping.xml" <<'PYEOF'
import sys
import xml.etree.ElementTree as ET
for p in ET.parse(sys.argv[1]).getroot().iter('param'):
    if p.get('name') == 'password':
        print(p.text or '')
        break
PYEOF
}

print_banner() {
    local http_port=$1 lan_ip public_ip ssh_host ssh_login
    lan_ip=$(python3 -c "import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(('1.1.1.1', 53)); print(s.getsockname()[0]); s.close()" 2>/dev/null || true)
    if [ -z "$lan_ip" ]; then
        lan_ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' || true)
    fi
    if [ -z "$lan_ip" ]; then
        lan_ip=$(hostname -I 2>/dev/null | awk '{print $1}' || true)
    fi
    lan_ip=${lan_ip:-UNKNOWN_LAN_IP}
    public_ip=""
    if [ "${SHOW_PUBLIC_IP:-0}" = "1" ]; then
        public_ip=$(curl -s --max-time 2 https://ifconfig.me 2>/dev/null || true)
    fi
    ssh_host=${SSH_HOST:-${public_ip:-$lan_ip}}

    echo " Local URL: http://127.0.0.1:$http_port/guacamole"
    echo ""
    echo " --- SSH Tunneling Info ---"
    echo " LAN IP:    $lan_ip"
    [ -n "$public_ip" ] && echo " Public IP: $public_ip"
    if [ "$IN_CONTAINER" = "1" ] && [ "$IN_APPTAINER" = "0" ]; then
        echo " NOTE: you are inside a Docker/Podman container. With --network host the IP above is the"
        echo "       Docker host's; otherwise it is the container's and you must tunnel via the host"
        echo "       (publish port $http_port or set SSH_HOST). If your login there differs from your local"
        echo "       one, set SSH_USER (and SSH_OPTS for things like '-J jumphost') for the command below."
    fi
    echo ""
    echo " To connect from your local PC, run this tunnel (-N: no remote shell; add -f to"
    echo " background it once you've authenticated):"
    # Username: use SSH_USER if given. Otherwise show our own login only where it is
    # meaningful on the host (not root, not inside Docker/Podman); else omit it and let
    # ssh use the person's default login.
    ssh_login=${SSH_USER:-}
    if [ -z "$ssh_login" ] && [ "$(id -u)" != "0" ] && { [ "$IN_CONTAINER" = "0" ] || [ "$IN_APPTAINER" = "1" ]; }; then
        ssh_login=$(whoami)
    fi
    echo "   ssh -N ${SSH_OPTS:+$SSH_OPTS }-L $http_port:127.0.0.1:$http_port ${ssh_login:+$ssh_login@}$ssh_host"
    echo ""
    echo " Then open in your client web browser:"
    echo "   http://127.0.0.1:$http_port/guacamole"
}

# ==============================================================================
# PHASE 0: PRE-FLIGHT CHECKS
# ==============================================================================
PREFLIGHT_FAILED=0

for bin in java python3; do
    if ! command -v "$bin" >/dev/null 2>&1; then
        echo "Error: '$bin' not found in PATH." >&2
        PREFLIGHT_FAILED=1
    fi
done

for f in "$WAR_PATH" \
         "$TOMCAT_SYS_HOME/bin/bootstrap.jar" \
         "$TOMCAT_SYS_HOME/bin/tomcat-juli.jar" \
         "$TOMCAT_CONF_SRC/server.xml"; do
    if [ ! -f "$f" ]; then
        echo "Error: $f missing. System package setup incomplete (see TOMCAT_SYS_HOME / TOMCAT_CONF_SRC / WAR_PATH)." >&2
        PREFLIGHT_FAILED=1
    elif [ ! -r "$f" ]; then
        echo "Error: $f is not readable by $(whoami)." >&2
        PREFLIGHT_FAILED=1
    fi
done

if [ "$PREFLIGHT_FAILED" -ne 0 ]; then
    echo "Pre-flight checks failed. Aborting." >&2
    exit 1
fi

if ! command -v ss >/dev/null 2>&1; then
    echo "WARNING: 'ss' (iproute2) not found; cannot tell whose process owns a port, so any busy" >&2
    echo "         VNC port will be treated as foreign. Install iproute2 (Ubuntu) / iproute (Rocky)." >&2
fi

# guacd: use the running one, or start our own (foreground, so we know its exact PID)
if ! is_port_listening 4822; then
    echo "-> guacd is not running on 127.0.0.1:4822. Launching it..."
    if [ -z "$GUACD_BIN" ]; then
        echo "ERROR: 'guacd' not found in PATH (or in spack's guacamole-server prefix)." >&2
        exit 1
    fi
    mkdir -p "$GUAC_HOME"
    chmod 700 "$GUAC_HOME"
    (
        # spack-located guacd: make sure it can find its libs/protocol plugins
        if [ -n "$GUACD_LIBDIR" ]; then
            export LD_LIBRARY_PATH="$GUACD_LIBDIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        fi
        exec "$GUACD_BIN" -b 127.0.0.1 -f >"$GUAC_HOME/guacd.log" 2>&1
    ) &
    STARTED_GUACD_PID=$!

    for _ in $(seq 1 20); do
        is_port_listening 4822 && break
        kill -0 "$STARTED_GUACD_PID" 2>/dev/null || break
        sleep 0.5
    done

    if ! is_port_listening 4822; then
        echo "ERROR: failed to start guacd on 127.0.0.1:4822. Last log lines:" >&2
        tail -n 10 "$GUAC_HOME/guacd.log" >&2 || true
        exit 1
    fi
    echo "-> guacd started (log: $GUAC_HOME/guacd.log)."
fi

# --- Soft checks (warnings only) ---
if [ -n "$GUACD_BIN" ]; then
    GUACD_VER=$(LD_LIBRARY_PATH="${GUACD_LIBDIR:-}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" "$GUACD_BIN" -v 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true)
    if [ -n "$GUACD_VER" ] && [ "$GUACD_VER" != "$EXPECTED_GUAC_VERSION" ]; then
        echo "WARNING: guacd is $GUACD_VER but the WAR is expected to be $EXPECTED_GUAC_VERSION." >&2
        echo "         Mismatched guacd/webapp versions often fail to connect." >&2
    fi
fi

TOMCAT_VER=$(java -cp "$TOMCAT_SYS_HOME/lib/*" org.apache.catalina.util.ServerInfo 2>/dev/null \
             | awk -F': *' '/Server number/{print $2}' || true)
if [ -n "$TOMCAT_VER" ]; then
    case "${TOMCAT_VER%%.*}" in
        ''|*[!0-9]*) ;;
        *) if [ "${TOMCAT_VER%%.*}" -ge 10 ]; then
               echo "WARNING: Tomcat $TOMCAT_VER detected. Verify your Guacamole WAR supports it" >&2
               echo "         (older Guacamole releases need Tomcat 9)." >&2
           fi ;;
    esac
fi

if command -v ss >/dev/null 2>&1; then
    if ss -ltn 2>/dev/null | awk '$4 ~ /:4822$/ && $4 !~ /^127\.0\.0\.1:/ {found=1} END{exit !found}'; then
        echo "WARNING: guacd appears to listen on a non-loopback address; check its bind (-b) setting." >&2
    fi
fi

# ==============================================================================
# PHASE 1: FIRST-TIME SETUP (only when config is missing)
# ==============================================================================
if [ ! -f "$GUAC_HOME/user-mapping.xml" ] || [ ! -f "$TOMCAT_BASE/conf/server.xml" ]; then
    echo "================================================="
    echo "   First-Time Setup: Guacamole & Tomcat Runtime "
    echo "================================================="
    echo "State dir: $GUAC_STATE_DIR"
    echo "VNC mode:  $([ "$VNC_ISOLATE" = "1" ] && echo "isolated (private config in $VNC_CONFIG_DIR)" || echo "host (uses your normal VNC config)")"

    if [ ! -t 0 ]; then
        echo "ERROR: first-time setup needs an interactive terminal (stdin is not a tty)." >&2
        exit 1
    fi

    HTTP_PORT=8081
    while port_in_use "$HTTP_PORT"; do HTTP_PORT=$((HTTP_PORT + 1)); done
    echo "Selected free HTTP port: $HTTP_PORT (shutdown port disabled; stop via signal)"

    # --- VNC port: default to the first unused display; reject other users' sessions ---
    DEFAULT_DISPLAY=$(find_free_display 1 || true)
    DEFAULT_PORT=""
    [ -n "$DEFAULT_DISPLAY" ] && DEFAULT_PORT=$((5900 + DEFAULT_DISPLAY))

    while true; do
        read -rp "VNC port to use (a free port launches your own session) [${DEFAULT_PORT:-none}]: " VNC_PORT
        VNC_PORT=${VNC_PORT:-$DEFAULT_PORT}
        if ! is_valid_port "$VNC_PORT"; then
            echo "Enter a numeric port between 1024 and 65535."
            continue
        fi
        case "$(vnc_port_state "$VNC_PORT")" in
            foreign)
                echo "Port $VNC_PORT is in use by another user's process (their desktop)."
                echo "Pick a different port${DEFAULT_PORT:+, e.g. $DEFAULT_PORT}."
                ;;
            mine)
                echo "Port $VNC_PORT is already served by one of your own processes; it will be reused."
                break
                ;;
            free)
                if [ "$VNC_PORT" -lt 5901 ]; then
                    echo "Port $VNC_PORT maps to display :$((VNC_PORT - 5900)); use 5901 or higher."
                else
                    break
                fi
                ;;
        esac
    done

    # If we will launch the session ourselves, check what we need up front: fail early.
    VNC_STATE_SETUP=$(vnc_port_state "$VNC_PORT")
    if [ "$VNC_STATE_SETUP" = "free" ]; then
        require_vnc_binaries
        if ! can_write_passwd && { [ -z "$VNC_PASSWD_FILE" ] || [ ! -s "$VNC_PASSWD_FILE" ]; }; then
            vnc_passwd_missing_exit
        fi
    fi
    [ -n "$VNC_PASSWD_FILE" ] && echo "VNC password file: $VNC_PASSWD_FILE"

    read -rp "Enter desired Guacamole web username [admin]: " GUAC_USER
    GUAC_USER=${GUAC_USER:-admin}

    while true; do
        read -rsp "Enter password for Guacamole web user ($GUAC_USER): " GUAC_PASS
        echo ""
        read -rsp "Confirm password: " GUAC_PASS_CONFIRM
        echo ""
        [ "$GUAC_PASS" = "$GUAC_PASS_CONFIRM" ] && [ -n "$GUAC_PASS" ] && break
        echo "Passwords do not match or were empty. Try again."
    done

    # --- VNC password: stored in Guacamole's config; verified against the password file ---

echo ""
echo "IMPORTANT:"
echo "  The VNC password is NOT your system login password."
echo "  Guacamole must store the VNC password in plaintext within its"
echo "  private configuration so it can automatically connect to the"
echo "  VNC server on your behalf. (vncpasswd only stores an obfuscated copy)"
echo "  Enter a dedicated password used ONLY for this VNC session or leave empty"
echo "  to generate a new random one."
echo "  Do not reuse your Linux, institutional, SSH, or other personal passwords."
echo "  NOTE: VNC authentication only uses the first 8 characters."
echo ""

    PASSWD_FILE_MISSING=0
    if [ -z "$VNC_PASSWD_FILE" ] || [ ! -s "$VNC_PASSWD_FILE" ]; then PASSWD_FILE_MISSING=1; fi

    while true; do
        if [ "$PASSWD_FILE_MISSING" = "1" ] && can_write_passwd && [ -n "$VNCPASSWD_BIN" ]; then
            read -rsp "Enter a VNC password for the new session (empty = generate one): " VNC_PASS
        else
            read -rsp "Enter the VNC password for that session: " VNC_PASS
        fi
        echo ""

        if [ -z "$VNC_PASS" ]; then
            if [ "$PASSWD_FILE_MISSING" = "1" ] && can_write_passwd && [ -n "$VNCPASSWD_BIN" ]; then
                VNC_PASS=$(random_vnc_password)
                echo "Generated a random VNC password (stored only in Guacamole's config and the VNC password file)."
            elif [ "$VNC_STATE_SETUP" = "free" ]; then
                echo "A password is required: this script only launches password-protected sessions."
                continue
            fi
        fi

        if [ -n "$VNC_PASS" ]; then
            [ "${#VNC_PASS}" -gt 8 ] && echo "NOTE: VNC authentication only uses the first 8 characters."
            rc=0
            vnc_passwd_check "$VNC_PASS" || rc=$?
            case "$rc" in
                0) echo "OK: matches $VNC_PASSWD_FILE." ;;
                1)
                    echo "NOTE: that does not match $VNC_PASSWD_FILE."
                    echo "      If that file belongs to the session being used, logins will fail"
                    echo "      (and repeated failures lock the VNC server out)."
                    if can_write_passwd; then
                        read -rp "Overwrite $VNC_PASSWD_FILE with this password? [y/N]: " OVERWRITE
                        case "$OVERWRITE" in
                            [Yy]*)
                                cp -p "$VNC_PASSWD_FILE" "$VNC_PASSWD_FILE.bak.$(date +%s)"
                                write_vnc_passwd "$VNC_PASS"
                                echo "Updated $VNC_PASSWD_FILE (backup kept)."
                                ;;
                            *)
                                read -rp "Use the entered password in Guacamole anyway? [y/N]: " ANYWAY
                                case "$ANYWAY" in [Yy]*) ;; *) continue ;; esac
                                ;;
                        esac
                    else
                        read -rp "Use it anyway? [y/N]: " ANYWAY
                        case "$ANYWAY" in [Yy]*) ;; *) continue ;; esac
                    fi
                    ;;
                *)
                    if [ "$PASSWD_FILE_MISSING" = "1" ] && can_write_passwd && [ -n "$VNCPASSWD_BIN" ]; then
                        write_vnc_passwd "$VNC_PASS"
                        echo "Created $VNC_PASSWD_FILE."
                    else
                        echo "NOTE: could not verify the password (no vncpasswd binary or no password file found)."
                    fi
                    ;;
            esac
        fi
        break
    done

    mkdir -p "$TOMCAT_BASE"/{conf,logs,temp,work,webapps} "$GUAC_HOME"
    chmod 700 "$TOMCAT_BASE" "$GUAC_HOME"

    # Copy base Tomcat config (ignore unreadable files such as tomcat-users.xml)
    cp -r "$TOMCAT_CONF_SRC"/* "$TOMCAT_BASE/conf/" 2>/dev/null || true
    ln -sf "$WAR_PATH" "$TOMCAT_BASE/webapps/guacamole.war"

    # Rewrite server.xml: no shutdown port, one HTTP connector bound to localhost only
    python3 - "$TOMCAT_BASE/conf/server.xml" "$HTTP_PORT" <<'PYEOF'
import sys
import xml.etree.ElementTree as ET

path, http_port = sys.argv[1], sys.argv[2]
tree = ET.parse(path)
root = tree.getroot()
root.set('port', '-1')

for service in root.iter('Service'):
    keep = None
    for c in list(service.findall('Connector')):
        proto = c.get('protocol', 'HTTP/1.1')
        if keep is None and proto.startswith('HTTP') and c.get('SSLEnabled') != 'true':
            c.set('port', http_port)
            c.set('address', '127.0.0.1')
            keep = c
        else:
            service.remove(c)   # drop AJP / TLS / extra connectors
    if keep is None:
        sys.exit("No usable HTTP connector found in server.xml")

tree.write(path, encoding='utf-8', xml_declaration=True)
PYEOF

    cat > "$GUAC_HOME/guacamole.properties" <<EOF
guacd-hostname: 127.0.0.1
guacd-port: 4822
auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping: $GUAC_HOME/user-mapping.xml
EOF

    # Build user-mapping.xml with a real XML writer (safe for &, <, quotes) and SHA-256
    GUAC_USER="$GUAC_USER" GUAC_PASS="$GUAC_PASS" VNC_PASS="$VNC_PASS" VNC_PORT="$VNC_PORT" \
    python3 - "$GUAC_HOME/user-mapping.xml" <<'PYEOF'
import hashlib
import os
import sys
import xml.etree.ElementTree as ET

root = ET.Element('user-mapping')
auth = ET.SubElement(root, 'authorize', {
    'username': os.environ['GUAC_USER'],
    'password': hashlib.sha256(os.environ['GUAC_PASS'].encode('utf-8')).hexdigest(),
    'encoding': 'sha256',
})
conn = ET.SubElement(auth, 'connection', {'name': 'Local VNC Session'})
ET.SubElement(conn, 'protocol').text = 'vnc'
for name, value in (('hostname', '127.0.0.1'),
                    ('port', os.environ['VNC_PORT']),
                    ('password', os.environ['VNC_PASS'])):
    ET.SubElement(conn, 'param', {'name': name}).text = value
if hasattr(ET, 'indent'):
    ET.indent(root)
ET.ElementTree(root).write(sys.argv[1], encoding='utf-8', xml_declaration=True)
PYEOF

    chmod 600 "$GUAC_HOME/guacamole.properties" "$GUAC_HOME/user-mapping.xml"
    unset GUAC_PASS GUAC_PASS_CONFIRM VNC_PASS
    echo "Setup complete!"
    echo ""
fi

# ==============================================================================
# PHASE 2: IS TOMCAT ALREADY RUNNING? (report and leave everything untouched)
# ==============================================================================
HTTP_PORT=$(get_http_port)
VNC_PORT=$(get_vnc_port)
if [ -z "$HTTP_PORT" ] || ! is_valid_port "${VNC_PORT:-}"; then
    echo "ERROR: could not read ports from $TOMCAT_BASE/conf/server.xml or $GUAC_HOME/user-mapping.xml." >&2
    exit 1
fi

VNC_STATE=$(vnc_port_state "$VNC_PORT")

# HTTP port taken by someone else's process (e.g. another user, or another container
# sharing the host network)? Move Tomcat to the next free port instead of failing.
if port_in_use "$HTTP_PORT" && command -v ss >/dev/null 2>&1 && ! port_owned_by_me "$HTTP_PORT"; then
    NEW_HTTP_PORT=$((HTTP_PORT + 1))
    while port_in_use "$NEW_HTTP_PORT"; do NEW_HTTP_PORT=$((NEW_HTTP_PORT + 1)); done
    echo "NOTE: HTTP port $HTTP_PORT is held by a process that is not yours; switching Tomcat to port $NEW_HTTP_PORT." >&2
    set_http_port "$NEW_HTTP_PORT"
    HTTP_PORT=$NEW_HTTP_PORT
fi

if port_in_use "$HTTP_PORT"; then
    case "$VNC_STATE" in
        mine)    VNC_DESC="Active (yours)" ;;
        foreign) VNC_DESC="port $VNC_PORT is owned by ANOTHER USER" ;;
        *)       VNC_DESC="NOT LISTENING on $VNC_PORT" ;;
    esac
    echo "================================================="
    echo " Tomcat is ALREADY RUNNING on port $HTTP_PORT; nothing was started or stopped."
    echo " VNC: $VNC_DESC | guacd: Active"
    echo "================================================="
    print_banner "$HTTP_PORT"
    echo "================================================="
    exit 0
fi

# ==============================================================================
# PHASE 3: VNC OWNERSHIP CHECK & LAUNCH
# ==============================================================================
echo "Checking VNC on port $VNC_PORT..."
GUAC_VNC_PASS=$(get_guac_vnc_password)

case "$VNC_STATE" in
    mine)
        echo "-> Using your existing VNC session on port $VNC_PORT (will be left running on exit)."
        if [ -n "$GUAC_VNC_PASS" ]; then
            rc=0
            vnc_passwd_check "$GUAC_VNC_PASS" || rc=$?
            if [ "$rc" -eq 1 ]; then
                echo "WARNING: Guacamole's stored VNC password does not match $VNC_PASSWD_FILE." >&2
                echo "         Fine if that session uses a different file; otherwise fix it before" >&2
                echo "         connecting (repeated failed logins lock the VNC server out)." >&2
            fi
        fi
        ;;

    foreign)
        if [ "${VNC_ALLOW_FOREIGN:-0}" = "1" ]; then
            echo "WARNING: port $VNC_PORT belongs to another user's process; continuing because VNC_ALLOW_FOREIGN=1." >&2
        else
            echo "ERROR: port $VNC_PORT is held by a process that is not yours (likely another user's desktop)." >&2
            echo "       Guacamole would try to log in to THEIR session, and failed logins can lock them out." >&2
            NEXT_DISPLAY=$(find_free_display 1 || true)
            if [ -n "$NEXT_DISPLAY" ]; then
                echo "       Next unused port: $((5900 + NEXT_DISPLAY))" >&2
            fi
            echo "       To pick a new port, delete $GUAC_HOME/user-mapping.xml and re-run this script." >&2
            exit 1
        fi
        ;;

    free)
        echo "-> Nothing is listening on port $VNC_PORT. Launching your own VNC session ($([ "$VNC_ISOLATE" = "1" ] && echo isolated || echo host) mode)..."

        # Self-heal: password file missing but Guacamole's config has the password -> recreate it from that
        if can_write_passwd && [ -n "$GUAC_VNC_PASS" ] && [ -n "$VNCPASSWD_BIN" ] \
           && { [ -z "$VNC_PASSWD_FILE" ] || [ ! -s "$VNC_PASSWD_FILE" ]; }; then
            write_vnc_passwd "$GUAC_VNC_PASS"
            echo "-> Created $VNC_PASSWD_FILE from the VNC password stored in Guacamole's config."
        fi

        require_vnc_ready
        echo "-> Using VNC password file: $VNC_PASSWD_FILE"

        # Don't launch a session Guacamole can't log in to
        if [ -z "$GUAC_VNC_PASS" ]; then
            echo "ERROR: no VNC password is stored in $GUAC_HOME/user-mapping.xml, but the session we launch is password-protected." >&2
            exit 1
        fi
        rc=0
        vnc_passwd_check "$GUAC_VNC_PASS" || rc=$?
        if [ "$rc" -eq 1 ]; then
            echo "ERROR: Guacamole's stored VNC password does not match $VNC_PASSWD_FILE." >&2
            echo "       Edit the VNC <param name=\"password\"> in $GUAC_HOME/user-mapping.xml, or" >&2
            echo "       delete that file and re-run to redo setup." >&2
            exit 1
        elif [ "$rc" -eq 2 ]; then
            echo "NOTE: could not verify the stored VNC password against the password file." >&2
        fi

        DISPLAY_NUM=$((VNC_PORT - 5900))
        if [ "$DISPLAY_NUM" -lt 1 ]; then
            echo "ERROR: port $VNC_PORT maps to display :$DISPLAY_NUM; refusing to auto-start there." >&2
            exit 1
        fi
        if x_display_taken "$DISPLAY_NUM"; then
            echo "ERROR: display :$DISPLAY_NUM already exists (X socket/lock present) but port $VNC_PORT is not listening." >&2
            echo "       It may belong to another user or be stale. Choose a different port." >&2
            exit 1
        fi

        if [ "$VNC_ISOLATE" = "1" ]; then
            launch_isolated_vnc "$DISPLAY_NUM" "$VNC_PORT"
            echo "-> Isolated VNC session :$DISPLAY_NUM is up on port $VNC_PORT (stopped on exit)."
            echo "   Logs: $VNC_CONFIG_DIR/xvnc.log, $VNC_CONFIG_DIR/session.log"
        else
            "$VNCSERVER_BIN" ":$DISPLAY_NUM" -localhost
            STARTED_VNC_DISPLAY=":$DISPLAY_NUM"

            for _ in $(seq 1 15); do
                port_in_use "$VNC_PORT" && break
                sleep 1
            done
            if ! port_in_use "$VNC_PORT"; then
                echo "ERROR: VNC server did not come up on port $VNC_PORT." >&2
                exit 1
            fi
            echo "-> VNC session $STARTED_VNC_DISPLAY is up on port $VNC_PORT (stopped on exit)."
        fi
        ;;
esac

# ==============================================================================
# PHASE 4: BANNER
# ==============================================================================
echo "================================================="
echo " Starting Guacamole Web Interface"
echo "================================================="
print_banner "$HTTP_PORT"
echo "================================================="

# ==============================================================================
# PHASE 5: LAUNCH TOMCAT DIRECTLY VIA JAVA
# ==============================================================================
export CATALINA_HOME="$TOMCAT_SYS_HOME"
export CATALINA_BASE="$TOMCAT_BASE"
export GUACAMOLE_HOME="$GUAC_HOME"

# catalina.sh adds these on JDK 9+; replicate since we bypass it.
JAVA_MAJOR=$(java -version 2>&1 | awk -F'"' '/version/{split($2,v,"."); print (v[1]=="1" ? v[2] : v[1]); exit}')
ADD_OPENS=()
if [ "${JAVA_MAJOR:-0}" -ge 9 ] 2>/dev/null; then
    ADD_OPENS=(
        --add-opens=java.base/java.lang=ALL-UNNAMED
        --add-opens=java.base/java.io=ALL-UNNAMED
        --add-opens=java.base/java.util=ALL-UNNAMED
        --add-opens=java.base/java.util.concurrent=ALL-UNNAMED
        --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
    )
fi

# Keep the JVM's user.home (prefs, caches) inside the state dir when it is not $HOME
JAVA_HOME_OPT=()
if [ "$GUAC_STATE_DIR" != "$HOME" ]; then
    JAVA_HOME_OPT=("-Duser.home=$GUAC_STATE_DIR")
fi

java \
    "${ADD_OPENS[@]}" \
    "${JAVA_HOME_OPT[@]}" \
    -Djava.util.logging.config.file="$CATALINA_BASE/conf/logging.properties" \
    -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
    -classpath "$CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar" \
    -Dcatalina.base="$CATALINA_BASE" \
    -Dcatalina.home="$CATALINA_HOME" \
    -Djava.io.tmpdir="$CATALINA_BASE/temp" \
    org.apache.catalina.startup.Bootstrap start &
TOMCAT_PID=$!

# Foreground wait lets bash run the INT/TERM traps promptly
wait "$TOMCAT_PID"

