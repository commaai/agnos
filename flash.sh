#!/bin/bash -e

FASTBOOT=platform-tools/fastboot

VERSION="r33.0.3"
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"

if [ ! -f $FASTBOOT ]; then
  rm -rf platform-tools
  rm -f platform-tools-latest-$PLATFORM.zip

  curl -L https://dl.google.com/android/repository/platform-tools_$VERSION-$PLATFORM.zip --output platform-tools.zip
  unzip platform-tools.zip
  rm -f platform-tools.zip
fi

echo "Enter your computer password if prompted"

CURRENT_SLOT="$(sudo $FASTBOOT getvar current-slot 2>&1 | grep current-slot | cut -d' ' -f2-)"
if [ "$CURRENT_SLOT" == "a" ]; then
  NEW_SLOT="b"
elif [ "$CURRENT_SLOT" == "b" ]; then
  NEW_SLOT="a"
else
  echo "Current slot invalid: '$CURRENT_SLOT'"
  exit 1
fi

echo "Current slot: $CURRENT_SLOT"
echo "Flashing slot: $NEW_SLOT"

# flash non-active slot
sudo $FASTBOOT flash aop_$NEW_SLOT aop.img
sudo $FASTBOOT flash devcfg_$NEW_SLOT devcfg.img
sudo $FASTBOOT flash xbl_$NEW_SLOT xbl.img
sudo $FASTBOOT flash xbl_config_$NEW_SLOT xbl_config.img
sudo $FASTBOOT flash abl_$NEW_SLOT abl.img
sudo $FASTBOOT flash boot_$NEW_SLOT boot.img
sudo $FASTBOOT flash system_$NEW_SLOT system.img

# swap to newly flashed slot
sudo $FASTBOOT --set-active=$NEW_SLOT

# wipe device
sudo $FASTBOOT format:ext4 userdata
sudo $FASTBOOT format cache

sudo $FASTBOOT continue
