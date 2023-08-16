#!/usr/bin/env bash
set -xeou pipefail

MNT_PATH="/mnt/dietpi" && export MNT_PATH
BOOT_PATH="$MNT_PATH/boot" && export BOOT_PATH
IMAGE_NAME="DietPi_RPi-ARMv8-Bullseye" && export IMAGE_NAME
IMAGE_URL="https://dietpi.com/downloads/images/$IMAGE_NAME.7z" && export IMAGE_URL
LOOP=$(sudo losetup -f) && export LOOP

OS_CONFIG=$1
DIET_CONFIG=$2
POSTBOOT_SCRIPT=$3

function cleanup {
  sudo umount -f "$BOOT_PATH"
  sudo umount -f "$MNT_PATH"
  sudo losetup -d "$LOOP"
  sudo rm -rf "$MNT_PATH"
}
trap cleanup EXIT

echo ">> Building DietPi Image <<"
echo ">> Downloading latest DietPi image <<"
wget -q "$IMAGE_URL" -O "$IMAGE_NAME.7z"
7z e -o. -bt -y "./$IMAGE_NAME.7z"

echo ">> Mounting DietPi image to current machine <<"
[ -d "$MNT_PATH" ] && sudo rm -rf "$MNT_PATH"
sudo mkdir -p "$MNT_PATH"
sudo losetup -Pr "$LOOP" "./$IMAGE_NAME.img"
sudo mount -t ext4 "${LOOP}p2" "$MNT_PATH"
sudo mount -t ext4 "${LOOP}p1" "$BOOT_PATH"

echo ">> Replacing OS and DietPi configurations <<"
pushd "$BOOT_PATH"
#cp "$BOOT_PATH/cmdline.txt" "./cmdline.txt"
sudo sed -i 's/console=tty[[:digit:]]\+/console=tty3/' cmdline.txt
sudo sed -i 's/console=tty3.*$/& loglevel=3 quiet logo.nologo vt.global_cursor_default=0/' cmdline.txt
sudo cp -f "$OS_CONFIG" config.txt
sudo cp -f "$DIET_CONFIG" cdietpi.txt
popd

echo ">> Creating custom scripts <<"
sudo cp -f "$POSTBOOT_SCRIPT" "$BOOT_PATH/Automation_Custom_Script.sh"
sudo chmod +x "$BOOT_PATH/Automation_Custom_Script.sh"
[ ! -d "$MNT_PATH/var/lib/dietpi/dietpi-autostart" ] && sudo mkdir -p "$MNT_PATH/var/lib/dietpi/dietpi-autostart"
printf "#!/usr/bin/env bash\nset -xeou pipefail\nXAUTHORITY=./Xauthority && export XAUTHORITY" |
  sudo tee -a "$MNT_PATH/var/lib/dietpi/dietpi-autostart/custom.sh"

echo ">> Unmounting DietPi image <<"
cleanup

echo ">> Compressing DietPi image <<"
sudo xz -z -6 -e -T0 "$IMAGE_NAME.img"

echo ">> Generating build summary <<"
ARCHIVE_PATH=$(find . -maxdepth 2 -type f -name "$IMAGE_NAME.img.xz" -print -quit)
echo "Archive path: $ARCHIVE_PATH"
$CI && {
  echo "ARCHIVE_PATH=$ARCHIVE_PATH"
  echo "IMAGE_NAME=$IMAGE_NAME"
} >>"$GITHUB_OUTPUT"

echo ">> Done <<"
