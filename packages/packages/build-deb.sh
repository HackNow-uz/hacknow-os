#!/bin/bash
# Custom .deb paketlarni yaratish
set -e

for pkg in */; do
    if [ -d "$pkg/DEBIAN" ]; then
        echo "Building: $pkg"
        dpkg-deb --build "$pkg"
    fi
done
