# E4S Release 21.11

November 2021 release of E4S

## Files

* `spack.yaml` -- Model Spack environment
  
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

* Built and tested on Ubuntu 20.04 for x86_64, using GCC 9.3.0
* Docker container image: `ecpe4s/ubuntu20.04-runner-x86_64:2021-11-01`
* Output of `spack find`
```
==> 422 installed packages
-- linux-ubuntu20.04-x86_64 / gcc@9.3.0 -------------------------
adiak@0.2.1              font-util@1.3.2             libelf@0.8.13          mpich@3.4.2              py-entrypoints@0.3            py-pylint@2.8.2            sqlite@3.35.5
adios@1.13.1             fontconfig@2.13.93          libevent@2.1.12        mpifileutils@0.11        py-future@0.18.2              py-pyopenssl@19.0.0        stc@0.9.0
adios2@2.7.1             fortrilinos@2.0.0           libfabric@1.12.1       munge@0.5.14             py-gast@0.5.2                 py-pyparsing@2.4.7         strumpack@5.1.1
adlbx@1.0.0              freetype@2.11.0             libffi@3.3             ncurses@6.2              py-gevent@1.3a2               py-pyrsistent@0.15.7       strumpack@5.1.1
aml@0.1.0                gasnet@2021.3.0             libgcrypt@1.9.3        netcdf-c@4.8.0           py-greenlet@1.1.0             py-python-dateutil@2.8.2   sundials@5.7.0
amrex@21.08              gdbm@1.19                   libgit2@1.1.0          netlib-scalapack@2.1.0   py-idna@2.8                   py-python-editor@1.0.4     sundials@5.7.0
amrex@21.08              geopm@1.1.0                 libgpg-error@1.42      nettle@3.4.1             py-ipykernel@5.3.4            py-python-oauth2@1.1.1     superlu@5.2.2
arborx@1.0               gettext@0.21                libiberty@2.33.1       ninja@1.10.2             py-ipython@7.21.0             py-pythran@0.9.12          superlu-dist@6.4.0
argobots@1.1             ginkgo@1.3.0                libice@1.0.9           nlohmann-json@3.9.1      py-ipython-genutils@0.2.0     py-pytz@2020.1             superlu-dist@6.4.0
arpack-ng@3.8.0          ginkgo@1.3.0                libiconv@1.16          nrm@0.1.0                py-isort@5.9.1                py-pyyaml@5.3.1            swig@4.0.2
ascent@0.7.1             glib@2.68.2                 libjpeg-turbo@2.1.0    numactl@2.0.14           py-jedi@0.18.0                py-pyzmq@17.1.2            swig@4.0.2-fortran
asio@1.18.2              globalarrays@5.8            libmd@1.0.3            nvhpc@21.7               py-jinja2@3.0.1               py-pyzmq@18.1.0            sz@1.4.12.3
axl@0.3.0                glproto@1.4.17              libmng@2.0.3           omega-h@9.32.5           py-jsonpatch@1.23             py-requests@2.25.1         sz@2.1.12
axl@0.4.0                gmake@4.3                   libmonitor@2021.04.27  openblas@0.3.17          py-jsonpointer@1.9            py-scipy@1.7.1             tar@1.34
axom@0.5.0               gmp@6.2.1                   libnrm@0.1.0           openjdk@11.0.8_10        py-jsonschema@2.6.0           py-semantic-version@2.8.2  tasmanian@7.5
berkeley-db@18.1.40      googletest@1.8.1            libogg@1.3.4           openmpi@4.1.1            py-jsonschema@3.2.0           py-send2trash@1.5.0        tasmanian@7.5
binutils@2.33.1          gotcha@1.0.3                libpciaccess@0.16      openpmd-api@0.13.4       py-jupyter-client@6.1.7       py-setuptools@57.4.0       tau@2.30.1
binutils@2.36.1          gperftools@2.9.1            libpng@1.6.37          openssh@8.5p1            py-jupyter-core@4.7.1         py-setuptools-rust@0.12.1  tcl@8.6.11
blaspp@2021.04.01        harfbuzz@2.6.8              libpthread-stubs@0.4   openssl@1.1.1k           py-jupyterhub@1.0.0           py-six@1.15.0              trilinos@13.0.1
blaspp@2021.04.01        hdf5@1.8.22                 libquo@1.3.1           otf2@2.3                 py-jupyterlab-pygments@0.1.1  py-sqlalchemy@1.4.20       turbine@1.3.0
bmi@main                 hdf5@1.8.22                 libsigsegv@2.13        papi@6.0.0.1             py-kiwisolver@1.1.0           py-tables@3.6.1            umap@2.1.0
bolt@2.0                 hdf5@1.12.0                 libsm@1.2.3            papyrus@1.0.1            py-lark-parser@0.11.3         py-terminado@0.8.3         umpire@4.1.2
boost@1.76.0             hdf5@1.12.0                 libsodium@1.0.18       parallel-netcdf@1.12.2   py-lazy-object-proxy@1.4.3    py-testpath@0.4.2          umpire@4.1.2
boost@1.76.0             heffte@2.1.0                libssh2@1.8.0          paraview@5.9.1           py-libensemble@0.7.2          py-toml@0.10.2             umpire@4.1.2
butterflypack@1.2.1      hip@4.3.0                   libtheora@1.1.1        parmetis@4.0.3           py-mako@1.1.4                 py-tornado@5.1.1           umpire@4.1.2
bzip2@1.0.8              hip-rocclr@4.3.0            libtiff@4.1.0          parsec@3.0.2012          py-markupsafe@2.0.1           py-tornado@6.1             unifyfs@0.9.1
c-blosc@1.21.0           hpctoolkit@2021.05.15       libunwind@1.5.0        parsec@3.0.2012          py-matplotlib@3.4.3           py-traitlets@5.0.4         unzip@6.0
cabana@0.3.0             hpcviewer@2021.05           libx11@1.7.0           pcre@8.44                py-mccabe@0.6.1               py-urllib3@1.26.6          upcxx@2021.3.0
cairo@1.16.0             hpx@1.7.1                   libxau@1.0.8           pcre2@10.36              py-mistune@0.8.4              py-warlock@1.3.3           util-linux-uuid@2.36.2
caliper@2.6.0            hpx@1.7.1                   libxcb@1.14            pdsh@2.31                py-mock@3.0.5                 py-warpx@21.08             util-macros@1.19.3
caliper@2.6.0            hsa-rocr-dev@4.3.0          libxdmcp@1.1.2         pdt@3.25.1               py-mpi4py@3.0.3               py-warpx@21.08             veloc@1.4
camp@0.1.0               hsakmt-roct@4.3.0           libxext@1.3.3          pegtl@3.2.0              py-natsort@7.1.1              py-warpx@21.08             vtk-h@0.7.1
camp@0.1.0               hwloc@2.4.1                 libxkbcommon@0.8.2     perl@5.34.0              py-nbclient@0.5.0             py-wcwidth@0.1.7           vtk-m@1.6.0
camp@0.1.0               hypre@2.22.0                libxml2@2.9.10         petsc@3.15.3             py-nbconvert@6.0.1            py-webencodings@0.5.1      warpx@21.08
chai@2.3.0               hypre@2.22.0                libxrandr@1.5.0        pfunit@3.3.3             py-nbformat@5.0.7             py-wrapt@1.12.1            warpx@21.08
chai@2.3.0               icu4c@67.1                  libxrender@0.9.10      phist@1.9.4              py-nest-asyncio@1.4.0         python@3.8.10              warpx@21.08
charliecloud@0.24        inputproto@2.3.2            libxt@1.1.5            pixman@0.40.0            py-notebook@6.1.4             qhull@2020.1               xcb-proto@1.14.1
cmake@3.20.5             intel-tbb@2020.3            libyaml@0.2.5          pkgconf@1.7.4            py-numexpr@2.7.2              qt@5.14.2                  xcb-util@0.4.0
comgr@4.3.0              intel-xed@12.0.1            libyogrt@1.24          plasma@20.9.20           py-numpy@1.21.1               qt@5.15.2                  xcb-util-image@0.4.0
conduit@0.7.2            jansson@2.13.1              libzmq@4.3.3           precice@2.2.1            py-oauthlib@3.1.0             qthreads@1.16              xcb-util-keysyms@0.4.0
conduit@0.7.2            json-c@0.15                 llvm-amdgpu@4.3.0      protobuf@3.17.3          py-pamela@1.0.0               qwt@6.1.6                  xcb-util-renderutil@0.3.9
cub@1.12.0-rc0           jsoncpp@1.9.4               loki@0.1.7             pugixml@1.11.4           py-pandas@1.3.2               raja@0.13.0                xcb-util-wm@0.4.1
cuda@11.4.0              kbproto@1.0.7               lua@5.3.5              pumi@2.2.6               py-pandocfilters@1.4.2        raja@0.13.0                xerces-c@3.2.3
curl@7.76.1              kokkos@3.4.00               lua-luaposix@35.0      py-alembic@1.5.5         py-parso@0.8.1                randrproto@1.5.0           xextproto@7.3.0
czmq@4.1.1               kokkos@3.4.00               lwgrp@1.0.3            py-argon2-cffi@20.1.0    py-periodictable@1.5.0        rankstr@0.0.3              xkbdata@1.0.1
darshan-runtime@3.3.1    kokkos@3.4.00               lz4@1.9.3              py-astroid@2.5.6         py-petsc4py@3.15.3            readline@8.1               xproto@7.0.31
darshan-util@3.3.1       kokkos@3.4.00               lzo@2.10               py-async-generator@1.10  py-pexpect@4.7.0              redset@0.0.5               xrandr@1.5.0
datatransferkit@3.1-rc2  kokkos-kernels@3.2.00       m4@1.4.19              py-attrs@20.3.0          py-pickleshare@0.7.5          rempi@1.1.0                xtrans@1.3.5
double-conversion@3.1.5  kokkos-kernels@3.2.00       magma@2.6.1            py-backcall@0.1.0        py-picmistandard@0.0.14       renderproto@0.11.1         xz@5.2.5
dtcmp@1.1.1              kokkos-nvcc-wrapper@3.2.00  mbedtls@2.16.9         py-beniget@0.4.0         py-pillow@7.2.0               rocminfo@4.3.0             yaml-cpp@0.7.0
dyninst@11.0.1           kvtree@1.1.1                memkind@1.10.1         py-bleach@3.1.0          py-ply@3.11                   roctracer-dev-api@4.3.0    z3@4.8.9
eigen@3.3.9              lapackpp@2021.04.00         mercury@1.0.1          py-blinker@1.4           py-prometheus-client@0.7.1    rust@1.51.0                zfp@0.5.5
elfutils@0.185           lapackpp@2021.04.00         mercury@2.0.1          py-bottleneck@1.3.2      py-prompt-toolkit@3.0.17      scr@3.0rc1                 zfp@0.5.5
er@0.0.4                 lcms@2.9                    mesa@21.0.3            py-certifi@2020.6.20     py-psutil@5.8.0               shuffile@0.0.4             zlib@1.2.11
exmcutils@0.6.0          legion@21.03.0              mesa18@18.3.6          py-certipy@0.1.3         py-ptyprocess@0.6.0           slate@2021.05.02           zsh@5.8
expat@2.4.1              libarchive@3.5.1            metall@0.15            py-cffi@1.14.3           py-py@1.9.0                   slate@2021.05.02           zstd@1.5.0
faodel@1.1906.1          libbsd@0.11.3               metis@5.1.0            py-chardet@3.0.4         py-pybind11@2.5.0             slepc@3.15.1
fftw@3.3.9               libcap@2.25                 mfem@4.3.0             py-cryptography@3.4.7    py-pycparser@2.20             slurm@20-11-5-1
flecsi@1.4.2             libcircle@0.3.0             mfem@4.3.0             py-cycler@0.10.0         py-pyelftools@0.26            snappy@1.1.8
flit@2.1.0               libdwarf@20180129           mochi-margo@0.4.3      py-decorator@4.4.2       py-pygments@2.10.0            spath@0.0.2
flux-core@0.28.0         libedit@3.1-20210216        mpark-variant@1.4.0    py-defusedxml@0.6.0      py-pyjwt@2.1.0                spath@0.0.2
```
