#!/bin/bash
# HackNow OS — Branding repo'dan build repo'ga assetlarni sync qilish
#
# Foydalanish:
#   bash scripts/sync-branding.sh
#
# Buni har safar branding repo'ni yangilagandan keyin ishga tushiring

set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
BRAND_DIR="${BRAND_DIR:-$(realpath "$BUILD_DIR/../branding")}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[SYNC]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# === Branding mavjudligini tekshirish ===
if [ ! -d "$BRAND_DIR" ]; then
    err "Branding katalogi topilmadi: $BRAND_DIR

Monorepo strukturasi kutiladi: hacknow-os/branding/
Override qilish uchun:
    BRAND_DIR=/absolyut/yo'l/branding bash sync-branding.sh"
fi

log "Branding: $BRAND_DIR"
log "Build:    $BUILD_DIR"

INCLUDES="$BUILD_DIR/config/includes.chroot"

# === 1. Wallpapers ===
log "Wallpaperlar sync qilinmoqda..."
mkdir -p "$INCLUDES/usr/share/backgrounds/hacknow"
declare -A WALLPAPERS=(
    ["hacknow-wallpaper-cyberpunk.png"]="wallpaper-1.png"
    ["hacknow-wallpaper-terminal.png"]="wallpaper-2.png"
    ["hacknow-login-bg.png"]="login.png"
    ["hacknow-logo-ascii.png"]="logo-ascii.png"
)
for src in "${!WALLPAPERS[@]}"; do
    dst="${WALLPAPERS[$src]}"
    if [ -f "$BRAND_DIR/wallpapers/$src" ]; then
        cp "$BRAND_DIR/wallpapers/$src" "$INCLUDES/usr/share/backgrounds/hacknow/$dst"
        echo "  ✓ $src → $dst"
    else
        warn "  $src — branding'da yo'q"
    fi
done

# === 2. Logo + Icon (pixmaps) ===
log "Logo va icon sync qilinmoqda..."
mkdir -p "$INCLUDES/usr/share/pixmaps"
for f in hacknow-logo.png hacknow-icon.png; do
    if [ -f "$BRAND_DIR/$f" ]; then
        cp "$BRAND_DIR/$f" "$INCLUDES/usr/share/pixmaps/$f"
        echo "  ✓ $f"
    fi
done

# === 3. GRUB theme ===
log "GRUB theme sync qilinmoqda..."
GRUB_DST="$INCLUDES/usr/share/grub/themes/hacknow"
GRUB_SRC="$BRAND_DIR/grub/hacknow"
mkdir -p "$GRUB_DST"
if [ -d "$GRUB_SRC" ]; then
    # background.png — ikkita variant: hacknow-grub-bg.png (eski nom) yoki background.png
    if [ -f "$GRUB_SRC/hacknow-grub-bg.png" ]; then
        cp "$GRUB_SRC/hacknow-grub-bg.png" "$GRUB_DST/background.png"
        echo "  ✓ background.png (hacknow-grub-bg.png'dan)"
    elif [ -f "$GRUB_SRC/background.png" ]; then
        cp "$GRUB_SRC/background.png" "$GRUB_DST/background.png"
        echo "  ✓ background.png"
    fi
    # Theme fayllar: logo, select sprites, theme.txt
    for f in logo.png theme.txt select_c.png select_e.png select_n.png select_ne.png select_nw.png select_s.png select_se.png select_sw.png select_w.png; do
        if [ -f "$GRUB_SRC/$f" ]; then
            cp "$GRUB_SRC/$f" "$GRUB_DST/$f"
        fi
    done
fi

# === 4. Plymouth ===
log "Plymouth assetlari sync qilinmoqda..."
mkdir -p "$INCLUDES/usr/share/plymouth/themes/hacknow"
if [ -f "$BRAND_DIR/plymouth/hacknow/hacknow-boot-logo.png" ]; then
    cp "$BRAND_DIR/plymouth/hacknow/hacknow-boot-logo.png" \
       "$INCLUDES/usr/share/plymouth/themes/hacknow/logo.png"
    echo "  ✓ Plymouth logo"
fi

# === 5. Neofetch ASCII ===
log "Neofetch ASCII sync qilinmoqda..."
mkdir -p "$INCLUDES/etc/neofetch"
if [ -f "$BRAND_DIR/neofetch/hacknow.ascii" ]; then
    cp "$BRAND_DIR/neofetch/hacknow.ascii" "$INCLUDES/etc/neofetch/hacknow.ascii"
    echo "  ✓ hacknow.ascii"
fi

# === 6. GTK Theme assets ===
log "GTK Theme assetlari sync qilinmoqda..."
if [ -d "$BRAND_DIR/gtk-theme/hacknow-dark" ]; then
    # Eski tema o'chirish va yangilash
    mkdir -p "$INCLUDES/usr/share/themes"
    # Faqat agar branding'da to'liq tema bo'lsa
    if [ -f "$BRAND_DIR/gtk-theme/hacknow-dark/index.theme" ]; then
        # Branding'da tema yangilangan bo'lsa — sync (ehtiyot bilan)
        echo "  i Branding'da GTK theme mavjud — build dir mustaqil saqlanadi"
    fi
fi

# === Verify ===
echo ""
log "Sync tugadi! Yangi fayllar:"
echo ""
echo "  Wallpapers:"
ls -lh "$INCLUDES/usr/share/backgrounds/hacknow/" | tail -4
echo ""
echo "  Pixmaps:"
ls -lh "$INCLUDES/usr/share/pixmaps/" 2>/dev/null | tail -3

echo ""
log "Endi build qiling: bash docker-build.sh minimal"
