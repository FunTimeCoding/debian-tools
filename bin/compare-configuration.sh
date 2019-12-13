#!/bin/sh -e

STRETCH=$(grep --invert-match '^#' debian_tools/template/stretch.txt | grep --extended-regexp '(d-i|popularity-contest|tasksel)' | awk '{ print $1" "$2 }' | sort)
BUSTER=$(grep --invert-match '^#' debian_tools/template/buster.txt | grep --extended-regexp '(d-i|popularity-contest|tasksel)' | awk '{ print $1" "$2 }' | sort)

echo "${STRETCH}" >tmp/stretch.txt
echo "${BUSTER}" >tmp/buster.txt
diff tmp/stretch.txt tmp/buster.txt
rm tmp/stretch.txt tmp/buster.txt
