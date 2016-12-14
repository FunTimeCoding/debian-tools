#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
TEMPLATE_DIRECTORY="${SCRIPT_DIRECTORY}/../template/example"
RELEASES="jessie wheezy"

for RELEASE in ${RELEASES}; do
    wget --output-document "${TEMPLATE_DIRECTORY}/${RELEASE}.cfg" "https://www.debian.org/releases/${RELEASE}/example-preseed.txt"
done
