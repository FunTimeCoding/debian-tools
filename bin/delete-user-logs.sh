#!/bin/sh -e

EMPTY="${HOME}/.bash_history
${HOME}/.ssh/known_hosts
${HOME}/.nano_history
${HOME}/.lesshst"

for FILE in ${EMPTY}; do
    if [ -f "${FILE}" ]; then
        cat /dev/null > "${FILE}"
    fi
done

REMOVE="${HOME}/.htoprc"

for FILE in ${REMOVE}; do
    if [ -f "${FILE}" ]; then
        rm "${FILE}"
    fi
done

echo "Run the following command:"
echo "unset HISTFILE"
