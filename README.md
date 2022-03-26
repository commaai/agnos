# AGNOS

AGNOS is the Ubuntu-based operating system for your [comma three devkit](https://comma.ai/shop/products/three).

## Fastboot

In order to put your device into fastboot mode:

1. Connect power to the OBD-C port (port 1).
2. Then, quickly connect the comma three to your computer using the USB-C port (port 2).
3. After a few seconds, the device should indicate it's in fastboot mode and show its serial number.
4. If you cannot get your device into fastboot mode connecting to a Windows computer, run a Linux distro on your Windows computer (polling issue)

![](fastboot.jpg)

# Flashing

1. Put your comma three in fastboot mode.
2. Run `./download.py`
3. Run `flash.sh` for Linux and macOS or `flash.ps1` for Windows
