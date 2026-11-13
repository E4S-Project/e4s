#!/bin/bash -e

export NPM_CONFIG_PREFIX=/opt/e4s/node/global
export PATH=/usr/local/node/bin:$PATH

curl -fsSL --proto '=https' --tlsv1.2 https://openclaw.ai/install.sh | bash -s -- --no-onboard --no-prompt 
