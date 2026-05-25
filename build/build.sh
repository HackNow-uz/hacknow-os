#!/bin/bash
# HackNow OS - ISO Build Script
# Foydalanish: sudo ./build.sh [clean|config|build|all|sign]

set -eo pipefail

GPG_KEY="EE639BAA5A076195"
RELEASE_DIR="/var/www/releases"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()   { echo -e "${GREEN}[HackNow OS]${NC} $1"; }
info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Root tekshiruvi
if [ "$(id -u)" -ne 0 ]; then
    error "Bu skript root sifatida ishlatilishi kerak: sudo ./build.sh"
fi

# Talab qilingan dasturlar
REQUIRED_CMDS="lb debootstrap mksquashfs xorriso"
for cmd in $REQUIRED_CMDS; do
    if ! command -v "$cmd" &>/dev/null; then
        error "'$cmd' topilmadi. O'rnating: apt install live-build debootstrap squashfs-tools xorriso"
    fi
done

ACTION="${1:-all}"
BUILD_START=$(date +%s)

do_clean() {
    log "Avvalgi build qoldiqlari tozalanmoqda..."
    lb clean --purge 2>/dev/null || true
    rm -rf .build cache chroot binary
    rm -f build.log
    log "Tozalash tugadi."
}

do_config() {
    log "live-build konfiguratsiyasi o'rnatilmoqda..."
    lb config
    log "Konfiguratsiya tayyor."
}

do_build() {
    log "ISO yaratish boshlandi..."
    info "Bu jarayon 30-90 daqiqa davom etishi mumkin."
    info "Jarayonni kuzatish: tail -f build.log"
    echo ""

    rm -f hacknow-os*.iso *.iso

    lb build 2>&1 | tee build.log

    ISO=$(ls -t hacknow-os*.iso 2>/dev/null | head -1)
    if [ -z "$ISO" ]; then
        ISO=$(ls -t *.iso 2>/dev/null | head -1)
    fi

    if [ -n "$ISO" ]; then
        SIZE=$(du -h "$ISO" | cut -f1)
        SHA=$(sha256sum "$ISO" | cut -d' ' -f1)
        BUILD_END=$(date +%s)
        ELAPSED=$(( BUILD_END - BUILD_START ))
        MINUTES=$(( ELAPSED / 60 ))
        SECONDS=$(( ELAPSED % 60 ))

        echo ""
        log "================================================="
        log "ISO muvaffaqiyatli yaratildi!"
        log "Fayl: $ISO"
        log "Hajm: $SIZE"
        log "Vaqt: ${MINUTES}m ${SECONDS}s"
        log "SHA256: $SHA"
        log "================================================="
    else
        error "ISO yaratilmadi! build.log ni tekshiring: tail -50 build.log"
    fi
}

do_sign() {
    ISO=$(ls -t hacknow-os*.iso 2>/dev/null | head -1)
    if [ -z "$ISO" ]; then
        error "ISO topilmadi. Avval build qiling."
    fi

    if ! gpg --list-keys "$GPG_KEY" &>/dev/null; then
        error "GPG kalit topilmadi: $GPG_KEY"
    fi

    log "ISO imzolanmoqda..."

    SHA=$(sha256sum "$ISO" | cut -d' ' -f1)

    # SHA256SUMS fayl yaratish
    sha256sum "$ISO" > SHA256SUMS
    log "SHA256SUMS yaratildi: $SHA"

    # SHA256SUMS ni imzolash
    gpg --batch --yes --passphrase "" --local-user "$GPG_KEY" \
        --detach-sign --armor SHA256SUMS
    log "SHA256SUMS.asc imzolandi"

    # ISO ni to'g'ridan-to'g'ri imzolash
    gpg --batch --yes --passphrase "" --local-user "$GPG_KEY" \
        --detach-sign --armor "$ISO"
    log "$(basename "$ISO").asc imzolandi"

    echo ""
    log "Tekshirish:"
    info "  gpg --verify SHA256SUMS.asc SHA256SUMS"
    info "  gpg --verify ${ISO}.asc ${ISO}"
    info "  sha256sum -c SHA256SUMS"
}

