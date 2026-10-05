# UEFI Builder

Comprehensive UEFI builder for OrangePi Zero3, builds UEFI, TF-A and SPL, then packs it into a bootable image.

## Usage

Clone this repo with
```
git clone https://github.com/OrangePi-Zero3/UEFI-Builder --recursive
```

First time users need to run
```
./setup_env.sh -p (package manager of choice)
```

then to build just run
```
./build.sh (DEBUG or RELEASE)
```

## Guides

- [Installing UEFI](GUIDES/Installing-UEFI.md)
- [Installing Windows](GUIDES/Installing-Windows.md)
- [Updating UEFI](GUIDES/Updating-UEFI.md)
