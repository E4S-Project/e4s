## 1. Install packages used by all subsequent stages
FROM rockylinux/rockylinux:9.8.20260525.0-ubi AS base-0
 
RUN dnf upgrade -y \
 && dnf install -y 'dnf-command(versionlock)' \
 && dnf install -y \
  autoconf \
  automake \
  bc \
  bzip2 \
  cpio \
  csh \
  emacs-nox \
  file \
  findutils \
  gettext \
  git \
  gpg \
  iputils \
  jq \
  libffi-devel \
  libudev-devel \
  libxml2-devel \
  m4 \
  make \
  mlocate \
  ncurses-devel \
  openssl-devel \
  patch \
  pciutils \
  perl-FindBin \
  python3-devel \
  python3-pip \
  rsync \
  sqlite-devel \
  tcsh \
  tree \
  unzip \
  util-linux \
  vim \
  wget \
  zlib-devel \
  zsh \
 && dnf autoremove -y

RUN dnf groupinstall -y 'Development Tools' \
 && dnf install -y gcc-toolset-13 gcc-toolset-13-libatomic-devel \
 && dnf autoremove -y

RUN cd /tmp \
 && curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/root/.local/bin/:$PATH"
RUN echo 'export PATH=/root/.local/bin/:$PATH' >> /etc/bashrc

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


## 3. Build Python; push to cache; then install from cache into PYTHON_PATH
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

WORKDIR $PYTHON_PATH

ARG CACHE_ONLY
ARG S3_ENDPOINT
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    --mount=type=secret,id=SIGNING_KEY,required=true \
    ./build-and-install-python.sh



## 4. Create new base for all subsequent stages that has the python from (3)
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
 && source scl_source enable gcc-toolset-13 \
 && spack -e . compiler find \
 && spack -e . config add packages:all:require:[target=aarch64] \
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


## 7. Create final runner image with the tools from (5)
FROM base-1 AS runner

ARG TOOLS_PATH

COPY --from=tools-build $TOOLS_PATH $TOOLS_PATH

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