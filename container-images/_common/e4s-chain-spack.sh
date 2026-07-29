#!/bin/bash

show_help() {
  cat <<EOF
Usage: $0 [options]
       $0 <SPACK_ROOT>

This script clones a new local Spack installation (named 'spack') and configures
it to use an upstream Spack installation. It attempts to match the upstream Spack
version and optionally handles the spack-packages repository (for Spack 1.0+).

Options:
  -u, --upstream <path>      Path to the upstream Spack installation. Defaults to
                             SPACK_ROOT if loaded, then spack_root_upstream,
                             then /spack.
  -l, --local <path>         Path where the new 'spack' directory will be created.
                             Defaults to current directory. Script will error if
                             'spack' already exists at this location.
  -n, --name <name>          Name for the new Spack directory. Defaults to 'spack'.
  -d, --develop              Use develop version of spack (do not match upstream
                             version).
  --full-history             Clone with full git history instead of shallow clone.
                             Slower but useful for development.
  -p, --packages <option>    How to handle spack-packages repo (for Spack 1.0+):
                               'upstream' - use upstream's packages repo (default)
                               'new' - let spack auto-bootstrap its own packages repo
  -h, --help                 Display this help message.

Notes:
  - To set an upstream for an *existing* local Spack, use the following
    command after initializing your Spack install:
      spack config --scope site add "upstreams:e4s:install_tree:\$UPSTREAM_SPACK_ROOT/opt/spack"
  - This script will checkout the spack version matching the upstream spack if possible
  - For Spack 1.0+, packages are in a separate repository (spack-packages)
  - Configuration settings (concretizer:reuse, concretizer:unify, mirrors) are
    automatically copied from upstream using spack config blame
  - The script will fail if a 'spack' directory already exists at the target location

Examples:

- Single argument mode:
  $0 /path/to/downstream/spack

- Create downstream Spack in current directory from loaded upstream:
  $0

- Specify upstream Spack and destination directory:
  $0 -u /path/to/upstream/spack -l /path/to/install/location

- Create downstream with new local packages repo:
  $0 -p new

- Create downstream using upstream's packages repo with custom name:
  $0 -p upstream -n my-spack
EOF
  exit "$1"
}

# Initialize variables
upstream_spack=""
local_parent_path=""  # Will default to current directory if not specified
spack_dir_name="spack"  # Name of the Spack directory to create
local_spack_arg=""  # Optional positional argument: full path to downstream Spack root
match_version=1
packages_option="upstream"  # Options: 'upstream', 'new', 'none'
full_history=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--upstream)
      upstream_spack="$2"
      shift 2
      ;;
    -l|--local)
      local_parent_path="$2"
      shift 2
      ;;
    -n|--name)
      spack_dir_name="$2"
      shift 2
      ;;
    -h|--help)
      show_help 0
      ;;
    -d|--develop)
      match_version=0
      shift
      ;;
    --full-history)
      full_history=1
      shift
      ;;
    -p|--packages)
      packages_option="$2"
      if [[ "$packages_option" != "upstream" && "$packages_option" != "new" ]]; then
        echo "Error: Invalid packages option '$packages_option'. Must be 'upstream' or 'new'."
        show_help 1
      fi
      shift 2
      ;;
    *)
      if [[ -z "$local_spack_arg" ]]; then
        local_spack_arg="$1"
        shift
      else
        echo "Error: Too many positional arguments. Expected at most one: <SPACK_ROOT>"
        show_help 1
      fi
      ;;
  esac
done

if [[ -n "$local_spack_arg" && ( -n "$local_parent_path" || "$spack_dir_name" != "spack" ) ]]; then
  echo "Error: Cannot combine positional <SPACK_ROOT> with -l/--local or -n/--name"
  show_help 1
fi

rundir=`pwd`

#Determine Upstream Spack Path
if [[ -n "$upstream_spack" ]]; then
  # Upstream Spack path is provided by the user via --upstream
  : # Do nothing, already set
