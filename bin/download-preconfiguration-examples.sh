#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

for RELEASE in jessie stretch buster; do
    wget --output-document "${SCRIPT_DIRECTORY}/../debian_tools/template/example/${RELEASE}.txt" "https://www.debian.org/releases/${RELEASE}/example-preseed.txt"
done
