#!/bin/bash -e

python_full_path=/opt/python/pkgs/python/bin/python3
source $HOME/.local/bin/env
export UV_TOOL_BIN_DIR=/usr/local/bin
export UV_TOOL_DIR=/opt/taucmdr/tools
uv tool install --no-cache --python $python_full_path taucmdr@1.7.1
chmod -R a+rX,o-w /opt/taucmdr
