# Installing UEFI

## Requirements

- Brain (especially reading, critical thinking and problem solving skills here)
- OrangePi Zero3

> [!CAUTION]
> This will overwrite the contents of the SPI flash with UEFI.
> We are assuming you have built / got the final spl boot image ready.

## Installing UEFI

- Enter FEL via your preferred method, I wont dig in deep here, use the internet.
- Use the latest sunxi-tools version and write the SPI flash via
```
sudo sunxi-fel -p spiflash-write 0 spl-bootable.img
```
- Powercycle the OrangePi, UEFI should boot.
- Done.
