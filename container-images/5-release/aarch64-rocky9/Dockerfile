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
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh
RUN /tmp/fixup-compilers.sh /etc/e4s/_config/packages.yaml
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cuda/120
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
COPY --from=rocky-common fixup-compilers.sh /tmp/fixup-compilers.sh
RUN /tmp/fixup-compilers.sh /etc/e4s/_config/packages.yaml
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cuda/90
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
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cuda/notarget
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack -e . remove 'paraview +qt' || true \
 && /etc/e4s/concretize-spack-env.sh


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
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cpu
# remove paraview+qt before checking for cached lockfile, as this is how it is done in build-env.sh
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack -e . remove 'paraview +qt' || true \
 && spack -e . remove 'quantum-espresso' || true \
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

COPY --from=common_4_5 --chmod=0755 e4s-chain-spack.sh /etc/e4s/
COPY --from=release-common --chmod=0755 guacamole-start.sh /etc/e4s/
# caching disabled due to as-yet unexplained deadlocks
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN dnf install -y epel-release \
 && ln -sf /etc/e4s/guacamole-start.sh /usr/local/bin/guacamole-start.sh \
 && ln -sf /etc/e4s/guacamole-start.sh /usr/local/bin/guacamole \
 && ln -sf /etc/e4s/e4s-chain-spack.sh /usr/local/bin/e4s-chain-spack.sh \
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

# Desktop + VNC for guacamole-start.sh (Rocky equivalents of the Ubuntu xfce4/tigervnc set;
# xfce and tigervnc come from EPEL/AppStream).
RUN dnf install -y --setopt=install_weak_deps=False \
         xfce4-session xfwm4 xfdesktop xfce4-panel xfce4-settings xfce4-terminal Thunar \
         tigervnc-server-minimal tigervnc-server \
         dbus-x11 dbus-daemon xorg-x11-xauth dejavu-sans-fonts iproute \
 && dnf clean all

# Disabled: https://github.com/E4S-Project/e4s/issues/172
# RUN curl -fsSL https://ollama.com/install.sh | sh

COPY google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
# caching disabled due to as-yet unexplained deadlocks
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN cd /tmp \
 && dnf install -y libxcrypt-compat.aarch64 \
 && dnf install -y google-cloud-cli

 # caching disabled due to as-yet unexplained deadlocks
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN cd /tmp \
 && rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg \
 && printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | tee -a /etc/yum.repos.d/vscodium.repo \
 && dnf install -y codium \
 && rm -f /etc/yum.repos.d/vscodium.repo

RUN wget --quiet -O firefox-latest.tar.xz "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" \
 && tar xf firefox-latest.tar.xz -C /usr/local \
 && rm -f firefox-latest.tar.xz \
 && ln -s /usr/local/firefox/firefox /usr/bin/firefox

# COPY /install-paraview-visit.sh /
# caching disabled due to as-yet unexplained deadlocks
# RUN --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#     /install-paraview-visit.sh \
#  && rm -f /install-paraview-visit.sh

COPY --from=release-common install-nodejs.sh /
RUN /install-nodejs.sh \
 && rm -f /install-nodejs.sh

COPY --from=release-common install-npm-packages.sh /
RUN /install-npm-packages.sh \
 && rm -f /install-npm-packages.sh

RUN cd /opt \
 && wget -q http://tau.uoregon.edu/demo.tgz \
 && tar xzf demo.tgz \
 && rm -rf demo.tgz \
 && sed -i 's@load tau@load tau/2.36-cuda@g' /opt/demo/CoMD/bin/rt.sh \
 && cd /opt/demo \
 && git clone --quiet https://github.com/ParaToolsInc/e4s-cloud-examples.git \
 && rm -rf e4s-cloud-examples/.git \
 && (cd e4s-cloud-examples && ./fetch-all.sh)

COPY --from=release-common julia/examples /opt/demo/julia-examples

ENV TF_CPP_MIN_LOG_LEVEL=2
ENV PYTHONWARNINGS="ignore::FutureWarning,ignore::DeprecationWarning,ignore::RuntimeWarning,ignore::SyntaxWarning"
ENV TIKTOKEN_ENCODINGS_BASE=/etc/encodings

ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/bashrc"]



FROM final-base AS final-cuda-base

RUN cd /tmp \
 && cuda_runfile=cuda_13.0.3_580.126.20_linux_sbsa.run \
 && wget -q https://developer.download.nvidia.com/compute/cuda/13.0.3/local_installers/$cuda_runfile \
 && sh $cuda_runfile --silent --toolkit \
 && rm -rf $cuda_runfile

RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/sbsa/cuda-rhel9.repo \
 && dnf install -y libnccl-2.32.3-1+cuda12.9 libnccl-devel-2.32.3-1+cuda12.9 libnccl-static-2.32.3-1+cuda12.9 \
 && dnf versionlock add libnccl*

