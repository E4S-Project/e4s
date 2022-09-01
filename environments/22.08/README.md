# E4S Release 22.08

August 2022 release of E4S

## Files

* `cuda-x86_64.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm.spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs
* `oneapi.spack.yaml` -- Model Spack Environment for systems w/ Intel GPUs
  
*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a non-branch tracking version.*


## Spack Version

E4S 22.08 uses Spack branch `e4s-22.08`
* https://github.com/spack/spack
* Branch [e4s-22.08](https://github.com/spack/spack/tree/e4s-22.08)


## Spack Build Cache

* https://cache.e4s.io/22.08

```
$> spack mirror add E4S https://cache.e4s.io/22.08
$> spack buildcache keys -it
```

## Model Environments

* For NVIDIA GPUs on x86_64 refer to:
  * `cuda-x86_64.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-08-01`

* For NVIDIA GPUs on ppc64le refer to:
  * `cuda-ppc64le.spack.yaml`
  * Built and tested using:
    * `Ubuntu 18.04, GCC 7.5.0`
    * `ecpe4s/ubuntu18.04-runner-ppc64le:2022-08-01`

* For NVIDIA GPUs on aarch64 refer to:
  * `cuda-aarch64.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-aarch64:2022-08-01`

* For AMD GPUs refer to:
  * `rocm.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-08-01`

* For OneAPI and Intel GPUs refer to:
  * `oneapi.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-08-01`

* Output of `spack find` following installation of `cuda-x86_64.spack.yaml` model environment. Here we've installed all +cuda packages w/ both `cuda_arch=70` (V100) and `cuda_arch=80` (A100).
```
root@d8d252f1a181:/# spack find
==> 845 installed packages
-- linux-ubuntu20.04-x86_64 / gcc@9.4.0 -------------------------
adiak@0.2.2                         hypre@2.25.0                   pflotran@3.0.2                              py-mccabe@0.7.0                    py-statsmodels@0.13.2
adios@1.13.1                        icu4c@67.1                     pfunit@3.3.3                                py-mistune@0.8.4                   py-tables@3.6.1
adios2@2.8.3                        inputproto@2.3.2               phist@1.9.5                                 py-mock@4.0.3                      py-tblib@1.6.0
adios2@2.8.3                        intel-tbb@2020.3               pigz@2.7                                    py-mpi4py@3.1.2                    py-terminado@0.12.1
adios2@2.8.3                        intel-tbb@2021.5.0             pixman@0.40.0                               py-mpi4py@3.1.2                    py-threadpoolctl@3.0.0
adlbx@1.0.0                         intel-xed@2022.04.17           pkgconf@1.8.0                               py-mpi4py@3.1.2                    py-tifffile@2021.11.2
adlbx@1.0.0                         jansson@2.14                   plasma@21.8.29                              py-msgpack@1.0.3                   py-tinycss2@1.1.1
adlbx@1.0.0                         jansson@2.14                   plumed@2.8.0                                py-mypy-extensions@0.4.3           py-toml@0.10.2
alquimia@1.0.9                      jq@1.6                         pmix@4.1.2                                  py-mypy-extensions@0.4.3           py-tomli@1.2.2
alsa-lib@1.2.3.2                    json-c@0.16                    precice@2.5.0                               py-natsort@7.1.1                   py-tomli@1.2.2
aml@0.2.0                           jsoncpp@1.9.4                  protobuf@21.1                               py-nbclassic@0.3.5                 py-tomli-w@1.0.0
amrex@22.08                         kbproto@1.0.7                  pruners-ninja@1.0.1                         py-nbclient@0.6.6                  py-tomlkit@0.11.0
amrex@22.08                         kim-api@2.2.1                  pugixml@1.11.4                              py-nbclient@0.6.6                  py-tornado@5.1.1
amrex@22.08                         kokkos@3.6.00                  pumi@2.2.7                                  py-nbconvert@6.5.0                 py-tornado@6.1
ant@1.10.7                          kokkos@3.6.00                  py-alembic@1.5.5                            py-nbconvert@6.5.0                 py-tornado@6.1
antlr@2.7.7                         kokkos@3.6.00                  py-anyio@3.5.0                              py-nbformat@5.4.0                  py-traitlets@5.3.0
arborx@1.2                          kokkos@3.6.01                  py-apache-libcloud@1.2.1                    py-nbformat@5.4.0                  py-traitlets@5.3.0
arborx@1.2                          kokkos@3.6.01                  py-argon2-cffi@21.3.0                       py-nest-asyncio@1.5.4              py-traitlets@5.3.0
arborx@1.2                          kokkos@3.6.01                  py-argon2-cffi@21.3.0                       py-nest-asyncio@1.5.4              py-typeguard@2.12.1
archer@2.0.0                        kokkos@3.6.01                  py-argon2-cffi-bindings@21.2.0              py-nest-asyncio@1.5.4              py-typing-extensions@4.3.0
argobots@1.1                        kokkos@3.6.01                  py-argon2-cffi-bindings@21.2.0              py-netifaces@0.10.5                py-typing-extensions@4.3.0
argobots@main                       kokkos@3.6.01                  py-astroid@2.11.6                           py-netifaces@0.10.5                py-urllib3@1.26.6
arpack-ng@3.8.0                     kokkos-kernels@3.6.00          py-asttokens@2.0.5                          py-networkx@2.7.1                  py-urllib3@1.26.6
ascent@0.8.0                        kokkos-kernels@3.6.00          py-asttokens@2.0.5                          py-nodeenv@1.3.3                   py-urllib3@1.26.6
ascent@0.8.0                        kokkos-kernels@3.6.00          py-asttokens@2.0.5                          py-notebook@6.4.12                 py-vcversioner@2.16.0.0
ascent@0.8.0                        kokkos-nvcc-wrapper@3.2.00     py-async-generator@1.10                     py-notebook@6.4.12                 py-virtualenv@20.10.0
asio@1.21.0                         kokkos-nvcc-wrapper@3.2.00     py-attrs@21.4.0                             py-ntplib@0.4.0                    py-warlock@1.3.3
assimp@5.2.4                        krb5@1.19.3                    py-attrs@21.4.0                             py-numexpr@2.8.3                   py-warpx@22.08
autoconf@2.69                       kvtree@1.3.0                   py-autograd@1.3                             py-numexpr@2.8.3                   py-warpx@22.08
autoconf@2.69                       lammps@20220623                py-babel@2.9.1                              py-numpy@1.21.5                    py-warpx@22.08
autoconf-archive@2022.02.11         lapackpp@2022.05.00            py-backcall@0.2.0                           py-numpy@1.23.2                    py-wcwidth@0.2.5
automake@1.16.5                     lapackpp@2022.05.00            py-backports-entry-points-selectable@1.1.1  py-numpy@1.23.2                    py-wcwidth@0.2.5
automake@1.16.5                     lcms@2.13.1                    py-bcrypt@3.2.0                             py-oauthlib@3.1.1                  py-webencodings@0.5.1
axl@0.3.0                           legion@21.03.0                 py-beautifulsoup4@4.10.0                    py-opentuner@0.8.7                 py-websocket-client@1.2.1
axl@0.6.0                           libarchive@3.5.2               py-beniget@0.4.1                            py-packaging@21.3                  py-wheel@0.37.1
axom@0.6.1                          libbsd@0.11.5                  py-black@22.6.0                             py-packaging@21.3                  py-wheel@0.37.1
bdftopcf@1.0.5                      libcap@2.65                    py-black@22.6.0                             py-packaging@21.3                  py-widgetsnbextension@3.6.0
berkeley-db@18.1.40                 libcircle@0.3.0                py-black@22.6.0                             py-pamela@1.0.0                    py-wrapt@1.13.3
binutils@2.38                       libdwarf@20180129              py-bleach@4.1.0                             py-pandas@1.4.3                    py-ytopt-autotune@1.1.0
bison@3.8.2                         libedit@3.1-20210216           py-blinker@1.4                              py-pandas@1.4.3                    py-zipp@3.6.0
blaspp@2022.05.00                   libedit@3.1-20210216           py-bottleneck@1.3.2                         py-pandocfilters@1.5.0             py-zipp@3.6.0
blaspp@2022.05.00                   libevent@2.1.12                py-bottleneck@1.3.2                         py-paramiko@2.7.1                  py-zipp@3.6.0
blt@0.5.1                           libfabric@1.14.1               py-certifi@2021.10.8                        py-paramz@0.9.5                    py-zope-event@4.5.0
bolt@2.0                            libffi@3.4.2                   py-certifi@2021.10.8                        py-parse@1.18.0                    py-zope-event@4.5.0
boost@1.79.0                        libfontenc@1.1.3               py-certifi@2021.10.8                        py-parsl@1.1.0                     py-zope-interface@5.4.0
boost@1.79.0                        libgcrypt@1.10.1               py-certipy@0.1.3                            py-parso@0.8.2                     py-zope-interface@5.4.0
boost@1.79.0                        libgit2@1.3.1                  py-cffi@1.15.0                              py-parso@0.8.2                     pygmo@2.18.0
boost@1.79.0                        libgpg-error@1.45              py-cffi@1.15.0                              py-pathspec@0.9.0                  python@3.8.13
boost@1.79.0                        libiberty@2.37                 py-cffi@1.15.0                              py-pathspec@0.9.0                  python@3.8.13
boost@1.79.0                        libice@1.0.9                   py-cfgv@2.0.1                               py-patsy@0.5.2                     qhull@2020.2
boost@1.79.0                        libiconv@1.16                  py-charset-normalizer@2.0.12                py-periodictable@1.5.0             qt@5.15.5
boost@1.79.0                        libidn2@2.3.0                  py-charset-normalizer@2.0.12                py-petsc4py@3.17.4                 qthreads@1.16
boost@1.79.0                        libjpeg-turbo@2.1.3            py-charset-normalizer@2.0.12                py-pexpect@4.8.0                   raja@2022.03.0
boost@1.79.0                        libmd@1.0.4                    py-cinemasci@1.7.0                          py-pexpect@4.8.0                   raja@2022.03.0
boost@1.79.0                        libmng@2.0.3                   py-click@8.0.3                              py-pickleshare@0.7.5               raja@2022.03.0
boost@1.79.0                        libmonitor@2021.11.08          py-click@8.0.3                              py-pickleshare@0.7.5               randrproto@1.5.0
bricks@r0.1                         libnrm@0.1.0                   py-cloudpickle@1.6.0                        py-picmistandard@0.0.19            rankstr@0.1.0
bricks@r0.1                         libogg@1.3.5                   py-colorama@0.4.4                           py-pika@0.13.0                     rankstr@0.2.0
butterflypack@2.1.1                 libpciaccess@0.16              py-configspace@0.4.20                       py-pillow@9.2.0                    readline@8.1.2
bzip2@1.0.8                         libpng@1.6.37                  py-cppy@1.1.0                               py-pillow@9.2.0                    readline@8.1.2
c-blosc@1.21.1                      libpthread-stubs@0.4           py-cppy@1.1.0                               py-pip@22.1.2                      redset@0.2.0
ca-certificates-mozilla@2022-07-19  libquo@1.3.1                   py-cryptography@3.2.1                       py-pip@22.1.2                      redset@0.2.0
cabana@0.5.0                        libsigsegv@2.13                py-cryptography@3.4.8                       py-pkgconfig@1.5.5                 rempi@1.1.0
cabana@0.5.0                        libsm@1.2.3                    py-cycler@0.11.0                            py-platformdirs@2.4.1              renderproto@0.11.1
cabana@0.5.0                        libsodium@1.0.18               py-cycler@0.11.0                            py-platformdirs@2.4.1              ruby@3.1.0
cairo@1.16.0                        libssh2@1.10.0                 py-cython@0.29.30                           py-platformdirs@2.4.1              ruby-hpricot@0.8.6
caliper@2.8.0                       libtheora@1.1.1                py-cython@0.29.30                           py-pluggy@1.0.0                    ruby-mustache@1.1.1
caliper@2.8.0                       libtiff@4.4.0                  py-cython@0.29.30                           py-pluggy@1.0.0                    ruby-rdiscount@2.2.0.2
caliper@2.8.0                       libtool@2.4.7                  py-cython@3.0.0a9                           py-pluggy@1.0.0                    ruby-ronn@0.7.3
camp@2022.03.0                      libunistring@0.9.10            py-cython@3.0.0a9                           py-ply@3.11                        rust@1.60.0
camp@2022.03.0                      libunwind@1.6.2                py-debugpy@1.5.1                            py-poetry-core@1.0.8               scr@3.0
camp@2022.03.0                      libx11@1.7.0                   py-debugpy@1.5.1                            py-pre-commit@2.20.0               shuffile@0.2.0
chai@2022.03.0                      libxau@1.0.8                   py-decorator@5.1.1                          py-prometheus-client@0.12.0        slate@2022.06.00
chai@2022.03.0                      libxcb@1.14                    py-decorator@5.1.1                          py-prompt-toolkit@3.0.29           slate@2022.06.00
chai@2022.03.0                      libxdmcp@1.1.2                 py-defusedxml@0.7.1                         py-prompt-toolkit@3.0.29           slate@2022.06.00
cinch@master                        libxext@1.3.3                  py-deprecation@2.1.0                        py-psutil@5.8.0                    slepc@3.17.2
cli11@1.9.1                         libxfont@1.5.2                 py-dill@0.3.4                               py-psutil@5.8.0                    slepc@3.17.2
cmake@3.23.3                        libxkbcommon@1.4.0             py-dill@0.3.4                               py-ptyprocess@0.7.0                slepc@3.17.2
cmake@3.23.3                        libxkbfile@1.0.9               py-distlib@0.3.4                            py-pure-eval@0.2.2                 slurm@21-08-8-2
conduit@0.8.3                       libxml2@2.9.13                 py-docutils@0.18.1                          py-pure-eval@0.2.2                 snappy@1.1.9
cub@1.16.0                          libxrandr@1.5.0                py-editables@0.3                            py-pure-eval@0.2.2                 spath@0.2.0
cuda@11.4.4                         libxrender@0.9.10              py-editables@0.3                            py-py@1.11.0                       spath@0.2.0
curl@7.84.0                         libxt@1.1.5                    py-entrypoints@0.4                          py-py@1.11.0                       sqlite@3.39.2
curl@7.84.0                         libyaml@0.2.5                  py-executing@0.8.2                          py-py@1.11.0                       sqlite@3.39.2
czmq@4.1.1                          libyogrt@1.27                  py-executing@0.8.2                          py-py@1.11.0                       stc@0.9.0
darshan-runtime@3.4.0               libzmq@4.3.4                   py-executing@0.8.2                          py-py@1.11.0                       stc@0.9.0
darshan-util@3.4.0                  llvm@8.0.0                     py-fastjsonschema@2.15.1                    py-pyaml@21.8.3                    strumpack@6.3.1
datatransferkit@3.1-rc3             llvm@12.0.1                    py-filelock@3.5.0                           py-pybind11@2.8.1                  strumpack@6.3.1
diffutils@3.8                       llvm-openmp-ompt@tr6_forwards  py-filelock@3.5.0                           py-pybind11@2.9.1                  strumpack@6.3.1
docbook-xml@4.5                     loki@0.1.7                     py-flit@3.6.0                               py-pycparser@2.20                  sundials@6.2.0
docbook-xsl@1.79.2                  lua@5.3.5                      py-flit-core@3.6.0                          py-pycparser@2.20                  sundials@6.2.0
double-conversion@3.1.5             lua@5.3.5                      py-flit-core@3.6.0                          py-pycparser@2.20                  sundials@6.2.0
doxygen@1.9.4                       lua-luaposix@35.0              py-fn-py@0.5.2                              py-pyelftools@0.26                 superlu@5.3.0
dtcmp@1.1.4                         lwgrp@1.0.5                    py-fonttools@4.31.2                         py-pygments@2.10.0                 superlu-dist@7.2.0
dyninst@12.2.0                      lz4@1.9.3                      py-fonttools@4.31.2                         py-pygments@2.10.0                 superlu-dist@7.2.0
dyninst@12.2.0                      lzo@2.10                       py-future@0.18.2                            py-pyjwt@2.4.0                     superlu-dist@7.2.0
eigen@3.4.0                         m4@1.4.19                      py-future@0.18.2                            py-pyjwt@2.4.0                     superlu-dist@7.2.0
elfutils@0.186                      magma@2.6.2                    py-gast@0.5.3                               py-pylint@2.14.4                   swig@4.0.2
er@0.2.0                            magma@2.6.2                    py-gevent@1.5.0                             py-pymongo@3.12.1                  swig@4.0.2-fortran
er@0.3.0                            mbedtls@2.28.0                 py-gevent@1.5.0                             py-pymoo@0.5.0                     sz@1.4.12.3
exaworks@0.1.0                      memkind@1.13.0                 py-gevent@21.12.0                           py-pynacl@1.5.0                    sz@2.1.12.2
exmcutils@0.6.0                     mercury@2.1.0                  py-gevent@21.12.0                           py-pyopenssl@19.0.0                sz@2.1.12.2
expat@2.4.8                         mesa@21.3.8                    py-globus-sdk@3.0.2                         py-pyparsing@3.0.6                 tar@1.34
faodel@1.2108.1                     meson@0.62.2                   py-gpy@1.9.9                                py-pyparsing@3.0.6                 tasmanian@7.7
ffmpeg@4.4.1                        metall@0.21                    py-greenlet@1.1.2                           py-pyparsing@3.0.6                 tasmanian@7.7
fftw@3.3.10                         metis@5.1.0                    py-greenlet@1.1.2                           py-pyro4@4.81                      tasmanian@7.7
fftw@3.3.10                         mfem@4.4.0                     py-greenlet@1.1.2                           py-pyrsistent@0.18.0               tau@2.31.1
findutils@4.9.0                     mfem@4.4.0                     py-h5py@3.6.0                               py-pyrsistent@0.18.0               tau@2.31.1
flecsi@1.4.2                        mfem@4.4.0                     py-hatchling@1.4.1                          py-python-dateutil@2.8.2           tcl@8.6.12
flecsi@2.1.0                        mkfontdir@1.0.7                py-hatchling@1.4.1                          py-python-dateutil@2.8.2           texinfo@6.5
flecsi@2.1.0                        mkfontscale@1.1.2              py-hatchling@1.4.1                          py-python-dateutil@2.8.2           texinfo@6.5
flex@2.6.3                          mochi-margo@0.9.10             py-hpbandster@0.7.4                         py-python-editor@1.0.4             trilinos@13.0.1
flit@2.1.0                          mpark-variant@1.4.0            py-identify@2.5.3                           py-python-json-logger@0.1.11       trilinos@13.4.0
flux-core@0.40.0                    mpfr@4.1.0                     py-idna@3.3                                 py-pythran@0.11.0                  trilinos@13.4.0
flux-core@0.40.0                    mpich@3.4.3                    py-idna@3.3                                 py-pythran@0.11.0                  turbine@1.3.0
flux-core@0.40.0                    mpich@4.0.2                    py-idna@3.3                                 py-pytz@2021.3                     turbine@1.3.0
flux-sched@0.23.0                   mpich@4.0.2                    py-imageio@2.16.0                           py-pytz@2021.3                     turbine@1.3.0
font-util@1.3.2                     mpich@4.0.2                    py-importlib-resources@5.3.0                py-pywavelets@1.1.1                udunits@2.2.28
fontconfig@2.13.94                  mpifileutils@0.11.1            py-importlib-resources@5.3.0                py-pyyaml@6.0                      umap@2.1.0
fontsproto@2.1.3                    munge@0.5.15                   py-importlib-resources@5.3.0                py-pyyaml@6.0                      umpire@2022.03.1
fortrilinos@2.0.0                   nasm@2.15.05                   py-ipykernel@6.9.1                          py-pyyaml@6.0                      umpire@2022.03.1
freetype@2.11.1                     nccmp@1.9.0.1                  py-ipykernel@6.9.1                          py-pyyaml@6.0                      umpire@2022.03.1
gasnet@2022.3.0                     nco@5.0.1                      py-ipykernel@6.9.1                          py-pyzmq@17.1.2                    umpire@2022.03.1
gawk@5.1.1                          ncurses@6.2                    py-ipyparallel@6.3.0                        py-pyzmq@22.3.0                    unifyfs@0.9.2
gdbm@1.19                           ncurses@6.3                    py-ipython@8.0.1                            py-pyzmq@22.3.0                    unzip@6.0
gdbm@1.19                           netcdf-c@4.8.1                 py-ipython@8.0.1                            py-pyzmq@22.3.0                    upcxx@2022.3.0
geopm@1.1.0                         netlib-scalapack@2.2.0         py-ipython@8.0.1                            py-pyzmq@22.3.0                    util-linux-uuid@2.37.4
gettext@0.21                        netlib-scalapack@2.2.0         py-ipython-genutils@0.2.0                   py-radical-entk@1.16.0             util-macros@1.19.3
gettext@0.21                        ninja@1.11.0                   py-ipython-genutils@0.2.0                   py-radical-gtod@1.16.0             variorum@0.4.1
ginkgo@1.4.0                        ninja@1.11.0                   py-ipywidgets@7.7.0                         py-radical-pilot@1.16.0            veloc@1.5
ginkgo@1.4.0                        nlohmann-json@3.11.2           py-isort@5.9.3                              py-radical-saga@1.16.0             vtk-h@0.8.1
ginkgo@1.4.0                        nrm@0.1.0                      py-jedi@0.18.1                              py-radical-utils@1.16.0            vtk-h@0.8.1
git@2.37.0                          numactl@2.0.14                 py-jedi@0.18.1                              py-regex@2020.11.13                vtk-h@0.8.1
glew@2.2.0                          nvhpc@22.7                     py-jinja2@3.0.3                             py-requests@2.26.0                 vtk-m@1.7.1
glib@2.72.3                         omega-h@9.34.1                 py-joblib@1.1.0                             py-requests@2.26.0                 vtk-m@1.7.1
globalarrays@5.8                    oniguruma@6.9.4                py-json5@0.9.6                              py-requests@2.26.0                 vtk-m@1.7.1
glproto@1.4.17                      openblas@0.3.20                py-jsonpatch@1.23                           py-ruamel-yaml@0.17.16             vtk-m@1.8.0
glx@1.4                             opencl-clhpp@2.0.16            py-jsonpointer@1.9                          py-ruamel-yaml-clib@0.2.0          vtk-m@1.8.0
gmake@4.3                           openjdk@11.0.15_10             py-jsonschema@2.6.0                         py-scikit-image@0.18.3             vtk-m@1.8.0
gmake@4.3                           openmpi@4.1.4                  py-jsonschema@4.4.0                         py-scikit-learn@1.1.2              wannier90@3.1.0
gmp@6.2.1                           openpmd-api@0.14.5             py-jsonschema@4.4.0                         py-scikit-optimize@master          warpx@22.08
gobject-introspection@1.72.0        openssh@9.0p1                  py-jsonschema@4.4.0                         py-scipy@1.5.4                     warpx@22.08
googletest@1.8.1                    openssl@1.1.1q                 py-jupyter-client@7.1.2                     py-scipy@1.8.1                     warpx@22.08
gotcha@1.0.3                        openssl@1.1.1q                 py-jupyter-client@7.1.2                     py-scipy@1.8.1                     xcb-proto@1.14.1
gperf@3.1                           openturns@1.18                 py-jupyter-client@7.1.2                     py-semantic-version@2.10.0         xcb-util@0.4.0
gperftools@2.10                     otf2@2.3                       py-jupyter-core@4.9.2                       py-send2trash@1.8.0                xcb-util-image@0.4.0
gptune@3.0.0                        pagmo2@2.18.0                  py-jupyter-core@4.9.2                       py-serpent@1.40                    xcb-util-keysyms@0.4.0
gsl@2.7.1                           papi@6.0.0.1                   py-jupyter-core@4.9.2                       py-setproctitle@1.1.10             xcb-util-renderutil@0.3.9
h5bench@1.2                         papi@6.0.0.1                   py-jupyter-packaging11@0.12.0               py-setuptools@59.4.0               xcb-util-wm@0.4.1
harfbuzz@4.2.1                      papyrus@1.0.2                  py-jupyter-packaging7@0.7.12                py-setuptools@63.0.0               xerces-c@3.2.3
hdf5@1.8.21                         parallel-netcdf@1.12.2         py-jupyter-server@1.17.0                    py-setuptools@63.0.0               xextproto@7.3.0
hdf5@1.12.2                         paraview@5.10.1                py-jupyter-telemetry@0.1.0                  py-setuptools-rust@1.4.1           xkbcomp@1.4.4
hdf5@1.13.2                         parmetis@4.0.3                 py-jupyterhub@1.4.1                         py-setuptools-scm@6.3.2            xkbdata@1.0.1
hdf5-vol-async@1.2                  parmetis@4.0.3                 py-jupyterlab@3.4.2                         py-setuptools-scm@6.3.2            xproto@7.0.31
heffte@2.2.0                        parsec@3.0.2012                py-jupyterlab-pygments@0.1.2                py-setuptools-scm@7.0.3            xrandr@1.5.0
heffte@2.2.0                        parsec@3.0.2012                py-jupyterlab-server@2.10.3                 py-setuptools-scm@7.0.3            xtrans@1.3.5
heffte@2.2.0                        parsec@3.0.2012                py-jupyterlab-widgets@1.1.0                 py-setuptools-scm@7.0.3            xz@5.2.5
hpctoolkit@2022.05.15               pcre@8.45                      py-kiwisolver@1.3.2                         py-setuptools-scm-git-archive@1.1  yaksa@0.2
hpctoolkit@2022.05.15               pcre2@10.39                    py-kiwisolver@1.3.2                         py-setuptools-scm-git-archive@1.1  yaksa@0.2
hpcviewer@2022.06                   pdsh@2.31                      py-lazy-object-proxy@1.7.1                  py-six@1.16.0                      yaml-cpp@0.6.3
hpx@1.8.1                           pdt@3.25.1                     py-lhsmdu@1.1                               py-six@1.16.0                      yasm@1.3.0
hpx@1.8.1                           pegtl@3.2.0                    py-libensemble@0.9.2                        py-six@1.16.0                      zfp@0.5.5
hpx@1.8.1                           perl@5.34.1                    py-mako@1.1.6                               py-sniffio@1.2.0                   zfp@0.5.5
hwloc@2.8.0                         perl@5.34.1                    py-markupsafe@2.0.1                         py-soupsieve@2.2.1                 zfp@0.5.5
hwloc@2.8.0                         perl-data-dumper@2.173         py-matplotlib@3.5.3                         py-sqlalchemy@1.4.20               zlib@1.2.12
hwloc@2.8.0                         petsc@3.17.4                   py-matplotlib@3.5.3                         py-sqlalchemy@1.4.20               zsh@5.8
hwloc@2.8.0                         petsc@3.17.4                   py-matplotlib-inline@0.1.3                  py-stack-data@0.2.0                zsh@5.8
hypre@2.25.0                        petsc@3.17.4                   py-matplotlib-inline@0.1.3                  py-stack-data@0.2.0                zstd@1.5.2
hypre@2.25.0                        petsc@3.17.4                   py-matplotlib-inline@0.1.3                  py-stack-data@0.2.0                zstd@1.5.2

```
