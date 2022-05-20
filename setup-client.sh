#!/usr/bin/bash

#Install tntapi client side scripting

sudo apt-get -y install  python3-distutils python3 python3-lxml libxml2-utils python3-paramiko
git clone https://github.com/vlvassilev/litenc.git
cd litenc
python setup.py install
cd tntapi
python setup.py install
cd ../..
cd yuma123/netconf/python
apt-get -y install python-all-dev
autoreconf -i -f
./configure CFLAGS="-g -O0"  CXXFLAGS="-g -O0" --prefix=/usr
make
make install
python setup.py install
cd ../../../

