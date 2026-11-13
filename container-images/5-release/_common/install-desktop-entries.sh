#!/bin/bash
# Add Applications-menu (XFCE) entries for the GUI tools that are actually present in this image.
#
# Each tool is described by one `entry` line at the bottom. A tool is located on PATH, then in its
# usual install dirs (/usr/local/...), then in spack's installed packages. Tools that are not found
# get no entry, and tools whose package already ships a .desktop file are left alone, so this one
# script is correct for every architecture/distro/variant. To cover a new tool, add an `entry` line.
#
# Run it after spack and the other tools are installed (the final image stages). 
set -uo pipefail

DEST="${DESKTOP_ENTRY_DIR:-/usr/local/share/applications}"
SYS_APPS=(/usr/share/applications /usr/local/share/applications)
[ -n "${SPACK_CORE_ROOT:-}" ] && [ -f "$SPACK_CORE_ROOT/share/spack/setup-env.sh" ] \
  && . "$SPACK_CORE_ROOT/share/spack/setup-env.sh"

# prefix of a spack-installed package, empty if none
spack_prefix() {
  command -v spack >/dev/null 2>&1 || return 0
  spack find --format '{prefix}' "$1" 2>/dev/null | head -n1
}

# find_exe cmd spec dir...  -> absolute path of the executable, empty if absent
find_exe() {
  local cmd=$1 spec=$2 d p
  shift 2
  if p=$(command -v "$cmd" 2>/dev/null); then echo "$p"; return; fi
  for d in "$@"; do
    for p in $d/$cmd; do [ -x "$p" ] && { echo "$p"; return; }; done
  done
  if [ -n "$spec" ]; then
    d=$(spack_prefix "$spec")
    if [ -n "$d" ]; then
      for p in "$d/bin/$cmd" "$d"/*/bin/$cmd; do [ -x "$p" ] && { echo "$p"; return; }; done
    fi
  fi
}

# entry id "Name" "Comment" "Categories" terminal cmd "spack spec|''" "exec args" "icon fallback" [dir globs...]
entry() {
  local id=$1 name=$2 comment=$3 cats=$4 term=$5 cmd=$6 spec=$7 args=$8 icon=$9 exe root ic f
  shift 9
  exe=$(find_exe "$cmd" "$spec" "$@")
  if [ -z "$exe" ]; then echo "[desktop] $name: not installed, skipping"; return; fi
  for d in "${SYS_APPS[@]}"; do
    if grep -qsE "^Exec=([^ ]*/)?$cmd[^ /]*( |$)" "$d"/*.desktop 2>/dev/null; then
      echo "[desktop] $name: already provided by the package, skipping"; return
    fi
  done
  # use an icon shipped next to the tool if there is one
  root=$(dirname "$(dirname "$(readlink -f "$exe")")")
  ic=
  case "$root" in /|/usr|/usr/local) ;; *)
    ic=$(find "$root" -maxdepth 6 \( -iname "$id.png" -o -iname "$id.svg" \) 2>/dev/null | head -n1) ;;
  esac
  mkdir -p "$DEST"
  f="$DEST/$id.desktop"
  printf '%s\n' '[Desktop Entry]' 'Type=Application' "Name=$name" "Comment=$comment" \
    "Exec=$exe${args:+ $args}" "Icon=${ic:-$icon}" "Terminal=$term" "Categories=$cats" > "$f"
  chmod 644 "$f"
  echo "[desktop] $name: $f -> $exe"
}

#     id         Name        Comment                          Categories                 term cmd       spack spec  args  fallback icon              extra dirs
entry paraview   ParaView    "Scientific data visualization"  "Graphics;Science;"        false paraview  "paraview"  "%F"  applications-science /usr/local/paraview-*/bin
entry visit      VisIt       "Scientific data visualization"  "Graphics;Science;"        false visit     ""          ""    applications-science /usr/local/visit/bin
entry paraprof   ParaProf     "TAU performance profile viewer" "Development;Profiling;"  false paraprof  "tau"       ""    utilities-system-monitor
entry codium     VSCodium    "Code editor"                    "Development;IDE;"         false codium    ""          "--no-sandbox %F" vscodium /usr/local/codium/bin
entry firefox    Firefox     "Web browser"                    "Network;WebBrowser;"      false firefox   ""          "%u"  web-browser /usr/local/firefox
#entry jupyter    "Jupyter Notebook" "Interactive notebooks"   "Development;Science;"     true  jupyter   ""          "notebook" applications-development

command -v update-desktop-database >/dev/null && update-desktop-database "$DEST" || true
exit 0
