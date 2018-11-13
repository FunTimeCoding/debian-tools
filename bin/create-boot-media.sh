#!/bin/sh -e

DEVICE="${1}"
SYSTEM=$(uname)

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
fi

if [ "${DEVICE}" = "" ]; then
    echo "Usage: ${0} DEVICE"
    echo "Device format is 'sda', without '/dev/' in front."
    echo "Valid devices:"

    if [ "${SYSTEM}" = Darwin ]; then
        diskutil list
    else
        sudo fdisk -l
    fi

    exit 1
fi

if [ ! -b "/dev/${DEVICE}" ]; then
    echo "${DEVICE} invalid."

    exit 1
fi

# https://www.debian.org/releases/stretch/debian-installer
IMAGE_NAME=debian-9.6.0-amd64-netinst.iso
IMAGE_PATH="${XDG_DOWNLOAD_DIR}/${IMAGE_NAME}"
LOCATOR=http://cdimage.debian.org/debian-cd/9.6.0/amd64/iso-cd

if [ ! -f "${IMAGE_PATH}" ]; then
    wget "${LOCATOR}/${IMAGE_NAME}" --output-document "${IMAGE_PATH}"
fi

if [ "${SYSTEM}" = Darwin ]; then
    SHA256SUM='gsha256sum'
else
    SHA256SUM='sha256sum'
fi

CHECKSUM=c51d84019c3637ae9d12aa6658ea8c613860c776bd84c6a71eaaf765a0dd60fe
IMAGE_CHECKSUM=$(${SHA256SUM} "${IMAGE_PATH}")
IMAGE_CHECKSUM=$(echo "${IMAGE_CHECKSUM% *}" | xargs)

if [ ! "${IMAGE_CHECKSUM}" = "${CHECKSUM}" ]; then
    echo "Checksum fail."
    echo "Web source:"
    wget "${LOCATOR}/SHA256SUMS" --quiet --output-document - | grep "${IMAGE_NAME}"

    exit 1
fi

echo "Continue? y/N"
read -r READ

if [ ! "${READ}" = y ]; then
    echo "User abort."

    exit 1
fi

if [ "${SYSTEM}" = Darwin ]; then
    MAC_NAME=$(echo "${IMAGE_NAME}" | gsed 's/iso/img/')
    MAC_PATH="${XDG_DOWNLOAD_DIR}/${MAC_NAME}"

    if [ ! -f "${MAC_PATH}" ]; then
        hdiutil convert -format UDRW -o "${MAC_PATH}" "${IMAGE_PATH}"
        mv "${MAC_PATH}.dmg" "${MAC_PATH}"
    fi

    diskutil unmountDisk "/dev/${DEVICE}"
    sudo dd if="${MAC_PATH}" of="/dev/r${DEVICE}" bs=1m
    diskutil eject "/dev/${DEVICE}"
else
    sudo umount "/dev/${DEVICE}*" || true
    sudo mount | grep -v "${DEVICE}" && UNMOUNTED=true || UNMOUNTED=false

    if [ "${UNMOUNTED}" = false ]; then
        echo "Unmount failed."

        exit 1
    fi

    sudo dd if="${IMAGE_NAME}" of="/dev/${DEVICE}"
    sudo eject "/dev/${DEVICE}"
fi