elif [[ -n "$SPACK_ROOT" ]]; then
  # Upstream Spack is loaded and --upstream is not specified
  upstream_spack="$SPACK_ROOT"
elif [[ -n "$spack_root_upstream" ]]; then
  # Compatibility with e4s-chain-spack.sh
  upstream_spack="$spack_root_upstream"
else
  # Compatibility default used by e4s-chain-spack.sh
  upstream_spack="/spack"
fi

# Validate upstream Spack by checking essential files
if [[ ! -d "$upstream_spack" ]]; then
  echo "Error: Upstream Spack directory does not exist: $upstream_spack"
  show_help 1
fi

echo "Validating upstream Spack installation at: $upstream_spack"

# Check for essential Spack files
missing_files=()
if [[ ! -f "$upstream_spack/share/spack/setup-env.sh" ]]; then
  missing_files+=("share/spack/setup-env.sh")
fi
if [[ ! -f "$upstream_spack/bin/spack" ]]; then
  missing_files+=("bin/spack")
fi
if [[ ! -d "$upstream_spack/lib/spack" ]]; then
  missing_files+=("lib/spack/")
fi
if [[ ! -d "$upstream_spack/etc/spack" ]]; then
  missing_files+=("etc/spack/")
fi
if [[ ! -d "$upstream_spack/opt/spack" ]]; then
  echo "Warning: No install tree found at $upstream_spack/opt/spack"
  echo "         This upstream Spack may not have any packages installed yet."
fi

