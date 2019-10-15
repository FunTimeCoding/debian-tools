#!/bin/sh -e

if [ "${1}" = '--firmware' ]; then
    FIRMWARE=true
    shift
else
    FIRMWARE=false
fi

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

VERSION=$(bin/show-debian-version.sh | grep --only-matching '[0-9]\+\.[0-9]\+')
VERSION="${VERSION}.0"

if [ "${FIRMWARE}" = true ]; then
    IMAGE_NAME="firmware-${VERSION}-amd64-netinst.iso"
    LOCATOR="https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/${VERSION}+nonfree/amd64/iso-cd"
else
    IMAGE_NAME="debian-${VERSION}-amd64-netinst.iso"
    LOCATOR="https://cdimage.debian.org/debian-cd/${VERSION}/amd64/iso-cd"
fi

IMAGE_PATH="${XDG_DOWNLOAD_DIR}/${IMAGE_NAME}"


if [ ! -f "${IMAGE_PATH}" ]; then
    wget "${LOCATOR}/${IMAGE_NAME}" --output-document "${IMAGE_PATH}"
fi

if [ "${SYSTEM}" = Darwin ]; then
    SHA256SUM='gsha256sum'
else
    SHA256SUM='sha256sum'
fi

CHECKSUM=$(curl --silent "${LOCATOR}/SHA256SUMS" | grep "${IMAGE_NAME}" | awk '{ print $1 }')
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

    sudo dd if="${IMAGE_PATH}" of="/dev/${DEVICE}"
    sudo eject "/dev/${DEVICE}"
fi
