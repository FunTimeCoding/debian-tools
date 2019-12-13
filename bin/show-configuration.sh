#!/bin/sh -e

ONLY_KEYS=false

if [ "${1}" = --only-keys ]; then
    ONLY_KEYS=true
fi

OUTPUT=$(grep --invert-match '^#' debian_tools/template/preseed.txt | grep --extended-regexp '(d-i|popularity-contest|tasksel)')

if [ "${ONLY_KEYS}" = true ]; then
    echo "${OUTPUT}" | awk '{ print $1" "$2 }'
else
    echo "${OUTPUT}"
fi
