## 1. Install packages used by all subsequent stages
FROM ubuntu:20.04 AS base-0

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
 
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && apt update -y \
 && apt upgrade -y \
 && apt install -y \
  autoconf \
  automake \
  bzip2 \
  cpio \
  curl \
  emacs-nox \
  file \
  findutils \
  g++ \
  gcc \
  gettext \
  gfortran \
  git \
  gpg \
  iputils-ping \
  jq \
  libffi-dev \
  libssl-dev \
  libudev-dev \
  libxml2-dev \
  locales \
  locate \
  m4 \
  make \
  mercurial \
  ncurses-dev \
  patch \
  pciutils \
  python3-pip \
  rsync \
  unzip \
  uuid-runtime \
  vim \
  wget \
  zlib1g-dev \
 && apt autoremove --purge

RUN locale-gen en_US.UTF-8 \
 && ln -s `which python3` /usr/bin/python

RUN cd /tmp \
 && curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/root/.local/bin/:$PATH"

RUN uv pip install --system --upgrade \
      boto3 \
      botocore \
      clingo \
      minio \
      pyyaml \
      requests \
      setuptools \
      wheel

RUN echo 'export PATH=/root/.local/bin/:$PATH' >> /etc/bash.bashrc


## Clone spack core
FROM base-0 AS spack-core

ARG SPACK_CORE_CHECKOUT
ARG SPACK_CORE_REPO
ARG SPACK_CORE_ROOT

RUN git clone --quiet $SPACK_CORE_REPO $SPACK_CORE_ROOT \
 && git -C $SPACK_CORE_ROOT checkout --quiet $SPACK_CORE_CHECKOUT


## Clone spack-packages repo
FROM base-0 AS spack-packages

ARG SPACK_PACKAGES_CHECKOUT
ARG SPACK_PACKAGES_REPO
ARG SPACK_PACKAGES_ROOT

RUN git clone --quiet $SPACK_PACKAGES_REPO $SPACK_PACKAGES_ROOT \
 && git -C $SPACK_PACKAGES_ROOT checkout --quiet $SPACK_PACKAGES_CHECKOUT


## Complete spack setup (spack core + spack-packages)
FROM base-0 AS spack-complete

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT

COPY --from=spack-core $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-packages $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && export SPACK_DISABLE_LOCAL_CONFIG=1 \
 && spack repo set --destination $SPACK_PACKAGES_ROOT builtin \
 && spack config --scope site add "config:db_lock_timeout:480" \
 && spack config --scope site add "config:connect_timeout:60"


## 4. Create new base for all subsequent stages that has the python from (3)
FROM base-0 AS base-1

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    export UV_LINK_MODE=copy \
 && uv pip install --system --upgrade \
      boto3 \
      botocore \
      clingo \
      minio \
      pyyaml \
      requests \
      setuptools \
      wheel


## 5. Concretize tools
FROM base-1 AS tools-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
ARG TOOLS_PATH

COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

COPY --from=runner-common spack.tools.yaml $TOOLS_PATH/spack.yaml

WORKDIR $TOOLS_PATH

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack -e . compiler find \
 && spack -e . config add packages:all:require:[target=ppc64le] \
 && spack -e . concretize -f | tee concretize.log


## 6. Build relocatable tools + push to cache; then install from cache into TOOLS_PATH
FROM base-1 AS tools-build

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
ARG TOOLS_MIRROR
ARG TOOLS_PATH

COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=tools-concretize $TOOLS_PATH $TOOLS_PATH

COPY --from=container-common utilities.sh $TOOLS_PATH/
COPY --from=runner-common build-and-install-tools.sh $TOOLS_PATH/

WORKDIR $TOOLS_PATH

ARG CACHE_ONLY
ARG S3_ENDPOINT
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    --mount=type=secret,id=SIGNING_KEY,required=true \
    ./build-and-install-tools.sh


## 6.. Create final runner image with the tools from (5)
FROM base-0 AS runner

ARG TOOLS_PATH

COPY --from=tools-build $TOOLS_PATH $TOOLS_PATH

RUN apt update -y \
 && apt install -y software-properties-common \
 && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
 && apt install -y \
    gcc-11 \
    g++-11 \
    gfortran-11 \
 && rm -rf /etc/apt/trusted.gpg.d/ubuntu-toolchain-r_ubuntu_test.gpg \
 && rm -rf /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-focal.list \
 && apt remove -y software-properties-common \
 && apt autoremove -y \
 && apt clean -y

RUN ln -s /usr/include/powerpc64le-linux-gnu/asm /usr/include/asm \
 && ln -s /usr/include/powerpc64le-linux-gnu/bits /usr/include/bits \
 && ln -s /usr/include/powerpc64le-linux-gnu/gnu /usr/include/gnu \
 && ln -s /usr/include/powerpc64le-linux-gnu/sys /usr/include/sys

RUN wget -q https://dl.min.io/client/mc/release/linux-ppc64le/mc \
 && chmod +x mc \
 && mv mc /usr/local/bin \
 && /usr/local/bin/mc --version

# RUN debfile=mcli_20250813083541.0.0_ppc64el.deb \
#  && wget --quiet https://dl.min.io/client/mc/release/linux-ppc64le/$debfile \
#  && dpkg -i $debfile \
#  && rm $debfile

COPY --from=container-common utilities.sh /
COPY --from=runner-common setup-rcfile.sh /
RUN /setup-rcfile.sh \
 && rm -f /setup-rcfile.sh /utilities.sh

RUN updatedb

CMD ["/bin/bash"]

ENV PATH=$TOOLS_PATH/view/bin:$PATH

ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    LANGUAGE=en_US:en \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8