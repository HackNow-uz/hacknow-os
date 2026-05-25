#!/bin/bash
# Barcha custom toollarni o'rnatish
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "╔══════════════════════════════════════╗"
echo "║  HackNow OS — Tool Installation      ║"
echo "╚══════════════════════════════════════╝"

scripts=(
    "install-pip-tools.sh"
    "install-go-tools.sh"
    "install-metasploit.sh"
    "install-ghidra.sh"
    "install-burpsuite.sh"
    "install-pwndbg.sh"
    "install-cyberchef.sh"
)

for script in "${scripts[@]}"; do
    echo ""
    echo "━━━ $script ━━━"
    bash "$SCRIPT_DIR/$script" || echo "[!] $script xato bilan tugadi"
done

echo ""
echo "✓ Barcha toollar o'rnatildi!"
