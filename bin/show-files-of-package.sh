#!/bin/sh -e

PACKAGE="${1}"

if [ "${PACKAGE}" = "" ]; then
    echo "Usage: ${0} PACKAGE"

    exit 1
fi

dpkg-query --listfiles "${PACKAGE}"
