# check=skip=InvalidDefaultArgInFrom

ARG SOURCE_IMAGE

FROM $SOURCE_IMAGE

ARG CUDA_RUNFILE
RUN --mount=type=bind,from=downloads,src=$CUDA_RUNFILE,dst=/$CUDA_RUNFILE \
    sh /$CUDA_RUNFILE --silent --toolkit

ARG CUDNN_TARBALL
RUN --mount=type=bind,from=downloads,src=$CUDNN_TARBALL,dst=/$CUDNN_TARBALL \
    tar xf /$CUDNN_TARBALL \
 && cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include \
 && cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64 \
 && chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn* \
 && rm -rf cudnn-*-archive

RUN ldconfig -v >/dev/null 2>&1

RUN updatedb

ENV PATH=/usr/local/cuda/bin:$PATH

ARG E4S_CUDA_VERSION
LABEL E4S_CUDA_VERSION=$E4S_CUDA_VERSION