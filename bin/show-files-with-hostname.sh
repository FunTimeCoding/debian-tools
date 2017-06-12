#!/bin/sh -e

NAME="${1}"

if [ "${NAME}" = "" ]; then
    NAME=$(hostname)
fi

FILES="/etc/hostname
/etc/hosts
/etc/ssh/ssh_host_rsa_key.pub
/etc/ssh/ssh_host_ed25519_key.pub
/etc/ssh/ssh_host_ecdsa_key.pub
/etc/ssh/ssh_host_dsa_key.pub"

for FILE in ${FILES}; do
    if [ -f "${FILE}" ]; then
        grep --color=always "${NAME}" "${FILE}" /dev/null
    fi
done
