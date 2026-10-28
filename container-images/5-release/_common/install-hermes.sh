#!/bin/bash
# install-hermes.sh -- Hermes Agent for E4S images (Debian/Ubuntu and RHEL/Rocky families).
# Run once from the Dockerfile (a final-*-base stage), AFTER the user-facing scripts from
# container-images/_common (hermes-*.sh) have been copied to /etc/e4s. This script installs
# only the application under /opt/hermes (+ /etc/hermes metadata); it writes no user scripts.
#
#It follows the RUN steps of upstream's Dockerfile at the
# pinned commit (github.com/NousResearch/hermes-agent): pm stages pinned uv/python/node/
# chromium (hash-pinned in pm/lock.json), pm builds a sealed venv from uv.lock, the
# frontends are prebuilt, docker/build_agent.py assembles it all under /opt/hermes.
#
# Deliberately NOT copied from upstream, because they would shadow E4S's own tools:
#   - symlinks of python3/node/npm/npx/rg/ffmpeg into /usr/local/bin
#   - /opt/hermes/.venv/bin on PATH
#   - s6-overlay, the UID-remap/chown hook, the root-drop shim
#
# Inputs (environment):
#   HERMES_REF      release tag, informational/label only          (default v0.22.2)
#   HERMES_COMMIT   full 40-hex commit SHA that is actually built  (default: pin for v0.22.2)
#                   The fetched tree is verified against it; a moved or forged tag cannot
#                   change what gets installed. Bump both together.
#   HERMES_EXTRAS   pip extras from the lockfile
#   BOOTSTRAP_PYTHON  python >=3.11 used to run pm (default: the image's python on PATH, i.e. E4S's)
set -euo pipefail
umask 022

HERMES_REF="${HERMES_REF:-v0.22.2}"
HERMES_COMMIT="${HERMES_COMMIT:-d923a5eb487a17c0a68801bba9ef0f56c81040a8}"
# Upstream's image uses: all messaging otlp anthropic bedrock azure-identity matrix google-chat.
# Anything else is installed on demand into $HERMES_HOME/installs (needs network at runtime).
HERMES_EXTRAS="${HERMES_EXTRAS:-all anthropic messaging}"
ROOT=/opt/hermes                                 # docker/build_agent.py hardcodes this path

[[ "$HERMES_COMMIT" =~ ^[0-9a-f]{40}$ ]] || { echo "HERMES_COMMIT must be a full 40-hex SHA" >&2; exit 1; }
[ "$(id -u)" = 0 ] || { echo "must run as root" >&2; exit 1; }

# ---- keep build state out of /root and the image ----
# pm, uv, npm and node all write under $HOME / XDG dirs / HERMES_HOME. Point them at a scratch
# directory that is removed on exit, and verify afterwards that /root gained nothing.
BUILD_TMP="$(mktemp -d /tmp/hermes-build.XXXXXX)"
SRC="$BUILD_TMP/src"
cleanup() { rm -rf "$BUILD_TMP" /opt/products; }
trap cleanup EXIT
mkdir -p "$BUILD_TMP"/{home,cache,config,data,hermes-home,tmp}
export HOME="$BUILD_TMP/home"
export XDG_CACHE_HOME="$BUILD_TMP/cache" XDG_CONFIG_HOME="$BUILD_TMP/config" XDG_DATA_HOME="$BUILD_TMP/data"
export HERMES_HOME="$BUILD_TMP/hermes-home"
export TMPDIR="$BUILD_TMP/tmp"
export npm_config_cache="$BUILD_TMP/npm-cache" npm_config_update_notifier=false npm_config_fund=false
export UV_LINK_MODE=copy
unset PYTHONPATH PYTHONHOME
export HERMES_RUNTIME_DIR="$ROOT/tools"          # tool store lives in the image, not in HERMES_HOME
export CC=gcc CXX=g++                            # pm's standalone Python records a clang toolchain
ROOT_BEFORE="$(find /root -mindepth 1 -maxdepth 4 2>/dev/null | sort || true)"

# ---- distro detection ----
. /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
  *" debian "*|*" ubuntu "*) FAMILY=debian ;;
  *" rhel "*|*" rocky "*|*" fedora "*|*" centos "*) FAMILY=rhel ;;
  *) echo "unsupported distribution: ${PRETTY_NAME:-unknown}" >&2; exit 1 ;;
esac
case "$(uname -m)" in
  x86_64|aarch64) ;;
  *) echo "unsupported architecture $(uname -m) (pm has no pinned tools for it)" >&2; exit 1 ;;
esac