RUN tarball=cudnn-linux-sbsa-9.22.0.52_cuda13-archive.tar.xz \
 && wget -q https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/$tarball \
 && tar xf $tarball \
 && /usr/bin/cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda-13.0/include \
 && /usr/bin/cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda-13.0/lib64 \
 && chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda-13.0/lib64/libcudnn* || true

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cuda.sh /

# caching disabled due to as-yet unexplained deadlocks
# --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cuda.sh \
 && rm -f /install-python-pkgs-cuda.sh

ENV JULIA_CPU_TARGET="generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-n1,clone_all;neoverse-512tvb,clone_all;neoverse-v1,base(6);neoverse-v2,base(6)"
COPY /install-julia-pkgs-cuda.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-cuda.sh \
 && rm -f /install-julia-pkgs-cuda.sh

COPY --chmod=0755 --from=release-common hermes-wrapper.sh hermes-init.sh hermes-ui.sh /etc/e4s/
COPY --from=release-common hermes.desktop /etc/e4s/
RUN ln -sf /etc/e4s/hermes-wrapper.sh /usr/local/bin/hermes \
 && ln -sf /etc/e4s/hermes-ui.sh /usr/local/bin/hermes-ui \
 && ln -sf /etc/e4s/hermes.desktop /usr/share/applications/hermes.desktop
COPY --chmod=0755 --from=release-common install-hermes.sh /
RUN /install-hermes.sh \
 && rm -f /install-hermes.sh

# Orca IDE (GUI is reached through guacamole): upstream's package, plus the E4S orca-ide
# dispatcher (/usr/local/bin) and desktop entry, all installed by install-orca.sh.
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-orca.sh

RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/sbsa/cuda-rhel9.repo \
 && dnf clean all \
 && dnf -y install nvshmem-cuda-12 nvshmem-cuda-13

COPY --from=release-common install-npm-packages-openclaw.sh /
RUN /install-npm-packages-openclaw.sh \
 && rm -f /install-npm-packages-openclaw.sh

COPY --from=release-common install-ollama.sh /tmp/install-ollama.sh
RUN ollama_installer=/tmp/install-ollama.sh \
 && curl -fsSL https://ollama.com/install.sh --output $ollama_installer \
 && sed -i '/install_cuda_driver_apt() {/a echo Skipping NVIDIA driver install && return' $ollama_installer \
 && sed -i '/install_cuda_driver_yum() {/a echo Skipping NVIDIA driver install && return' $ollama_installer \
 && chmod +x $ollama_installer \
 && $ollama_installer \
 && rm $ollama_installer


## FINAL CUDA 120
FROM final-cuda-base AS final-cuda-120

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=rocky9-aarch64-cuda120

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-120 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 /etc/spack /etc/spack
COPY --from=spack-cuda-120 /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

RUN alternatives --set java $(realpath /usr/lib/jvm/java-11/bin/java)

WORKDIR /


## FINAL CUDA 90
FROM final-cuda-base AS final-cuda-90

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=rocky9-aarch64-cuda90

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-90 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 /etc/spack /etc/spack
COPY --from=spack-cuda-90 /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

RUN alternatives --set java $(realpath /usr/lib/jvm/java-11/bin/java)

WORKDIR /


## FINAL CPU
FROM final-base AS final-cpu

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=rocky9-aarch64-cpu

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cpu.sh /
# caching disabled due to as-yet unexplained deadlocks
#   --mount=type=cache,target=/var/cache/dnf,sharing=locked \
#RUN --mount=type=cache,target=/var/cache/dnf,sharing=private \
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cpu.sh \
 && rm -f /install-python-pkgs-cpu.sh

ENV JULIA_CPU_TARGET="generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-n1,clone_all;neoverse-512tvb,clone_all;neoverse-v1,base(6);neoverse-v2,base(6)"
COPY /install-julia-pkgs-cpu.sh /
RUN /install-julia-pkgs-cpu.sh \
 && rm -f /install-julia-pkgs-cpu.sh

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

COPY --chmod=0755 --from=release-common hermes-wrapper.sh hermes-init.sh hermes-ui.sh /etc/e4s/
COPY --from=release-common hermes.desktop /etc/e4s/
RUN ln -sf /etc/e4s/hermes-wrapper.sh /usr/local/bin/hermes \
 && ln -sf /etc/e4s/hermes-ui.sh /usr/local/bin/hermes-ui \
 && ln -sf /etc/e4s/hermes.desktop /usr/share/applications/hermes.desktop
COPY --chmod=0755 --from=release-common install-hermes.sh /
RUN /install-hermes.sh \
 && rm -f /install-hermes.sh

# Orca IDE (GUI is reached through guacamole): upstream's package, plus the E4S orca-ide
# dispatcher (/usr/local/bin) and desktop entry, all installed by install-orca.sh.
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-orca.sh

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

RUN alternatives --set java $(realpath /usr/lib/jvm/java-11/bin/java)

WORKDIR /
