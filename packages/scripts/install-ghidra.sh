#!/bin/bash
# NSA Ghidra o'rnatish
set -e

GHIDRA_VERSION="11.3"
GHIDRA_DATE="20250205"

echo "[HackNow] Ghidra ${GHIDRA_VERSION} o'rnatilmoqda..."

cd /tmp
wget -q "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_VERSION}_build/ghidra_${GHIDRA_VERSION}_PUBLIC_${GHIDRA_DATE}.zip" -O ghidra.zip
unzip -q ghidra.zip -d /opt/
mv /opt/ghidra_${GHIDRA_VERSION}_PUBLIC /opt/ghidra
ln -sf /opt/ghidra/ghidraRun /usr/local/bin/ghidra

# Desktop entry
cat > /usr/share/applications/ghidra.desktop << 'EOF'
[Desktop Entry]
Name=Ghidra
Comment=NSA Reverse Engineering Suite
Exec=/opt/ghidra/ghidraRun
Icon=/opt/ghidra/support/ghidra.ico
Terminal=false
Type=Application
Categories=Development;ReverseEngineering;
EOF

rm -f /tmp/ghidra.zip
echo "[HackNow] Ghidra tayyor!"
