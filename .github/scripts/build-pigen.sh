#!/usr/bin/env bash
set -xeou pipefail

comp_type=${1:-zip}
comp_level=${2:-6}
img_key=${3:-iot-pi}

sudo apt-get update -y
xargs sudo apt-get install -f -y <depends

cat >config <<-EOF
# -- pigen config --
IMG_NAME="$img_key"
RELEASE="bullseye"
DEPLOY_COMPRESSION="$comp_type"
COMPRESSION_LEVEL="$comp_level"
LOCALE_DEFAULT="en_US.UTF-8"
TARGET_HOSTNAME="LittleBirdTE-XXX"
KEYBOARD_KEYMAP="us"
TIMEZONE_DEFAULT="America/Phoenix"
FIRST_USER_NAME="pi"
FIRST_USER_PASS="password"
ENABLE_SSH=1
PUBKEY_SSH_FIRST_USER=0
STAGE_LIST="stage0 stage1 stage2"
# ------------------
EOF

touch ./pi-gen/stage2/SKIP_NOOBS
ln -s ./config ./pi-gen/config

chmod +x ./pi-gen/build.sh
./pi-gen/build.sh
