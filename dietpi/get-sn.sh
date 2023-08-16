#!/usr/bin/env bash
set -xeou pipefail

echo ">> Getting device serial number <<"

sudo apt-get update -y
sudo apt-get install lshw sed -y
sudo apt-get autoremove -f -y

SERIAL_NUMBER=$(
  sudo lshw |
    grep -E 'serial:' |
    head -n1 |
    sed "s/serial: //" |
    sed -e 's/^[ \t]*//'
) && export SERIAL_NUMBER

echo ">> Serial number: $SERIAL_NUMBER <<"
