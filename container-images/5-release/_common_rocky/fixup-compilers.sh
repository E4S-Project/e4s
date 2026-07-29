#!/bin/bash -e

sed -i 's/gcc@13.3.0/gcc@13.3.1/g' $1
sed -i 's@/usr/bin/gcc@/opt/rh/gcc-toolset-13/root/usr/bin/gcc@g' $1
sed -i 's@/usr/bin/g++@/opt/rh/gcc-toolset-13/root/usr/bin/g++@g' $1
sed -i 's@/usr/bin/gfortran@/opt/rh/gcc-toolset-13/root/usr/bin/gfortran@g' $1
sed -i -e '0,/prefix: \/usr/ s@prefix: /usr@prefix: /opt/rh/gcc-toolset-13/root/usr@' $1
