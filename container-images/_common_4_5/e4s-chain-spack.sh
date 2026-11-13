#!/bin/bash

set -o pipefail

show_help() {
  cat <<USAGE
Usage: $0 [options]

Create or reuse a writable Spack chained to an existing upstream Spack.
By default, Spack and spack-packages are stored under:
  ~/.e4s/\${E4S_IID}-\${E4S_VERSION}
--latest initializes both repositories from their current default branches.
Existing clean checkouts are reused without being updated, whatever commit
they are at. --latest only affects checkouts that have to be created.
Options:
  -u, --upstream <path>      Upstream Spack root. Defaults to the currently
                             loaded SPACK_ROOT, then /spack.
  -l, --local <path>         Override the E4S release-scoped parent directory.
  -n, --name <name>          Downstream Spack directory name. Default: spack.
      --latest               Initialize both repositories from current default branches.
  -d, --develop              Deprecated alias for --latest.
      --full-history         Clone full Git history.
  -h, --help                 Show this help.
Existing invalid or dirty checkouts are left untouched and cause an error.
USAGE
  exit "$1"
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

short_sha() {
  printf '%s' "$1" | cut -c1-12
}

require_value() {
  [[ $# -ge 2 && -n "$2" ]] || fail "Option '$1' requires a value"
}

# Pinned checkout: fetch exactly one commit. Returns non-zero on failure so
# the caller can remove the partial directory.
clone_revision() {
  local repository=$1
  local commit=$2
  local destination=$3

  if [[ $full_history -eq 1 ]]; then
    git clone "$repository" "$destination" || return 1
    git -C "$destination" checkout -q --detach "$commit" || return 1
  else
    mkdir -p "$destination" || return 1
    git -C "$destination" init -q || return 1
    git -C "$destination" remote add origin "$repository" || return 1
    git -C "$destination" fetch --depth 1 origin "$commit" || return 1
    git -C "$destination" checkout -q --detach FETCH_HEAD || return 1
  fi
}

# --latest checkout: current tip of the repository's default branch.
clone_latest() {
  local repository=$1
  local destination=$2

  if [[ $full_history -eq 1 ]]; then
    git clone "$repository" "$destination" || return 1
  else
    git clone --depth 1 "$repository" "$destination" || return 1
  fi
}

# Reuse an existing clean checkout (any commit) or create a new one.
ensure_checkout() {
  local repository=$1
  local commit=$2
  local destination=$3
  local label=$4

  if [[ -e "$destination" ]]; then
    [[ -e "$destination/.git" ]] || \
      fail "$destination already exists but is not a Git checkout ($label). Choose another location or move/remove the existing directory."
    git -C "$destination" diff --quiet --ignore-submodules -- && \
      git -C "$destination" diff --cached --quiet --ignore-submodules -- || \
      fail "$destination has local changes; refusing to reuse this $label checkout. Commit/stash them or choose another location."

    local head
    head=$(git -C "$destination" rev-parse HEAD 2>/dev/null) || \
      fail "Could not read HEAD of existing $label checkout $destination"
    echo "Reusing $label checkout at $(short_sha "$head"): $destination"
    if [[ $use_latest -eq 1 ]]; then
      echo "  Note: --latest does not update existing checkouts."
    elif [[ "$head" != "$commit" ]]; then
      echo "  Note: differs from the upstream commit $(short_sha "$commit"); reused as-is."
    fi
    return 0
  fi

  if [[ $use_latest -eq 1 ]]; then
    echo "Creating $label checkout from the default branch: $destination"
    clone_latest "$repository" "$destination" || {
      rm -rf "$destination"
      fail "Failed to clone $label"
    }
  else
    echo "Creating $label checkout at $(short_sha "$commit"): $destination"
    clone_revision "$repository" "$commit" "$destination" || {
      rm -rf "$destination"
      fail "Failed to create $label checkout at commit $commit"
    }
  fi
}

upstream_spack=""
local_parent_path=""
spack_dir_name="spack"
upstream_was_explicit=0
use_latest=0
full_history=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--upstream)
      require_value "$@"
      upstream_spack=$2
      upstream_was_explicit=1
      shift 2
      ;;
    -l|--local)
      require_value "$@"
      local_parent_path=$2
      shift 2
      ;;
    -n|--name)
      require_value "$@"
      spack_dir_name=$2
      shift 2
      ;;
    --latest|-d|--develop)
      use_latest=1
      shift
      ;;
    --full-history)
      full_history=1
      shift
      ;;
    -h|--help)
      show_help 0
      ;;
    -*)
      fail "Unknown option: $1"
      ;;
    *)
      fail "Unexpected positional argument: $1. Use --upstream, --local, or --name."
      ;;
  esac
