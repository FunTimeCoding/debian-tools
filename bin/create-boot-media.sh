#!/bin/sh -e

DEVICE="${1}"
OPERATING_SYSTEM=$(uname)
CONFIG_DIRECTORY="${XDG_CONFIG_HOME:-$HOME/.config}"
USER_DIRECTORIES_FILE="${CONFIG_DIRECTORY}/user-dirs.dirs"

if [ -f "${USER_DIRECTORIES_FILE}" ]; then
    . "${USER_DIRECTORIES_FILE}"
fi

if [ "${DEVICE}" = "" ]; then
    echo "Usage: ${0} DEVICE"
    echo "Device format is 'sda', without '/dev/' in front."
    echo "Valid devices:"

    if [ "${OPERATING_SYSTEM}" = "Linux" ]; then
        sudo fdisk -l
    elif [ "${OPERATING_SYSTEM}" = "Darwin" ]; then
        diskutil list
    fi

    exit 1
fi

if [ ! -b "/dev/${DEVICE}" ]; then
    echo "${DEVICE} invalid."

    exit 1
fi

# https://www.debian.org/releases/jessie/debian-installer
VERSION="8.4.0"
IMAGE_NAME="debian-${VERSION}-amd64-netinst.iso"
IMAGE_PATH="${XDG_DOWNLOAD_DIR}/${IMAGE_NAME}"
LOCATOR="http://cdimage.debian.org/debian-cd/${VERSION}/amd64/iso-cd"

if [ ! -f "${IMAGE_PATH}" ]; then
    wget "${LOCATOR}/${IMAGE_NAME}" --output-document "${IMAGE_PATH}"
fi

CHECKSUM="7a6b418e6a4ee3ca75dda04d79ed96c9e2c33bb0c703ca7e40c6374ab4590748"
IMAGE_CHECKSUM=$(sha256sum "${IMAGE_PATH}")
IMAGE_CHECKSUM=$(echo "${IMAGE_CHECKSUM% *}" | xargs)

if [ ! "${IMAGE_CHECKSUM}" = "${CHECKSUM}" ]; then
    echo "Checksum fail."
    echo "Web source:"
    wget "${LOCATOR}/SHA256SUMS" --quiet --output-document - | grep "${IMAGE_NAME}"

    exit 1
fi

echo "Continue? y/N"
read -r READ

if [ ! "${READ}" = "y" ]; then
    echo "User abort."

    exit 1
fi

if [ "${OPERATING_SYSTEM}" = "Linux" ]; then
    sudo umount "/dev/${DEVICE}*" || true
    sudo mount | grep -v "${DEVICE}" && UNMOUNTED=true || UNMOUNTED=false

    if [ "${UNMOUNTED}" = false ]; then
        echo "Unmount failed."

        exit 1
    fi

    sudo dd if="${IMAGE_NAME}" of="/dev/${DEVICE}"
    sudo eject "/dev/${DEVICE}"
elif [ "${OPERATING_SYSTEM}" = "Darwin" ]; then
    MAC_NAME=$(echo "${IMAGE_NAME}" | sed 's/iso/img/')
    MAC_PATH="${XDG_DOWNLOAD_DIR}/${MAC_NAME}"

    if [ -f "${MAC_PATH}" ]; then
        hdiutil convert -format UDRW -o "${MAC_PATH}" "${IMAGE_PATH}"
        mv "${MAC_PATH}.dmg" "${MAC_PATH}"
    fi

    diskutil unmountDisk "/dev/${DEVICE}"
    sudo dd if="${MAC_PATH}" of="/dev/r${DEVICE}" bs=1m
    diskutil eject "/dev/${DEVICE}"
fi
