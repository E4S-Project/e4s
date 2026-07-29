#!/bin/bash -e

site_packages=$(python -c "import site; print(site.getsitepackages()[0])")

export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=true
export H5PY_SETUP_REQUIRES=0
apt update -y
apt install -y pkg-config libjpeg-dev zlib1g-dev

cd /tmp
tar xvf /tmp/downloads/$PY_TARBALL -C /tmp

wheeldir=$(realpath /tmp/wheels)
reqdir=$wheeldir

sed -i 's@file:///wheels@file:///tmp/wheels@g' $reqdir/requirements*.txt

ls -l $wheeldir
ls -l $reqdir

curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

python --version | grep 3.8

uv pip install --system --no-binary mpi4py -r $reqdir/requirements.txt

chmod -R o+rwX $site_packages

# rm -rf /wheels     # skip this as long as docker mounts in artifacts
# rm -rf ~/.cache    # skip this as long as docker is caching
