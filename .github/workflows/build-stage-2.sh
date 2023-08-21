#!/usr/bin/env bash
set -aeou pipefail

sudo apt-get install -y -f coreutils quilt parted qemu-user-static debootstrap \
  dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
  qemu-utils kpartx gpg pigz zerofree zip jq lshw

cat <<-CONFIG >config
IMG_NAME="iot-pi"
IMG_DATE=$(date +%Y%m%d_%H%M%S)
RELEASE=bullseye
LOCALE_DEFAULT="en_US.UTF-8"
TARGET_HOSTNAME="iot-pi-${RANDOM}"
KEYBOARD_KEYMAP="us"
KEYBOARD_LAYOUT="English (US)"
TIMEZONE_DEFAULT="America/Phoenix"
FIRST_USER_NAME="root"
FIRST_USER_PASS="pigen"
DISABLE_FIRST_BOOT_USER_RENAME=1
STAGE_LIST="stage0 stage1 stage2"
CONFIG

cat <<EXPIMG >stage2/EXPORT_IMAGE
IMG_SUFFIX=""
if [ "\${USE_QEMU}" = "1" ]; then
	export IMG_SUFFIX="\${IMG_SUFFIX}-qemu"
fi
EXPIMG

cat <<EXPNOOBS >stage2/EXPORT_NOOBS
NOOBS_NAME="RPiOS Lite-ish (stage2-arm64)"
NOOBS_DESCRIPTION="A port of Debian with no desktop environment"
EXPNOOBS

sudo chmod +x build.sh
sudo ./build.sh

ls -lh1 deploy