do_publish() {
    ISO=$(ls -t hacknow-os*.iso 2>/dev/null | head -1)
    if [ -z "$ISO" ]; then
        error "ISO topilmadi. Avval build qiling."
    fi

    if [ ! -f "SHA256SUMS.asc" ]; then
        warn "Imzo topilmadi — avval imzolanadi..."
        do_sign
    fi

    log "Release fayllari $RELEASE_DIR ga ko'chirilmoqda..."
    mkdir -p "$RELEASE_DIR"

    cp "$ISO" "$RELEASE_DIR/"
    cp SHA256SUMS SHA256SUMS.asc "$RELEASE_DIR/"
    cp "${ISO}.asc" "$RELEASE_DIR/"

    # Torrent yaratish
    if command -v mktorrent &>/dev/null; then
        log "Torrent yaratilmoqda..."
        BASENAME=$(basename "$ISO")
        mktorrent \
            -a udp://tracker.opentrackr.org:1337/announce \
            -a udp://tracker.openbittorrent.com:6969/announce \
            -a udp://open.stealth.si:80/announce \
            -a udp://tracker.torrent.eu.org:451/announce \
            -a udp://exodus.desync.com:6969/announce \
            -a udp://open.demonii.com:1337/announce \
            -c "HackNow OS - Pentesting Linux distro. https://os.hacknow.uz" \
            -l 22 \
            -w "https://os.hacknow.uz/releases/$BASENAME" \
            -o "$RELEASE_DIR/${BASENAME}.torrent" \
            "$RELEASE_DIR/$BASENAME" 2>/dev/null
        log "Torrent yaratildi"
    else
        warn "mktorrent topilmadi — torrent yaratilmadi"
    fi

    # Zsync yaratish
    if command -v zsyncmake &>/dev/null; then
        log "Zsync yaratilmoqda..."
        BASENAME=$(basename "$ISO")
        zsyncmake \
            -u "https://os.hacknow.uz/releases/$BASENAME" \
            -o "$RELEASE_DIR/${BASENAME}.zsync" \
            "$RELEASE_DIR/$BASENAME" 2>/dev/null
        log "Zsync yaratildi"
    else
        warn "zsyncmake topilmadi — zsync yaratilmadi"
    fi

    # GPG public key
    gpg --armor --export "$GPG_KEY" > "$RELEASE_DIR/hacknow-os-signing-key.asc"

    # Seed service qayta ishga tushirish
    if systemctl is-active hacknow-seed &>/dev/null; then
        systemctl restart hacknow-seed
        log "Torrent seed qayta ishga tushdi"
    fi

    echo ""
    log "================================================="
    log "Release tayyor!"
    log "Papka: $RELEASE_DIR"
    ls -lh "$RELEASE_DIR/"
    log "================================================="
}

do_test() {
    ISO=$(ls -t hacknow-os*.iso 2>/dev/null | head -1)
    if [ -z "$ISO" ]; then
        error "ISO topilmadi. Avval build qiling: sudo ./build.sh build"
    fi

    if ! command -v qemu-system-x86_64 &>/dev/null; then
        warn "qemu topilmadi. O'rnating: apt install qemu-system-x86"
        exit 1
    fi

    log "QEMU da test ishlatilmoqda: $ISO"
    qemu-system-x86_64 \
        -m 2048 \
        -cdrom "$ISO" \
        -boot d \
        -vga virtio \
        -display gtk \
        -enable-kvm 2>/dev/null || \
    qemu-system-x86_64 \
        -m 2048 \
        -cdrom "$ISO" \
        -boot d \
        -vga std
}

case "$ACTION" in
    clean)
        do_clean
        ;;
    config)
        do_config
        ;;
    build)
        do_config
        do_build
        ;;
    rebuild)
        do_clean
        do_config
        do_build
        ;;
    all)
        do_clean
        do_config
        do_build
        ;;
    sign)
        do_sign
        ;;
    publish)
        do_sign
        do_publish
        ;;
    release)
        do_clean
        do_config
        do_build
        do_sign
        do_publish
        ;;
    test)
        do_test
        ;;
    *)
        echo ""
        echo -e "${GREEN}HackNow OS Build System${NC}"
        echo ""
        echo "Foydalanish: sudo ./build.sh [buyruq]"
        echo ""
        echo "Buyruqlar:"
        echo "  all      - Tozalash + config + build (default)"
        echo "  build    - Faqat config + build"
        echo "  rebuild  - Tozalash + config + build (all ga teng)"
        echo "  clean    - Build qoldiqlarini tozalash"
        echo "  config   - Faqat konfiguratsiya"
        echo "  sign     - ISO ni GPG bilan imzolash"
        echo "  publish  - Imzolash + torrent/zsync + /var/www/releases/ ga ko'chirish"
        echo "  release  - To'liq: build + sign + publish"
        echo "  test     - QEMU da ISO ni test qilish"
        echo ""
        exit 1
        ;;
esac
