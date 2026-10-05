# Installed Windows

## Requirements

- Brain (especially reading, critical thinking and problem solving skills here)
- OrangePi Zero3
- Patience, alot.
- USB hub, USB Keyboards in UEFI atleast will not work when directly plugged into the Pi due to no OHCI driver.
- USB Drive with Windows 11 ARM64 imaged, build 22000 and above (can run lower but you'd need to rebuild the SD driver with older WDK).
- SD Card where you don't mind losing data
- A Linux machine where you can access the SD card via parted
- A windows machine (?, the step requiring this on the host side MIGHT be able to be completed on the Zero3 but you will need to reboot into the installer twice)
- MMC Driver downloaded
- Experience in installing windows manually via CMD

## Main bit

> [!NOTE]
> We are assuming you have installed UEFI to the SPI flash already, if not and you imaged it to the SD card, which isn't reccomended, good luck.

- Copy over and unpack the MMC driver into the USB installer.
- Enable testsigning on the USB installer via
```
bcdedit /store path\to\bcd\on\usb /set {default} testsigning on
```

- Plug in your USB drive and Keyboard to the USB hub.
- Plug the USB hub and SD card into the OrangePi.
- Plug your OrangePi into power.
- Let it boot to Windows Setup.
- Use Shift + F10 to open command prompt.
- Go to the usb drive via
```
C:\
```
- Load the MMC driver via
```
drvload path\to\awmmc.inf
```
- Wait ~30s for the SD card to be picked up
- Run diskpart in cmd
- Find your disk via
```
list disk
```
- Select the SD card via
```
sel dis X, where X is the disk number
```

> [!CAUTION]
> This step WILL wipe the SD Card, after rebooting if you have installed UEFI to the SD previously, you will need to install it again! You will also lose data in the process!!
- Clean the card via
```
clean
```
- Convert the card into GPT format via
```
conv gpt
```
- Create and assign partition letters
```
create part prim size=100
format fs=fat32 quick label="ESP"
assign letter=E
create part prim
format fs=ntfs quick label="Windows"
assign letter=W
```
- Exit diskpart (seriously, just type exit...)
> [!CAUTION]
> Imaging takes ages.
- Image windows, I really wont go into the specifics on choosing which edition, we will go with the first index, if you know what to do here, take the wheel. Just run
```
dism /apply-image /imagefile:sources\install.wim /index:1 /applydir:W:
```
> [!CAUTION]
> Forget these and windows is not going to boot.
- Create boot files via
```
bcdboot W:\Windows /s E: /f UEFI
```
- Enable testsigning on the new install via
```
bcdedit /store E:\EFI\Microsoft\Boot\BCD /set {default} testsigning on
```
- Provision the install with the MMC driver via
```
dism /image:W:\ /add-driver /driver:path\to\awmmc.inf
```
> [!NOTE]  
> It may freeze when shutting down, thats normal, PSCI in mainline A-TF for H616 doesn't really implement shutdown? Just give it a few seconds and unplug the OrangePi.
- Shut down the OrangePi via
```
wpeutil shutdown
```
> [!CAUTION]
> This is needed, without ESP flags on ESP, windows sysprep will fail! We can't make an esp partition and format it in diskpart due to massive restrictions on removable devices.
- Unplug the SD card and insert into the Linux host
- On linux host run
```
sudo parted /dev/SDCARDIDENTIFIER
set 1 esp on
quit
sync
```
- Plug the SD card back into the OrangePi.
- Power on the OrangePi, and let windows do it's job.
- Done.
