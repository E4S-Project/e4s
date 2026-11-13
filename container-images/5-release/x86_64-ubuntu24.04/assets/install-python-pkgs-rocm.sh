#!/bin/bash -e

export site_packages=$(python -c "import site; print(site.getsitepackages()[0])")
export python_full_path=/opt/python/pkgs/python/bin/python3

cd /tmp
tar xvf /tmp/downloads/$PY_TARBALL -C /tmp

wheeldir=$(realpath /tmp/ml-1/wheels)
reqdir=$(realpath /tmp/ml-1/requirements)

sed -i 's@file:///ml-1@file:///tmp/ml-1@g' $reqdir/*.requirements*.txt

ls -l $wheeldir
ls -l $reqdir

curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

uv pip install \
 --system \
 --python $python_full_path \
 --pre \
 -r $reqdir/torch-vllm-rocm-env.requirements.txt

uv pip install \
 --system \
 --python $python_full_path \
 -r $reqdir/jax-rocm-env.requirements.txt 

uv pip install \
 --system \
 --python $python_full_path \
 -r $reqdir/tensorflow-rocm-env.requirements.txt 

# 403 permission denied; worked for a while, stopped working, unclear why
# uv pip install \
#  --system \
#  --python $python_full_path \
#  -r $reqdir/xgboost-rocm-env.requirements.txt 

uv pip install \
 --system \
 --python $python_full_path \
 --no-binary mpi4py \
 --overrides $reqdir/main-env.requirements.overrides.txt \
 -r $reqdir/main-env.requirements.txt

rm -rf /tmp/ml-1

fail=0
for pkg in \
  a2a \
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
  sympy \
  tensorboard \
  tensorflow \
  torch \
  tqdm \
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
