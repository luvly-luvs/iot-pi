#!/usr/bin/env bash
set -xeou pipefail

comp_type=${1:-zip}
comp_level=${2:-6}
img_key=${3:-iot-pi}

sudo apt-get update -y
xargs sudo apt-get install -f -y <../depends

cat >>config <<-EOF
# -- pigen config --
IMG_NAME="$img_key"
RELEASE="bullseye"
DEPLOY_COMPRESSION="$comp_type"
COMPRESSION_LEVEL="$comp_level"
LOCALE_DEFAULT="en_US.UTF-8"
TARGET_HOSTNAME="LittleBirdTE-001"
KEYBOARD_KEYMAP="us"
TIMEZONE_DEFAULT="America/Phoenix"
FIRST_USER_NAME="pi"
FIRST_USER_PASS="password"
DISABLE_FIRST_BOOT_USER_RENAME=1
ENABLE_SSH=1
STAGE_LIST="stage0 stage1 stage2"
# ------------------
EOF

touch ./stage2/SKIP_NOOBS

sudo chmod +x ./build.sh
sudo ./build.sh
