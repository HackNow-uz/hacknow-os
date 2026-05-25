#!/bin/bash
# Metasploit Framework o'rnatish
set -e

echo "[HackNow] Metasploit Framework o'rnatilmoqda..."

curl -fsSL https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
chmod +x /tmp/msfinstall
/tmp/msfinstall

echo "[HackNow] Metasploit tayyor!"
