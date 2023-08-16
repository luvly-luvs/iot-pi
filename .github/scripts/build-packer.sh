#!/usr/bin/env bash
set -xeou pipefail

base_img=${1:-"DietPi_RPi-ARMv8-Bookworm"}

sudo chmod +x ./*.sh

sudo apt-get update -y
sudo apt-get install qemu-user-static p7zip-full p7zip-rar -y -f
wget -q "https://dietpi.com/downloads/images/$base_img.7z" -O "$base_img.7z"
7z e -o. -bt -y "$base_img.7z"
rm "$base_img.7z"
cat hash.txt
IFS=" " read -ra sha_out <<<"$(shasum -a 256 "$base_img.img")"
echo "sha256:${sha_out[0]}"

cat >"rpi-os.pkrvars.hcl" <<-EOF
source_iso_url = "$base_img.img"
source_iso_checksum = "${sha_out[0]}"
EOF

! command -v packer && (
  echo "packer not found"
  exit 1
)

sudo packer init .
sudo packer validate .
sudo packer build -var-file="rpi-os.pkrvars.hcl" .
rm "$base_img.img"
