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
adiak@0.2.1              exaworks@0.1.0         kokkos-nvcc-wrapper@3.2.00  magma@2.6.1             py-alembic@1.5.5              py-notebook@6.1.4             py-setuptools@57.4.0                    slepc@3.16.0
adios@1.13.1             exmcutils@0.6.0        kokkos-nvcc-wrapper@3.2.00  mbedtls@2.27.0          py-apache-libcloud@1.2.1      py-ntplib@0.4.0               py-setuptools@58.2.0                    slepc@3.16.0
adios2@2.7.1             expat@2.4.1            kvtree@1.2.0                mbedtls@3.0.0           py-argon2-cffi@21.1.0         py-numpy@1.21.3               py-setuptools-rust@0.12.1               slurm@21-08-1-1
adlbx@1.0.0              faodel@1.2108.1        lapackpp@2021.04.00         memkind@1.10.1          py-async-generator@1.10       py-numpy@1.21.3               py-setuptools-scm@6.3.2                 snappy@1.1.8
aml@0.1.0                fftw@3.3.10            lapackpp@2021.04.00         mercury@1.0.1           py-attrs@21.2.0               py-oauthlib@3.1.0             py-setuptools-scm@6.3.2                 spath@0.1.0
amrex@21.11              findutils@4.8.0        lapackpp@2021.04.00         mercury@2.0.1           py-babel@2.7.0                py-packaging@21.0             py-six@1.16.0                           spath@0.1.0
amrex@21.11              flecsi@1.4.2           legion@21.03.0              mesa18@18.3.6           py-backcall@0.2.0             py-pamela@1.0.0               py-snowballstemmer@2.0.0                sqlite@3.36.0
amrex@21.11              flecsi@2.1.0           libarchive@3.5.2            metall@0.17             py-bcrypt@3.2.0               py-pandocfilters@1.4.2        py-sphinx@4.1.2                         stc@0.9.0
ant@1.10.7               flit@2.1.0             libbsd@0.11.3               metis@5.1.0             py-beniget@0.4.1              py-paramiko@2.7.1             py-sphinx-autodoc-typehints@1.12.0      strumpack@6.1.0
arborx@1.1               flux-core@0.30.0       libcap@2.25                 mfem@4.3.0              py-bleach@4.1.0               py-parse@1.18.0               py-sphinx-rtd-theme@0.5.1               strumpack@6.1.0
argobots@1.1             flux-sched@0.19.0      libcircle@0.3.0             mfem@4.3.0              py-blinker@1.4                py-parsl@1.1.0                py-sphinxcontrib-applehelp@1.0.1        strumpack@6.1.0
arpack-ng@3.8.0          fortrilinos@2.0.0      libdwarf@20180129           mfem@4.3.0              py-certifi@2021.10.8          py-parso@0.8.1                py-sphinxcontrib-devhelp@1.0.1          sundials@5.8.0
ascent@0.7.1             freetype@2.11.0        libedit@3.1-20210216        mochi-margo@0.4.3       py-certipy@0.1.3              py-periodictable@1.5.0        py-sphinxcontrib-htmlhelp@2.0.0         sundials@5.8.0
asio@1.20.0              gasnet@2021.9.0        libelf@0.8.13               mpark-variant@1.4.0     py-cffi@1.15.0                py-petsc4py@3.16.1            py-sphinxcontrib-jsmath@1.0.1           superlu@5.3.0
autoconf@2.69            gdbm@1.19              libevent@2.1.12             mpich@3.4.2             py-chardet@4.0.0              py-pexpect@4.7.0              py-sphinxcontrib-qthelp@1.0.2           superlu-dist@7.1.1
automake@1.16.3          gettext@0.21           libfabric@1.13.2            mpich@3.4.2             py-colorama@0.4.4             py-pickleshare@0.7.5          py-sphinxcontrib-serializinghtml@1.1.5  superlu-dist@7.1.1
axl@0.3.0                ginkgo@1.4.0           libffi@3.3                  mpifileutils@0.11       py-cryptography@3.4.7         py-picmistandard@0.0.14       py-sphobjinv@2.1                        superlu-dist@7.1.1
axl@0.5.0                ginkgo@1.4.0           libgcrypt@1.9.3             msgpack-c@3.1.1         py-cython@0.29.24             py-pika@0.13.0                py-sqlalchemy@1.4.20                    swig@4.0.2
axom@0.5.0               ginkgo@1.4.0           libgit2@1.1.1               munge@0.5.14            py-cython@0.29.24             py-pip@21.1.2                 py-tblib@1.6.0                          swig@4.0.2-fortran
berkeley-db@18.1.40      glib@2.70.0            libgpg-error@1.42           ncurses@6.2             py-debugpy@1.4.1              py-pip@21.1.2                 py-terminado@0.8.3                      sz@1.4.12.3
binutils@2.33.1          globalarrays@5.8       libiberty@2.33.1            netcdf-c@4.8.1          py-decorator@5.1.0            py-pluggy@0.13.0              py-testpath@0.4.2                       sz@2.1.12
binutils@2.36.1          glproto@1.4.17         libice@1.0.9                netlib-scalapack@2.1.0  py-defusedxml@0.7.1           py-ply@3.11                   py-toml@0.10.2                          tar@1.34
bison@3.8.2              gmake@4.3              libiconv@1.16               ninja@1.10.2            py-dill@0.3.4                 py-prometheus-client@0.7.1    py-tomli@1.2.1                          tasmanian@7.7
blaspp@2021.04.01        gmp@6.2.1              libidn2@2.3.0               nlohmann-json@3.10.4    py-docutils@0.17.1            py-prompt-toolkit@3.0.17      py-tornado@5.1.1                        tasmanian@7.7
blaspp@2021.04.01        googletest@1.8.1       libjpeg-turbo@2.1.0         nrm@0.1.0               py-entrypoints@0.3            py-psutil@5.8.0               py-tornado@6.1                          tau@2.31
blaspp@2021.04.01        gotcha@1.0.3           libmd@1.0.3                 numactl@2.0.14          py-fuzzywuzzy@0.18.0          py-ptyprocess@0.7.0           py-traitlets@5.0.4                      tcl@8.6.11
blt@0.4.1                gperftools@2.9.1       libmonitor@2021.04.27       nvhpc@21.9              py-gast@0.5.2                 py-py@1.9.0                   py-typed-ast@1.4.3                      texinfo@6.5
bmi@main                 hdf5@1.8.22            libnrm@0.1.0                omega-h@9.34.1          py-gevent@1.5.0               py-pybind11@2.6.2             py-typeguard@2.12.1                     trilinos@13.0.1
bolt@2.0                 hdf5@1.8.22            libogg@1.3.4                openblas@0.3.18         py-globus-sdk@3.0.2           py-pycparser@2.20             py-typing-extensions@3.10.0.2           trilinos@13.2.0
boost@1.77.0             hdf5@1.12.0            libpciaccess@0.16           openjdk@11.0.12_7       py-greenlet@1.1.0             py-pyelftools@0.26            py-urllib3@1.26.6                       turbine@1.3.0
boost@1.77.0             hdf5@1.12.1            libpng@1.6.37               openmpi@4.1.1           py-idna@2.9                   py-pygments@2.10.0            py-vcversioner@2.16.0.0                 umap@2.1.0
butterflypack@2.0.0      heffte@2.2.0           libpthread-stubs@0.4        openpmd-api@0.14.3      py-imagesize@1.1.0            py-pyjwt@2.1.0                py-warlock@1.3.3                        umpire@5.0.1
bzip2@1.0.8              heffte@2.2.0           libquo@1.3.1                openssh@8.7p1           py-iniconfig@1.1.1            py-pyjwt@2.1.0                py-warpx@21.11                          umpire@6.0.0
c-blosc@1.21.0           heffte@2.2.0           libsigsegv@2.13             openssl@1.1.1l          py-ipykernel@6.4.1            py-pymongo@3.9.0              py-warpx@21.11                          umpire@6.0.0
cabana@0.4.0             hip@4.3.1              libsm@1.2.3                 otf2@2.3                py-ipython@7.28.0             py-pynacl@1.4.0               py-warpx@21.11                          unifyfs@0.9.1
caliper@2.7.0            hip-rocclr@4.3.1       libsodium@1.0.18            papi@6.0.0.1            py-ipython-genutils@0.2.0     py-pyopenssl@19.0.0           py-wcwidth@0.1.7                        unzip@6.0
caliper@2.7.0            hipblas@4.3.1          libssh2@1.8.0               papyrus@1.0.1           py-jedi@0.18.0                py-pyparsing@2.4.7            py-webencodings@0.5.1                   upcxx@2021.3.0
camp@0.1.0               hipsparse@4.3.1        libtheora@1.1.1             parallel-netcdf@1.12.2  py-jinja2@3.0.1               py-pyrsistent@0.15.7          py-wheel@0.36.2                         util-linux-uuid@2.36.2
camp@0.2.2               hpctoolkit@2021.10.15  libtiff@4.3.0               paraview@5.9.1          py-jsonpatch@1.23             py-pytest@6.2.4               python@3.8.12                           util-macros@1.19.3
camp@0.2.2               hpcviewer@2021.10      libtool@2.4.6               parmetis@4.0.3          py-jsonpointer@1.9            py-pytest-runner@5.1          qthreads@1.16                           veloc@1.5
chai@2.4.0               hpx@1.7.1              libunistring@0.9.10         parmetis@4.0.3          py-jsonschema@2.6.0           py-python-dateutil@2.8.2      raja@0.13.0                             vtk-h@0.7.1
chai@2.4.0               hpx@1.7.1              libunwind@1.5.0             parsec@3.0.2012         py-jsonschema@3.2.0           py-python-editor@1.0.4        raja@0.14.0                             vtk-m@1.6.0
charliecloud@0.25        hsa-rocr-dev@4.3.1     libx11@1.7.0                parsec@3.0.2012         py-jupyter-client@6.1.12      py-python-json-logger@0.1.11  raja@0.14.0                             vtk-m@1.6.0
cmake@3.21.4             hsakmt-roct@4.3.1      libxau@1.0.8                pcre@8.44               py-jupyter-core@4.7.1         py-pythran@0.9.12             rankstr@0.1.0                           warpx@21.11
comgr@4.3.1              hwloc@2.6.0            libxcb@1.14                 pcre2@10.36             py-jupyter-telemetry@0.1.0    py-pytz@2021.1                readline@8.1                            warpx@21.11
conduit@0.7.2            hwloc@2.6.0            libxdmcp@1.1.2              pdsh@2.31               py-jupyterhub@1.4.1           py-pyyaml@5.3.1               redset@0.1.0                            warpx@21.11
conduit@0.7.2            hypre@2.23.0           libxext@1.3.3               pdt@3.25.1              py-jupyterlab-pygments@0.1.2  py-pyzmq@17.1.2               rempi@1.1.0                             xcb-proto@1.14.1
cub@1.12.0-rc0           hypre@2.23.0           libxml2@2.9.12              pegtl@3.2.0             py-libensemble@0.8.0          py-pyzmq@18.1.0               rocblas@4.3.1                           xerces-c@3.2.3
cuda@11.4.2              inputproto@2.3.2       libxt@1.1.5                 perl@5.34.0             py-mako@1.1.4                 py-radical-entk@1.8.0         rocfft@4.3.1                            xextproto@7.3.0
curl@7.79.0              intel-tbb@2020.3       libyaml@0.2.5               petsc@3.16.1            py-markupsafe@2.0.1           py-radical-gtod@1.6.7         rocminfo@4.3.1                          xproto@7.0.31
czmq@4.1.1               intel-xed@12.0.1       libyogrt@1.24               petsc@3.16.1            py-matplotlib-inline@0.1.2    py-radical-pilot@1.8.0        rocprim@4.3.1                           xtrans@1.3.5
darshan-runtime@3.3.1    jansson@2.13.1         libzmq@4.3.3                petsc@3.16.1            py-mistune@0.8.4              py-radical-saga@1.8.0         rocrand@4.3.1                           xz@5.2.5
darshan-util@3.3.1       json-c@0.15            llvm-amdgpu@4.3.1           pfunit@3.3.3            py-mpi4py@3.1.2               py-radical-utils@1.8.0        rocsolver@4.3.1                         yaml-cpp@0.7.0
datatransferkit@3.1-rc3  jsoncpp@1.9.4          loki@0.1.7                  phist@1.9.5             py-msgpack@1.0.2              py-regex@2020.11.13           rocsparse@4.3.1                         z3@4.8.9
diffutils@3.8            kbproto@1.0.7          lua@5.3.5                   pkgconf@1.8.0           py-mypy@0.910                 py-requests@2.25.1            roctracer-dev-api@4.3.1                 zfp@0.5.5
double-conversion@3.1.5  kokkos@3.4.01          lua-luaposix@35.0           plasma@21.8.29          py-mypy-extensions@0.4.3      py-ruamel-yaml@0.17.16        rust@1.51.0                             zfp@0.5.5
dtcmp@1.1.3              kokkos@3.4.01          lwgrp@1.0.4                 precice@2.3.0           py-nbclient@0.5.0             py-ruamel-yaml-clib@0.2.0     scr@3.0rc2                              zlib@1.2.11
dyninst@11.0.1           kokkos@3.4.01          lz4@1.9.3                   protobuf@3.18.0         py-nbconvert@6.0.1            py-scipy@1.7.1                shuffile@0.1.0                          zsh@5.8
eigen@3.4.0              kokkos@3.4.01          lzo@2.10                    pugixml@1.11.4          py-nbformat@5.1.3             py-semantic-version@2.8.2     slate@2021.05.02                        zstd@1.5.0
elfutils@0.185           kokkos-kernels@3.4.01  m4@1.4.19                   pumi@2.2.6              py-nest-asyncio@1.4.0         py-send2trash@1.5.0           slate@2021.05.02
er@0.1.0                 kokkos-kernels@3.4.01  magma@2.6.1                 py-alabaster@0.7.12     py-netifaces@0.10.5           py-setproctitle@1.1.10        slate@2021.05.02

-- linux-ubuntu20.04-x86_64 / gcc@11.1.0 ------------------------
berkeley-db@18.1.40  cmake@3.21.4   gdbm@1.19     libbsd@0.11.3         libiconv@1.16      libsigsegv@2.13  llvm@13.0.0  openssl@1.1.1l  perl-data-dumper@2.173  readline@8.1   tar@1.34                xz@5.2.5
binutils@2.36.1      diffutils@3.8  gettext@0.21  libedit@3.1-20210216  libmd@1.0.3        libtool@2.4.6    m4@1.4.19    pcre@8.44       pkgconf@1.8.0           sqlite@3.36.0  util-linux-uuid@2.36.2  z3@4.8.9
bzip2@1.0.8          expat@2.4.1    hwloc@2.6.0   libffi@3.3            libpciaccess@0.16  libxml2@2.9.12   ncurses@6.2  perl@5.34.0     python@3.8.12           swig@4.0.2     util-macros@1.19.3      zlib@1.2.11
```
