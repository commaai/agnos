#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
EDL_DIR=$DIR/edl

if [! -d  $EDL_DIR ]; then
  git clone https://github.com/bkerler/edl edl
  cd $EDL_DIR
  git submodule update --depth=1 --init --recursive
  python -m pip3 install -r requirements.txt
  sudo apt purge -y modemmanager
  cd ..
fi

echo "Enter your computer password if prompted"

FLASH_SLOT="a"
echo "Flashing slot: $FLASH_SLOT"

$EDL_DIR/edl setactiveslot a

edlFlash() {
  $EDL_DIR/edl w "$@"
}

# flash non-active slot
edlFlash aop_$FLASH_SLOT aop.img
edlFlash devcfg_$FLASH_SLOT devcfg.img
edlFlash xbl_$FLASH_SLOT xbl.img
edlFlash xbl_config_$FLASH_SLOT xbl_config.img
edlFlash abl_$FLASH_SLOT abl.img
edlFlash boot_$FLASH_SLOT boot.img
edlFlash system_$FLASH_SLOT system.img


# wipe device
#TODO: format userdata cache in edl mode

#sudo $FASTBOOT format:ext4 userdata
#sudo $FASTBOOT format cache

$EDL/eld reset
