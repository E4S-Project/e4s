# check=skip=InvalidDefaultArgInFrom

ARG CPU_BASE_IMAGE
ARG CUDA_BASE_IMAGE
ARG FINAL_BASE_IMAGE
ARG GENERIC_BASE_IMAGE

## Clone spack core repo
FROM $GENERIC_BASE_IMAGE AS spack-core

ARG SPACK_CORE_CHECKOUT
ARG SPACK_CORE_REPO
ARG SPACK_CORE_ROOT

RUN git clone --quiet $SPACK_CORE_REPO $SPACK_CORE_ROOT \
 && git -C $SPACK_CORE_ROOT checkout --quiet $SPACK_CORE_CHECKOUT


## Clone spack-packages repo
FROM $GENERIC_BASE_IMAGE AS spack-packages

ARG SPACK_PACKAGES_CHECKOUT
ARG SPACK_PACKAGES_REPO
ARG SPACK_PACKAGES_ROOT

RUN git clone --quiet $SPACK_PACKAGES_REPO $SPACK_PACKAGES_ROOT \
 && git -C $SPACK_PACKAGES_ROOT checkout --quiet $SPACK_PACKAGES_CHECKOUT


## Complete spack setup (spack core + spack-packages)
FROM $GENERIC_BASE_IMAGE AS spack-complete

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-core $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-packages $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && export SPACK_DISABLE_LOCAL_CONFIG=1 \
 && spack repo set --destination $SPACK_PACKAGES_ROOT builtin \
 && spack config --scope site add "config:db_lock_timeout:480" \
 && spack config --scope site add "config:connect_timeout:60"


## ETC
FROM $GENERIC_BASE_IMAGE AS etc
COPY --from=container-common /utilities.sh /etc/e4s/
COPY --from=release-common /install-spack-packages.sh /etc/e4s/
COPY --from=release-common /concretize-spack-env.sh /etc/e4s/
COPY --from=release-common /modules.yaml /etc/spack/


FROM $GENERIC_BASE_IMAGE AS etc-spack-cpu
COPY --from=spack-env gnu/_config/packages.yaml /etc/spack


FROM $GENERIC_BASE_IMAGE AS etc-spack-cuda
COPY --from=spack-common merge-spack-packages.py /tmp/
COPY --from=spack-env gnu/_config/packages.yaml /tmp/packages-1.yaml
COPY --from=spack-env gnu/cuda/_config/packages.yaml /tmp/packages-2.yaml
RUN mkdir -p /etc/spack \
 && python3 \
      /tmp/merge-spack-packages.py \
      /tmp/packages-1.yaml /tmp/packages-2.yaml \
       | tee /etc/spack/packages.yaml


## cuda-70 SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-70-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/70 /etc/e4s/cuda/70
COPY --from=spack-env gnu/cuda/70_driver_reqd /etc/e4s/cuda/70_driver_reqd
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/70
RUN /etc/e4s/concretize-spack-env.sh

WORKDIR /etc/e4s/cuda/70_driver_reqd
RUN /etc/e4s/concretize-spack-env.sh


## CUDA-NOARCH SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-notarget-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/notarget /etc/e4s/cuda/notarget
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/notarget
RUN /etc/e4s/concretize-spack-env.sh


## CPU SPACK CONCRETIZE
FROM $CPU_BASE_IMAGE AS spack-cpu-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cpu /etc/e4s/cpu
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cpu
RUN /etc/e4s/concretize-spack-env.sh


## cuda-70 SPACK INSTALL
FROM $CUDA_BASE_IMAGE AS spack-cuda-70

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cuda-70-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cuda-70-concretize /etc/e4s/cuda /etc/e4s/cuda
COPY --from=spack-cuda-notarget-concretize /etc/e4s/cuda/notarget /etc/e4s/cuda/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/70
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/70_driver_reqd
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y


## CPU SPACK INSTALL
FROM $CPU_BASE_IMAGE AS spack-cpu

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cpu-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cpu-concretize /etc/e4s/cpu /etc/e4s/cpu

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cpu
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y


FROM $FINAL_BASE_IMAGE AS final-base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN rm -f /etc/apt/apt.conf.d/docker-clean \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
 && apt install -y \
        bc \
        clinfo \
        csh \
        firefox \
        git-lfs \
        imagemagick \
        libfreetype6-dev \
        libhdf5-dev \
        libnl-3-dev \
        libnl-route-3-dev \
        libqt5gui5 \
        libxi-dev \
        libxrender-dev \
        libxtst-dev \
        openjdk-11-jdk \
        pkg-config \
        tcsh \
        xterm \
        zsh \
