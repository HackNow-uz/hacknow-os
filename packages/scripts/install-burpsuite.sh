#!/bin/bash
# Burp Suite Community Edition o'rnatish
set -e

echo "[HackNow] Burp Suite CE o'rnatilmoqda..."

BURP_VERSION="2024.12.1"
cd /tmp
wget -q "https://portswigger-cdn.net/burp/releases/download?product=community&version=${BURP_VERSION}&type=Linux" -O burpsuite_install.sh
chmod +x burpsuite_install.sh
./burpsuite_install.sh -q -dir /opt/BurpSuiteCommunity

ln -sf /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite

cat > /usr/share/applications/burpsuite.desktop << 'EOF'
[Desktop Entry]
Name=Burp Suite CE
Comment=Web Security Testing
Exec=/opt/BurpSuiteCommunity/BurpSuiteCommunity
Icon=/opt/BurpSuiteCommunity/icon.png
Terminal=false
Type=Application
Categories=Network;Security;
EOF

rm -f /tmp/burpsuite_install.sh
echo "[HackNow] Burp Suite tayyor!"