# ---- system packages (Chromium runtime libs follow upstream's Dockerfile list) ----
if [ "$FAMILY" = debian ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  # Ubuntu 24.04 renamed several libs with a t64 suffix; fall back to the plain name elsewhere.
  pkg() { if apt-cache show "${1}t64" >/dev/null 2>&1; then echo "${1}t64"; else echo "$1"; fi; }
  apt-get install -y --no-install-recommends \
    git curl ca-certificates xz-utils build-essential cmake libffi-dev libatomic1 \
    procps openssh-client \
    "$(pkg libasound2)" "$(pkg libatk-bridge2.0-0)" "$(pkg libatk1.0-0)" "$(pkg libatspi2.0-0)" \
    libcairo2 "$(pkg libcups2)" libdbus-1-3 libgbm1 "$(pkg libglib2.0-0)" libnspr4 libnss3 \
    libpango-1.0-0 libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 libxfixes3 \
    libxkbcommon0 libxrandr2
else
  # Rocky ships curl-minimal, which conflicts with the full `curl` package; it is all we need.
  command -v curl >/dev/null || dnf install -y curl-minimal
  dnf install -y --setopt=install_weak_deps=False \
    git ca-certificates xz gcc gcc-c++ make cmake libffi-devel libatomic \
    procps-ng openssh-clients \
    alsa-lib atk at-spi2-atk at-spi2-core cairo cups-libs dbus-libs mesa-libgbm glib2 \
    nspr nss pango libX11 libxcb libXcomposite libXdamage libXext libXfixes libxkbcommon libXrandr
  dnf clean all
fi

# pm only needs a stdlib python >=3.11 to start; use the image's own interpreter.
# No system python is installed for this.
if [ -n "${BOOTSTRAP_PYTHON:-}" ]; then
  BOOT="$BOOTSTRAP_PYTHON"
else
  BOOT=""
  # The E4S python is only on PATH via bash.bashrc, so look for it explicitly first.
  for p in /opt/python/pkgs/python-*/bin/python3 "$(command -v python3 || true)" "$(command -v python || true)"; do
    [ -x "$p" ] && "$p" -c 'import sys; sys.exit(sys.version_info < (3, 11))' && { BOOT="$p"; break; }
  done
fi
[ -n "$BOOT" ] || { echo "no python >=3.11 found for bootstrapping pm; set BOOTSTRAP_PYTHON" >&2; exit 1; }
echo "bootstrap python: $BOOT ($("$BOOT" --version))"

# ---- source: fetch exactly the pinned commit ----
git init --quiet "$SRC"
git -C "$SRC" fetch --quiet --depth 1 https://github.com/NousResearch/hermes-agent.git "$HERMES_COMMIT"
git -C "$SRC" -c advice.detachedHead=false checkout --quiet FETCH_HEAD
COMMIT="$(git -C "$SRC" rev-parse HEAD)"
[ "$COMMIT" = "$HERMES_COMMIT" ] || { echo "fetched $COMMIT, expected $HERMES_COMMIT" >&2; exit 1; }
echo "hermes source: $HERMES_REF @ $COMMIT"

# ---- phase 1: same subset upstream has in /opt/hermes while pm stages its tools ----
mkdir -p "$ROOT/hermes_cli" "$ROOT/scripts/bundles"
cp -a "$SRC/pm" "$ROOT/"
cp "$SRC/hermes_constants.py" "$ROOT/"
cp "$SRC/hermes_cli/__init__.py" "$SRC/hermes_cli/runtime_state.py" "$ROOT/hermes_cli/"
cp "$SRC/scripts/bundles/payload.py" "$ROOT/scripts/bundles/"
cd "$ROOT"

# uv/chromium/npm are always staged (pinned; the image has no Chromium, and its node is far
# newer than upstream's). ffmpeg and ripgrep are staged only if the image lacks them.
PM_TOOLS="uv chromium npm"
command -v ffmpeg >/dev/null || PM_TOOLS="$PM_TOOLS ffmpeg"
command -v rg >/dev/null || PM_TOOLS="$PM_TOOLS ripgrep"
echo "pm tools: $PM_TOOLS"
"$BOOT" -c 'import sys; from pm import ensure; [ensure(name, explicit=True) for name in sys.argv[1:]]' $PM_TOOLS
PM_PY="$("$BOOT" -c 'from pm import installed_package; print(installed_package("python").binary)')"
BROWSER_BIN="$("$BOOT" -c 'from pm import installed_package; print(installed_package("chromium").binary)')"
"$PM_PY" --version
"$BROWSER_BIN" --version
mkdir -p /etc/hermes
printf '%s' "$BROWSER_BIN" > /etc/hermes/agent-browser-executable-path

# pm's own runtime, sealed against the pm-staged Python
"$BOOT" -c '
import sys
from pathlib import Path
from pm import stage_manager_runtime
from scripts.bundles.payload import seal_pm_runtime
root = Path("/opt/hermes"); python = Path(sys.argv[1]).resolve()
stage_manager_runtime(python=python, destination=root / "pm-runtime", project=root / "pm")
seal_pm_runtime(root, python)' "$PM_PY"

# ---- phase 2: sealed venv from the lockfile ----
cp "$SRC/pyproject.toml" "$SRC/uv.lock" "$ROOT/"
touch "$ROOT/README.md"
extra_args=(); for e in $HERMES_EXTRAS; do extra_args+=(--extra "$e"); done
"$BOOT" -m pm.build_env --source "$ROOT" --python "$PM_PY" \
  --cache "$ROOT/uv-cache" --out "$ROOT/.venv" \
  --no-install-project --sealed --record-selection "${extra_args[@]}"

# ---- phase 3: frontends (built in the source tree, products copied in below) ----
# node/npm come from pm's pinned toolchain, on PATH for this script only.
TOOL_PATH="$("$BOOT" -c 'from pm import env_for; print(env_for("npm", base_env={})["PATH"])')"
export PATH="$TOOL_PATH:$PATH"
node --version; npm --version
export HERMES_PYTHON="$PM_PY" npm_config_install_links=false
"$ROOT/.venv/bin/python" -I "$SRC/scripts/generate_icons.py" --source "$SRC" --out "$BUILD_TMP/icons"
(
  cd "$SRC"
  node scripts/build/node-deps.mjs --source "$SRC" --workspace ui-tui --workspace web
  node scripts/build/tui.mjs --source "$SRC" --out /opt/products/tui
  node scripts/build/web.mjs --source "$SRC" --icons "$BUILD_TMP/icons" --out /opt/products/web
)

# ---- phase 4: full source, products, assemble ----
tar -C "$SRC" --exclude=.git --exclude=node_modules -cf - . | tar -C "$ROOT" -xf -
mkdir -p "$ROOT/ui-tui" "$ROOT/hermes_cli/web_dist" "$ROOT/node_modules/.bin"
cp -a /opt/products/tui/. "$ROOT/ui-tui/"
cp -a /opt/products/web/. "$ROOT/hermes_cli/web_dist/"
# standalone TypeScript linting is the only node_modules runtime need upstream keeps
cp -a "$SRC/node_modules/typescript" "$ROOT/node_modules/typescript"
ln -sf ../typescript/bin/tsc "$ROOT/node_modules/.bin/tsc"
rm -rf /opt/products

( cd "$ROOT" && "$ROOT/.venv/bin/python" -m docker.build_agent )

# ---- phase 5: freeze + stamps (what makes `hermes update` treat this as an image) ----
printf 'docker\n' > "$ROOT/.install_method"
printf '{"schemaVersion":2,"commit":"%s","distribution":"docker","source":"fallback","updateMechanism":"external"}\n' \
  "$COMMIT" > "$ROOT/install-stamp.json"
"$BOOT" -c '
import json, sys
p = sys.argv[1]; s = json.load(open(p)); s["pmRuntime"] = "/opt/hermes/pm-runtime"
open(p, "w").write(json.dumps(s) + "\n")' "$ROOT/install-stamp.json"
printf '{"schema":1,"deployment_kind":"image","manager":"docker","image":"e4s","version":"%s","revision":"%s"}\n' \
  "${HERMES_REF#v}" "$COMMIT" > /etc/hermes/image-provenance.json
chmod 0444 /etc/hermes/image-provenance.json
printf '%s\n' "$HERMES_REF" > /etc/hermes/e4s-ref
rm -f "$ROOT/.venv/.lock" "$ROOT/pm-runtime/.lock"
# Precompile: /opt/hermes is not writable by users, so without this every launch recompiles.
"$ROOT/.venv/bin/python" -m compileall -q -j 0 "$ROOT" >/dev/null 2>&1 || true
# NOTE: $ROOT/uv-cache is intentionally kept. Upstream ships it as the seed that pm merges into
# $HERMES_HOME/cache/uv, so runtime plugin installs don't hit the network or build from source.
# Root-owned, never group/world writable: a non-root container user (or a Singularity user
# mapped into the image) must not be able to alter code that other users or root later run.
chown -R root:root "$ROOT" /etc/hermes
chmod -R a+rX,go-w "$ROOT"
chmod 0644 "$ROOT/tools/facts.json" 2>/dev/null || true

# ---- verify no build state leaked into /root ----
ROOT_AFTER="$(find /root -mindepth 1 -maxdepth 4 2>/dev/null | sort || true)"
LEAK="$(comm -13 <(printf '%s\n' "$ROOT_BEFORE") <(printf '%s\n' "$ROOT_AFTER"))"
if [ -n "$LEAK" ]; then
  echo "ERROR: build left files in /root:" >&2; printf '%s\n' "$LEAK" >&2; exit 1
fi

# ---- smoke tests (throwaway HERMES_HOME; nothing persists) ----
fail() { echo "SMOKE TEST FAILED: $*" >&2; exit 1; }
smoke="$BUILD_TMP/smoke"; mkdir -p "$smoke"
HV="$ROOT/.venv/bin/hermes"; HP="$ROOT/.venv/bin/python"

E4S_HERMES_WRAPPED=1 HERMES_HOME="$smoke" "$HV" --version || fail "hermes --version"
"$HP" -c "import hermes_cli, fastapi, uvicorn; print('python deps ok')" || fail "python imports"
"$HP" --version | grep -q . || fail "venv python"
[ -s "$ROOT/hermes_cli/web_dist/index.html" ] || fail "web UI build missing"
[ -d "$ROOT/ui-tui" ] && [ -n "$(ls -A "$ROOT/ui-tui")" ] || fail "TUI build missing"
grep -q "$COMMIT" "$ROOT/install-stamp.json" || fail "install stamp"

# pm-pinned tools run, and the Chromium libs resolve
node --version >/dev/null || fail "node"; npm --version >/dev/null || fail "npm"
"$BROWSER_BIN" --version >/dev/null || fail "chromium"
if command -v ldd >/dev/null; then
  missing="$(ldd "$BROWSER_BIN" 2>/dev/null | grep 'not found' || true)"
  [ -z "$missing" ] || fail "chromium missing shared libs: $missing"
fi

# E4S's own toolchain must not be shadowed
case "$(PATH="${PATH#"$TOOL_PATH":}" command -v python3 || true)" in
  "$ROOT"/*) fail "python3 resolves into $ROOT" ;;
esac
# Nothing under /opt/hermes may be group/world writable
[ -z "$(find "$ROOT" /etc/hermes ! -type l \( -perm -g+w -o -perm -o+w \) -print -quit)" ] \
  || fail "group/world-writable files under $ROOT"

# Wrapper + init (installed by the Dockerfile from container-images/_common)
[ -x /etc/e4s/hermes-wrapper.sh ] || fail "/etc/e4s/hermes-wrapper.sh missing or not executable"
[ -x /etc/e4s/hermes-init.sh ] || fail "/etc/e4s/hermes-init.sh missing or not executable"
w="$BUILD_TMP/wrapper-home"
env -u E4S_HERMES_WRAPPED HERMES_HOME=/nonexistent HERMES_CONTAINER_HOME="$w" \
  /etc/e4s/hermes-wrapper.sh --version || fail "wrapper --version"
[ -f "$w/.e4s-init-done" ] || fail "init did not complete"
[ -f "$w/config.yaml" ] || fail "init did not seed config.yaml"
[ ! -e /nonexistent ] || fail "wrapper honored inherited HERMES_HOME"
[ -z "$(find "$w" -maxdepth 0 -perm /077)" ] || fail "HERMES_HOME is not private (0700)"
if [ -f "$w/.env" ]; then [ "$(stat -c %a "$w/.env")" = 600 ] || fail ".env must be 0600"; fi
[ -n "$(find "$ROOT/hermes_cli" -name '*.pyc' -print -quit)" ] || fail "bytecode was not precompiled"

# Dashboard actually serves on loopback
port=19119
E4S_HERMES_WRAPPED=1 HERMES_HOME="$smoke" "$HV" dashboard --host 127.0.0.1 --port "$port" \
  --no-open --skip-build >"$smoke/dashboard.log" 2>&1 &
dash=$!
ok=0
for _ in $(seq 120); do
  curl -fsS -o /dev/null "http://127.0.0.1:$port/" 2>/dev/null && { ok=1; break; }
  kill -0 "$dash" 2>/dev/null || break
  sleep 0.5
done
kill "$dash" 2>/dev/null || true; wait "$dash" 2>/dev/null || true
[ "$ok" = 1 ] || { tail -n 40 "$smoke/dashboard.log" >&2; fail "dashboard did not respond on 127.0.0.1:$port"; }
echo "hermes smoke tests passed"
