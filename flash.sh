#!/bin/bash -e

FASTBOOT=platform-tools/fastboot

VERSION="r28.0.2"
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"

if [ ! -f $FASTBOOT ]; then
  rm -rf platform-tools
  rm -f platform-tools-latest-$PLATFORM.zip

  curl -L https://dl.google.com/android/repository/platform-tools_$VERSION-$PLATFORM.zip --output platform-tools.zip
  unzip platform-tools.zip
  rm -f platform-tools.zip
fi

echo "Please enter your computer password when prompted"

sudo $FASTBOOT --set-active=a
sudo $FASTBOOT flash xbl_a xbl.img
sudo $FASTBOOT flash xbl_config_a xbl_config.img
sudo $FASTBOOT flash abl_a abl.img
sudo $FASTBOOT flash boot_a boot.img
sudo $FASTBOOT flash system_a system.img
sudo $FASTBOOT format:ext4 userdata
sudo $FASTBOOT format cache
sudo $FASTBOOT continue
