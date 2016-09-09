#!/bin/sh -e

FILES=$(find /etc -name '*.bak')

for FILE in ${FILES}; do
    if [ -f "${FILE}" ]; then
        echo "Remove ${FILE}"
	#rm "${FILE}"
    fi
done
