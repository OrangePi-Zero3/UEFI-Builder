#!/usr/bin/env bash

SPL=thirty/spl.bin
UEFI=Mu-Silicium/Mu-Zero3.bin
DEBUG_TFA=arm-trusted-firmware/build/sun50i_h616/debug/bl31.bin
RELEASE_TFA=arm-trusted-firmware/build/sun50i_h616/release/bl31.bin
 
[ -f "$SPL" ]  || { echo "Missing SPL: $SPL"; exit 1; }
[ -f "$UEFI" ] || { echo "Missing UEFI: $UEFI"; exit 1; }
 
if   [ -f "$DEBUG_TFA" ];   then TFA=$DEBUG_TFA
elif [ -f "$RELEASE_TFA" ]; then TFA=$RELEASE_TFA
else echo "Missing TF-A: no debug or release bl31.bin"; exit 1
fi
 
sunxi-fel -p -v spl "$SPL"
sunxi-fel -p -v write 0x40000000 "$TFA"
sunxi-fel -p -v write 0x4A000000 "$UEFI"
sunxi-fel -v reset64 0x40000000
