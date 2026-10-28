# check=skip=InvalidDefaultArgInFrom

ARG SOURCE_IMAGE

FROM $SOURCE_IMAGE

ARG ONEAPI_DEB_VERSION

# https://www.intel.com/content/www/us/en/docs/oneapi-toolkit/installation-guide-linux/latest/install-oneapi-toolkit-with-apt.html#INSTALL-ONEAPI-TOOLKIT-WITH-APT
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null \
 && echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list \
 && apt update -y \
 && apt install -y \
     intel-oneapi-ccl-devel=2022.1.2-9 \
     intel-oneapi-common-licensing=2026.0.0-235 \
     intel-oneapi-common-oneapi-vars=2026.0.0-235 \
     intel-oneapi-common-vars=2026.0.0-235 \
     intel-oneapi-compiler-cpp-eclipse-cfg-2026.1 \
     intel-oneapi-compiler-dpcpp-cpp-2026.1 \
     intel-oneapi-compiler-dpcpp-cpp-common-2026.1 \
     intel-oneapi-compiler-dpcpp-cpp-runtime-2026.1 \
     intel-oneapi-compiler-dpcpp-cpp=2026.1.1-325 \
     intel-oneapi-compiler-dpcpp-eclipse-cfg-2026.1 \
     intel-oneapi-compiler-fortran-2026.1 \
     intel-oneapi-compiler-fortran-common-2026.1 \
     intel-oneapi-compiler-fortran-runtime-2026.1 \
     intel-oneapi-compiler-shared-2026.1 \
     intel-oneapi-compiler-shared-common-2026.1 \
     intel-oneapi-compiler-shared-runtime-2026.1 \
     intel-oneapi-dev-utilities-2026.0 \
     intel-oneapi-dev-utilities-eclipse-cfg-2026.0 \
     intel-oneapi-dev-utilities=2026.0.1-16 \
     intel-oneapi-dnnl-devel=2026.0.2-40 \
     intel-oneapi-dpcpp-cpp-2026.1 \
     intel-oneapi-dpcpp-debugger-2026.1 \
     intel-oneapi-icc-eclipse-plugin-cpp-2026.1 \
     intel-oneapi-ipp-2026.0 \
     intel-oneapi-ipp-devel-2026.0 \
     intel-oneapi-ipp-devel=2026.0.1-51 \
     intel-oneapi-ippcp-2026.0 \
     intel-oneapi-ippcp-devel-2026.0 \
     intel-oneapi-ippcp-devel=2026.0.1-9 \
     intel-oneapi-mkl-classic-devel-2026.1 \
     intel-oneapi-mkl-classic-include-2026.1 \
     intel-oneapi-mkl-cluster-2026.1 \
     intel-oneapi-mkl-cluster-devel-2026.1 \
     intel-oneapi-mkl-core-2026.1 \
     intel-oneapi-mkl-core-devel-2026.1 \
     intel-oneapi-mkl-devel-2026.1 \
     intel-oneapi-mkl-devel=2026.1.0-236 \
     intel-oneapi-mkl-sycl-2026.1 \
     intel-oneapi-mkl-sycl-blas-2026.1 \
     intel-oneapi-mkl-sycl-data-fitting-2026.1 \
     intel-oneapi-mkl-sycl-devel-2026.1 \
     intel-oneapi-mkl-sycl-dft-2026.1 \
     intel-oneapi-mkl-sycl-include-2026.1 \
     intel-oneapi-mkl-sycl-lapack-2026.1 \
     intel-oneapi-mkl-sycl-rng-2026.1 \
     intel-oneapi-mkl-sycl-sparse-2026.1 \
     intel-oneapi-mkl-sycl-stats-2026.1 \
     intel-oneapi-mkl-sycl-vm-2026.1 \
     intel-oneapi-mpi-devel=2021.18.1-9 \
     intel-oneapi-openmp-2026.1 \
     intel-oneapi-openmp-common-2026.1 \
     intel-oneapi-tbb-devel=2023.1.0-151 \
     intel-oneapi-tlt-2026.0 \
     intel-oneapi-tlt=2026.0.0-220 \
     intel-oneapi-toolkit-env-2026.1 \
     intel-oneapi-toolkit=2026.1.1-31 \
     intel-oneapi-vtune=2026.4.0-20 \
    && apt-mark hold intel-oneapi*

# https://dgpu-docs.intel.com/driver/client/overview.html
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
   --mount=type=cache,target=/var/lib/apt,sharing=locked \
   apt-get install -y software-properties-common \
&& add-apt-repository -y ppa:kobuk-team/intel-graphics \
&& apt-get install -y \
   clinfo \
   intel-gsc \
   intel-metrics-discovery \
   intel-ocloc \
   intel-ocloc-dev \
   intel-opencl-icd \
   libigc-dev \
   libigc2 \
   libigdfcl-dev \
   libigdgmm12 \
   libze-dev \
   libze-intel-gpu-dev \
   libze-intel-gpu1 \
   libze1

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt install -y libstdc++-14-dev

ENV METRICS_SOURCE=/tmp/metrics-discovery
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
 && apt install -y libdrm-dev \
 && git clone https://github.com/intel/metrics-discovery.git $METRICS_SOURCE \
 && git -C $METRICS_SOURCE checkout 4bab60535fdae26d533c004c8fd292802a185967 \
 && mkdir -p $METRICS_SOURCE/build \
 && cd $METRICS_SOURCE/build \
 && cmake .. \
 && make -j \
 && make -j install \
 && rm -rf $METRICS_SOURCE

ENV METRICS_SOURCE=/tmp/metrics-library
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
 && apt install -y libdrm-dev \
 && git clone https://github.com/intel/metrics-library.git $METRICS_SOURCE \
 && git -C $METRICS_SOURCE checkout 7f9707d04545bc50208d7b04093cfeaee76ffefe \
 && mkdir -p $METRICS_SOURCE/build \
 && cd $METRICS_SOURCE/build \
 && cmake .. \
 && make -j \
 && make -j package \
 && dpkg -i intel-metrics-library*.deb \
 && rm -rf $METRICS_SOURCE

RUN ldconfig -v >/dev/null 2>&1

RUN ./opt/intel/oneapi/modulefiles-setup.sh --output-dir=/opt/intel/oneapi/modulefiles

RUN updatedb

RUN echo '. /opt/intel/oneapi/setvars.sh >/dev/null 2>&1' >> /etc/bash.bashrc \
 && echo module use /opt/intel/oneapi/modulefiles/ >> /etc/bash.bashrc \
 && echo module load mpi >> /etc/bash.bashrc

ENV PATH=/opt/intel/oneapi/compiler/latest/bin:/opt/intel/oneapi/mpi/latest/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:/opt/intel/oneapi/compiler/latest/lib:/opt/intel/oneapi/mpi/latest/lib

ARG E4S_ONEAPI_VERSION
LABEL E4S_ONEAPI_VERSION=$E4S_ONEAPI_VERSION