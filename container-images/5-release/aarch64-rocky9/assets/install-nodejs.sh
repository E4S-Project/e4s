#!/bin/bash -e

. /opt/utilities.sh

nodefile=node-v22.19.0-linux-arm64
tarball=$nodefile.tar.xz

cmd cd /tmp
cmd wget -q https://nodejs.org/dist/v22.19.0/$tarball
cmd tar xf $tarball -C /usr/local
export PATH=/usr/local/$nodefile/bin:$PATH
cmd npm install -g npm@11.6.0
cmd rm $tarball

tmp_rcfile=/tmp/bashrc

echo export PATH=/usr/local/$nodefile/bin:'$PATH' > $tmp_rcfile

cat <<'EOF' >>$tmp_rcfile
echo prefix=$(realpath ~/.npm-global) > ~/.npmrc
export NPM_CONFIG_PREFIX=~/.npm-global
npm config set fund false --location=global
npm config set update-notifier false
export PATH=$HOME/.npm-global/bin:$PATH
EOF
cat $tmp_rcfile >> /etc/bashrc

cat <<'EOF' >>/etc/bashrc
set +m
(npm install -g npx >/dev/null 2>&1 &)
EOF
