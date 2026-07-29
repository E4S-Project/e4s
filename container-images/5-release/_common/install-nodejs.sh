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
export PATH=/usr/local/$nodefile/bin:$PATH
cmd npm install -g npm
cmd rm $tarball

tmp_rcfile=/tmp/bash.bashrc

echo export PATH=/usr/local/$nodefile/bin:'$PATH' > $tmp_rcfile

cat <<'EOF' >>$tmp_rcfile
echo prefix=$(realpath ~/.npm-global) > ~/.npmrc
export NPM_CONFIG_PREFIX=~/.npm-global
npm config set fund false --location=global
npm config set update-notifier false
export PATH=$HOME/.npm-global/bin:$PATH
EOF
cat $tmp_rcfile >> /etc/bash.bashrc
