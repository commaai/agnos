# AGNOS

AGNOS is the Ubuntu-based operating system for your [comma three devkit](https://comma.ai/shop/products/three).

## Fastboot

In order to put your device into fastboot mode:

1. Connect power to the OBD-C port.
2. Then, quickly connect the comma three to your computer using the USB-C port.
3. After a few seconds, the device should indicate it's in fastboot mode and show its serial number.

![](fastboot.jpg)

# Flashing

1. Put your comma three in fastboot mode.
2. Run `./download.py`
3. Run `flash.sh` for Linux and macOS
