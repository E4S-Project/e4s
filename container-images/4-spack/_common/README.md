# E4S Lite Container - Spack + MPICH

Welcome to the Extreme-scale Scientific Software Stack (E4S) Lite container! This container provides the base environment for an E4S installation with Spack and MPICH pre-configured.

## Quick Start

This container comes with pre-installed MPICH and a Spack instance. The Spack environment is automatically loaded on login and connected to the E4S binary repository for quick installation of E4S packages. MPICH is loaded by default and managed via modules.

## Important Files

The following helper files are available in `/etc/e4s/`:

- **README.md** (this file) - General documentation
- **spack.yaml** - E4S Spack environment configuration file
- **pingpong.c** - MPI ping-pong demo program
- **e4s-chain-spack.sh** - Upstreamed spack instance generator script
The `e4s-chain-spack.sh` command is available in your PATH for creating local, writable Spack installations backed by this image's Spack.

## Working with Read-Only Container Filesystems

Many container runtimes (especially Singularity/Apptainer) mount the container's root filesystem as read-only. Since Spack needs write access to install packages, you'll need to create a local Spack instance that uses the container's Spack as an "upstream" installation.

### Creating a Local Spack with Upstream Configuration

Use the `e4s-chain-spack.sh` command to set up a local Spack installation:

```bash
# Create a local Spack in your current directory with upstream configuration
e4s-chain-spack.sh

# The script will create a 'spack' directory with upstream already configured
cd spack
source share/spack/setup-env.sh
spack install <package>  # New packages install to your local writable Spack
```

**What this does:**
- Clones a new Spack installation matching the container's version
- Automatically configures it to use the container's Spack as an upstream
- All packages installed in the container remain available
- New packages you install go into your local writable directory
- Inherits mirror and concretizer settings from the upstream

**For advanced options** (custom locations, package repo handling, etc.):
```bash
e4s-chain-spack.sh --help
```

## Customizing Your Spack Environment

### Using the Provided spack.yaml

The `/etc/e4s/spack.yaml` file contains a comprehensive E4S environment definition. You can use it as a template:

1. **Copy it to a writable location:**
   ```bash
   mkdir -p ~/my-env
   cp /etc/e4s/spack.yaml ~/my-env/
   cd ~/my-env
   ```

2. **Edit the specs section** to add or remove packages:
   ```bash
   # Edit the specs: section in spack.yaml
   vi spack.yaml
   ```
   The packages listed in spack.yaml and their dependencies are provided prebuilt by the E4S binary repo. NOTE: The first time you install a package there may be a delay while the buildcache index downloads.  
   If you add other packges to your environment they may be built form source.

3. **Create and install the environment** (requires local Spack or writable filesystem):
   ```bash
   spack env create my-env spack.yaml
   spack env activate my-env
   spack install
   ```

### Key Configuration Settings

The provided spack.yaml includes:
- **Target architecture**: x86_64_v3
- **Compilers**: GCC 13.3.0 (system compiler)
- **MPI provider**: MPICH (pre-installed as external)
- **BLAS/LAPACK**: OpenBLAS
- **Concretizer settings**: Configured for optimal package reuse

## MPICH-Specific Information

### Pre-installed MPICH

MPICH 4.3.1 is pre-installed and configured as an external package. If it isn't already in your environment it can be loaded via:
```bash
module load mpich
```

### MPICH Configuration

- **Version**: 4.3.1
- **Device**: CH4 with OFI netmod
- **Features**: Hydra process manager, libxml2 support, ROMIO
- **Location**: `/opt/mpi/pkgs/mpich-4.3.1`

### Testing MPICH

A ping-pong demo program is included to verify your MPICH installation:

```bash
# Create a test directory and copy the demo
mkdir mpi-test
cd mpi-test
cp /etc/e4s/pingpong.c .

# Compile the program
mpicc -O2 -o pingpong pingpong.c

# Run with 2 processes
mpirun -np 2 ./pingpong
```

You should see output showing 10 iterations of ping-pong communication between two MPI ranks.

### Using MPICH with New Spack Packages

When installing MPI-dependent packages in your local Spack, they will automatically use the container's MPICH installation due to the upstream configuration. This ensures compatibility and avoids rebuilding MPI.

## Spack Tips and Best Practices

### 1. View Installed Packages
```bash
spack find              # List all installed packages
spack find -v           # Verbose (shows variants)
spack find -p <package> # Show installation path
```

### 2. Using Spack Environments
Environments allow you to manage collections of packages:
```bash
spack env create myenv
spack env activate myenv
spack add <package>
spack install
```

### 3. Viewing Package Information
```bash
spack info <package>    # Show package details
spack spec <package>    # Show what would be installed
spack graph <package>   # Show dependency graph
```

### 4. Using Binary Caches
This container is configured with the E4S binary cache mirror, which provides pre-built binaries for many packages:
```bash
spack buildcache list           # See available binaries
spack install --use-cache       # Prefer binary installs
```

### 5. Module System
Spack integrates with module systems for easy package loading:
```bash
module avail               # Show available modules
module load <package>      # Load a package
module list                # Show loaded modules
```

### 6. Troubleshooting
```bash
spack debug report         # Generate debug information
spack config blame <key>   # Show where config values come from
spack spec --fresh <pkg>   # See spec without reuse
```

## Additional Resources

- **E4S Project Website**: https://e4s.io
- **Spack Documentation**: https://spack.readthedocs.io
- **MPICH Documentation**: https://www.mpich.org/documentation/guides/
- **E4S GitHub**: https://github.com/E4S-Project

## Getting Help

For issues specific to this container or E4S, please visit:
- E4S Website: https://e4s.io
- E4S Slack: https://e4s-project.slack.com (sign up at https://e4s.io)
- E4S Github: https://github.com/E4S-Project/e4s/issues

For Spack issues:
- Spack Slack: https://spackpm.slack.com
- Spack GitHub: https://github.com/spack/spack/issues

---

**Last Updated**: February 2026  
**Container Version**: E4S 25.11  
**Spack Version**: See `spack --version`  
**MPICH Version**: 4.3.1
