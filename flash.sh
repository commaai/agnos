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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
EDL=$DIR/edl

if [! -f  $EDL ]; then
  git clone https://github.com/bkerler/edl
  cd $DIR/edl
  #git fetch --all if we want certain commit
  git submodule update --depth=1 --init --recursive
  python -m pip3 install -r requirements.txt
  # edl uses fastboot
  export PATH=$PATH:$DIR/platform-tools
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

edlFlash() {
  sudo $EDL w "$@"
}

# flash non-active slot
edlFlash aop_$NEW_SLOT aop.img
edlFlash devcfg_$NEW_SLOT devcfg.img
edlFlash xbl_$NEW_SLOT xbl.img
edlFlash xbl_config_$NEW_SLOT xbl_config.img
edlFlash abl_$NEW_SLOT abl.img
edlFlash boot_$NEW_SLOT boot.img
edlFlash system_$NEW_SLOT system.img


# swap to newly flashed slot
sudo $EDL_DIR/edl setactiveslot $NEW_SLOT

# wipe device
sudo $FASTBOOT format:ext4 userdata
sudo $FASTBOOT format cache

sudo $FASTBOOT continue
