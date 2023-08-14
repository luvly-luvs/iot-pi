#!/usr/bin/env bash
set -xeou pipefail

git clone --depth 1 --branch arm64 https://github.com/RPI-Distro/pi-gen.git

touch ./pi-gen/stage2/SKIP_IMAGES ./pi-gen/stage2/SKIP_NOOBS

ln -s ../config ./pi-gen
ln -s ../stage2-iot ./pi-gen
[ ! -d ./pi-gen/deploy ] && mkdir ./pi-gen/deploy
ln -s ./pi-gen/deploy .
