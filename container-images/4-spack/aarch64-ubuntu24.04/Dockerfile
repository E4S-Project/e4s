# check=skip=InvalidDefaultArgInFrom

ARG FINAL_IMAGE_BASE
ARG BUILDER_IMAGE

## Clone spack core repo
FROM $BUILDER_IMAGE AS spack-core

ARG SPACK_CORE_CHECKOUT
ARG SPACK_CORE_REPO
ARG SPACK_CORE_ROOT

RUN git clone --quiet $SPACK_CORE_REPO $SPACK_CORE_ROOT \
 && git -C $SPACK_CORE_ROOT checkout --quiet $SPACK_CORE_CHECKOUT


## Clone spack-packages repo
FROM $BUILDER_IMAGE AS spack-packages

ARG SPACK_PACKAGES_CHECKOUT
ARG SPACK_PACKAGES_REPO
ARG SPACK_PACKAGES_ROOT

RUN git clone --quiet $SPACK_PACKAGES_REPO $SPACK_PACKAGES_ROOT \
 && git -C $SPACK_PACKAGES_ROOT checkout --quiet $SPACK_PACKAGES_CHECKOUT


## Complete spack setup (spack core + spack-packages)
FROM $BUILDER_IMAGE AS spack-complete

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT

COPY --from=spack-core $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-packages $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && export SPACK_DISABLE_LOCAL_CONFIG=1 \
 && spack repo set --destination $SPACK_PACKAGES_ROOT builtin \
 && spack config --scope site add "config:db_lock_timeout:480" \
 && spack config --scope site add "config:connect_timeout:60"


FROM $FINAL_IMAGE_BASE AS cpu-final

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT

COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

ARG SPACK_MIRROR
ARG S3_ENDPOINT

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && export SPACK_DISABLE_LOCAL_CONFIG=1 \
 && spack mirror add --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -it -y

COPY --from=spack-common etc-spack/* /etc/spack/
COPY --from=spack-common merge-spack-packages.py /tmp/
COPY --from=spack_env gnu/_config/packages.yaml /etc/spack/

COPY --from=spack-common install-external-specs.sh /tmp
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && /tmp/install-external-specs.sh /etc/spack/packages.yaml

# Copy helper files and documentation to /etc/e4s
RUN mkdir -p /etc/e4s
COPY --from=spack_env gnu/_config /etc/e4s/_config
COPY --from=spack_env gnu/cpu /etc/e4s/cpu
COPY --from=spack-common README.md pingpong.c e4s-init.sh /etc/e4s
RUN chmod +x /etc/e4s/e4s-init.sh

# Install e4s-chain-spack script
COPY --from=container-common --chmod=755 e4s-chain-spack.sh /etc/e4s/

# Configure bash initialization
RUN echo . $SPACK_CORE_ROOT/share/spack/setup-env.sh >> /etc/bash.bashrc \
 && ln -sf /etc/e4s/e4s-chain-spack.sh /usr/local/bin/e4s-chain-spack.sh \
 && echo module use $SPACK_CORE_ROOT/share/spack/modules/linux-ubuntu24.04-x86_64_v3 >> /etc/bash.bashrc \
 && echo module load mpich >> /etc/bash.bashrc \
 && echo . /etc/e4s/e4s-init.sh >> /etc/bash.bashrc

RUN updatedb

RUN chmod -R ugo+rwX $SPACK_CORE_ROOT

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

# Set working directory to root's home for a cleaner user experience
WORKDIR /root


FROM $FINAL_IMAGE_BASE AS cuda-final

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT

COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

ARG SPACK_MIRROR
ARG S3_ENDPOINT

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && export SPACK_DISABLE_LOCAL_CONFIG=1 \
 && spack mirror add --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -it -y

COPY --from=spack-common etc-spack/* /etc/spack/
COPY --from=spack-common merge-spack-packages.py /tmp/
COPY --from=spack_env gnu/_config/packages.yaml /tmp/packages-1.yaml
COPY --from=spack_env gnu/cuda/_config/packages.yaml /tmp/packages-2.yaml
RUN python3 \
      /tmp/merge-spack-packages.py \
      /tmp/packages-1.yaml /tmp/packages-2.yaml \
       | tee /etc/spack/packages.yaml

COPY --from=spack-common install-external-specs.sh /tmp
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && /tmp/install-external-specs.sh /etc/spack/packages.yaml

# Copy helper files and documentation to /etc/e4s
RUN mkdir -p /etc/e4s
COPY --from=spack_env gnu/_config /etc/e4s/_config
COPY --from=spack_env gnu/cpu /etc/e4s/cpu
COPY --from=spack_env gnu/cuda /etc/e4s/cuda
COPY --from=spack-common README.md pingpong.c e4s-init.sh /etc/e4s
RUN chmod +x /etc/e4s/e4s-init.sh

# Install e4s-chain-spack script
COPY --from=container-common --chmod=755 e4s-chain-spack.sh /etc/e4s/

# Configure bash initialization
RUN echo . $SPACK_CORE_ROOT/share/spack/setup-env.sh >> /etc/bash.bashrc \
 && ln -sf /etc/e4s/e4s-chain-spack.sh /usr/local/bin/e4s-chain-spack.sh \
 && echo module use $SPACK_CORE_ROOT/share/spack/modules/linux-ubuntu24.04-x86_64_v3 >> /etc/bash.bashrc \
 && echo module load mpich >> /etc/bash.bashrc \
 && echo . /etc/e4s/e4s-init.sh >> /etc/bash.bashrc

RUN updatedb

RUN chmod -R ugo+rwX $SPACK_CORE_ROOT

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

# Set working directory to root's home for a cleaner user experience
WORKDIR /root
