#!/usr/bin/env bash
set -xeou pipefail

echo ">> Pre-Run Script <<"

sudo apt-get update -y
sudo apt-get install -y -f git chromium-browser policykit-1 rfkill alsa-utils alsa-oss libportaudio2 g++ make apt-file libasound2 libasound-dev libxtst-dev libpng++-dev unclutter xdotool
sudo apt-get install -y -f --no-install-recommends xorg xserver-xorg-core xserver-xorg-video-fbdev xinit lxde gvfs-backends gvfs-fuse gnome-keyring
sudo apt-get autoremove -y

touch /boot/ssh
touch "$HOME/.xinitrc"

cat >"$HOME/.bash_profile" <<EOF
if [ -z \$DISPLAY ] && [ \$(tty) = /dev/tty1 ]
then
  startx >/dev/null 2>&1
fi
EOF

sudo rm -rf /etc/motd
