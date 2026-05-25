#!/bin/bash
# HackNow OS — branding va installer assetlarini build config tree'siga sync qilish
#
# Foydalanish:
#   bash sync.sh           # ikkalasini sync qiladi
#   bash sync.sh branding  # faqat branding
#   bash sync.sh installer # faqat installer
#
# Monorepo strukturasida:
#   build/      — ushbu skript va live-build config
#   branding/   — GRUB, Plymouth, wallpaper, ikonkalar
#   installer/  — Calamares brending va i18n

set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${CYAN}[sync]${NC} $1"; }
ok()  { echo -e "${GREEN}[OK]${NC} $1"; }
err() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

TARGET="${1:-all}"

run_branding() {
    log "Branding sync"
    bash "$SCRIPT_DIR/scripts/sync-branding.sh"
}

run_installer() {
    log "Installer sync"
    bash "$SCRIPT_DIR/scripts/sync-installer.sh"
}

case "$TARGET" in
    all)       run_branding && run_installer ;;
    branding)  run_branding ;;
    installer) run_installer ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \?//' ; exit 0 ;;
    *)         err "Noma'lum target: $TARGET. Foydalanish: bash sync.sh [all|branding|installer]" ;;
esac

ok "Sync tugadi"
