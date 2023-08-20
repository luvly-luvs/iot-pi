#!/usr/bin/env bash

git clone --branch arm64 https://github.com/RPI-Distro/pi-gen.git pi-gen

pushd pi-gen || exit
xargs sudo apt-get install -y -f <depends

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

chmod +x build.sh
sudo ./build.sh

ls -lh1 deploy

popd || exit
