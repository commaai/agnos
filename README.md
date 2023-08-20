# AGNOS

AGNOS is the Ubuntu-based operating system for your [comma 3/3X](https://comma.ai/shop/comma-3x).

## web flasher

If you're looking for the easiest way to reflash your comma device to stock, check out [flash.comma.ai](https://flash.comma.ai/) instead.

## Fastboot

In order to put your device into fastboot mode:

1. Connect power to the OBD-C port (port 1).
2. Then, quickly connect the comma device to your computer using the USB-C port (port 2).
3. After a few seconds, the device should indicate it's in fastboot mode and show its serial number.

![](fastboot.jpg)

# Flashing

1. Put your comma device in fastboot mode.
2. Run `./download.py`
3. Run `flash.sh` for Linux and macOS or `flash.ps1` for Windows
