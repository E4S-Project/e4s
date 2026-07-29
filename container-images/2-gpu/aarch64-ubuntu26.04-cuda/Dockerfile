# check=skip=InvalidDefaultArgInFrom

ARG SOURCE_IMAGE

FROM $SOURCE_IMAGE

# RUN debfile=libicu74_74.2-1ubuntu3.1_amd64.deb \
#  && wget -q http://security.ubuntu.com/ubuntu/pool/main/i/icu/$debfile \
#  && dpkg -i $debfile && rm -f $debfile \
#  && debfile=libxml2_2.9.14+dfsg-1.3ubuntu3.8_amd64.deb \
#  && wget -q http://security.ubuntu.com/ubuntu/pool/main/libx/libxml2/$debfile \
#  && dpkg -i $debfile && rm -f $debfile

ARG RUNFILE_12_9
RUN --mount=type=bind,from=downloads,src=$RUNFILE_12_9,dst=/$RUNFILE_12_9 \
    sh /$RUNFILE_12_9 --silent --toolkit

COPY --from=gpu-common cuda-12_9-math-functions-newer-glibc.patch /tmp/
RUN patch \
     /usr/local/cuda-12.9/targets/x86_64-linux/include/crt/math_functions.h \
     /tmp/cuda-12_9-math-functions-newer-glibc.patch

ARG CUDNN_TARBALL
RUN --mount=type=bind,from=downloads,src=$CUDNN_TARBALL,dst=/$CUDNN_TARBALL \
    tar xf $CUDNN_TARBALL \
 && cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include \
 && cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64 \
 && chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn* \
 && rm -rf cudnn-*-archive

RUN ldconfig -v >/dev/null 2>&1

RUN updatedb

ENV PATH=/usr/local/cuda/bin:$PATH
