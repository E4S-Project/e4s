#!/bin/bash -e

## PARAVIEW
cd /tmp
dnf install -y \
 libxcb-devel \
 libxkbcommon-x11 \
 xcb-util-cursor \
 xcb-util-image \
 xcb-util-keysyms \
 xcb-util-renderutil \
 xcb-util-wm
 # xcb-wm

pv_ver=6.1.0
pv_dir=ParaView-$pv_ver-MPI-Linux-Python3.12-x86_64
pv_tarball=${pv_dir}.tar.gz
export pv_dest=/usr/local/paraview-$pv_ver
curl 'https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v6.1&type=binary&os=Linux&downloadFile='$pv_tarball \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:150.0) Gecko/20100101 Firefox/150.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Connection: keep-alive' \
  -H 'Referer: https://www.paraview.org/download/' \
  -H 'Cookie: _ga_QR4H1SSLGQ=GS2.1.s1777216462$o2$g1$t1777216483$j39$l0$h0; _ga=GA1.1.458585666.1776793475; _gid=GA1.2.571128669.1777216462; _gat_UA-6042509-6=1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Priority: u=0, i' \
  --silent \
  --output $pv_tarball
tar xzf $pv_tarball
rm -f $pv_tarball
mv $pv_dir $pv_dest
echo export PATH=$pv_dest/bin:'$PATH' >> /etc/bashrc


## VISIT
cd /tmp
visit_install=visit-install3_4_2
visit_tarball=visit3_4_2.linux-x86_64-rocky9.tar.gz
visit_dest=/usr/local/visit
wget -q https://github.com/visit-dav/visit/releases/download/v3.4.2/$visit_install
wget -q https://github.com/visit-dav/visit/releases/download/v3.4.2/$visit_tarball
chmod +x $visit_install
echo 1 | ./${visit_install} 3.4.2 linux-x86_64-rocky9 $visit_dest  >/dev/null 2>&1
rm -f $visit_tarball $visit_install
echo export PATH=$visit_dest/bin:'$PATH' >> /etc/bashrc
