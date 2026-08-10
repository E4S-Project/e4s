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


FROM $GENERIC_BASE_IMAGE AS etc-spack-cuda
COPY --from=spack-common merge-spack-packages.py /tmp/
COPY --from=spack-env gnu/_config/packages.yaml /tmp/packages-1.yaml
COPY --from=spack-env gnu/cuda/_config/packages.yaml /tmp/packages-2.yaml
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh

RUN mkdir -p /etc/spack \
 && /tmp/fixup-compilers.sh /tmp/packages-1.yaml \
 && python3 \
      /tmp/merge-spack-packages.py \
      /tmp/packages-1.yaml /tmp/packages-2.yaml \
       | tee /etc/spack/packages.yaml


## CUDA-120 SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-120-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/120 /etc/e4s/cuda/120
COPY --from=spack-env gnu/cuda/120_driver_reqd /etc/e4s/cuda/120_driver_reqd
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh
RUN /tmp/fixup-compilers.sh /etc/e4s/_config/packages.yaml
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/120
RUN /etc/e4s/concretize-spack-env.sh

WORKDIR /etc/e4s/cuda/120_driver_reqd
RUN /etc/e4s/concretize-spack-env.sh


## CUDA-90 SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-90-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/90 /etc/e4s/cuda/90
COPY --from=spack-env gnu/cuda/90_driver_reqd /etc/e4s/cuda/90_driver_reqd
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh
RUN /tmp/fixup-compilers.sh /etc/e4s/_config/packages.yaml
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/90
RUN /etc/e4s/concretize-spack-env.sh

WORKDIR /etc/e4s/cuda/90_driver_reqd
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
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh
RUN /tmp/fixup-compilers.sh /etc/e4s/_config/packages.yaml
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
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh
RUN /tmp/fixup-compilers.sh /etc/e4s/_config/packages.yaml

COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cpu
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack -e . remove 'paraview +qt' \
 && /etc/e4s/concretize-spack-env.sh


## CUDA-120 SPACK INSTALL
FROM $CUDA_BASE_IMAGE AS spack-cuda-120

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cuda-120-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cuda-120-concretize /etc/e4s/cuda /etc/e4s/cuda
COPY --from=spack-cuda-notarget-concretize /etc/e4s/cuda/notarget /etc/e4s/cuda/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/120
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/120_driver_reqd
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y


## CUDA-90 SPACK INSTALL
FROM $CUDA_BASE_IMAGE AS spack-cuda-90

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cuda-90-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cuda-90-concretize /etc/e4s/cuda /etc/e4s/cuda
COPY --from=spack-cuda-notarget-concretize /etc/e4s/cuda/notarget /etc/e4s/cuda/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/90
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/90_driver_reqd
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

ENV TZ=America/Los_Angeles

# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN dnf install -y epel-release \
 && dnf config-manager --set-enabled crb \
 && dnf install -y \
        csh \
        freetype-devel \
        git-lfs \
        glib2-devel \
        glx-utils \
        hdf5 \
        hdf5-devel \
        hostname \
        ImageMagick \
        ImageMagick-devel \
        java-11-openjdk-devel \
        libjpeg-devel \
        libpng-devel \
        libXi-devel \
        libXrender-devel \
        libXtst-devel \
        moreutils \
        python3-tkinter \
        qt5-qtbase-gui \
        sox \
        xdg-utils \
        xterm

# Disabled: https://github.com/E4S-Project/e4s/issues/172
# RUN curl -fsSL https://ollama.com/install.sh | sh

COPY google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN cd /tmp \
 && dnf install -y libxcrypt-compat.x86_64 \
 && dnf install -y google-cloud-cli

# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#RUN --mount=type=cache,target=/var/cache/dnf,sharing=private 
RUN cd /tmp \
 && rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg \
 && printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | tee -a /etc/yum.repos.d/vscodium.repo \
 && dnf install -y codium \
 && rm -f /etc/yum.repos.d/vscodium.repo

RUN wget --quiet -O firefox-latest.tar.xz "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" \
 && tar xf firefox-latest.tar.xz -C /usr/local \
 && rm -f firefox-latest.tar.xz \
 && ln -s /usr/local/firefox/firefox /usr/bin/firefox

COPY /install-paraview-visit.sh /
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN /install-paraview-visit.sh \
 && rm -f /install-paraview-visit.sh

COPY --from=release-common install-nodejs.sh /
RUN dnf install -y libatomic \
 && /install-nodejs.sh \
 && rm -f /install-nodejs.sh

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

ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/bashrc"]



FROM final-base AS final-cuda-base

RUN cd /tmp \
 && runfile_13_0_3=cuda_13.0.3_580.126.20_linux.run \
 && wget -q https://developer.download.nvidia.com/compute/cuda/13.0.3/local_installers/$runfile_13_0_3 \
 && sh $runfile_13_0_3 --toolkit --silent \
 && rm -rf $runfile_13_0_3

RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo \
 && dnf install -y libnccl-2.29.7-1+cuda12.9 libnccl-devel-2.29.7-1+cuda12.9 libnccl-static-2.29.7-1+cuda12.9 \
 && dnf versionlock add libnccl*

RUN cd /tmp \
 && cudnn_name=cudnn-linux-x86_64-9.22.0.52_cuda13-archive \
 && cudnn_tarball=$cudnn_name.tar.xz \
 && wget -q https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.22.0.52_cuda13-archive.tar.xz \
 && tar xf $cudnn_tarball \
 && cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda-13.0/include \
 && cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda-13.0/lib64 \
 && chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda-13.0/lib64/libcudnn* || true \
 && rm -rf $cudnn_tarball cudnn-*-archive

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cuda.sh /
# disabled due to cache deadlock
#    --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cuda.sh \
 && rm -f /install-python-pkgs-cuda.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-cuda.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-cuda.sh \
 && rm -f /install-julia-pkgs-cuda.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root




## FINAL CUDA 120
FROM final-cuda-base AS final-cuda-120

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-120 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 /etc/spack /etc/spack
COPY --from=spack-cuda-120 /etc/e4s /etc/e4s
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


## FINAL CUDA 90
FROM final-cuda-base AS final-cuda-90

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-90 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 /etc/spack /etc/spack
COPY --from=spack-cuda-90 /etc/e4s /etc/e4s

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
#    --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cpu.sh \
 && rm -f /install-python-pkgs-cpu.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
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
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh
RUN /tmp/fixup-compilers.sh /etc/spack/packages.yaml
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
