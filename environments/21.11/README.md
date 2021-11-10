# E4S Release 21.11

November 2021 release of E4S

## Files

* `spack-x86_64.yaml` -- Model Spack environment, for x86_64
* `spack-ppc64le.yaml` -- Model Spack environment, for ppc64le
  
*Specs in the Model Spack Environment are commented out if (a) there are outstanding build issues or (b) if their Spack package does not offer a versioned installation option*


## Spack Version

E4S 21.11 uses Spack branch `e4s-21.11`
* https://github.com/spack/spack
* Branch [e4s-21.11](https://github.com/spack/spack/tree/e4s-21.11)


## Spack Build Cache

* https://cache.e4s.io/21.11

```
$> spack mirror add E4S https://cache.e4s.io/21.11
$> spack buildcache keys -it
```

## Model Environment

* Built and tested on Ubuntu 20.04 w/ GCC 9.3.0 for most packages, GCC 11.1.0 for `LLVM@13` for x86_64
* Built and tested on Ubuntu 18.04 w/ GCC 7.5.0 for most packages, GCC 11.1.0 for `LLVM@13` for ppc64le
* Docker container images:
  * `ecpe4s/ubuntu20.04-runner-x86_64:2021-11-01`
  * `ecpe4s/ubuntu18.04-runner-ppc64le:2021-11-01`
* Output of `spack find` for x86_64 model environment
```
# spack find
==> 481 installed packages
-- linux-ubuntu20.04-x86_64 / gcc@9.3.0 -------------------------
adiak@0.2.1              googletest@1.8.1       libyaml@0.2.5             py-blinker@1.4                py-psutil@5.8.0                         python@3.8.12
adios@1.13.1             gotcha@1.0.3           libyogrt@1.24             py-certifi@2021.10.8          py-ptyprocess@0.7.0                     qthreads@1.16
adios2@2.7.1             gperftools@2.9.1       libzmq@4.3.3              py-certipy@0.1.3              py-py@1.9.0                             raja@0.13.0
adlbx@1.0.0              hdf5@1.8.22            llvm-amdgpu@4.3.1         py-cffi@1.15.0                py-pybind11@2.6.2                       raja@0.14.0
aml@0.1.0                hdf5@1.8.22            loki@0.1.7                py-chardet@4.0.0              py-pycparser@2.20                       rankstr@0.1.0
amrex@21.11              hdf5@1.12.0            lua@5.3.5                 py-colorama@0.4.4             py-pyelftools@0.26                      readline@8.1
amrex@21.11              hdf5@1.12.1            lua-luaposix@35.0         py-cryptography@3.4.7         py-pygments@2.10.0                      redset@0.1.0
ant@1.10.7               heffte@2.2.0           lwgrp@1.0.4               py-cython@0.29.24             py-pyjwt@2.1.0                          rempi@1.1.0
arborx@1.1               heffte@2.2.0           lz4@1.9.3                 py-cython@0.29.24             py-pyjwt@2.1.0                          rocblas@4.3.1
argobots@1.1             hip@4.3.1              lzo@2.10                  py-debugpy@1.4.1              py-pymongo@3.9.0                        rocfft@4.3.1
arpack-ng@3.8.0          hip-rocclr@4.3.1       m4@1.4.19                 py-decorator@5.1.0            py-pynacl@1.4.0                         rocminfo@4.3.1
ascent@0.7.1             hipblas@4.3.1          magma@2.6.1               py-defusedxml@0.7.1           py-pyopenssl@19.0.0                     rocprim@4.3.1
asio@1.20.0              hipsparse@4.3.1        mbedtls@2.27.0            py-dill@0.3.4                 py-pyparsing@2.4.7                      rocrand@4.3.1
autoconf@2.69            hpctoolkit@2021.10.15  mbedtls@3.0.0             py-docutils@0.17.1            py-pyrsistent@0.15.7                    rocsolver@4.3.1
automake@1.16.3          hpcviewer@2021.10      memkind@1.10.1            py-entrypoints@0.3            py-pytest@6.2.4                         rocsparse@4.3.1
axl@0.3.0                hpx@1.7.1              mercury@1.0.1             py-fuzzywuzzy@0.18.0          py-pytest-runner@5.1                    roctracer-dev-api@4.3.1
axl@0.5.0                hsa-rocr-dev@4.3.1     mercury@2.0.1             py-gast@0.5.2                 py-python-dateutil@2.8.2                rust@1.51.0
axom@0.5.0               hsakmt-roct@4.3.1      mesa18@18.3.6             py-gevent@1.5.0               py-python-editor@1.0.4                  scr@3.0rc2
berkeley-db@18.1.40      hwloc@2.6.0            metall@0.17               py-globus-sdk@3.0.2           py-python-json-logger@0.1.11            shuffile@0.1.0
binutils@2.33.1          hypre@2.23.0           metis@5.1.0               py-greenlet@1.1.0             py-pythran@0.9.12                       slate@2021.05.02
binutils@2.36.1          inputproto@2.3.2       mfem@4.3.0                py-idna@2.9                   py-pytz@2021.1                          slate@2021.05.02
blaspp@2021.04.01        intel-tbb@2020.3       mfem@4.3.0                py-imagesize@1.1.0            py-pyyaml@5.3.1                         slepc@3.16.0
blaspp@2021.04.01        intel-xed@12.0.1       mochi-margo@0.4.3         py-iniconfig@1.1.1            py-pyzmq@17.1.2                         slurm@21-08-1-1
blt@0.4.1                jansson@2.13.1         mpark-variant@1.4.0       py-ipykernel@6.4.1            py-pyzmq@18.1.0                         snappy@1.1.8
bmi@main                 json-c@0.15            mpich@3.4.2               py-ipython@7.28.0             py-radical-entk@1.8.0                   spath@0.1.0
bolt@2.0                 jsoncpp@1.9.4          mpifileutils@0.11         py-ipython-genutils@0.2.0     py-radical-gtod@1.6.7                   spath@0.1.0
boost@1.77.0             kbproto@1.0.7          msgpack-c@3.1.1           py-jedi@0.18.0                py-radical-pilot@1.8.0                  sqlite@3.36.0
boost@1.77.0             kokkos@3.4.01          munge@0.5.14              py-jinja2@3.0.1               py-radical-saga@1.8.0                   stc@0.9.0
butterflypack@2.0.0      kokkos@3.4.01          ncurses@6.2               py-jsonpatch@1.23             py-radical-utils@1.8.0                  strumpack@6.1.0
bzip2@1.0.8              kokkos@3.4.01          netcdf-c@4.8.1            py-jsonpointer@1.9            py-regex@2020.11.13                     strumpack@6.1.0
c-blosc@1.21.0           kokkos-kernels@3.4.01  netlib-scalapack@2.1.0    py-jsonschema@2.6.0           py-requests@2.25.1                      sundials@5.8.0
cabana@0.4.0             kvtree@1.2.0           ninja@1.10.2              py-jsonschema@3.2.0           py-ruamel-yaml@0.17.16                  superlu@5.3.0
caliper@2.7.0            lapackpp@2021.04.00    nlohmann-json@3.10.4      py-jupyter-client@6.1.12      py-ruamel-yaml-clib@0.2.0               superlu-dist@7.1.1
camp@0.1.0               lapackpp@2021.04.00    nrm@0.1.0                 py-jupyter-core@4.7.1         py-scipy@1.7.1                          swig@4.0.2
camp@0.2.2               legion@21.03.0         numactl@2.0.14            py-jupyter-telemetry@0.1.0    py-semantic-version@2.8.2               swig@4.0.2-fortran
chai@2.4.0               libarchive@3.5.2       nvhpc@21.9                py-jupyterhub@1.4.1           py-send2trash@1.5.0                     sz@1.4.12.3
charliecloud@0.25        libbsd@0.11.3          omega-h@9.34.1            py-jupyterlab-pygments@0.1.2  py-setproctitle@1.1.10                  sz@2.1.12
cmake@3.21.4             libcap@2.25            openblas@0.3.18           py-libensemble@0.8.0          py-setuptools@57.4.0                    tar@1.34
comgr@4.3.1              libcircle@0.3.0        openjdk@11.0.12_7         py-mako@1.1.4                 py-setuptools@58.2.0                    tasmanian@7.7
conduit@0.7.2            libdwarf@20180129      openmpi@4.1.1             py-markupsafe@2.0.1           py-setuptools-rust@0.12.1               tau@2.30.2
conduit@0.7.2            libedit@3.1-20210216   openpmd-api@0.14.3        py-matplotlib-inline@0.1.2    py-setuptools-scm@6.3.2                 tcl@8.6.11
curl@7.79.0              libelf@0.8.13          openssh@8.7p1             py-mistune@0.8.4              py-setuptools-scm@6.3.2                 texinfo@6.5
czmq@4.1.1               libevent@2.1.12        openssl@1.1.1l            py-mpi4py@3.1.2               py-six@1.16.0                           trilinos@13.0.1
darshan-runtime@3.3.1    libfabric@1.13.2       otf2@2.3                  py-msgpack@1.0.2              py-snowballstemmer@2.0.0                turbine@1.3.0
darshan-util@3.3.1       libffi@3.3             papi@6.0.0.1              py-mypy@0.910                 py-sphinx@4.1.2                         umap@2.1.0
datatransferkit@3.1-rc3  libgcrypt@1.9.3        papyrus@1.0.1             py-mypy-extensions@0.4.3      py-sphinx-autodoc-typehints@1.12.0      umpire@5.0.1
diffutils@3.8            libgit2@1.1.1          parallel-netcdf@1.12.2    py-nbclient@0.5.0             py-sphinx-rtd-theme@0.5.1               umpire@6.0.0
double-conversion@3.1.5  libgpg-error@1.42      paraview@5.9.1            py-nbconvert@6.0.1            py-sphinxcontrib-applehelp@1.0.1        unifyfs@0.9.1
dtcmp@1.1.3              libiberty@2.33.1       parmetis@4.0.3            py-nbformat@5.1.3             py-sphinxcontrib-devhelp@1.0.1          unzip@6.0
dyninst@11.0.1           libice@1.0.9           parsec@3.0.2012           py-nest-asyncio@1.4.0         py-sphinxcontrib-htmlhelp@2.0.0         upcxx@2021.3.0
eigen@3.4.0              libiconv@1.16          pcre@8.44                 py-netifaces@0.10.5           py-sphinxcontrib-jsmath@1.0.1           util-linux-uuid@2.36.2
elfutils@0.185           libjpeg-turbo@2.1.0    pdsh@2.31                 py-notebook@6.1.4             py-sphinxcontrib-qthelp@1.0.2           util-macros@1.19.3
er@0.1.0                 libmd@1.0.3            pdt@3.25.1                py-ntplib@0.4.0               py-sphinxcontrib-serializinghtml@1.1.5  veloc@1.5
exaworks@0.1.0           libmonitor@2021.04.27  pegtl@3.2.0               py-numpy@1.21.3               py-sphobjinv@2.1                        vtk-h@0.7.1
exmcutils@0.6.0          libnrm@0.1.0           perl@5.34.0               py-numpy@1.21.3               py-sqlalchemy@1.4.20                    vtk-m@1.6.0
expat@2.4.1              libogg@1.3.4           petsc@3.16.1              py-oauthlib@3.1.0             py-tblib@1.6.0                          warpx@21.11
faodel@1.2108.1          libpciaccess@0.16      pfunit@3.3.3              py-packaging@21.0             py-terminado@0.8.3                      warpx@21.11
fftw@3.3.10              libpng@1.6.37          phist@1.9.5               py-pamela@1.0.0               py-testpath@0.4.2                       warpx@21.11
findutils@4.8.0          libpthread-stubs@0.4   pkgconf@1.8.0             py-pandocfilters@1.4.2        py-toml@0.10.2                          xcb-proto@1.14.1
flecsi@1.4.2             libquo@1.3.1           plasma@21.8.29            py-paramiko@2.7.1             py-tomli@1.2.1                          xerces-c@3.2.3
flit@2.1.0               libsigsegv@2.13        precice@2.3.0             py-parse@1.18.0               py-tornado@5.1.1                        xextproto@7.3.0
flux-core@0.30.0         libsm@1.2.3            protobuf@3.18.0           py-parsl@1.1.0                py-tornado@6.1                          xproto@7.0.31
flux-sched@0.19.0        libsodium@1.0.18       pugixml@1.11.4            py-parso@0.8.1                py-traitlets@5.0.4                      xtrans@1.3.5
fortrilinos@2.0.0        libssh2@1.8.0          pumi@2.2.6                py-periodictable@1.5.0        py-typed-ast@1.4.3                      xz@5.2.5
freetype@2.11.0          libtheora@1.1.1        py-alabaster@0.7.12       py-petsc4py@3.16.1            py-typeguard@2.12.1                     yaml-cpp@0.7.0
gasnet@2021.9.0          libtiff@4.3.0          py-alembic@1.5.5          py-pexpect@4.7.0              py-typing-extensions@3.10.0.2           z3@4.8.9
gdbm@1.19                libtool@2.4.6          py-apache-libcloud@1.2.1  py-pickleshare@0.7.5          py-urllib3@1.26.6                       zfp@0.5.5
gettext@0.21             libunwind@1.5.0        py-argon2-cffi@21.1.0     py-picmistandard@0.0.14       py-vcversioner@2.16.0.0                 zlib@1.2.11
ginkgo@1.4.0             libx11@1.7.0           py-async-generator@1.10   py-pika@0.13.0                py-warlock@1.3.3                        zsh@5.8
ginkgo@1.4.0             libxau@1.0.8           py-attrs@21.2.0           py-pip@21.1.2                 py-warpx@21.11                          zstd@1.5.0
glib@2.70.0              libxcb@1.14            py-babel@2.7.0            py-pip@21.1.2                 py-warpx@21.11
globalarrays@5.8         libxdmcp@1.1.2         py-backcall@0.2.0         py-pluggy@0.13.0              py-warpx@21.11
glproto@1.4.17           libxext@1.3.3          py-bcrypt@3.2.0           py-ply@3.11                   py-wcwidth@0.1.7
gmake@4.3                libxml2@2.9.12         py-beniget@0.4.1          py-prometheus-client@0.7.1    py-webencodings@0.5.1
gmp@6.2.1                libxt@1.1.5            py-bleach@4.1.0           py-prompt-toolkit@3.0.17      py-wheel@0.36.2

-- linux-ubuntu20.04-x86_64 / gcc@11.1.0 ------------------------
berkeley-db@18.1.40  diffutils@3.8  hwloc@2.6.0           libiconv@1.16      libtool@2.4.6   ncurses@6.2     perl-data-dumper@2.173  sqlite@3.36.0           util-macros@1.19.3
binutils@2.36.1      expat@2.4.1    libbsd@0.11.3         libmd@1.0.3        libxml2@2.9.12  openssl@1.1.1l  pkgconf@1.8.0           swig@4.0.2              xz@5.2.5
bzip2@1.0.8          gdbm@1.19      libedit@3.1-20210216  libpciaccess@0.16  llvm@13.0.0     pcre@8.44       python@3.8.12           tar@1.34                z3@4.8.9
cmake@3.21.4         gettext@0.21   libffi@3.3            libsigsegv@2.13    m4@1.4.19       perl@5.34.0     readline@8.1            util-linux-uuid@2.36.2  zlib@1.2.11
```
