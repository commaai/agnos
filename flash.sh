#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
EDL=$DIR/edl_repo/edl

if [! -f  $EDL ]; then
  git clone https://github.com/bkerler/edl $DIR/edl_repo
  cd $DIR/edl_repo
  git submodule update --depth=1 --init --recursive
  python -m pip3 install -r requirements.txt
  #sudo apt purge -y modemmanager ?
  sudo systemctl stop ModemManager
  cd $DIR
fi

echo "Enter your computer password if prompted"

FLASH_SLOT="a"
echo "Flashing slot: $FLASH_SLOT"

# this always flash to partition "a"
$EDL --memory=ufs
$EDL setactiveslot a

# flash non-active slot
$EDL w aop_$FLASH_SLOT aop.img
$EDL w devcfg_$FLASH_SLOT devcfg.img
$EDL w xbl_$FLASH_SLOT xbl.img
$EDL w xbl_config_$FLASH_SLOT xbl_config.img
$EDL w abl_$FLASH_SLOT abl.img
$EDL w boot_$FLASH_SLOT boot.img
$EDL w system_$FLASH_SLOT system.img


# wipe device
$EDL e userdata
$EDL e cache

$EDL/edl reset