done

if [[ -z "$upstream_spack" ]]; then
  if [[ -n ${SPACK_ROOT:-} ]]; then
    upstream_spack=$SPACK_ROOT
  elif [[ -x /spack/bin/spack ]]; then
    upstream_spack=/spack
  else
    fail "Could not determine an upstream Spack. Load the intended Spack or use --upstream /path/to/spack."
  fi
fi
upstream_spack=${upstream_spack%/}

# Automatic discovery must not silently chain from an instance managed by this
# script. Managed instances carry a marker file (written at the end of setup),
# so this works for any --local or --name. An explicit --upstream is treated as
# intentional and bypasses this guard.
if [[ $upstream_was_explicit -eq 0 && -e "$upstream_spack/.e4s-chained" ]]; then
  fail "Automatically selected SPACK_ROOT is already a managed chained Spack: $upstream_spack. Select the original upstream explicitly with --upstream /path/to/spack. To intentionally chain from this instance, rerun with --upstream '$upstream_spack'."
fi

# Print this before validation so every later error identifies the selected source.
echo "Selected upstream Spack: $upstream_spack"

[[ -x "$upstream_spack/bin/spack" ]] || fail "No Spack executable at $upstream_spack/bin/spack"
[[ -f "$upstream_spack/share/spack/setup-env.sh" ]] || \
  fail "No setup-env.sh under $upstream_spack"
[[ -d "$upstream_spack/lib/spack" ]] || fail "No lib/spack under $upstream_spack"
[[ -d "$upstream_spack/etc/spack" ]] || fail "No etc/spack under $upstream_spack"

# Query the upstream with its own executable and without any downstream
# SPACK_ROOT / SPACK_SYSTEM_CONFIG_PATH leaking into the query.
upstream_exec() {
  env -u SPACK_ROOT -u SPACK_SYSTEM_CONFIG_PATH "$upstream_spack/bin/spack" "$@"
}

upstream_version_output=$(upstream_exec --version 2>/dev/null) || \
  fail "Could not query upstream Spack version from $upstream_spack"
upstream_version=$(printf '%s\n' "$upstream_version_output" | awk '{print $1}')

upstream_commit=""
if [[ -d "$upstream_spack/.git" ]]; then
  upstream_commit=$(git -c safe.directory="$upstream_spack" \
    -C "$upstream_spack" rev-parse HEAD 2>/dev/null) || upstream_commit=""
fi
if [[ -z "$upstream_commit" ]]; then
  upstream_commit=$(printf '%s\n' "$upstream_version_output" | \
    sed -n 's/.*(\([0-9a-fA-F]\{40\}\)).*/\1/p' | head -1)
fi

# The upstream spack-packages commit is only needed to pin a new checkout, so
# these lookups are best effort and only enforced when not using --latest.
upstream_packages_commit=""
upstream_packages_repo=$(upstream_exec repo list 2>/dev/null | \
  awk '$2 == "builtin" {print $NF; exit}')
if [[ -n "$upstream_packages_repo" && -d "$upstream_packages_repo" ]]; then
  upstream_packages_root=${upstream_packages_repo%/repos/spack_repo/builtin}
  if [[ -d "$upstream_packages_root/.git" ]]; then
    actual_packages_root=$(git -c safe.directory="$upstream_packages_root" \
      -C "$upstream_packages_root" rev-parse --show-toplevel 2>/dev/null) || \
      actual_packages_root=""
    if [[ "$actual_packages_root" == "$upstream_packages_root" ]]; then
      upstream_packages_commit=$(git -c safe.directory="$upstream_packages_root" \
        -C "$upstream_packages_root" rev-parse HEAD 2>/dev/null) || \
        upstream_packages_commit=""
    fi
  fi
fi

