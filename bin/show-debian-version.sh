#!/bin/sh -e

OUTPUT=$(wget --quiet http://cdimage.debian.org/debian-cd/current/amd64/iso-cd --output-document -)
IMAGES=$(echo ${OUTPUT} | hxnormalize -x | hxselect -s "\n" -c a | grep '^debian-[0-9].*') || true
VERSION=$(echo "${IMAGES}" | head -1 | grep --only-match '[0-9]\+\.[0-9]\+')

echo "Debian: ${VERSION}"
