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
==> 522 installed packages
-- linux-ubuntu20.04-x86_64 / gcc@9.3.0 -------------------------
adiak@0.2.1              hipsparse@4.3.1             mpark-variant@1.4.0           py-matplotlib-inline@0.1.2              py-typed-ast@1.4.3
adios@1.13.1             hpctoolkit@2021.10.15       mpich@3.4.2                   py-mistune@0.8.4                        py-typeguard@2.12.1
adios2@2.7.1             hpcviewer@2021.10           mpich@3.4.2                   py-mpi4py@3.1.2                         py-typing-extensions@3.10.0.2
adlbx@1.0.0              hpx@1.7.1                   mpifileutils@0.11             py-msgpack@1.0.2                        py-urllib3@1.26.6
aml@0.1.0                hpx@1.7.1                   msgpack-c@3.1.1               py-mypy@0.910                           py-vcversioner@2.16.0.0
amrex@21.11              hsa-rocr-dev@4.3.1          munge@0.5.14                  py-mypy-extensions@0.4.3                py-warlock@1.3.3
amrex@21.11              hsakmt-roct@4.3.1           ncurses@6.2                   py-nbclient@0.5.0                       py-warpx@21.11
amrex@21.11              hwloc@2.6.0                 netcdf-c@4.8.1                py-nbconvert@6.0.1                      py-warpx@21.11
ant@1.10.7               hwloc@2.6.0                 netlib-scalapack@2.1.0        py-nbformat@5.1.3                       py-warpx@21.11
arborx@1.1               hypre@2.23.0                ninja@1.10.2                  py-nest-asyncio@1.4.0                   py-wcwidth@0.1.7
argobots@1.1             hypre@2.23.0                nlohmann-json@3.10.4          py-netifaces@0.10.5                     py-webencodings@0.5.1
arpack-ng@3.8.0          inputproto@2.3.2            nrm@0.1.0                     py-notebook@6.1.4                       py-wheel@0.36.2
ascent@0.7.1             intel-tbb@2020.3            numactl@2.0.14                py-ntplib@0.4.0                         python@3.8.12
asio@1.20.0              intel-xed@12.0.1            nvhpc@21.9                    py-numpy@1.21.3                         qthreads@1.16
autoconf@2.69            jansson@2.13.1              omega-h@9.34.1                py-numpy@1.21.3                         raja@0.13.0
automake@1.16.3          json-c@0.15                 openblas@0.3.18               py-oauthlib@3.1.0                       raja@0.14.0
axl@0.3.0                jsoncpp@1.9.4               openjdk@11.0.12_7             py-packaging@21.0                       raja@0.14.0
axl@0.5.0                kbproto@1.0.7               openmpi@4.1.1                 py-pamela@1.0.0                         rankstr@0.1.0
axom@0.5.0               kokkos@3.4.01               openpmd-api@0.14.3            py-pandocfilters@1.4.2                  readline@8.1
berkeley-db@18.1.40      kokkos@3.4.01               openssh@8.7p1                 py-paramiko@2.7.1                       redset@0.1.0
binutils@2.33.1          kokkos@3.4.01               openssl@1.1.1l                py-parse@1.18.0                         rempi@1.1.0
binutils@2.36.1          kokkos@3.4.01               otf2@2.3                      py-parsl@1.1.0                          rocblas@4.3.1
bison@3.8.2              kokkos-kernels@3.4.01       papi@6.0.0.1                  py-parso@0.8.1                          rocfft@4.3.1
blaspp@2021.04.01        kokkos-kernels@3.4.01       papyrus@1.0.1                 py-periodictable@1.5.0                  rocminfo@4.3.1
blaspp@2021.04.01        kokkos-nvcc-wrapper@3.2.00  parallel-netcdf@1.12.2        py-petsc4py@3.16.1                      rocprim@4.3.1
blaspp@2021.04.01        kokkos-nvcc-wrapper@3.2.00  paraview@5.9.1                py-pexpect@4.7.0                        rocrand@4.3.1
blt@0.4.1                kvtree@1.2.0                parmetis@4.0.3                py-pickleshare@0.7.5                    rocsolver@4.3.1
bmi@main                 lapackpp@2021.04.00         parmetis@4.0.3                py-picmistandard@0.0.14                 rocsparse@4.3.1
bolt@2.0                 lapackpp@2021.04.00         parsec@3.0.2012               py-pika@0.13.0                          roctracer-dev-api@4.3.1
boost@1.77.0             lapackpp@2021.04.00         parsec@3.0.2012               py-pip@21.1.2                           rust@1.51.0
boost@1.77.0             legion@21.03.0              pcre@8.44                     py-pip@21.1.2                           scr@3.0rc2
butterflypack@2.0.0      libarchive@3.5.2            pcre2@10.36                   py-pluggy@0.13.0                        shuffile@0.1.0
bzip2@1.0.8              libbsd@0.11.3               pdsh@2.31                     py-ply@3.11                             slate@2021.05.02
c-blosc@1.21.0           libcap@2.25                 pdt@3.25.1                    py-prometheus-client@0.7.1              slate@2021.05.02
cabana@0.4.0             libcircle@0.3.0             pegtl@3.2.0                   py-prompt-toolkit@3.0.17                slate@2021.05.02
caliper@2.7.0            libdwarf@20180129           perl@5.34.0                   py-psutil@5.8.0                         slepc@3.16.0
caliper@2.7.0            libedit@3.1-20210216        petsc@3.16.1                  py-ptyprocess@0.7.0                     slepc@3.16.0
camp@0.1.0               libelf@0.8.13               petsc@3.16.1                  py-py@1.9.0                             slurm@21-08-1-1
camp@0.2.2               libevent@2.1.12             petsc@3.16.1                  py-pybind11@2.6.2                       snappy@1.1.8
camp@0.2.2               libfabric@1.13.2            pfunit@3.3.3                  py-pycparser@2.20                       spath@0.1.0
chai@2.4.0               libffi@3.3                  phist@1.9.5                   py-pyelftools@0.26                      spath@0.1.0
chai@2.4.0               libgcrypt@1.9.3             pkgconf@1.8.0                 py-pygments@2.10.0                      sqlite@3.36.0
charliecloud@0.25        libgit2@1.1.1               plasma@21.8.29                py-pyjwt@2.1.0                          stc@0.9.0
cmake@3.21.4             libgpg-error@1.42           precice@2.3.0                 py-pyjwt@2.1.0                          strumpack@6.1.0
comgr@4.3.1              libiberty@2.33.1            protobuf@3.18.0               py-pymongo@3.9.0                        strumpack@6.1.0
conduit@0.7.2            libice@1.0.9                pugixml@1.11.4                py-pynacl@1.4.0                         strumpack@6.1.0
conduit@0.7.2            libiconv@1.16               pumi@2.2.6                    py-pyopenssl@19.0.0                     sundials@5.8.0
cub@1.12.0-rc0           libidn2@2.3.0               py-alabaster@0.7.12           py-pyparsing@2.4.7                      sundials@5.8.0
cuda@11.4.2              libjpeg-turbo@2.1.0         py-alembic@1.5.5              py-pyrsistent@0.15.7                    superlu@5.3.0
curl@7.79.0              libmd@1.0.3                 py-apache-libcloud@1.2.1      py-pytest@6.2.4                         superlu-dist@7.1.1
czmq@4.1.1               libmonitor@2021.04.27       py-argon2-cffi@21.1.0         py-pytest-runner@5.1                    superlu-dist@7.1.1
darshan-runtime@3.3.1    libnrm@0.1.0                py-async-generator@1.10       py-python-dateutil@2.8.2                superlu-dist@7.1.1
darshan-util@3.3.1       libogg@1.3.4                py-attrs@21.2.0               py-python-editor@1.0.4                  swig@4.0.2
datatransferkit@3.1-rc3  libpciaccess@0.16           py-babel@2.7.0                py-python-json-logger@0.1.11            swig@4.0.2-fortran
diffutils@3.8            libpng@1.6.37               py-backcall@0.2.0             py-pythran@0.9.12                       sz@1.4.12.3
double-conversion@3.1.5  libpthread-stubs@0.4        py-bcrypt@3.2.0               py-pytz@2021.1                          sz@2.1.12
dtcmp@1.1.3              libquo@1.3.1                py-beniget@0.4.1              py-pyyaml@5.3.1                         tar@1.34
dyninst@11.0.1           libsigsegv@2.13             py-bleach@4.1.0               py-pyzmq@17.1.2                         tasmanian@7.7
eigen@3.4.0              libsm@1.2.3                 py-blinker@1.4                py-pyzmq@18.1.0                         tasmanian@7.7
elfutils@0.185           libsodium@1.0.18            py-certifi@2021.10.8          py-radical-entk@1.8.0                   tau@2.31
er@0.1.0                 libssh2@1.8.0               py-certipy@0.1.3              py-radical-gtod@1.6.7                   tcl@8.6.11
exaworks@0.1.0           libtheora@1.1.1             py-cffi@1.15.0                py-radical-pilot@1.8.0                  texinfo@6.5
exmcutils@0.6.0          libtiff@4.3.0               py-chardet@4.0.0              py-radical-saga@1.8.0                   trilinos@13.0.1
expat@2.4.1              libtool@2.4.6               py-colorama@0.4.4             py-radical-utils@1.8.0                  trilinos@13.2.0
faodel@1.2108.1          libunistring@0.9.10         py-cryptography@3.4.7         py-regex@2020.11.13                     turbine@1.3.0
fftw@3.3.10              libunwind@1.5.0             py-cython@0.29.24             py-requests@2.25.1                      umap@2.1.0
findutils@4.8.0          libx11@1.7.0                py-cython@0.29.24             py-ruamel-yaml@0.17.16                  umpire@5.0.1
flecsi@1.4.2             libxau@1.0.8                py-debugpy@1.4.1              py-ruamel-yaml-clib@0.2.0               umpire@6.0.0
flecsi@2.1.0             libxcb@1.14                 py-decorator@5.1.0            py-scipy@1.7.1                          umpire@6.0.0
flit@2.1.0               libxdmcp@1.1.2              py-defusedxml@0.7.1           py-semantic-version@2.8.2               unifyfs@0.9.1
flux-core@0.30.0         libxext@1.3.3               py-dill@0.3.4                 py-send2trash@1.5.0                     unzip@6.0
flux-sched@0.19.0        libxml2@2.9.12              py-docutils@0.17.1            py-setproctitle@1.1.10                  upcxx@2021.9.0
fortrilinos@2.0.0        libxt@1.1.5                 py-entrypoints@0.3            py-setuptools@57.4.0                    util-linux-uuid@2.36.2
freetype@2.11.0          libyaml@0.2.5               py-fuzzywuzzy@0.18.0          py-setuptools@58.2.0                    util-macros@1.19.3
gasnet@2021.9.0          libyogrt@1.24               py-gast@0.5.2                 py-setuptools-rust@0.12.1               veloc@1.5
gdbm@1.19                libzmq@4.3.3                py-gevent@1.5.0               py-setuptools-scm@6.3.2                 vtk-h@0.7.1
gettext@0.21             llvm-amdgpu@4.3.1           py-globus-sdk@3.0.2           py-setuptools-scm@6.3.2                 vtk-m@1.6.0
ginkgo@1.4.0             loki@0.1.7                  py-greenlet@1.1.0             py-six@1.16.0                           vtk-m@1.6.0
ginkgo@1.4.0             lua@5.3.5                   py-idna@2.9                   py-snowballstemmer@2.0.0                warpx@21.11
ginkgo@1.4.0             lua-luaposix@35.0           py-imagesize@1.1.0            py-sphinx@4.1.2                         warpx@21.11
glib@2.70.0              lwgrp@1.0.4                 py-iniconfig@1.1.1            py-sphinx-autodoc-typehints@1.12.0      warpx@21.11
globalarrays@5.8         lz4@1.9.3                   py-ipykernel@6.4.1            py-sphinx-rtd-theme@0.5.1               xcb-proto@1.14.1
glproto@1.4.17           lzo@2.10                    py-ipython@7.28.0             py-sphinxcontrib-applehelp@1.0.1        xerces-c@3.2.3
gmake@4.3                m4@1.4.19                   py-ipython-genutils@0.2.0     py-sphinxcontrib-devhelp@1.0.1          xextproto@7.3.0
gmp@6.2.1                magma@2.6.1                 py-jedi@0.18.0                py-sphinxcontrib-htmlhelp@2.0.0         xproto@7.0.31
googletest@1.8.1         magma@2.6.1                 py-jinja2@3.0.1               py-sphinxcontrib-jsmath@1.0.1           xtrans@1.3.5
gotcha@1.0.3             mbedtls@2.27.0              py-jsonpatch@1.23             py-sphinxcontrib-qthelp@1.0.2           xz@5.2.5
gperftools@2.9.1         mbedtls@3.0.0               py-jsonpointer@1.9            py-sphinxcontrib-serializinghtml@1.1.5  yaml-cpp@0.7.0
hdf5@1.8.22              memkind@1.10.1              py-jsonschema@2.6.0           py-sphobjinv@2.1                        z3@4.8.9
hdf5@1.8.22              mercury@1.0.1               py-jsonschema@3.2.0           py-sqlalchemy@1.4.20                    zfp@0.5.5
hdf5@1.12.0              mercury@2.0.1               py-jupyter-client@6.1.12      py-tblib@1.6.0                          zfp@0.5.5
hdf5@1.12.1              mesa18@18.3.6               py-jupyter-core@4.7.1         py-terminado@0.8.3                      zlib@1.2.11
heffte@2.2.0             metall@0.17                 py-jupyter-telemetry@0.1.0    py-testpath@0.4.2                       zsh@5.8
heffte@2.2.0             metis@5.1.0                 py-jupyterhub@1.4.1           py-toml@0.10.2                          zstd@1.5.0
heffte@2.2.0             mfem@4.3.0                  py-jupyterlab-pygments@0.1.2  py-tomli@1.2.1
hip@4.3.1                mfem@4.3.0                  py-libensemble@0.8.0          py-tornado@5.1.1
hip-rocclr@4.3.1         mfem@4.3.0                  py-mako@1.1.4                 py-tornado@6.1
hipblas@4.3.1            mochi-margo@0.4.3           py-markupsafe@2.0.1           py-traitlets@5.0.4

-- linux-ubuntu20.04-x86_64 / gcc@11.1.0 ------------------------
berkeley-db@18.1.40  expat@2.4.1    libedit@3.1-20210216  libsigsegv@2.13  ncurses@6.2             pkgconf@1.8.0  tar@1.34                zlib@1.2.11
binutils@2.36.1      gdbm@1.19      libffi@3.3            libtool@2.4.6    openssl@1.1.1l          python@3.8.12  util-linux-uuid@2.36.2
bzip2@1.0.8          gettext@0.21   libiconv@1.16         libxml2@2.9.12   pcre@8.44               readline@8.1   util-macros@1.19.3
cmake@3.21.4         hwloc@2.6.0    libmd@1.0.3           llvm@13.0.0      perl@5.34.0             sqlite@3.36.0  xz@5.2.5
diffutils@3.8        libbsd@0.11.3  libpciaccess@0.16     m4@1.4.19        perl-data-dumper@2.173  swig@4.0.2     z3@4.8.9
```
