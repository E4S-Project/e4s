#!/bin/bash -e

export site_packages=$(python -c "import site; print(site.getsitepackages()[0])")
export python_full_path=/opt/python/pkgs/python-3.12.13/bin/python3

cd /tmp
tar xvf /tmp/downloads/$PY_TARBALL -C /tmp

wheeldir=$(realpath /tmp/ml-1/wheels)
reqdir=$(realpath /tmp/ml-1/requirements)

sed -i 's@file:///ml-1@file:///tmp/ml-1@g' $reqdir/requirements-*.txt

ls -l $wheeldir
ls -l $reqdir

curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

apt update -y
apt-get install -y \
  ffmpeg \
  libibverbs-dev \
  libsndfile1 \
  libsqlite3-dev \
  libzmq3-dev

uv pip install \
 --python $python_full_path \
 --system \
 -r $reqdir/requirements-torch.txt

uv pip install \
 --python $python_full_path \
 --system \
 --no-binary mpi4py \
 -r $reqdir/requirements-2.txt \
 --overrides $reqdir/overrides-for-requirements-2-total-install.txt

uv pip install \
 --python $python_full_path \
 --system ray[tune]

uv pip install \
 --python $python_full_path \
 --system rdkit

uv pip install \
 --python $python_full_path \
 --system \
 cupy-cuda13x==14.1.1

uv pip install \
 --python $python_full_path \
 --system \
 'kernels>=0.12.0,<0.13'

rm -rf /tmp/ml-1

fail=0
for pkg in \
  a2a \
  bionemo \
  cupy \
  cv2 \
  geopandas \
  gradio \
  ipykernel \
  ipywidgets \
  jax \
  jupyter \
  langchain.agents \
  langchain.messages \
  langchain.tools \
  marimo \
  matplotlib \
  monarch \
  mpi4py \
  notebook \
  numpy \
  pandas \
  plotly \
  ray \
  rdkit \
  requests \
  scipy \
  seaborn \
  sglang \
  sympy \
  tensorboard \
  tensorflow \
  torch \
  tqdm \
  vllm \
  wandb;
do
  rc=0
  python3 -c "import $pkg" >/dev/null 2>&1 && echo $pkg succeeded || rc=1
  if [[ $rc -eq 1 ]]; then
    echo $pkg failed;
    fail=1
  fi
done
if [[ $fail -eq 1 ]]; then
  echo "ERROR: Python import tests failed; one or more packages could not be imported as expected"
  exit 1
fi


# Fix VLLM bug: https://github.com/vllm-project/vllm/issues/22525
wget -q https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken
wget -q https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken
mkdir -p /etc/encodings
mv *.tiktoken /etc/encodings
chmod -R o+rwX /etc/encodings
