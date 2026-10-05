# Updating UEFI

- Brain (especially reading, critical thinking and problem solving skills here)
- OrangePi Zero3
- USB Stick that is in GPT table but is non bootable and is formatted to FAT32.

> [!CAUTION]
> Applicable to SPI UEFI installs only.

## Host steps

- Plug in USB drive to host
- Copy spl-bootable.img to the root of the drive
- Unplug the drive

## OrangePi steps

- Unplug any bootable media and SD cards.
- Plug in the usb stick
- Plug in the OrangePi to power and watch your monitor for text showing how the update process is going.
- Wait for it to reboot
- Replug bootable media and SD cards and power cycle if needed
- Done
