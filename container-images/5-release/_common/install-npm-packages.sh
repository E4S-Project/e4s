#!/bin/bash -e

export NPM_CONFIG_PREFIX=/opt/e4s/node/global
export PATH=/usr/local/node/bin:$PATH

npm install -g @google/gemini-cli
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
npm install -g --allow-scripts=@opencode/cli @opencode/cli
npm config set fund false --location=global
npm config set update-notifier false
