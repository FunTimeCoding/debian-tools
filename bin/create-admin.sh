#!/bin/sh -e

USER_NAME="${1}"
USER_NUMBER="${2}"

if [ "${USER_NAME}" = "" ] || [ "${USER_NUMBER}" = "" ]; then
    echo "Usage: ${0} USER_NAME USER_NUMBER"

    exit 1
fi

# Reasons for groups
# adm: /var/log
# sudo: avoid working as root
useradd --create-home --user-group --uid "${USER_NUMBER}" --shell /bin/bash --groups sudo,adm "${USER_NAME}"
