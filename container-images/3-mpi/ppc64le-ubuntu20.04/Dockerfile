# check=skip=InvalidDefaultArgInFrom

ARG BUILDER_IMAGE
ARG FINAL_IMAGE_BASE

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


## 2. Concretize mpich
FROM $BUILDER_IMAGE AS mpich-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT

COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

ARG MPICH_PATH

COPY --from=mpi-common spack.mpich.yaml $MPICH_PATH/spack.yaml

WORKDIR $MPICH_PATH

ARG MPICH_VERSION
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack env activate -d . \
 && spack -e . compiler find \
 && spack -e . config add packages:all:require:[target=ppc64le] \
 && spack add mpich@$MPICH_VERSION ~wrapperrpath ~hwloc \
 && spack concretize -f | tee concretize.log


## 3. Build a relocatable mpich + push to cache; then install from cache into MPICH_PATH
FROM $BUILDER_IMAGE AS mpich-build

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
ARG MPICH_PATH

COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=mpich-concretize $MPICH_PATH $MPICH_PATH

COPY --from=container-common utilities.sh $MPICH_PATH/
COPY --from=mpi-common build-and-install-mpich.sh $MPICH_PATH/

WORKDIR $MPICH_PATH

ARG MPICH_MIRROR
ARG CACHE_ONLY
ARG S3_ENDPOINT
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    --mount=type=secret,id=SIGNING_KEY,required=true \
    ./build-and-install-mpich.sh


## 4. Create final release-base image with mpich from (2)
FROM $FINAL_IMAGE_BASE AS mpich-final

ARG MPICH_PATH
ARG MPICH_VERSION

COPY --from=mpich-build $MPICH_PATH $MPICH_PATH

RUN echo $MPICH_PATH/pkgs/mpich-$MPICH_VERSION/lib > /etc/ld.so.conf.d/mpich.conf \
 && ldconfig -v >/dev/null 2>&1

RUN updatedb

ENV PATH=$MPICH_PATH/pkgs/mpich-$MPICH_VERSION/bin:$PATH