&& apt autoremove -y

# RUN curl -fsSL https://ollama.com/install.sh | sh

# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     --mount=type=cache,target=/var/lib/apt,sharing=locked \
#     cd /tmp \
#  && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /tmp/google-cloud-sdk.gpg \
#  && gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg /tmp/google-cloud-sdk.gpg \
#  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list \
#  && apt update -y \
#  && apt install -y google-cloud-cli

RUN mkdir /usr/local/codium \
 && cd /usr/local/codium \
 && wget -q https://github.com/VSCodium/vscodium/releases/download/1.99.32846/VSCodium-linux-ppc64le-1.99.32846.tar.gz \
 && tar xzf VSCodium-linux-ppc64le-1.99.32846.tar.gz \
 && rm -rf VSCodium-linux-ppc64le-1.99.32846.tar.gz \
 && echo export PATH=/usr/local/codium/bin:'$PATH' >> /etc/bash.bashrc

# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     --mount=type=cache,target=/var/lib/apt,sharing=locked \
#     apt install -y software-properties-common \
#  && add-apt-repository ppa:mozillateam/ppa \
#  && apt update -y \
#  && apt remove -y firefox \
#  && apt install -y firefox-esr \
#  && ln -s /usr/bin/firefox-esr /usr/bin/firefox

ENV JULIA_VER_MAJ_MIN=1.10
ENV JULIA_VER_PATCH=10
ENV JULIA_VER=${JULIA_VER_MAJ_MIN}.${JULIA_VER_PATCH}
ENV JULIA_ARCH=ppc64le
ENV JULIA_ARCH_SHORT=ppc64le
ENV JULIA_TARBALL=julia-$JULIA_VER-linux-${JULIA_ARCH}.tar.gz
RUN cd /tmp \
 && wget -q https://julialang-s3.julialang.org/bin/linux/$JULIA_ARCH_SHORT/$JULIA_VER_MAJ_MIN/$JULIA_TARBALL \
 && mkdir -p /usr/local/julia \
 && tar xzf $JULIA_TARBALL -C /usr/local/julia \
 && mv /usr/local/julia/julia-$JULIA_VER/* /usr/local/julia/. \
 && rm -rf /usr/local/julia/julia-$JULIA_VER \
 && rm -rf $JULIA_TARBALL

# COPY /install-paraview-visit.sh /
# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     --mount=type=cache,target=/var/lib/apt,sharing=locked \
#     /install-paraview-visit.sh \
#  && rm -f /install-paraview-visit.sh

# COPY --from=release-common install-nodejs.sh /
# RUN /install-nodejs.sh \
#  && rm -f /install-nodejs.sh

RUN cd /opt \
 && wget -q http://tau.uoregon.edu/demo.tgz \
 && tar xzf demo.tgz \
 && rm -rf demo.tgz \
 && sed -i 's@load tau@load tau/2.35.2-cuda@g' /opt/demo/CoMD/bin/rt.sh \
 && cd /opt/demo \
 && git clone --quiet https://github.com/ParaToolsInc/e4s-cloud-examples.git \
 && rm -rf e4s-cloud-examples/.git \
 && (cd e4s-cloud-examples && ./fetch-all.sh)

COPY --from=release-common julia/examples /opt/demo/julia-examples

RUN chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV TF_CPP_MIN_LOG_LEVEL=2
ENV PYTHONWARNINGS="ignore::FutureWarning,ignore::DeprecationWarning,ignore::RuntimeWarning,ignore::SyntaxWarning"
ENV TIKTOKEN_ENCODINGS_BASE=/etc/encodings

ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/bash.bashrc"]



FROM final-base AS final-cuda-base

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cuda.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cuda.sh \
 && rm -f /install-python-pkgs-cuda.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET="pwr8"
COPY /install-julia-pkgs-cuda.sh /
RUN /install-julia-pkgs-cuda.sh \
 && rm -f /install-julia-pkgs-cuda.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root


## FINAL CUDA 70
FROM final-cuda-base AS final-cuda-70

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-70 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-70 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-70 /etc/spack /etc/spack
COPY --from=spack-cuda-70 /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


## FINAL CPU
FROM final-base AS final-cpu

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cpu.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cpu.sh \
 && rm -f /install-python-pkgs-cpu.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET="pwr8"
COPY /install-julia-pkgs-cpu.sh /
RUN /install-julia-pkgs-cpu.sh \
 && rm -f /install-julia-pkgs-cpu.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cpu $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cpu $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cpu /etc/spack /etc/spack
COPY --from=spack-cpu /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=spack-env gnu/_config/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /
