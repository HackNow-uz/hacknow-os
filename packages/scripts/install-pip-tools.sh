#!/bin/bash
# Python-based pentesting toollarni pipx bilan o'rnatish
set -e

echo "[HackNow] Python toollar o'rnatilmoqda..."

TOOLS=(
    "impacket"
    "pwntools"
    "crackmapexec"
    "certipy-ad"
    "bloodhound"
    "updog"
    "sherlock-project"
    "maigret"
    "theHarvester"
)

for tool in "${TOOLS[@]}"; do
    echo "  -> $tool"
    pipx install "$tool" 2>/dev/null || echo "    [!] $tool o'rnatilmadi"
done

# z3-solver — pipx emas, pip kerak
pip3 install --break-system-packages z3-solver 2>/dev/null || true

echo "[HackNow] Python toollar tayyor!"
