#!/bin/sh -e

FILES=$(find /etc -name '*.bak')

for FILE in ${FILES}; do
    if [ -f "${FILE}" ]; then
        echo "Restore ${FILE}"
	NEW_LOCATION=$(echo "${FILE}" | sed --expression "s/\.bak$//")
	#mv "${FILE}" "${NEW_LOCATION}"
    fi
done
