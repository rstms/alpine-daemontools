#!/bin/sh
# install python3 and pip3 as default python on alpine linux
apk add --no-cache python3
if [ ! -e /usr/bin/python ]; then
  ln -sf python3 /usr/bin/python
fi
python3 -m ensurepip
rm -r /usr/lib/python*/ensurepip
pip3 install --no-cache --upgrade pip setuptools wheel
if [ ! -e /usr/bin/pip ]; then
  ln -s pip3 /usr/bin/pip
fi
