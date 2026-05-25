#!/bin/bash
# HackNow OS — Docker ichidagi build skripti
set -eo pipefail

echo "[*] Paketlar o'rnatilmoqda..."
apt-get update -qq
apt-get install -y -qq live-build debootstrap squashfs-tools xorriso rsync >/dev/null 2>&1

# Build fayllarni Docker ichiga nusxalash (volume mount sekin)
echo "[*] Build fayllar nusxalanmoqda..."
mkdir -p /tmp/hacknow-build
rsync -a --exclude='.git' --exclude='output' --exclude='chroot' --exclude='.build' --exclude='binary' /build/ /tmp/hacknow-build/
cd /tmp/hacknow-build

echo "[*] Eski build tozalanmoqda..."
lb clean --purge 2>/dev/null || true

echo "[*] Konfiguratsiya..."
lb config

echo "[*] ISO build boshlandi..."
echo "[*] Bu 15-60 daqiqa davom etishi mumkin..."
lb build 2>&1 | tee /output/build.log

# ISO ni output papkaga kanonik nom bilan nusxalash
ISO_SRC=$(ls -t *.iso 2>/dev/null | head -1)
ISO_NAME="hacknow-os-amd64.hybrid.iso"
if [ -n "$ISO_SRC" ]; then
    cp "$ISO_SRC" "/output/$ISO_NAME"
    SIZE=$(du -h "/output/$ISO_NAME" | cut -f1)
    HASH=$(sha256sum "/output/$ISO_NAME" | cut -d" " -f1)
    echo "$HASH  $ISO_NAME" > "/output/${ISO_NAME}.sha256"
    # Host user (UID/GID 1000) ga yozish huquqi berish
    chmod 644 "/output/$ISO_NAME" "/output/${ISO_NAME}.sha256"
    echo ""
    echo "========================================="
    echo "  ISO TAYYOR: $ISO_NAME"
    echo "  Manba nomi: $ISO_SRC"
    echo "  Hajmi: $SIZE"
    echo "  SHA256: $HASH"
    echo "========================================="
else
    echo "[!] ISO yaratilmadi! Log: /output/build.log"
    exit 1
fi
