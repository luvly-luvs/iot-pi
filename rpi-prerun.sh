#!/usr/bin/env bash
set -xeou pipefail

echo ">> Pre-Run Script <<"

sudo apt-get update -y
xargs sudo apt-get -y -f install <packages
xargs sudo apt-get -y -f install --no-install-recommends <packages_nr

touch /boot/ssh
touch "$HOME/.xinitrc"

cat >"$HOME/.bash_profile" <<EOF
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty3 ]
then
  startx >/dev/null 2>&1
fi
EOF

sudo rm -rf /etc/motd
