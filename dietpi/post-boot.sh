#!/usr/bin/env bash
set -xeou pipefail

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

echo ">> Done with post-boot <<"
