#!/bin/sh -e

DEVICE="${1}"
SYSTEM=$(uname)

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
fi

if [ "${DEVICE}" = '' ]; then
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

RELEASE='buster'
ARCHIVE_PATH="${XDG_DOWNLOAD_DIR}/firmware-${RELEASE}.tar.gz"

if [ ! -f "${ARCHIVE_PATH}" ]; then
    wget "http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/${RELEASE}/current/firmware.tar.gz" --output-document "${ARCHIVE_PATH}"
fi

echo "Continue? y/N"
read -r READ

if [ ! "${READ}" = y ]; then
    echo "User abort."

    exit 1
fi

if [ "${SYSTEM}" = Darwin ]; then
    echo "Not implemented yet."
else
    #sudo sgdisk --zap-all "/dev/${DEVICE}"
    # TODO: This does not work as expected.
    #echo -e "o\nn\np\n1\n\n\nt\nb\nw" | sudo fdisk "/dev/${DEVICE}"
    sudo mkfs.vfat "/dev/${DEVICE}1"
    MOUNT_DIRECTORY="${PWD}/tmp/mount"
    mkdir -p "${MOUNT_DIRECTORY}"
    sudo mount "/dev/${DEVICE}1" "${MOUNT_DIRECTORY}"
    sudo tar --extract --file "${ARCHIVE_PATH}" --directory "${MOUNT_DIRECTORY}"
    sudo umount "${MOUNT_DIRECTORY}"
    sudo eject "/dev/${DEVICE}"
fi
