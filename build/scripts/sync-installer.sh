#!/bin/bash
# HackNow OS — Installer repo'dan build repo'ga Calamares config sync
#
# Foydalanish:
#   bash scripts/sync-installer.sh
#
# Installer repo'da branding va modul konfiguratsiyalarini boshqaradi,
# build repo esa ISO yaratish uchun ularni o'z ichiga oladi.
# Sinxronlash yo'nalishi: installer → build (installer — manba)

set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
INSTALLER_DIR="${INSTALLER_DIR:-$(realpath "$BUILD_DIR/../installer")}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[SYNC-INSTALLER]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

# === Installer repo mavjudligini tekshirish ===
if [ ! -d "$INSTALLER_DIR/calamares" ]; then
    warn "Installer repo topilmadi: $INSTALLER_DIR — o'tkazildi"
    exit 0
fi

log "Installer: $INSTALLER_DIR"
log "Build:     $BUILD_DIR"

INCLUDES="$BUILD_DIR/config/includes.chroot"
SRC_CAL="$INSTALLER_DIR/calamares"

# === 1. Calamares branding ===
log "Calamares branding sync qilinmoqda..."
BRAND_DST="$INCLUDES/usr/share/calamares/branding/hacknow"
mkdir -p "$BRAND_DST"

if [ -d "$SRC_CAL/branding/hacknow" ]; then
    cp -a "$SRC_CAL/branding/hacknow/"* "$BRAND_DST/"
    count=$(ls -1 "$BRAND_DST" | wc -l)
    echo "  ✓ branding: $count fayl (show.qml, logo, wallpaper...)"
else
    warn "  branding papkasi yo'q"
fi

# === 2. Calamares module configs ===
log "Calamares module konfig'lari sync qilinmoqda..."
MOD_DST="$INCLUDES/etc/calamares/modules"
mkdir -p "$MOD_DST"

SYNCED=0
SKIPPED=0
for src_file in "$SRC_CAL/modules/"*.conf; do
    [ -f "$src_file" ] || continue
    name=$(basename "$src_file")
    dst_file="$MOD_DST/$name"

    # Build repo'dagi versiya yangilanishlarni saqlash uchun:
    # agar build'da yangi versiya bo'lsa (ko'proq satrlar) — o'tkazish
    if [ -f "$dst_file" ]; then
        src_lines=$(wc -l < "$src_file")
        dst_lines=$(wc -l < "$dst_file")
        if [ "$dst_lines" -gt "$src_lines" ]; then
            echo "  ~ $name — build versiyasi yangi ($dst_lines > $src_lines satr), o'tkazildi"
            SKIPPED=$((SKIPPED + 1))
            continue
        fi
    fi

    cp "$src_file" "$dst_file"
    echo "  ✓ $name"
    SYNCED=$((SYNCED + 1))
done

# === 3. settings.conf ===
log "settings.conf sync qilinmoqda..."
SETTINGS_DST="$INCLUDES/etc/calamares/settings.conf"
if [ -f "$SRC_CAL/settings.conf" ]; then
    cp "$SRC_CAL/settings.conf" "$SETTINGS_DST"
    echo "  ✓ settings.conf"
fi

# === 4. i18n (agar mavjud bo'lsa) ===
# Branding ichidagi uz.ts/uz.qm — Calamares branding strings tarjimasi.
# Ular faqat "Welcome to ... installer." kabi brending stringlariga ta'sir qiladi.
LRELEASE=""
for cand in lrelease lrelease-qt5 lrelease6 lrelease-qt6; do
    if command -v "$cand" >/dev/null 2>&1; then
        LRELEASE="$cand"
        break
    fi
done

if [ -d "$INSTALLER_DIR/i18n" ]; then
    log "i18n tarjimalar sync qilinmoqda..."
    I18N_DST="$INCLUDES/usr/share/calamares/branding/hacknow"
    mkdir -p "$I18N_DST"
    for ts_file in "$INSTALLER_DIR/i18n/"*.ts; do
        [ -f "$ts_file" ] || continue
        cp "$ts_file" "$I18N_DST/"
        base=$(basename "$ts_file" .ts)
        if [ -n "$LRELEASE" ]; then
            $LRELEASE "$ts_file" -qm "$I18N_DST/${base}.qm" >/dev/null 2>&1 && \
                echo "  ✓ ${base}.ts → ${base}.qm (build-time)" || \
                echo "  ~ ${base}.ts (lrelease xato, chroot'da qayta urinadi)"
        else
            echo "  ✓ ${base}.ts (lrelease yo'q — chroot hook kompilyatsiya qiladi)"
        fi
    done
fi

# === 5. Pre-shipped calamares_uz.qm (asosiy 800+ string) ===
# `calamares-settings-debian` paketi calamares_uz.ts ni /usr/share/calamares/lang/
# ichiga olib keladi. Chroot hook lrelease bilan qm qiladi, lekin agar lrelease
# topilmasa muvaffaqiyatsiz bo'ladi. Shu sababli, agar host'da lrelease bo'lsa,
# build-time'da ham urinib ko'ramiz (bu fayl chroot bosqichigacha mavjud emas,
# shu sababli ko'pincha skip bo'ladi — lekin warn chiqarish foydali).
if [ -n "$LRELEASE" ]; then
    log "Calamares core tarjimasi (calamares_uz.qm) chroot bosqichida kompilyatsiya qilinadi"
fi

# === Xulosa ===
echo ""
log "Sync tugadi: $SYNCED yangilandi, $SKIPPED o'tkazildi"
