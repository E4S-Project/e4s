#!/bin/bash -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
cmd() {
  echo -e "${GREEN}+ $@ ${NC}"
  eval $@
}
_err() {
  echo -e "${RED}$@${NC}"
}

sysarch=$(arch)
if [[ "$sysarch" == "x86_64" ]]; then
  nodearch=x64
elif [[ "$sysarch" == "aarch64" ]]; then
  nodearch=arm64
else
  _err error: could not match system architecture when installing nodejs
  exit 1
fi

nodever=v26.2.0
nodefile=node-${nodever}-linux-${nodearch}
tarball=$nodefile.tar.xz

cmd cd /tmp
cmd wget -q https://nodejs.org/dist/${nodever}/$tarball
cmd tar xf $tarball -C /usr/local
cmd mv /usr/local/$nodefile /usr/local/node
export PATH=/usr/local/node/bin:$PATH
cmd npm install -g npm
cmd rm $tarball
