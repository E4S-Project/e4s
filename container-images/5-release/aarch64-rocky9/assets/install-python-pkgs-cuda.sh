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

dnf install -y epel-release
dnf config-manager --set-enabled crb
dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm -y
dnf install -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm
dnf install -y ffmpeg ffmpeg-devel

dnf install -y \
 hwloc-devel \
 libsndfile-devel \
 sqlite-devel \
 zeromq-devel

uv pip install \
 --system \
 --python $python_full_path \
 --no-binary mpi4py \
 --overrides $reqdir/main-env.requirements.overrides.txt \
 -r $reqdir/main-env.requirements.txt

rm -rf /tmp/ml-1

# curl --silent -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh
# bash ./Miniconda3-latest-Linux-aarch64.sh -b -p /usr/local/miniconda3
# rm -f Miniconda3-latest-Linux-aarch64.sh
# conda install -c conda-forge libstdcxx-ng=13
# find /usr/local/miniconda3 -type f -name "libstdc++*"
wget -q https://cache.e4s.io/$(python3 -c "import urllib.parse; print(urllib.parse.quote('''libstdc++.so.6.0.32.aarch64'''))")
mv libstdc++.so.6.0.32.aarch64 /lib64/libstdc++.so.6.0.32
rm -f /lib64/libstdc++.so.6
ln -s /lib64/libstdc++.so.6.0.32 /lib64/libstdc++.so.6

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

