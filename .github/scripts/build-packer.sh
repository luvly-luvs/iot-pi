#!/usr/bin/env bash
set -xeou pipefail

base_img=${1:-"DietPi_RPi-ARMv8-Bookworm.7z"}

sudo chmod +x ./*.sh

sudo apt-get install qemu-user-static p7zip-full p7zip-rar -y -f
wget -qO "https://dietpi.com/downloads/images/$base_img"
7z e -o. -bt -y "$base_img"
IFS=" " read -ra sha_out <<<"$(shasum -a 256 "$base_img")"

echo "iso_url=$base_img" >>"$GITHUB_OUTPUT"
echo "iso_checksum=${sha_out[0]}" >>"$GITHUB_OUTPUT"

cat >"./rpi-os.pkrvars.hcl" <<-EOF
iso_url = "$base_img"
iso_checksum = "${sha_out[0]}"
EOF

! command -v packer && (
  echo "packer not found"
  exit 1
)

packer build -var-file="rpi-os.pkrvars.hcl" .
