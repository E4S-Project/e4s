# E4S Release 22.02

February 2022 release of E4S

## Files

* `spack.yaml` -- Model Spack environment, for x86_64
  
*Specs in the Model Spack Environment are commented out if (a) there are outstanding build issues or (b) if their Spack package does not offer a versioned installation option*


## Spack Version

E4S 22.02 uses Spack branch `e4s-22.02`
* https://github.com/spack/spack
* Branch [e4s-22.02](https://github.com/spack/spack/tree/e4s-22.02)


## Spack Build Cache

* https://cache.e4s.io/22.02

```
$> spack mirror add E4S https://cache.e4s.io/22.02
$> spack buildcache keys -it
```

## Model Environment

* Built and tested on Ubuntu 20.04 w/ GCC 9.3.0
* Built and tested on Ubuntu 18.04 w/ GCC 7.5.0
* Docker container images:
  * `ecpe4s/ubuntu20.04-runner-x86_64:2022-02-01`
  * `ecpe4s/ubuntu18.04-runner-ppc64le:2022-02-01`
* Output of `spack find` for x86_64 model environment
```
# spack find
==> 554 installed packages
-- linux-ubuntu20.04-x86_64 / gcc@9.3.0 -------------------------
adiak@0.2.1              glib@2.70.2                 libxml2@2.9.12                 py-babel@2.9.1               py-pandas@1.4.1                qthreads@1.16
adios@1.13.1             globalarrays@5.8            libxt@1.1.5                    py-backcall@0.2.0            py-paramiko@2.7.1              raja@0.14.0
adios2@2.7.1             glproto@1.4.17              libyaml@0.2.5                  py-bcrypt@3.2.0              py-paramz@0.9.5                raja@0.14.0
adlbx@1.0.0              gmake@4.3                   libyogrt@1.27                  py-beniget@0.4.1             py-parse@1.18.0                raja@0.14.0
alquimia@1.0.9           gmp@6.2.1                   libzmq@4.3.4                   py-blinker@1.4               py-parsl@1.1.0                 rankstr@0.1.0
alsa-lib@1.2.3.2         googletest@1.8.1            llvm@8.0.0                     py-bottleneck@1.3.2          py-parso@0.8.2                 readline@8.1
aml@0.1.0                gotcha@1.0.3                llvm-amdgpu@4.5.2              py-bottleneck@1.3.2          py-patsy@0.5.1                 redset@0.1.0
amrex@22.02              gperftools@2.9.1            llvm-openmp-ompt@tr6_forwards  py-certifi@2021.10.8         py-periodictable@1.5.0         rempi@1.1.0
amrex@22.02              gptune@2.1.0                loki@0.1.7                     py-certipy@0.1.3             py-petsc4py@3.16.4             rocblas@4.5.2
amrex@22.02              gsl@2.7                     lua@5.3.5                      py-cffi@1.15.0               py-pexpect@4.8.0               rocfft@4.5.2
antlr@2.7.7              hdf5@1.8.22                 lua-luaposix@35.0              py-charset-normalizer@2.0.7  py-pickleshare@0.7.5           rocminfo@4.5.2
arborx@1.1               hdf5@1.8.22                 lwgrp@1.0.5                    py-cinemasci@1.3             py-picmistandard@0.0.19        rocprim@4.5.2
archer@2.0.0             hdf5@1.10.7                 lz4@1.9.3                      py-cloudpickle@1.6.0         py-pika@0.13.0                 rocrand@4.5.2
argobots@1.1             heffte@2.2.0                lzo@2.10                       py-colorama@0.4.4            py-pillow@9.0.0                rocsolver@4.5.2
arpack-ng@3.8.0          heffte@2.2.0                m4@1.4.19                      py-configspace@0.4.20        py-platformdirs@2.4.0          rocsparse@4.5.2
ascent@0.7.1             heffte@2.2.0                magma@2.6.1                    py-cryptography@3.4.8        py-ply@3.11                    rocthrust@4.5.2
asio@1.21.0              hip@4.5.2                   magma@2.6.1                    py-cryptography@35.0.0       py-prometheus-client@0.12.0    roctracer-dev-api@4.5.2
axl@0.3.0                hipblas@4.5.2               mbedtls@2.28.0                 py-cycler@0.11.0             py-prompt-toolkit@3.0.24       rust@1.51.0
axl@0.5.0                hipsparse@4.5.2             mbedtls@3.1.0                  py-cython@0.29.24            py-psutil@5.8.0                scr@3.0rc2
axom@0.6.1               hpctoolkit@2022.01.15       memkind@1.12.0                 py-debugpy@1.5.1             py-ptyprocess@0.7.0            shuffile@0.1.0
berkeley-db@18.1.40      hpctoolkit@2022.01.15       mercury@1.0.1                  py-decorator@5.1.0           py-py@1.11.0                   slate@2021.05.02
binutils@2.33.1          hpcviewer@2022.01           mercury@2.1.0                  py-dill@0.3.4                py-pyaml@21.8.3                slate@2021.05.02
binutils@2.36.1          hpx@1.7.1                   mesa18@18.3.6                  py-entrypoints@0.3           py-pybind11@2.8.1              slate@2021.05.02
blaspp@2021.04.01        hpx@1.7.1                   metall@0.17                    py-filelock@3.4.0            py-pycparser@2.20              slepc@3.16.2
blaspp@2021.04.01        hpx@1.7.1                   metis@5.1.0                    py-fn-py@0.5.2               py-pyelftools@0.26             slepc@3.16.2
blaspp@2021.04.01        hsa-rocr-dev@4.5.2          mfem@4.3.0                     py-fonttools@4.28.1          py-pygments@2.10.0             slepc@3.16.2
blt@0.4.1                hsakmt-roct@4.5.2           mfem@4.3.0                     py-future@0.18.2             py-pyjwt@2.1.0                 slurm@21-08-1-1
blt@0.4.1                hwloc@2.7.0                 mfem@4.3.0                     py-gast@0.5.3                py-pyjwt@2.1.0                 snappy@1.1.8
bmi@main                 hwloc@2.7.0                 mochi-margo@0.4.3              py-gevent@1.5.0              py-pylint@2.11.1               spath@0.1.0
bolt@2.0                 hypre@2.23.0                mpark-variant@1.4.0            py-gevent@21.8.0             py-pymongo@3.12.1              spath@0.1.0
boost@1.78.0             hypre@2.24.0                mpich@3.4.2                    py-globus-sdk@3.0.2          py-pynacl@1.4.0                sqlite@3.37.1
boost@1.78.0             hypre@2.24.0                mpich@3.4.2                    py-gpy@1.9.9                 py-pyopenssl@19.0.0            stc@0.9.0
boost@1.78.0             inputproto@2.3.2            mpifileutils@0.11.1            py-greenlet@1.1.2            py-pyparsing@3.0.6             strumpack@6.3.0
boost@1.78.0             intel-tbb@2020.3            msgpack-c@3.1.1                py-h5py@3.6.0                py-pyro4@4.81                  strumpack@6.3.0
boost@1.78.0             intel-xed@12.0.1            munge@0.5.14                   py-hpbandster@0.7.4          py-pyrsistent@0.18.0           strumpack@6.3.0
butterflypack@2.1.0      jansson@2.13.1              nccmp@1.9.0.1                  py-idna@3.3                  py-python-dateutil@2.8.2       sundials@6.1.1
bzip2@1.0.8              jq@1.6                      nco@5.0.1                      py-ipykernel@6.4.1           py-python-editor@1.0.4         sundials@6.1.1
c-blosc@1.21.0           json-c@0.15                 ncurses@6.2                    py-ipykernel@6.4.1           py-python-json-logger@0.1.11   superlu@5.3.0
cabana@0.4.0             jsoncpp@1.9.4               netcdf-c@4.8.1                 py-ipyparallel@6.3.0         py-pythran@0.10.0              superlu-dist@7.2.0
caliper@2.7.0            kbproto@1.0.7               netlib-scalapack@2.1.0         py-ipython@7.28.0            py-pythran@0.10.0              superlu-dist@7.2.0
caliper@2.7.0            kim-api@2.2.1               netlib-scalapack@2.1.0         py-ipython-genutils@0.2.0    py-pytz@2021.3                 superlu-dist@7.2.0
camp@0.2.2               kokkos@3.5.00               ninja@1.10.2                   py-ipywidgets@7.6.5          py-pyyaml@6.0                  superlu-dist@7.2.0
camp@0.2.2               kokkos@3.5.00               nlohmann-json@3.10.5           py-isort@5.9.3               py-pyzmq@17.1.2                swig@4.0.2
camp@0.2.2               kokkos@3.5.00               nrm@0.1.0                      py-jedi@0.18.0               py-pyzmq@22.3.0                swig@4.0.2-fortran
catalyst@5.6.0           kokkos@3.5.00               numactl@2.0.14                 py-jinja2@3.0.3              py-pyzmq@22.3.0                sz@1.4.12.3
chai@2.4.0               kokkos-kernels@3.5.00       nvhpc@22.1                     py-joblib@1.0.1              py-radical-entk@1.11.0         sz@2.1.12
chai@2.4.0               kokkos-kernels@3.5.00       omega-h@9.34.1                 py-json5@0.9.4               py-radical-gtod@1.6.7          tar@1.34
chai@2.4.0               kokkos-nvcc-wrapper@3.2.00  oniguruma@6.9.4                py-jsonpatch@1.23            py-radical-pilot@1.11.2        tasmanian@7.7
charliecloud@0.26        kokkos-nvcc-wrapper@3.2.00  openblas@0.3.19                py-jsonpointer@1.9           py-radical-saga@1.11.1         tasmanian@7.7
cli11@1.9.1              kvtree@1.2.0                openjdk@11.0.12_7              py-jsonschema@2.6.0          py-radical-utils@1.11.0        tau@2.31
cmake@3.20.6             lammps@20220107             openmpi@4.1.2                  py-jsonschema@3.2.0          py-regex@2020.11.13            tcl@8.6.11
cmake@3.22.2             lapackpp@2021.04.00         openmpi@4.1.2                  py-jupyter-client@7.0.6      py-requests@2.26.0             trilinos@13.0.1
comgr@4.5.2              lapackpp@2021.04.00         openpmd-api@0.14.4             py-jupyter-client@7.0.6      py-ruamel-yaml@0.17.16         trilinos@13.2.0
conduit@0.7.2            lapackpp@2021.04.00         openssh@8.8p1                  py-jupyter-core@4.7.1        py-ruamel-yaml-clib@0.2.0      turbine@1.3.0
conduit@0.8.2            legion@21.03.0              openssl@1.1.1m                 py-jupyter-server@1.11.2     py-scikit-learn@1.0.2          udunits@2.2.28
conduit@0.8.2            libarchive@3.5.2            openturns@master               py-jupyter-telemetry@0.1.0   py-scikit-optimize@master      umap@2.1.0
cub@1.12.0-rc0           libbsd@0.11.3               otf2@2.3                       py-jupyterhub@1.4.1          py-scipy@1.8.0                 umpire@6.0.0
cuda@11.4.2              libcap@2.25                 pagmo2@2.18.0                  py-jupyterlab@3.2.1          py-scipy@1.8.0                 umpire@6.0.0
curl@7.80.0              libcircle@0.3.0             papi@6.0.0.1                   py-jupyterlab-server@2.6.0   py-semantic-version@2.8.2      umpire@6.0.0
czmq@4.1.1               libdrm@2.4.100              papi@6.0.0.1                   py-jupyterlab-widgets@1.0.2  py-send2trash@1.8.0            umpire@6.0.0
darshan-runtime@3.3.1    libdwarf@20180129           papyrus@1.0.1                  py-kiwisolver@1.3.2          py-serpent@1.40                unifyfs@0.9.1
darshan-util@3.3.1       libedit@3.1-20210216        parallel-netcdf@1.12.2         py-lazy-object-proxy@1.4.3   py-setproctitle@1.1.10         unzip@6.0
datatransferkit@3.1-rc3  libelf@0.8.13               paraview@5.10.0                py-lhsmdu@1.1                py-setuptools@59.4.0           upcxx@2021.9.0
double-conversion@3.1.5  libevent@2.1.12             parmetis@4.0.3                 py-libensemble@0.8.0         py-setuptools-rust@0.12.1      util-linux-uuid@2.36.2
dtcmp@1.1.4              libfabric@1.14.0            parmetis@4.0.3                 py-mako@1.1.5                py-six@1.16.0                  variorum@0.4.1
dyninst@12.0.1           libffi@3.3                  parsec@3.0.2012                py-markupsafe@2.0.1          py-sniffio@1.2.0               veloc@1.5
dyninst@12.0.1           libgcrypt@1.9.4             parsec@3.0.2012                py-matplotlib@3.5.1          py-sqlalchemy@1.4.20           vtk-h@0.7.1
eigen@3.4.0              libgit2@1.1.1               pcre@8.44                      py-matplotlib@3.5.1          py-statsmodels@0.12.2          vtk-m@1.6.0
elfutils@0.186           libgpg-error@1.43           pdsh@2.31                      py-matplotlib-inline@0.1.2   py-tables@3.6.1                vtk-m@1.7.1
er@0.1.0                 libiberty@2.37              pdt@3.25.1                     py-mccabe@0.6.1              py-tblib@1.6.0                 vtk-m@1.7.1
exaworks@0.1.0           libice@1.0.9                pegtl@3.2.0                    py-mistune@0.8.4             py-terminado@0.12.1            wannier90@3.1.0
exmcutils@0.6.0          libiconv@1.16               perl@5.34.0                    py-mock@4.0.3                py-threadpoolctl@3.0.0         warpx@22.02
expat@2.4.4              libjpeg-turbo@2.1.0         petsc@3.16.4                   py-mpi4py@3.1.2              py-toml@0.10.2                 warpx@22.02
faodel@1.2108.1          libmd@1.0.3                 petsc@3.16.4                   py-mpi4py@3.1.2              py-tornado@5.1.1               warpx@22.02
ffmpeg@4.4.1             libmonitor@2021.11.08       petsc@3.16.4                   py-msgpack@1.0.2             py-tornado@6.1                 xcb-proto@1.14.1
fftw@3.3.10              libnrm@0.1.0                petsc@3.16.4                   py-natsort@7.1.1             py-traitlets@5.1.1             xerces-c@3.2.3
fftw@3.3.10              libogg@1.3.5                pflotran@3.0.2                 py-nbclassic@0.3.1           py-typeguard@2.12.1            xextproto@7.3.0
flecsi@1.4.2             libpciaccess@0.16           pfunit@3.3.3                   py-nbconvert@4.2.0           py-typing-extensions@3.10.0.2  xproto@7.0.31
flecsi@2.1.0             libpng@1.6.37               phist@1.9.5                    py-nbformat@5.1.3            py-urllib3@1.26.6              xtrans@1.3.5
flit@2.1.0               libpthread-stubs@0.4        pkgconf@1.8.0                  py-nest-asyncio@1.5.1        py-warlock@1.3.3               xz@5.2.5
flux-core@0.35.0         libquo@1.3.1                plasma@21.8.29                 py-netifaces@0.10.5          py-warpx@22.02                 yaml-cpp@0.6.3
flux-core@0.35.0         libsigsegv@2.13             plumed@2.6.3                   py-notebook@6.4.5            py-warpx@22.02                 yaml-cpp@0.7.0
flux-core@0.35.0         libsm@1.2.3                 precice@2.3.0                  py-notebook@6.4.5            py-warpx@22.02                 yasm@1.3.0
flux-sched@0.20.0        libsodium@1.0.18            protobuf@3.18.0                py-ntplib@0.4.0              py-wcwidth@0.2.5               z3@4.8.14
fortrilinos@2.0.0        libssh2@1.10.0              pugixml@1.11.4                 py-numexpr@2.7.3             py-websocket-client@1.2.1      zfp@0.5.5
freetype@2.11.1          libtheora@1.1.1             pumi@2.2.6                     py-numexpr@2.7.3             py-widgetsnbextension@3.5.1    zfp@0.5.5
gasnet@2021.9.0          libtiff@4.3.0               py-alembic@1.5.5               py-numpy@1.21.5              py-wrapt@1.13.3                zlib@1.2.11
gdbm@1.19                libunwind@1.5.0             py-anyio@3.3.4                 py-numpy@1.22.2              py-ytopt-autotune@1.1.0        zsh@5.8
geopm@1.1.0              libx11@1.7.0                py-apache-libcloud@1.2.1       py-oauthlib@3.1.0            py-zope-event@4.5.0            zstd@1.5.0
gettext@0.21             libxau@1.0.8                py-argon2-cffi@21.1.0          py-opentuner@0.8.7           py-zope-interface@5.4.0
ginkgo@1.4.0             libxcb@1.14                 py-astroid@2.8.3               py-packaging@21.3            pygmo@2.18.0
ginkgo@1.4.0             libxdmcp@1.1.2              py-async-generator@1.10        py-pamela@1.0.0              python@3.8.12
ginkgo@1.4.0             libxext@1.3.3               py-attrs@21.2.0                py-pandas@1.4.1              qhull@2020.2
```
