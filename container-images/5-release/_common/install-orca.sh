#!/bin/bash
# install-orca.sh -- Orca IDE (https://github.com/stablyai/orca) for E4S images:
# Ubuntu/Debian (deb) and Rocky/RHEL (rpm), x86_64 and aarch64.
#
# Run from a Dockerfile stage as root, with this script's directory (release-common) available,
# e.g.  RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common /tmp/e4s-common/install-orca.sh
#
# It installs the upstream package (/opt/Orca, plus the package's /usr/bin/orca-ide CLI symlink, left
# untouched), then installs next to it from this directory:
#   orca-ide.sh      -> /usr/local/bin/orca-ide                           E4S dispatcher: CLI + wrapped GUI
#   orca-ide.desktop -> /usr/local/share/applications/orca-ide.desktop    overrides the upstream entry
#                       (same desktop-id; /usr/local/share precedes /usr/share in the default
#                       XDG_DATA_DIRS, and the package's own /usr/share file is left alone)
#
# The package is downloaded to a scratch directory, checked against the SHA-256 pinned below, and
# the verified local file is what gets installed.
#   ORCA_VERSION   release to install (default below). Another version needs ORCA_SHA256 for the asset
#                  for this distro/arch, otherwise the install is refused.
#   ORCA_SHA256    SHA-256 of that asset
set -euo pipefail
umask 022

ORCA_VERSION="${ORCA_VERSION:-1.4.255}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

die() { echo "[orca] ERROR: $*" >&2; exit 1; }
[ "$(id -u)" = 0 ] || die "must run as root"
for f in orca-ide.sh orca-ide.desktop; do [ -f "$SRC/$f" ] || die "$SRC/$f not found"; done

. /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
  *" debian "*|*" ubuntu "*) FAMILY=debian ;;
  *" rhel "*|*" rocky "*|*" fedora "*|*" centos "*) FAMILY=rhel ;;
  *) die "unsupported distribution: ${PRETTY_NAME:-unknown}" ;;
esac

case "$FAMILY:$(uname -m)" in
  debian:x86_64)  ASSET="orca-ide_${ORCA_VERSION}_amd64.deb" ;;
  debian:aarch64) ASSET="orca-ide_${ORCA_VERSION}_arm64.deb" ;;
  rhel:x86_64)    ASSET="orca-ide-${ORCA_VERSION}.x86_64.rpm" ;;
  rhel:aarch64)   ASSET="orca-ide-${ORCA_VERSION}.aarch64.rpm" ;;
  *) die "unsupported architecture $(uname -m) (Orca publishes x86_64 and aarch64 packages)" ;;
esac

# SHA-256 of the v1.4.255 release assets; they match the digests GitHub publishes for them.
case "$ASSET" in
  orca-ide_1.4.255_amd64.deb)     SHA256=6df53f4f6c919fd1f10dfe3511940934acc940a7754eb1b0e896d2c62e4add5a ;;
  orca-ide_1.4.255_arm64.deb)     SHA256=c04f3c3b5c8cf8442703be18ffee09f835be860dc87dd9061c1a6cc8aaac60f0 ;;
  orca-ide-1.4.255.x86_64.rpm)    SHA256=195ec0ac2af03ca3efbe7b750759c79fc2f77e2f692eda0e9739304dece501a8 ;;
  orca-ide-1.4.255.aarch64.rpm)   SHA256=3216eabe9a3e1641cca44817920a09389fe1df53b0cf77bf056ade3934ea1517 ;;
  *) SHA256="${ORCA_SHA256:-}" ;;
esac
[[ "$SHA256" =~ ^[0-9a-f]{64}$ ]] || die "no pinned SHA-256 for $ASSET; set ORCA_SHA256 to install another version"

# ---- download and verify ----
TMP="$(mktemp -d /tmp/orca-install.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT
chmod 755 "$TMP"      # lets apt's unprivileged _apt user read the package

if ! command -v curl >/dev/null; then
  if [ "$FAMILY" = debian ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y && apt-get install -y --no-install-recommends ca-certificates curl
  else
    dnf install -y curl-minimal      # the full curl conflicts with Rocky's curl-minimal
  fi
fi

echo "[orca] Downloading $ASSET"
curl -fsSL --retry 3 --retry-connrefused \
  "https://github.com/stablyai/orca/releases/download/v${ORCA_VERSION}/${ASSET}" -o "$TMP/$ASSET" \
  || die "download of $ASSET failed"
echo "$SHA256  $TMP/$ASSET" | sha256sum -c - >/dev/null \
  || die "SHA-256 mismatch for $ASSET (expected $SHA256, got $(sha256sum "$TMP/$ASSET" | cut -d' ' -f1))"
echo "[orca] SHA-256 verified"

# ---- install ----
if [ "$FAMILY" = debian ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y "$TMP/$ASSET"
else
  # xclip and xdotool (required by orca-ide) are only in EPEL for EL9.
  epel_pkgs="xclip xdotool"
  # shellcheck disable=SC2086
  if ! dnf -q list --available $epel_pkgs >/dev/null 2>&1; then
    dnf install -y epel-release || true
    dnf install -y dnf-plugins-core && dnf config-manager --set-enabled crb || true
    # shellcheck disable=SC2086
    dnf -q list --available $epel_pkgs >/dev/null 2>&1 \
      || die "$epel_pkgs (dependencies of orca-ide) are not available. They are provided by EPEL: enable it (dnf install epel-release) or make a mirror carrying them reachable, then retry."
  fi
  dnf install -y "$TMP/$ASSET" \
    || die "dnf could not install $ASSET. Its dependencies must come from the base, AppStream and EPEL repositories (CRB if a library is missing)."
  dnf clean all
fi

# ---- verify the package and add the E4S pieces ----
[ -x /opt/Orca/orca-ide ] || die "/opt/Orca/orca-ide missing after install"
[ -x /opt/Orca/resources/bin/orca-ide ] || die "Orca CLI shim missing after install"
[ "$(readlink -f /usr/bin/orca-ide)" = /opt/Orca/resources/bin/orca-ide ] \
  || die "/usr/bin/orca-ide is not the packaged Orca CLI"
[ -u /opt/Orca/chrome-sandbox ] || echo "[orca] WARNING: /opt/Orca/chrome-sandbox is not setuid; non-root GUI needs user namespaces" >&2

install -D -m 0755 "$SRC/orca-ide.sh" /usr/local/bin/orca-ide
install -D -m 0644 "$SRC/orca-ide.desktop" /usr/local/share/applications/orca-ide.desktop
command -v update-desktop-database >/dev/null && update-desktop-database /usr/local/share/applications || true

hash -r
[ "$(command -v orca-ide)" = /usr/local/bin/orca-ide ] \
  || echo "[orca] WARNING: 'orca-ide' resolves to $(command -v orca-ide), not /usr/local/bin/orca-ide; check PATH order" >&2
echo "[orca] Orca $ORCA_VERSION installed: $(/opt/Orca/resources/bin/orca-ide --version 2>&1 | head -1)"
