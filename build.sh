#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 RELEASE|DEBUG"
    exit 1
}

[ $# -eq 1 ] || usage

BUILD_TYPE="${1^^}"   # normalise to uppercase

case "$BUILD_TYPE" in
    DEBUG)   TFA_DEBUG=1; TFA_DIR=debug ;;
    RELEASE) TFA_DEBUG=0; TFA_DIR=release ;;
    *)       usage ;;
esac

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "Building UEFI ($BUILD_TYPE)"
(
    cd Mu-Silicium
    ./build_uefi.py -c -d Zero3 -r "$BUILD_TYPE"
) || { echo "Failed to build UEFI"; exit 1; }

echo "Building TF-A ($BUILD_TYPE)"
(
    cd arm-trusted-firmware
    rm -rf build
    make PLAT=sun50i_h616 DEBUG="$TFA_DEBUG" bl31 -j"$(nproc --all)"
) || { echo "Failed to build TF-A"; exit 1; }

echo "Building thirty SPL"
(
    cd thirty
    cp ../Mu-Silicium/Mu-Zero3.bin blobs/
    cp "../arm-trusted-firmware/build/sun50i_h616/$TFA_DIR/bl31.bin" blobs/
    make zero3_defconfig
    make clean
    make
    cp spl-bootable.img ../
) || { echo "Failed to build final image"; exit 1; }

echo "Final image at $ROOT/spl-bootable.img"
