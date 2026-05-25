#!/bin/bash
# CyberChef offline o'rnatish
set -e

echo "[HackNow] CyberChef o'rnatilmoqda..."

CYBERCHEF_VERSION="10.19.4"
mkdir -p /opt/cyberchef
cd /opt/cyberchef
wget -q "https://github.com/gchq/CyberChef/releases/download/v${CYBERCHEF_VERSION}/CyberChef_v${CYBERCHEF_VERSION}.zip" -O cyberchef.zip
unzip -q cyberchef.zip
rm -f cyberchef.zip

cat > /usr/share/applications/cyberchef.desktop << 'EOF'
[Desktop Entry]
Name=CyberChef
Comment=Cyber Swiss Army Knife
Exec=firefox-esr /opt/cyberchef/CyberChef_v10.19.4.html
Terminal=false
Type=Application
Categories=Security;Utility;
EOF

echo "[HackNow] CyberChef tayyor!"
