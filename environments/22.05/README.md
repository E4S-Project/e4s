# E4S Release 22.05

May 2022 release of E4S

## Files

* `cuda-x86_64.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `rocm.spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs
* `oneapi.spack.yaml` -- Model Spack Environment for systems w/ Intel GPUs
  
*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a non-branch tracking version.*


## Spack Version

E4S 22.05 uses Spack branch `e4s-22.05`
* https://github.com/spack/spack
* Branch [e4s-22.02](https://github.com/spack/spack/tree/e4s-22.05)


## Spack Build Cache

* https://cache.e4s.io/22.05

```
$> spack mirror add E4S https://cache.e4s.io/22.05
$> spack buildcache keys -it
```

## Model Environment

* Built and tested on Ubuntu 20.04 w/ GCC 9.4.0 for x86_64
* Built and tested on Ubuntu 18.04 w/ GCC 7.5.0 for ppc64le
* Docker container images:
  * `ecpe4s/ubuntu20.04-runner-x86_64:2022-05-01`
  * `ecpe4s/ubuntu18.04-runner-ppc64le:2022-05-01`
* Output of `spack find` following installation of `cuda-x86_64.spack.yaml` model environment. Here we've installed all +cuda packages w/ both `cuda_arch=70` and `cuda_arch=80`.
```
# spack find
==> 661 installed packages
-- linux-ubuntu20.04-x86_64 / gcc@9.4.0 -------------------------
adiak@0.2.1                  heffte@2.2.0                   ninja@1.10.2                    py-jupyterlab@3.2.9                py-tornado@5.1.1
adios@1.13.1                 heffte@2.2.0                   nlohmann-json@3.10.5            py-jupyterlab-pygments@0.1.2       py-tornado@6.1
adios2@2.8.0                 heffte@2.2.0                   nrm@0.1.0                       py-jupyterlab-server@2.10.3        py-tqdm@4.62.3
adios2@2.8.0                 hpctoolkit@2022.04.15          numactl@2.0.14                  py-jupyterlab-widgets@1.1.0        py-traitlets@5.1.1
adios2@2.8.0                 hpctoolkit@2022.04.15          nvhpc@22.3                      py-kiwisolver@1.3.2                py-typeguard@2.12.1
adlbx@1.0.0                  hpcviewer@2022.03              omega-h@9.34.1                  py-lazy-object-proxy@1.4.3         py-typing-extensions@4.1.1
adlbx@1.0.0                  hpx@1.7.1                      oniguruma@6.9.4                 py-lhsmdu@1.1                      py-urllib3@1.26.6
alquimia@1.0.9               hpx@1.7.1                      openblas@0.3.20                 py-libensemble@0.9.1               py-vcversioner@2.16.0.0
alsa-lib@1.2.3.2             hpx@1.7.1                      opencl-clhpp@2.0.16             py-mako@1.1.6                      py-warlock@1.3.3
aml@0.1.0                    hwloc@2.7.1                    openjdk@11.0.14.1_1             py-markupsafe@2.0.1                py-warpx@22.05
amrex@22.05                  hwloc@2.7.1                    openmpi@4.1.3                   py-matplotlib@3.5.2                py-warpx@22.05
ant@1.10.7                   hypre@2.24.0                   openpmd-api@0.14.4              py-matplotlib@3.5.2                py-warpx@22.05
antlr@2.7.7                  hypre@2.24.0                   openssh@9.0p1                   py-matplotlib-inline@0.1.3         py-wcwidth@0.2.5
arborx@1.2                   hypre@2.24.0                   openssl@1.1.1o                  py-mccabe@0.6.1                    py-webencodings@0.5.1
arborx@1.2                   icu4c@67.1                     openturns@1.18                  py-mistune@0.8.4                   py-websocket-client@1.2.1
arborx@1.2                   inputproto@2.3.2               otf2@2.3                        py-mock@4.0.3                      py-wheel@0.37.0
archer@2.0.0                 intel-tbb@2020.3               pagmo2@2.18.0                   py-mpi4py@3.1.2                    py-widgetsnbextension@3.6.0
argobots@1.1                 intel-xed@2022.04.17           papi@6.0.0.1                    py-mpi4py@3.1.2                    py-wrapt@1.13.3
arpack-ng@3.8.0              jansson@2.13.1                 papi@6.0.0.1                    py-msgpack@1.0.3                   py-ytopt-autotune@1.1.0
ascent@0.8.0                 jq@1.6                         papyrus@1.0.2                   py-mypy-extensions@0.4.3           py-zipp@3.6.0
asio@1.21.0                  json-c@0.15                    parallel-netcdf@1.12.2          py-natsort@7.1.1                   py-zope-event@4.5.0
assimp@5.2.3                 jsoncpp@1.9.4                  paraview@5.10.1                 py-nbclassic@0.3.5                 py-zope-interface@5.4.0
autoconf@2.69                kbproto@1.0.7                  parmetis@4.0.3                  py-nbclient@0.5.5                  pygmo@2.18.0
autoconf-archive@2022.02.11  kim-api@2.2.1                  parmetis@4.0.3                  py-nbclient@0.5.5                  python@3.8.13
automake@1.16.5              kokkos@3.6.00                  parsec@3.0.2012                 py-nbconvert@6.4.2                 qhull@2020.2
axl@0.3.0                    kokkos@3.6.00                  parsec@3.0.2012                 py-nbconvert@6.4.2                 qt@5.15.4
axl@0.5.0                    kokkos@3.6.00                  parsec@3.0.2012                 py-nbformat@5.1.3                  qthreads@1.16
axom@0.6.1                   kokkos@3.6.00                  pcre@8.45                       py-nest-asyncio@1.5.4              raja@0.14.0
bdftopcf@1.0.5               kokkos@3.6.00                  pcre2@10.39                     py-netifaces@0.10.5                raja@0.14.0
berkeley-db@18.1.40          kokkos@3.6.00                  pdsh@2.31                       py-networkx@2.7.1                  raja@0.14.0
binutils@2.38                kokkos-kernels@3.6.00          pdt@3.25.1                      py-notebook@6.4.5                  randrproto@1.5.0
bison@3.8.2                  kokkos-kernels@3.6.00          pegtl@3.2.0                     py-notebook@6.4.5                  rankstr@0.1.0
blaspp@2021.04.01            kokkos-kernels@3.6.00          perl@5.34.1                     py-ntplib@0.4.0                    readline@8.1
blaspp@2021.04.01            kokkos-nvcc-wrapper@3.2.00     perl-data-dumper@2.173          py-numexpr@2.7.3                   redset@0.1.0
blt@0.4.1                    kokkos-nvcc-wrapper@3.2.00     petsc@3.17.1                    py-numexpr@2.7.3                   rempi@1.1.0
bolt@2.0                     kvtree@1.2.0                   petsc@3.17.1                    py-numpy@1.21.5                    renderproto@0.11.1
boost@1.79.0                 lammps@20220107                petsc@3.17.1                    py-numpy@1.22.3                    ruby@3.1.0
boost@1.79.0                 lapackpp@2021.04.00            petsc@3.17.1                    py-oauthlib@3.1.1                  ruby-hpricot@0.8.6
boost@1.79.0                 lapackpp@2021.04.00            pflotran@3.0.2                  py-opentuner@0.8.7                 ruby-mustache@1.1.1
boost@1.79.0                 lcms@2.9                       pfunit@3.3.3                    py-packaging@21.3                  ruby-rdiscount@2.2.0.2
boost@1.79.0                 legion@21.03.0                 phist@1.9.5                     py-pamela@1.0.0                    ruby-ronn@0.7.3
boost@1.79.0                 libarchive@3.5.2               pixman@0.40.0                   py-pandas@1.4.2                    rust@1.60.0
boost@1.79.0                 libbsd@0.11.5                  pkgconf@1.8.0                   py-pandas@1.4.2                    scr@3.0rc2
boost@1.79.0                 libcap@2.64                    plasma@21.8.29                  py-pandocfilters@1.5.0             shuffile@0.1.0
boost@1.79.0                 libcircle@0.3.0                plumed@2.6.3                    py-paramiko@2.7.1                  slate@2021.05.02
boost@1.79.0                 libdwarf@20180129              pmix@4.1.2                      py-paramz@0.9.5                    slate@2021.05.02
bricks@r0.1                  libedit@3.1-20210216           precice@2.4.0                   py-parse@1.18.0                    slate@2021.05.02
bricks@r0.1                  libevent@2.1.12                protobuf@3.18.0                 py-parsl@1.1.0                     slepc@3.17.1
butterflypack@2.1.1          libfabric@1.14.1               pruners-ninja@1.0.1             py-parso@0.8.2                     slepc@3.17.1
bzip2@1.0.8                  libffi@3.4.2                   pugixml@1.11.4                  py-pathspec@0.9.0                  slepc@3.17.1
c-blosc@1.21.1               libfontenc@1.1.3               pumi@2.2.7                      py-patsy@0.5.2                     slurm@21-08-8-2
cabana@0.4.0                 libgcrypt@1.9.4                py-alembic@1.5.5                py-periodictable@1.5.0             snappy@1.1.8
cabana@0.4.0                 libgit2@1.3.1                  py-anyio@3.5.0                  py-petsc4py@3.17.1                 spath@0.1.0
cabana@0.4.0                 libgpg-error@1.43              py-apache-libcloud@1.2.1        py-pexpect@4.8.0                   spath@0.1.0
cairo@1.16.0                 libiberty@2.37                 py-argon2-cffi@21.3.0           py-pickleshare@0.7.5               sqlite@3.38.5
caliper@2.7.0                libice@1.0.9                   py-argon2-cffi-bindings@21.2.0  py-picmistandard@0.0.19            stc@0.9.0
caliper@2.7.0                libiconv@1.16                  py-astroid@2.11.4               py-pika@0.13.0                     strumpack@6.3.1
caliper@2.7.0                libidn2@2.3.0                  py-asttokens@2.0.5              py-pillow@9.0.0                    strumpack@6.3.1
camp@0.2.2                   libjpeg-turbo@2.1.3            py-async-generator@1.10         py-pip@21.3.1                      strumpack@6.3.1
camp@0.2.2                   libmd@1.0.4                    py-attrs@21.4.0                 py-pkgconfig@1.5.5                 sundials@6.2.0
camp@0.2.2                   libmng@2.0.3                   py-autograd@1.3                 py-platformdirs@2.4.0              sundials@6.2.0
chai@2.4.0                   libmonitor@2021.11.08          py-babel@2.9.1                  py-ply@3.11                        sundials@6.2.0
chai@2.4.0                   libnrm@0.1.0                   py-backcall@0.2.0               py-poetry-core@1.0.8               superlu@5.3.0
chai@2.4.0                   libogg@1.3.5                   py-bcrypt@3.2.0                 py-prometheus-client@0.12.0        superlu-dist@7.2.0
charliecloud@0.26            libpciaccess@0.16              py-beniget@0.4.1                py-prompt-toolkit@3.0.29           superlu-dist@7.2.0
cinch@master                 libpng@1.6.37                  py-black@22.1.0                 py-psutil@5.8.0                    superlu-dist@7.2.0
cli11@1.9.1                  libpthread-stubs@0.4           py-bleach@4.1.0                 py-ptyprocess@0.7.0                superlu-dist@7.2.0
cmake@3.23.1                 libquo@1.3.1                   py-blinker@1.4                  py-pure-eval@0.2.2                 swig@4.0.2
conduit@0.8.3                libsigsegv@2.13                py-bottleneck@1.3.2             py-py@1.11.0                       swig@4.0.2-fortran
cub@1.16.0                   libsm@1.2.3                    py-bottleneck@1.3.2             py-pyaml@21.8.3                    sz@1.4.12.3
cuda@11.4.2                  libsodium@1.0.18               py-certifi@2021.10.8            py-pybind11@2.8.1                  sz@2.1.12
curl@7.83.0                  libssh2@1.10.0                 py-certipy@0.1.3                py-pycparser@2.20                  tar@1.34
czmq@4.1.1                   libtheora@1.1.1                py-cffi@1.15.0                  py-pyelftools@0.26                 tasmanian@7.7
darshan-runtime@3.3.1        libtiff@4.3.0                  py-charset-normalizer@2.0.12    py-pygments@2.10.0                 tasmanian@7.7
darshan-util@3.3.1           libtool@2.4.7                  py-cinemasci@1.7.0              py-pyjwt@2.1.0                     tasmanian@7.7
datatransferkit@3.1-rc3      libunistring@0.9.10            py-click@8.0.3                  py-pyjwt@2.1.0                     tau@2.31
diffutils@3.8                libunwind@1.6.2                py-cloudpickle@1.6.0            py-pylint@2.13.5                   tau@2.31.1
docbook-xml@4.5              libx11@1.7.0                   py-colorama@0.4.4               py-pymongo@3.12.1                  tcl@8.6.12
docbook-xsl@1.79.2           libxau@1.0.8                   py-configspace@0.4.20           py-pymoo@0.5.0                     texinfo@6.5
double-conversion@3.1.5      libxcb@1.14                    py-cppy@1.1.0                   py-pynacl@1.4.0                    trilinos@13.0.1
doxygen@1.9.3                libxdmcp@1.1.2                 py-cryptography@3.2.1           py-pyopenssl@19.0.0                trilinos@13.2.0
dtcmp@1.1.4                  libxext@1.3.3                  py-cryptography@3.4.8           py-pyparsing@3.0.6                 trilinos@13.2.0
dyninst@12.1.0               libxfont@1.5.2                 py-cycler@0.11.0                py-pyro4@4.81                      turbine@1.3.0
dyninst@12.1.0               libxkbcommon@1.4.0             py-cython@0.29.24               py-pyrsistent@0.18.0               turbine@1.3.0
eigen@3.4.0                  libxkbfile@1.0.9               py-cython@3.0.0a9               py-python-dateutil@2.8.2           udunits@2.2.28
elfutils@0.186               libxml2@2.9.13                 py-debugpy@1.5.1                py-python-editor@1.0.4             umap@2.1.0
er@0.1.0                     libxrandr@1.5.0                py-decorator@5.1.1              py-python-json-logger@0.1.11       umpire@6.0.0
exaworks@0.1.0               libxrender@0.9.10              py-defusedxml@0.7.1             py-pythran@0.10.0                  umpire@6.0.0
exmcutils@0.6.0              libxt@1.1.5                    py-deprecation@2.1.0            py-pythran@0.10.0                  umpire@6.0.0
expat@2.4.8                  libyaml@0.2.5                  py-dill@0.3.4                   py-pytz@2021.3                     umpire@6.0.0
faodel@1.2108.1              libyogrt@1.27                  py-docutils@0.18.1              py-pywavelets@1.1.1                unifyfs@0.9.2
ffmpeg@4.4.1                 libzmq@4.3.4                   py-entrypoints@0.4              py-pyyaml@6.0                      unzip@6.0
fftw@3.3.10                  llvm@8.0.0                     py-executing@0.8.2              py-pyyaml@6.0                      upcxx@2022.3.0
fftw@3.3.10                  llvm@12.0.1                    py-filelock@3.5.0               py-pyzmq@17.1.2                    util-linux-uuid@2.37.4
findutils@4.9.0              llvm-openmp-ompt@tr6_forwards  py-flit@3.6.0                   py-pyzmq@22.3.0                    util-macros@1.19.3
flecsi@1.4.2                 lmod@8.7.2                     py-flit-core@3.6.0              py-pyzmq@22.3.0                    variorum@0.4.1
flex@2.6.3                   loki@0.1.7                     py-fn-py@0.5.2                  py-radical-entk@1.11.0             veloc@1.5
flit@2.1.0                   lua@5.3.5                      py-fonttools@4.31.2             py-radical-gtod@1.6.7              vtk-h@0.8.1
flux-core@0.37.0             lua-luafilesystem@1_8_0        py-future@0.18.2                py-radical-pilot@1.11.2            vtk-m@1.7.1
flux-core@0.38.0             lua-luaposix@35.0              py-gast@0.5.3                   py-radical-saga@1.11.1             vtk-m@1.7.1
flux-core@0.38.0             lwgrp@1.0.5                    py-gevent@1.5.0                 py-radical-utils@1.11.0            vtk-m@1.7.1
flux-sched@0.22.0            lz4@1.9.3                      py-gevent@21.12.0               py-regex@2020.11.13                vtk-m@1.7.1
font-util@1.3.2              lzo@2.10                       py-globus-sdk@3.0.2             py-requests@2.26.0                 wannier90@3.1.0
fontconfig@2.13.94           m4@1.4.19                      py-gpy@1.9.9                    py-ruamel-yaml@0.17.16             warpx@22.05
fontsproto@2.1.3             magma@2.6.2                    py-greenlet@1.1.2               py-ruamel-yaml-clib@0.2.0          warpx@22.05
fortrilinos@2.0.0            magma@2.6.2                    py-h5py@3.6.0                   py-scikit-image@0.18.3             warpx@22.05
freetype@2.11.1              mbedtls@2.28.0                 py-hpbandster@0.7.4             py-scikit-learn@1.1.0              xcb-proto@1.14.1
gasnet@2022.3.0              memkind@1.13.0                 py-idna@3.3                     py-scikit-optimize@master          xcb-util@0.4.0
gawk@5.1.1                   mercury@2.1.0                  py-imageio@2.16.0               py-scipy@1.8.0                     xcb-util-image@0.4.0
gdbm@1.19                    mesa@21.3.8                    py-importlib-resources@5.3.0    py-scipy@1.8.0                     xcb-util-keysyms@0.4.0
geopm@1.1.0                  meson@0.62.1                   py-ipykernel@6.9.1              py-semantic-version@2.8.2          xcb-util-renderutil@0.3.9
gettext@0.21                 metall@0.20                    py-ipykernel@6.9.1              py-send2trash@1.8.0                xcb-util-wm@0.4.1
ginkgo@1.4.0                 metis@5.1.0                    py-ipyparallel@8.0.0            py-serpent@1.40                    xerces-c@3.2.3
ginkgo@1.4.0                 mfem@4.4.0                     py-ipython@8.0.1                py-setproctitle@1.1.10             xextproto@7.3.0
ginkgo@1.4.0                 mfem@4.4.0                     py-ipython-genutils@0.2.0       py-setuptools@59.4.0               xkbcomp@1.4.4
git@2.35.2                   mfem@4.4.0                     py-ipywidgets@7.7.0             py-setuptools-rust@0.12.1          xkbdata@1.0.1
glib@2.72.1                  mkfontdir@1.0.7                py-isort@5.9.3                  py-setuptools-scm@6.3.2            xproto@7.0.31
globalarrays@5.8             mkfontscale@1.1.2              py-jedi@0.18.1                  py-setuptools-scm-git-archive@1.1  xrandr@1.5.0
glproto@1.4.17               mochi-margo@0.9.9              py-jinja2@3.0.3                 py-six@1.16.0                      xtrans@1.3.5
gmake@4.3                    mpark-variant@1.4.0            py-joblib@1.1.0                 py-sniffio@1.2.0                   xz@5.2.5
gmp@6.2.1                    mpfr@4.1.0                     py-json5@0.9.6                  py-sqlalchemy@1.4.20               yaksa@0.2
googletest@1.8.1             mpich@3.4.3                    py-jsonpatch@1.23               py-stack-data@0.2.0                yaml-cpp@0.6.3
googletest@1.10.0            mpich@4.0.2                    py-jsonpointer@1.9              py-statsmodels@0.13.1              yasm@1.3.0
gotcha@1.0.3                 mpich@4.0.2                    py-jsonschema@2.6.0             py-tables@3.6.1                    zfp@0.5.5
gperf@3.1                    mpifileutils@0.11.1            py-jsonschema@4.4.0             py-tblib@1.6.0                     zfp@0.5.5
gperftools@2.9.1             munge@0.5.14                   py-jupyter-client@7.1.2         py-terminado@0.12.1                zfp@0.5.5
gptune@3.0.0                 nasm@2.15.05                   py-jupyter-client@7.1.2         py-testpath@0.6.0                  zlib@1.2.12
gsl@2.7.1                    nccmp@1.9.0.1                  py-jupyter-core@4.9.2           py-threadpoolctl@3.0.0             zsh@5.8
h5bench@1.2                  nco@5.0.1                      py-jupyter-packaging11@0.11.1   py-tifffile@2021.11.2              zstd@1.5.2
harfbuzz@4.2.1               ncurses@6.2                    py-jupyter-packaging7@0.7.12    py-toml@0.10.2
hdf5@1.8.22                  netcdf-c@4.8.1                 py-jupyter-server@1.13.5        py-tomli@1.2.2
hdf5@1.10.7                  netlib-scalapack@2.2.0         py-jupyter-telemetry@0.1.0      py-tomli-w@1.0.0
hdf5@1.12.2                  netlib-scalapack@2.2.0         py-jupyterhub@1.4.1             py-tomlkit@0.7.2
```
