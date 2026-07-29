#!/bin/bash -e


GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
cmd() {
  echo -e "${GREEN}+ $@ ${NC}"
  eval $@
}


## PARAVIEW
cd /tmp
apt update -y
apt install -y libxcb*dev #libxkbcommon-x11-dev libegl1 libgl1 libxcursor1
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
echo export PATH=$pv_dest/bin:'$PATH' >> /etc/bash.bashrc


## VISIT
cd /tmp
visit_install=visit-install3_4_2
visit_tarball=visit3_4_2.linux-x86_64-ubuntu24.tar.gz
visit_dest=/usr/local/visit
wget -q https://github.com/visit-dav/visit/releases/download/v3.4.2/$visit_install
wget -q https://github.com/visit-dav/visit/releases/download/v3.4.2/$visit_tarball
chmod +x $visit_install
echo 1 | ./${visit_install} 3.4.2 linux-x86_64-ubuntu24 $visit_dest  >/dev/null 2>&1
rm -f $visit_tarball $visit_install
for f in \
 "/usr/local/visit/3.4.2/linux-x86_64/lib/python/lib/python3.9/site-packages/certifi/cacert.pem" \
 "/usr/local/visit/3.4.2/linux-x86_64/lib/python/lib/python3.9/site-packages/pip/_vendor/certifi/cacert.pem" ;
do
  sed -i '/# SHA256 Fingerprint: b0:bf:d5:2b:b0:d7:d9:bd:92:bf:5d:4d:c1:3d:a2:55:c0:2c:54:2f:37:83:65:ea:89:39:11:f5:5e:55:f2:3c/,/-----END CERTIFICATE-----/d' $f
  sed -i '/# SHA256 Fingerprint: ef:66:b0:b1:0a:3c:db:9f:2e:36:48:c7:6b:d2:af:18:ea:d2:bf:e6:f1:17:65:5e:28:c4:06:0d:a1:a3:f4:c2/,/-----END CERTIFICATE-----/d' $f
  sed -i '/# SHA256 Fingerprint: 87:3f:46:85:fa:7f:56:36:25:25:2e:6d:36:bc:d7:f1:6f:c2:49:51:f2:64:e4:7e:1b:95:4f:49:08:cd:ca:13/,/-----END CERTIFICATE-----/d' $f
done
echo export PATH=$visit_dest/bin:'$PATH' >> /etc/bash.bashrc
