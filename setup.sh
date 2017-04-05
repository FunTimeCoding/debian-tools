#!/bin/sh -e

SYSTEM=$(uname)

if [ "${SYSTEM}" = Linux ]; then
    sudo apt-get --quiet 2 install libenchant-dev
fi

pip3 install --upgrade --user --requirement requirements.txt
pip3 install --user --editable .
