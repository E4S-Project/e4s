## 1. Install packages used by all subsequent stages
FROM ubuntu:26.04 AS base-0

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
  bc \
  bzip2 \
  cpio \
  csh \
  curl \
  emacs-nox \
  file \
  findutils \
  g++ \
  g++-13 \
  gcc \
  gcc-13 \
  gettext \
  gfortran \
  gfortran-13 \
  git \
  gpg \
  htop \
  iputils-ping \
  jq \
  libffi-dev \
  libgdbm-dev \
  libreadline-dev \
  libssl-dev \
  libtool \
  libudev-dev \
  libxml2-dev \
  locales \
  locate \
  m4 \
  make \
  ncurses-dev \
  patch \
  pciutils \
  pkgconf \
  python3-dev \
  python3-pip \
  python3-venv \
  rsync \
  tcsh \
  tree \
  unzip \
  uuid-runtime \
  vim \
  wget \
  zlib1g-dev \
  zsh

RUN rm -rf /usr/bin/gcc && ln -s /usr/bin/aarch64-linux-gnu-gcc-13 /usr/bin/gcc \
 && rm -rf /usr/bin/g++ && ln -s /usr/bin/aarch64-linux-gnu-g++-13 /usr/bin/g++ \
 && rm -rf /usr/bin/gfortran && ln -s /usr/bin/aarch64-linux-gnu-gfortran-13 /usr/bin/gfortran

RUN locale-gen en_US.UTF-8 \
 && ln -s `which python3` /usr/bin/python

RUN cd /tmp \
 && curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/root/.local/bin/:$PATH"
RUN echo 'export PATH=/root/.local/bin/:$PATH' >> /etc/bash.bashrc

RUN curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
 && unzip -q awscliv2.zip \
 && ./aws/install \
 && rm -rf awscliv2.zip


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


## Build Python; push to cache; then install from cache into PYTHON_PATH
FROM base-0 AS python-build

ARG PYTHON_MIRROR
ARG PYTHON_PATH
ARG PYTHON_VERSION
ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT

COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    export UV_LINK_MODE=copy \
 && uv pip install --system --break-system-packages --upgrade boto3 botocore

COPY --from=container-common utilities.sh $PYTHON_PATH/
COPY --from=runner-common build-and-install-python.sh $PYTHON_PATH/
COPY --from=runner-common spack.python.yaml $PYTHON_PATH/spack.yaml
COPY packages.yaml /etc/spack/
WORKDIR $PYTHON_PATH

ARG CACHE_ONLY
ARG S3_ENDPOINT
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    --mount=type=secret,id=SIGNING_KEY,required=true \
    ./build-and-install-python.sh



## Create new base for all subsequent stages that has python
FROM base-0 AS base-1

ARG PYTHON_PATH
ARG PYTHON_VERSION

COPY --from=python-build $PYTHON_PATH $PYTHON_PATH

ENV PATH=$PYTHON_PATH/pkgs/python-$PYTHON_VERSION/bin:$PATH

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


## Create final runner image
FROM base-1 AS runner

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && apt update -y \
 && apt install -y \
     ccache \
     cmake \
     environment-modules \
     libtree \
     patchelf

COPY --from=container-common utilities.sh /
COPY --from=runner-common setup-rcfile.sh /

ARG PYTHON_PATH
ARG PYTHON_VERSION

RUN /setup-rcfile.sh \
 && rm -f /setup-rcfile.sh /utilities.sh

RUN updatedb

CMD ["/bin/bash"]

ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    LANGUAGE=en_US:en \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
