#!/bin/bash
# HackNow Tools — O'rnatish
set -e

PREFIX="${PREFIX:-/usr/local}"

echo "[HackNow] Toollar o'rnatilmoqda -> $PREFIX/bin/"

for tool in bin/hn-*; do
    name=$(basename "$tool")
    install -m 755 "$tool" "$PREFIX/bin/$name"
    echo "  [✓] $name"
done

# Version file
echo "0.1.0" > /etc/hacknow-version 2>/dev/null || true

echo "[HackNow] O'rnatish tugadi!"
