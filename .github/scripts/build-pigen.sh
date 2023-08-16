#!/usr/bin/env bash
set -xeou pipefail

touch ./stage2/SKIP_IMAGES ./stage2/SKIP_NOOBS
find ../stage2-iot -type f -iname "*.sh" -exec chmod +x {} \; -exec basename {} ./ \;

ln -s ../config ./
ln -s ../stage2-iot ./
