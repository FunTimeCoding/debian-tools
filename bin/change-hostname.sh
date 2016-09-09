#!/bin/sh -e

NEW_HOSTNAME="${1}"

if [ "${NEW_HOSTNAME}" = "" ]; then
    echo "Usage: ${0} NEW_HOSTNAME"

    exit 1
fi

# TODO: Add /etc/mailname but without sed. Maybe ditch sed if someone missed one file before.
OLD_HOSTNAME=$(hostname)
FILES="/etc/hostname
/etc/hosts
/etc/ssh/ssh_host_rsa_key.pub
/etc/ssh/ssh_host_ed25519_key.pub
/etc/ssh/ssh_host_ecdsa_key.pub
/etc/ssh/ssh_host_dsa_key.pub"

for FILE in ${FILES}; do
    if [ -f "${FILE}" ]; then
        echo "Modify ${FILE}"
        sed --in-place=".bak" --expression "s/${OLD_HOSTNAME}/${NEW_HOSTNAME}/g" "${FILE}"
    fi
done
