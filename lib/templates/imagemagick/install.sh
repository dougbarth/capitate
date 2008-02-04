#! /bin/sh

set -e
trap ERROR ERR

cd /tmp

wget -nv ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz

tar zxpf ImageMagick.tar.gz
cd ImageMagick-*
./configure
make && make install

cd ..
rm -rf ImageMagick*