if [[ ${#missing_files[@]} -gt 0 ]]; then
  echo "Error: Invalid upstream Spack installation. Missing required files:"
  for file in "${missing_files[@]}"; do
    echo "  - $file"
  done
  exit 1
fi

echo "✓ Upstream Spack validation successful"

# Determine local Spack path
if [[ -n "$local_spack_arg" ]]; then
  local_parent_path=$(cd "$(dirname "$local_spack_arg")" && pwd)
  spack_dir_name=$(basename "$local_spack_arg")
  local_spack="$local_parent_path/$spack_dir_name"
  echo "Using explicit downstream path: $local_spack"
else
  # Handle Local Spack Parent Path (Default to current directory)
  if [[ -z "$local_parent_path" ]]; then
    local_parent_path="."
    echo "No local path specified, using current directory: $(pwd)"
  fi

  # Convert to absolute path
  local_parent_path=$(cd "$local_parent_path" && pwd)

  # Set the actual local Spack path (where we will clone to)
  local_spack="$local_parent_path/$spack_dir_name"
fi

# Check if Spack already exists at target location
if [[ -e "$local_spack" ]]; then
  echo "Error: '$local_spack' already exists."
  echo "       Please remove it first, choose a different location with -l,"
  echo "       or use a different name with -n."
  exit 1
fi

# Create parent directory if it doesn't exist
mkdir -p "$local_parent_path"

# Get upstream Spack version using spack debug report
upstream_version=""
upstream_commit=""
if [[ $match_version -eq 1 ]]; then
  # Temporarily activate upstream spack to get version info
  source "$upstream_spack/share/spack/setup-env.sh" 2>/dev/null
  
  # Try to get version from spack debug report
  # Format: * **Spack:** 1.0.2 (https://github.com/spack/spack/commit/...)
  upstream_version=$(spack debug report 2>/dev/null | grep -E '^\*\s+\*\*Spack:\*\*' | awk '{print $3}')
  
  if [[ -z "$upstream_version" ]]; then
    echo "Warning: Could not determine upstream Spack version from 'spack debug report'"
  else
    echo "Detected upstream Spack version: $upstream_version"
  fi
  
  # Also get commit hash if it's a git repo
  if [[ -d "$upstream_spack/.git" ]]; then
    upstream_commit=$(cd "$upstream_spack" && git rev-parse HEAD)
    echo "Detected upstream Spack commit: $upstream_commit"
  fi
  
  # Deactivate upstream spack
  unset SPACK_ROOT
fi

# Clone Local Spack
clone_opts=""
if [[ $full_history -eq 0 ]]; then
  clone_opts="--depth 1"
  echo "Using shallow clone (--depth 1) for faster download"
else
  echo "Cloning with full git history"
fi

if [[ $match_version -eq 1 && -n "$upstream_version" ]]; then
  echo "Cloning Spack version $upstream_version to $local_spack..."
  
  # Try to clone the specific version tag
  if git clone --branch "v$upstream_version" $clone_opts https://github.com/spack/spack "$local_spack" 2>/dev/null; then
    echo "Successfully cloned Spack version $upstream_version"
  elif git clone --branch "$upstream_version" $clone_opts https://github.com/spack/spack "$local_spack" 2>/dev/null; then
    echo "Successfully cloned Spack version $upstream_version"
  else
    echo "Warning: Could not clone specific version $upstream_version."
    
    # Try to checkout the specific commit if available
    if [[ -n "$upstream_commit" ]]; then
      echo "Attempting to clone and checkout commit $upstream_commit..."
      # For commit checkout, we need full history
      if ! git clone https://github.com/spack/spack "$local_spack"; then
        echo "Error: Failed to clone Spack to $local_spack"
        show_help 1
      fi
      
      cd "$local_spack"
      if git checkout "$upstream_commit" 2>/dev/null; then
        echo "Successfully checked out commit $upstream_commit"
      else
        echo "Warning: Could not checkout commit $upstream_commit."
        echo "This may happen if the upstream is using a private branch or local commits."
        echo "Attempting to find closest stable version..."
        
        # Try to find the closest stable release tag
        closest_tag=$(git tag -l "v*" --sort=-version:refname | grep -v "dev" | head -1)
        if [[ -n "$closest_tag" ]]; then
          git checkout "$closest_tag"
          echo "Checked out closest stable version: $closest_tag"
        else
          echo "Warning: No stable version tags found. Using latest release tag."
          latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "develop")
          git checkout "$latest_tag"
          echo "Checked out: $latest_tag"
        fi
      fi
      cd "$rundir"
    else
      echo "Warning: No commit hash available. Cloning latest stable release..."
      if ! git clone https://github.com/spack/spack "$local_spack"; then
        echo "Error: Failed to clone Spack to $local_spack"
        show_help 1
      fi
      cd "$local_spack"
      # Find the latest stable release (avoid dev versions)
      latest_stable=$(git tag -l "v*" --sort=-version:refname | grep -v "dev" | head -1)
      if [[ -n "$latest_stable" ]]; then
        git checkout "$latest_stable"
        echo "Checked out latest stable version: $latest_stable"
      else
        latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "develop")
        git checkout "$latest_tag"
        echo "Checked out: $latest_tag"
      fi
      cd "$rundir"
    fi
  fi
else
  echo "Cloning latest stable spack to $local_spack."
  if ! git clone https://github.com/spack/spack "$local_spack"; then
    echo "Error: Failed to clone Spack to $local_spack"
    show_help 1
  fi
  # When not matching version, checkout latest stable release instead of develop
  cd "$local_spack"
  latest_stable=$(git tag -l "v*" --sort=-version:refname | grep -v "dev" | head -1)
  if [[ -n "$latest_stable" ]]; then
    git checkout "$latest_stable"
    echo "Checked out latest stable version: $latest_stable"
  fi
  cd "$rundir"
fi

# Handle spack-packages repository (for Spack 1.0+)
if [[ "$packages_option" == "upstream" ]]; then
  echo "Configuring to use upstream's spack-packages repository..."
  
  # Activate upstream spack to query its repo configuration
  old_spack_root="$SPACK_ROOT"
  source "$upstream_spack/share/spack/setup-env.sh" 2>/dev/null
  
  # Get the upstream packages repo path using spack repo ls
  # Format: [+] builtin    v2.2    /path/to/repo
  # We want the last column (the path)
  upstream_packages_repo=$(spack repo ls 2>/dev/null | grep builtin | awk '{print $NF}')
  
  # Switch to local spack
  if [[ -n "$old_spack_root" ]]; then
    source "$old_spack_root/share/spack/setup-env.sh"
  else
    source "$local_spack/share/spack/setup-env.sh"
  fi
  
  # Configure local spack to use upstream's packages repo
  if [[ -n "$upstream_packages_repo" && -d "$upstream_packages_repo" ]]; then
    if spack repo add "$upstream_packages_repo" 2>/dev/null; then
      echo "✓ Configured to use upstream packages repo: $upstream_packages_repo"
    else
      echo "Warning: Failed to configure upstream packages repo. Spack will auto-bootstrap."
    fi
  else
    echo "No custom packages repository found in upstream. Spack will auto-bootstrap when needed."
  fi
  
elif [[ "$packages_option" == "new" ]]; then
  echo "Letting Spack auto-bootstrap packages repository when needed..."
fi

  # Activate local Spack
  cd "$rundir"
  if ! source "$local_spack/share/spack/setup-env.sh"; then
    echo "Failed to activate spack at $local_spack"
    exit 1
  fi

  # Enable upstreaming using spack config
  echo "Enabling upstreaming from $local_spack to $upstream_spack..."
  if ! spack config --scope site add "upstreams:e4s:install_tree:$upstream_spack/opt/spack"; then
    echo "Error: Failed to configure upstreaming. Check the Spack configuration." >&2
    exit 1
  fi

  # Copy over the upstream compilers.yaml
  cp $SPACK_ROOT/etc/spack/compilers.yaml{,.bak} >/dev/null 2>&1 || true

  if [[ -f $upstream_spack/etc/spack/compilers.yaml ]] ; then
    cp $upstream_spack/etc/spack/compilers.yaml $SPACK_ROOT/etc/spack/
  else
    echo "Warning: compilers.yaml not found in upstream $upstream_spack/etc/spack/compilers.yaml"
  fi
  # Copy GPG keys from upstream for binary package verification
  echo "Copying GPG keys from upstream..."
  if [[ -d $upstream_spack/opt/spack/gpg ]] ; then
    mkdir -p $SPACK_ROOT/opt/spack/gpg
    if cp -r $upstream_spack/opt/spack/gpg/* $SPACK_ROOT/opt/spack/gpg/ 2>/dev/null; then
      # Set secure permissions on GPG directory to avoid warnings
      chmod 700 $SPACK_ROOT/opt/spack/gpg
      chmod -R go-rwx $SPACK_ROOT/opt/spack/gpg/* 2>/dev/null || true
      echo "  GPG keys copied successfully"
    else
      echo "  Warning: GPG directory exists but no keys found or copy failed"
    fi
  else
    echo "  Warning: No GPG keys found in upstream $upstream_spack/opt/spack/gpg"
    echo "           Binary package verification may not work"
  fi
  # Copy configuration settings from upstream
  echo "Copying configuration settings from upstream..."
  
  # Temporarily activate upstream to use spack config blame
  old_spack_root="$SPACK_ROOT"
  source "$upstream_spack/share/spack/setup-env.sh" 2>/dev/null
  
  # Get the config files that define key settings using spack config blame
  # Look for concretizer:reuse, concretizer:unify, and mirrors
  # Note: awk extracts first column which contains "filepath:linenumber", so we strip the :linenumber part
  config_files=$(spack config blame config 2>/dev/null | grep -E '(concretizer:|reuse:|unify:)' | awk '{print $1}' | sed 's/:[0-9]*$//' | sort -u)
  mirrors_files=$(spack config blame mirrors 2>/dev/null | awk '{print $1}' | sed 's/:[0-9]*$//' | sort -u)
  
  # Combine and get unique non-default config files
  # Filter out: default config paths, YAML markers (---), and empty lines
  all_config_files=$(echo -e "${config_files}\n${mirrors_files}" | grep -v '/defaults/' | grep -v '^---$' | grep -v '^$' | sort -u)
  
  # Reactivate downstream spack
  source "$old_spack_root/share/spack/setup-env.sh"
  
  # Copy relevant settings
  for config_file in $all_config_files; do
    if [[ -f "$config_file" ]]; then
      # Determine the scope and filename based on the file's location in upstream
      # If the file is directly in etc/spack/ (no scope subdirectory), preserve that structure
      # Otherwise, extract and preserve the scope subdirectory (site, user, system, etc.)
      config_name=$(basename "$config_file")
      
      # Check if file has a scope subdirectory in its path
      if echo "$config_file" | grep -q "/etc/spack/site/"; then
        scope="site"
        echo "  Copying $config_name from site scope..."
        target_dir="$SPACK_ROOT/etc/spack/site"
      elif echo "$config_file" | grep -q "/etc/spack/user/"; then
        scope="user"
        echo "  Copying $config_name from user scope..."
        target_dir="$SPACK_ROOT/etc/spack/user"
      elif echo "$config_file" | grep -q "/etc/spack/system/"; then
        scope="system"
        echo "  Copying $config_name from system scope..."
        target_dir="$SPACK_ROOT/etc/spack/system"
      else
        # File is directly in etc/spack/ without a scope subdirectory
        echo "  Copying $config_name (no scope subdirectory)..."
        target_dir="$SPACK_ROOT/etc/spack"
      fi
      
      # Copy the file to the downstream spack, preserving the directory structure
      mkdir -p "$target_dir"
      cp "$config_file" "$target_dir/$config_name"
    fi
  done
  
  echo "Configuration settings copied successfully."

  # Validate the configuration
  echo ""
  echo "Validating downstream Spack configuration..."
  
  # Check that upstreaming is configured
  if spack config get upstreams | grep -q "e4s:"; then
    echo "✓ Upstreaming configuration verified"
  else
    echo "Warning: Upstreaming may not be configured correctly"
  fi
  
  # Check that setup-env.sh exists
  if [[ -f "$SPACK_ROOT/share/spack/setup-env.sh" ]]; then
    echo "✓ Spack setup script exists"
  else
    echo "Warning: Spack setup script not found"
  fi
  
  # Check that compilers.yaml was copied
  if [[ -f "$SPACK_ROOT/etc/spack/compilers.yaml" ]]; then
    echo "✓ Compilers configuration copied"
  else
    echo "Warning: No compilers.yaml found"
  fi
  
  # Check that GPG keys were copied
  if [[ -d "$SPACK_ROOT/opt/spack/gpg" ]] && [[ -n "$(ls -A $SPACK_ROOT/opt/spack/gpg 2>/dev/null)" ]]; then
    echo "✓ GPG keys copied"
  else
    echo "Warning: No GPG keys found (binary verification may fail)"
  fi

  # Display configuration summary
  echo ""
  echo "==================================================================="
  echo "Downstream Spack Setup Complete!"
  echo "==================================================================="
  echo "  Location:         $local_spack"
  echo "  Spack Version:    ${upstream_version:-develop/latest}"
  if [[ -n "$upstream_commit" ]]; then
    echo "  Commit:           ${upstream_commit:0:12}"
  fi
  echo "  Upstream:         $upstream_spack"
  echo "  Packages Repo:    $packages_option"
  echo "  Full History:     $([ $full_history -eq 1 ] && echo 'yes' || echo 'no (shallow clone)')"
  echo ""
  echo -e "To activate run: \e[1;33msource $local_spack/share/spack/setup-env.sh\e[0m"
  echo "==================================================================="

exit 0
