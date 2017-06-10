#!/bin/sh -e

NEW_HOSTNAME="${1}"

if [ "${NEW_HOSTNAME}" = "" ]; then
    echo "Usage: ${0} NEW_HOSTNAME"

    exit 1
fi

CURRENT_HOSTNAME=$(hostname)
FILES="/etc/exim4/update-exim4.conf.conf
/etc/printcap
/etc/hostname
/etc/hosts
/etc/ssh/ssh_host_rsa_key.pub
/etc/ssh/ssh_host_ed25519_key.pub
/etc/ssh/ssh_host_ecdsa_key.pub
/etc/ssh/ssh_host_dsa_key.pub
/etc/motd
/etc/ssmtp/ssmtp.conf"

for FILE in ${FILES}; do
    if [ -f "${FILE}" ]; then
        sed --in-place --expression "s:${CURRENT_HOSTNAME}:${NEW_HOSTNAME}:g" "${FILE}"
    fi
done

sudo reboot
