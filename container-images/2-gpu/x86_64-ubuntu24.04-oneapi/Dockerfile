# check=skip=InvalidDefaultArgInFrom

ARG SOURCE_IMAGE

FROM $SOURCE_IMAGE

ARG ONEAPI_VERSION

# https://www.intel.com/content/www/us/en/docs/oneapi-toolkit/installation-guide-linux/latest/install-oneapi-toolkit-with-apt.html#INSTALL-ONEAPI-TOOLKIT-WITH-APT
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null \
 && echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list \
 && apt update -y \
 && apt install -y intel-oneapi-toolkit=$ONEAPI_VERSION

COPY intel-graphics.sources /etc/apt/sources.list.d/
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
 && apt install -y \
      level-zero-dev \
      libigc-dev \
      libigdfcl-dev \
      libze-intel-gpu-dev

## https://dgpu-docs.intel.com/driver/client/overview.html
#RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#    --mount=type=cache,target=/var/lib/apt,sharing=locked \
#    apt-get install -y software-properties-common \
# && add-apt-repository -y ppa:kobuk-team/intel-graphics \
# && apt-get install -y \
#    clinfo \
#    intel-gsc \
#    intel-metrics-discovery \
#    intel-ocloc \
#    intel-ocloc-dev \
#    intel-opencl-icd \
#    libze-dev \
#    libze-intel-gpu1 \
#    libze1

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt install -y libstdc++-14-dev

RUN ldconfig -v >/dev/null 2>&1

RUN ./opt/intel/oneapi/modulefiles-setup.sh --output-dir=/opt/intel/oneapi/modulefiles

RUN updatedb

RUN echo '. /opt/intel/oneapi/setvars.sh >/dev/null 2>&1' >> /etc/bash.bashrc \
 && echo module use /opt/intel/oneapi/modulefiles/ >> /etc/bash.bashrc \
 && echo module load mpi >> /etc/bash.bashrc

ENV PATH=/opt/intel/oneapi/compiler/${ONEAPI_VERSION}/bin:/opt/intel/oneapi/mpi/latest/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:/opt/intel/oneapi/compiler/${ONEAPI_VERSION}/lib:/opt/intel/oneapi/mpi/latest/lib