if [[ $use_latest -eq 0 ]]; then
  [[ -n "$upstream_commit" ]] || \
    fail "Upstream Spack at '$upstream_spack' reports '$upstream_version_output' without an exact commit. Refusing to select a possibly incompatible release. Use --latest only if version matching is intentionally not required."
  [[ -n "$upstream_packages_commit" ]] || \
    fail "Could not determine the upstream spack-packages commit (builtin repo '${upstream_packages_repo:-not found}' is missing, not a Git checkout, or not at its Git root). Use --latest only if version matching is intentionally not required."
fi

# Locate the upstream install tree rather than assuming <root>/opt/spack.
upstream_install_root=$(upstream_exec python -c \
  'import spack.store; print(spack.store.STORE.root)' 2>/dev/null | tail -1)
if [[ -z "$upstream_install_root" || ! -d "$upstream_install_root" ]]; then
  upstream_install_root="$upstream_spack/opt/spack"
fi
[[ -d "$upstream_install_root" ]] || \
  fail "Could not locate the upstream install tree (tried $upstream_install_root)"

if [[ -z "$local_parent_path" ]]; then
  [[ -n ${E4S_IID:-} ]] || fail "E4S_IID must be set when --local is not specified"
  [[ -n ${E4S_VERSION:-} ]] || fail "E4S_VERSION must be set when --local is not specified"
  case "$E4S_IID-$E4S_VERSION" in */*|*..*) fail "E4S_IID and E4S_VERSION must not contain / or .." ;; esac
  local_parent_path="${HOME:?HOME is not set}/.e4s/${E4S_IID}-${E4S_VERSION}"
fi
mkdir -p "$local_parent_path" || fail "Could not create $local_parent_path"
local_parent_path=$(cd "$local_parent_path" && pwd)

local_spack="$local_parent_path/$spack_dir_name"
local_packages_root="$local_parent_path/spack-packages"
local_packages_repo="$local_packages_root/repos/spack_repo/builtin"
local_module_root="$local_parent_path/modules"

echo "Upstream Spack:          $upstream_spack"
echo "Upstream version:        $upstream_version"
echo "Upstream install tree:   $upstream_install_root"
echo "Persistent directory:    $local_parent_path"
echo "Module directory:        $local_module_root"
ensure_checkout https://github.com/spack/spack.git "$upstream_commit" "$local_spack" Spack
ensure_checkout https://github.com/spack/spack-packages.git "$upstream_packages_commit" "$local_packages_root" spack-packages
[[ -d "$local_packages_repo" ]] || \
  fail "Checked-out spack-packages repository has no builtin repo at $local_packages_repo"

# Mark this checkout as managed so later automatic upstream discovery refuses
# to chain from it by accident (see the guard above).
touch "$local_spack/.e4s-chained" || fail "Could not write marker in $local_spack"

if [[ -d "$upstream_spack/opt/spack/gpg" ]]; then
  mkdir -p "$local_spack/opt/spack/gpg"
  cp -a "$upstream_spack/opt/spack/gpg/." "$local_spack/opt/spack/gpg/" 2>/dev/null || true
  chmod 700 "$local_spack/opt/spack/gpg"
  chmod -R go-rwx "$local_spack/opt/spack/gpg" 2>/dev/null || true
fi

# Spack 1.x stores compiler definitions in packages.yaml. E4S supplies its
# image-specific configuration (packages.yaml, modules.yaml, ...) in the system
# scope (/etc/spack), which both the upstream and downstream Spack instances
# read automatically. Do not copy system or user scope files into the
# persistent checkout, where they could become stale across image use.
#
# Only files that live under the upstream's own config directory
# (<upstream>/etc/spack, excluding defaults; this covers its "spack" and "site"
# scopes) are copied, and only when they supply concretizer or mirror settings.
# Query with the upstream executable so SPACK_ROOT stays downstream. Note that
# a copied file brings along everything else it contains.
config_files=$(
  for section in concretizer mirrors; do
    upstream_exec config blame "$section" 2>/dev/null
  done | awk '{print $1}' | sed 's/:[0-9]*$//' |
    awk -v prefix="$upstream_spack/etc/spack/" 'index($0, prefix) == 1' |
    grep -v '/defaults/' | sort -u
)

while IFS= read -r config_file; do
  [[ -n "$config_file" && -f "$config_file" ]] || continue
  relative_path=${config_file#"$upstream_spack/etc/spack/"}
  target="$local_spack/etc/spack/$relative_path"
  mkdir -p "$(dirname "$target")" || fail "Could not create $(dirname "$target")"
  cp "$config_file" "$target" || fail "Failed to copy $config_file"
done <<< "$config_files"

# Activate the downstream checkout for the remainder of this process. Because a
# child script cannot modify its parent's environment, print a source command at
# the end for the caller's shell.
source "$local_spack/share/spack/setup-env.sh" || fail "Failed to activate $local_spack"

# Make setup idempotent. Replacing the named upstream avoids duplicate entries
# when a persistent checkout is reused with the same container installation.
spack config --scope site remove upstreams:e4s >/dev/null 2>&1 || true
spack config --scope site add "upstreams:e4s:install_tree:$upstream_install_root" || \
  fail "Failed to configure E4S upstream install tree"

# Spack 1.x configures the builtin repository as a Git repository whose local
# checkout is selected by destination. Preserve the built-in Git URL and change
# only its destination; adding the nested repo path creates an invalid remote
# repository entry in current Spack.
spack repo set --scope site --destination "$local_packages_root" builtin >/dev/null || \
  fail "Failed to configure the local spack-packages checkout"
configured_packages_root=$(spack repo list 2>/dev/null | \
  awk '$2 == "builtin" {print $NF; exit}')
[[ "$configured_packages_root" == "$local_packages_repo" ]] || \
  fail "Builtin repository validation failed: expected $local_packages_repo, found ${configured_packages_root:-none}"

# Tcl modules. Everything that determines module names and autoload targets
# (projections, hash_length, hide_implicits, suffixes, autoload) comes from the
# upstream's system-scope modules.yaml and is inherited unchanged, so downstream
# modules autoload upstream modules by the same names. Only the location is
# overridden here, in site scope (which outranks system scope): modules go in
# the release-scoped directory without an architecture folder. MODULEPATH is
# deliberately not touched; it is set by the environment.
#
# exclude_implicits matches the upstream's module tree, which contains modules
# for explicitly installed packages only. Without it, downstream modules
# autoload implicit and external dependencies (for example an external glibc)
# that have no modulefile on MODULEPATH, and "module load" fails. The trade-off
# is that implicit dependencies are not autoloaded; link dependencies are
# reached through RPATH, as with the upstream modules.
mkdir -p "$local_module_root" || fail "Could not create $local_module_root"
spack config --scope site remove modules:default:enable >/dev/null 2>&1 || true
spack config --scope site add "modules:default:roots:tcl:$local_module_root" || fail "Failed to configure Tcl module root"
spack config --scope site add "modules:default:arch_folder:false" || fail "Failed to disable module arch folder"
spack config --scope site add "modules:default:tcl:exclude_implicits:true" || fail "Failed to exclude implicit packages from Tcl modules"
spack config --scope site add "modules:default:enable:[tcl]" || fail "Failed to enable Tcl modules"

spack config get upstreams | grep -q 'e4s:' || fail "E4S upstream configuration validation failed"
spack config get modules | grep -qF "$local_module_root" || \
  fail "Tcl module root validation failed: $local_module_root is not in the effective modules configuration"

cat <<SUMMARY

===================================================================
Downstream Spack Setup Complete
===================================================================
  Location:              $local_spack
  Spack Version:         $(spack --version)
  Upstream:              $upstream_spack
  Packages Repo:         $local_packages_root
  Persistent Directory:  $local_parent_path
  Module Directory:      $local_module_root
===================================================================
SUMMARY

if [[ -t 1 ]]; then
  bold=$(printf '\033[1m')
  cyan=$(printf '\033[1;36m')
  reset=$(printf '\033[0m')
else
  bold=""
  cyan=""
  reset=""
fi

printf '\n%s%sNEXT STEP: activate the writable Spack in this shell%s\n' \
  "$bold" "$cyan" "$reset"
printf '%s\n' '-------------------------------------------------------------------'
printf '  %ssource "%s/share/spack/setup-env.sh"%s\n' \
  "$bold" "$local_spack" "$reset"
printf '%s\n' '-------------------------------------------------------------------'

# Informational only: MODULEPATH is never modified by this script.
case ":${MODULEPATH:-}:" in
  *":$local_module_root:"*) ;;
  *)
    printf '\nNote: %s is not in MODULEPATH. Add it (for example with\n' "$local_module_root"
    printf '  "module use %s") to see modules generated by this Spack.\n' "$local_module_root"
    ;;
esac
