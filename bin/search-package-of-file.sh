#!/bin/sh

PATTERN="${1}"

if [ "${PATTERN}" = "" ]; then
    echo "Usage: ${0} PATTERN"

    exit 1
fi

dpkg --search "${PATTERN}"
