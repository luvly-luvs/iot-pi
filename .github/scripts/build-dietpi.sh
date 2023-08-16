#!/usr/bin/env bash
set -xeou pipefail

MNT_PATH="/mnt/dietpi" && export MNT_PATH
BOOT_PATH="$MNT_PATH/boot" && export BOOT_PATH
IMAGE_NAME="DietPi_RPi-ARMv8-Bullseye" && export IMAGE_NAME
IMAGE_URL="https://dietpi.com/downloads/images/$IMAGE_NAME.7z" && export IMAGE_URL

OS_CONFIG=$1
DIET_CONFIG=$2
POSTBOOT_SCRIPT=$3

function cleanup {
  sudo umount -f "$BOOT_PATH"
  sudo umount -f "$MNT_PATH"
  sudo losetup -D
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
sudo losetup -Pr /dev/loop0 "./$IMAGE_NAME.img"
sudo mount /dev/loop0p2 "$MNT_PATH"
sudo mount /dev/loop0p1 "$BOOT_PATH"

echo ">> Replacing OS and DietPi configurations <<"
pushd "$BOOT_PATH"
sed -i 's/console=tty[[:digit:]]\+/console=tty3/' cmdline.txt
sed -i 's/console=tty3.*$/& loglevel=3 quiet logo.nologo vt.global_cursor_default=0/' cmdline.txt
cp -f "$OS_CONFIG" config.txt
cp -f "$DIET_CONFIG" cdietpi.txt
popd

echo ">> Creating custom scripts <<"
cp -f "$POSTBOOT_SCRIPT" "$BOOT_PATH/Automation_Custom_Script.sh"
chmod +x "$BOOT_PATH/Automation_Custom_Script.sh"
[ ! -d "$MNT_PATH/var/lib/dietpi/dietpi-autostart" ] && sudo mkdir -p "$MNT_PATH/var/lib/dietpi/dietpi-autostart"
cat >>"$MNT_PATH/var/lib/dietpi/dietpi-autostart/custom.sh" <<-EOF
#!/usr/bin/env bash
set -xeou pipefail
XAUTHORITY=./Xauthority && export XAUTHORITY
#startx /root/.build/startTE.sh |& tee /root/.build/log.txt 
EOF

echo ">> Unmounting DietPi image <<"
cleanup

echo ">> Compressing DietPi image <<"
xz -z -6 -e -T0 "$IMAGE_NAME.img"

echo ">> Generating build summary <<"
ARCHIVE_PATH=$(find . -maxdepth 2 -type f -name "$IMAGE_NAME.img.xz" -print -quit)
echo "Archive path: $ARCHIVE_PATH"
$CI && {
  echo "ARCHIVE_PATH=$ARCHIVE_PATH"
  echo "IMAGE_NAME=$IMAGE_NAME"
} >>"$GITHUB_OUTPUT"

echo ">> Done <<"
