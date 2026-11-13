#!/bin/bash -e

export site_packages=$(python -c "import site; print(site.getsitepackages()[0])")
export python_full_path=/opt/python/pkgs/python/bin/python3

which mpicc | grep mpich

cd /tmp
tar xvf /tmp/downloads/$PY_TARBALL -C /tmp

wheeldir=$(realpath /tmp/ml-1/wheels)
reqdir=$(realpath /tmp/ml-1/requirements)

sed -i 's@file:///ml-1@file:///tmp/ml-1@g' $reqdir/*.requirements*.txt

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
  libzmq3-dev \
  sqlite3 \

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
  bionemo_ir \
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

python3 -m venv --system-site-packages /opt/e4s/venv/nemo
. /opt/e4s/venv/nemo/bin/activate
pip install 'nemo-toolkit[asr,tts]' wget
