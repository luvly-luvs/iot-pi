#!/usr/bin/env bash
set -eou pipefail

git clone --branch arm64 https://github.com/RPI-Distro/pi-gen.git pi-gen

pushd pi-gen || exit
sudo apt-get update
xargs sudo apt-get install -y -f <../depends

cat <<CONFIG >config
IMG_NAME="iot-pi"
IMG_DATE=$(date +%Y%m%d_%H%M%S)
RELEASE=bullseye
LOCALE_DEFAULT="en_US.UTF-8"
TARGET_HOSTNAME="iot-pi-${RANDOM}"
KEYBOARD_KEYMAP="us"
KEYBOARD_LAYOUT="English (US)"
TIMEZONE_DEFAULT="America/Phoenix"
STAGE_LIST="stage0 stage1"
CONFIG

cat <<EXPIMG >stage1/EXPORT_IMAGE
IMG_SUFFIX=""
if [ "\${USE_QEMU}" = "1" ]; then
	export IMG_SUFFIX="\${IMG_SUFFIX}-qemu"
fi
EXPIMG

cat <<EXPNOOBS >stage1/EXPORT_NOOBS
NOOBS_NAME="RPiOS (stage1-arm64)"
NOOBS_DESCRIPTION="A port of Debian with no desktop environment"
EXPNOOBS

sudo chmod +x build.sh
sudo ./build.sh

ls -lh1 deploy

popd || exit
