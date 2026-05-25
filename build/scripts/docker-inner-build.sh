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

# ISO ni output papkaga nusxalash
ISO=$(ls -t *.iso 2>/dev/null | head -1)
if [ -n "$ISO" ]; then
    cp "$ISO" /output/
    SIZE=$(du -h "$ISO" | cut -f1)
    HASH=$(sha256sum "$ISO" | cut -d" " -f1)
    echo ""
    echo "========================================="
    echo "  ISO TAYYOR: $ISO"
    echo "  Hajmi: $SIZE"
    echo "  SHA256: $HASH"
    echo "========================================="
else
    echo "[!] ISO yaratilmadi! Log: /output/build.log"
    exit 1
fi
