#!/bin/bash
# HackNow OS — Docker orqali ISO build
# Foydalanish: ./docker-build.sh [minimal|full]

set -e

MODE="${1:-minimal}"
BUILD_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$BUILD_DIR/output"

echo "[HackNow OS] ISO Build — $MODE rejim"
echo "[HackNow OS] Build dir: $BUILD_DIR"

mkdir -p "$OUTPUT_DIR"

# === Branding sync (avtomatik) ===
if [ -d "$BUILD_DIR/../branding" ] && [ -x "$BUILD_DIR/scripts/sync-branding.sh" ]; then
    echo "[HackNow OS] Branding repo'dan assetlar sync qilinmoqda..."
    bash "$BUILD_DIR/scripts/sync-branding.sh" 2>&1 | grep -E "✓|⚠|ERROR" || true
fi

# === Installer sync (avtomatik) ===
if [ -d "$BUILD_DIR/../installer" ] && [ -x "$BUILD_DIR/scripts/sync-installer.sh" ]; then
    echo "[HackNow OS] Installer repo'dan Calamares config sync qilinmoqda..."
    bash "$BUILD_DIR/scripts/sync-installer.sh" 2>&1 | grep -E "✓|~|⚠|ERROR" || true
fi

# === Hook'larni o'chirish/yoqish helper ===
HOOKS_DISABLED=()

restore_hooks() {
    # Build xato bo'lsa ham hooklarni qaytarish (trap ERR/EXIT)
    for hook in "${HOOKS_DISABLED[@]}"; do
        f="$BUILD_DIR/config/hooks/live/${hook}.hook.chroot.disabled"
        if [ -f "$f" ]; then
            mv "$f" "${f%.disabled}" 2>/dev/null || true
        fi
    done
}

# Trap: build qanday yakunlansa ham hooklar tiklanadi
trap restore_hooks EXIT

# Minimal rejimda og'ir hooklarni o'chiramiz
if [ "$MODE" = "minimal" ]; then
    echo "[WARNING] Minimal rejim: pip/go/git hook'lar o'chiriladi"
    for hook in 0200-install-pip-tools 0300-install-go-tools 0400-install-git-tools; do
        f="$BUILD_DIR/config/hooks/live/${hook}.hook.chroot"
        if [ -f "$f" ]; then
            mv "$f" "${f}.disabled" 2>/dev/null || true
            HOOKS_DISABLED+=("$hook")
        fi
    done
fi

echo "[HackNow OS] Docker konteyner ishga tushirilmoqda..."

# set -e bilan birga BUILD_RESULT to'g'ri olish uchun
set +e
docker run --rm \
    --privileged \
    -v "$BUILD_DIR":/build \
    -v "$OUTPUT_DIR":/output \
    -w /build \
    debian:bookworm \
    bash /build/scripts/docker-inner-build.sh
BUILD_RESULT=$?
set -e

if [ $BUILD_RESULT -eq 0 ]; then
    echo "[HackNow OS] Build muvaffaqiyatli!"
    ls -lh "$OUTPUT_DIR"/*.iso 2>/dev/null || true
else
    echo "[ERROR] Build xato bilan tugadi (exit $BUILD_RESULT). Log: $OUTPUT_DIR/build.log"
    exit 1
fi
