#!/bin/sh -e

LIST=$(find /var/log -type f)

for ELEMENT in ${LIST}; do
    cat /dev/null > "${ELEMENT}"
done

EMPTY=/var/www/php_error.log

for ELEMENT in ${EMPTY}; do
    if [ -f "${ELEMENT}" ]; then
        cat /dev/null > "${ELEMENT}"
    fi
done

LIST="${HOME}/.htoprc
/etc/udev/rules.d/70-persistent-cd.rules
/etc/udev/rules.d/70-persistent-net.rules"

for ELEMENT in ${LIST}; do
    if [ -f "${ELEMENT}" ]; then
        echo "removing: ${ELEMENT}"
        rm "${ELEMENT}"
    fi
done

LIST=$(find /var/log -type f -name '*.bz2' -or -name '*.gz')

for ELEMENT in ${LIST}; do
    rm "${ELEMENT}";
done

LIST=$(find /var/www -type f -name 'php_error_log.*')

for ELEMENT in ${LIST}; do
    rm "${ELEMENT}"
done
