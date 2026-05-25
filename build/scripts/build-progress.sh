#!/bin/bash
# HackNow OS — Build progress monitor
# Build jarayonini foiz va vaqt bilan ko'rsatadi
#
# Foydalanish:
#   ./scripts/build-progress.sh                  — yangi build + progress
#   ./scripts/build-progress.sh --watch          — mavjud build'ni kuzatish
#   ./scripts/build-progress.sh --log <fayl>     — log fayl bilan

set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$BUILD_DIR/output/build.log"
MODE="${1:-build}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
CLEAR_LINE='\033[2K\r'

# === Build bosqichlari va foizlari ===
# Bootstrap: 0-10%
# Package download: 10-45%
# Package install: 45-80%
# Hooks: 80-85%
# Squashfs: 85-97%
# ISO finalize: 97-100%

START_TIME=$(date +%s)

format_time() {
    local secs=$1
    local h=$((secs / 3600))
    local m=$(( (secs % 3600) / 60 ))
    local s=$((secs % 60))
    if [ $h -gt 0 ]; then
        printf "%dh %02dm %02ds" $h $m $s
    elif [ $m -gt 0 ]; then
        printf "%dm %02ds" $m $s
    else
        printf "%ds" $s
    fi
}

# Progress bar — 40 char width (ASCII safe)
draw_bar() {
    local pct=$1
    local width=40
    local filled=$((pct * width / 100))
    local empty=$((width - filled))
    local bar=""
    bar+=$(printf "%${filled}s" | tr ' ' '#')
    bar+=$(printf "%${empty}s" | tr ' ' '-')
    echo "$bar"
}

# Build holatini log'dan aniqlash
detect_phase() {
    local log="$1"
    [ ! -f "$log" ] && { echo "0:Boshlanmagan"; return; }

    # Eng oxirgi qatorlardan boshqa indikator izlash
    local tail50=$(tail -50 "$log" 2>/dev/null)

    if echo "$tail50" | grep -q "Build completed successfully"; then
        echo "100:Tugadi"
    elif echo "$tail50" | grep -q "ISO TAYYOR\|hybrid.iso"; then
        echo "99:ISO finalizatsiya"
    elif echo "$tail50" | grep -q "Creating ISO image\|xorriso\|grub-mkrescue"; then
        echo "97:ISO yaratish"
    elif echo "$tail50" | grep -q "mksquashfs\|squashfs.*Compress\|Preparing squashfs"; then
        echo "90:Squashfs siqish"
    elif echo "$tail50" | grep -q "binary stage\|lb binary"; then
        echo "85:Binary stage"
    elif echo "$tail50" | grep -q "chroot_hooks\|Executing hook\|0100-hacknow"; then
        echo "82:Hooklar"
    elif echo "$tail50" | grep -q "Setting up\|Processing triggers"; then
        # O'rnatish bosqichi — jami paketga nisbatan
        local total=$(grep -c "^Get:" "$log" 2>/dev/null); total=${total:-0}; [ "$total" -lt 100 ] && total=1500
        local setup=$(grep -c "^Setting up\|^Processing triggers" "$log" 2>/dev/null); setup=${setup:-0}
        if [ "$total" -gt 0 ]; then
            local pct=$((45 + (setup * 35 / total)))
            [ $pct -gt 80 ] && pct=80
            echo "${pct}:Paketlar o'rnatilmoqda ($setup/$total)"
        else
            echo "60:Paketlar o'rnatilmoqda"
        fi
    elif echo "$tail50" | grep -q "Unpacking\|^Selecting previously"; then
        local total=$(grep -c "^Get:" "$log" 2>/dev/null); total=${total:-0}; [ "$total" -lt 100 ] && total=1500
        local unpack=$(grep -c "^Unpacking " "$log" 2>/dev/null); unpack=${unpack:-0}
        if [ "$total" -gt 0 ]; then
            local pct=$((50 + (unpack * 15 / total)))
            [ $pct -gt 65 ] && pct=65
            echo "${pct}:Paketlar ochilmoqda ($unpack/$total)"
        else
            echo "55:Paketlar ochilmoqda"
        fi
    elif echo "$tail50" | grep -q "^Get:"; then
        # Yuklab olish bosqichi
        local current=$(echo "$tail50" | grep "^Get:" | tail -1 | grep -oP 'Get:\K[0-9]+' | head -1)
        local total=1500  # Taxminiy umumiy paket soni
        if [ -n "$current" ] && [ "$current" -gt 0 ]; then
            local pct=$((10 + (current * 35 / total)))
            [ $pct -gt 45 ] && pct=45
            echo "${pct}:Paketlar yuklanmoqda ($current/$total)"
        else
            echo "15:Paketlar yuklanmoqda"
        fi
    elif echo "$tail50" | grep -q "lb chroot_archives\|chroot_apt"; then
        echo "12:APT sources"
    elif echo "$tail50" | grep -q "lb chroot_includes_before"; then
        echo "11:Chroot includes"
    elif echo "$tail50" | grep -q "Validating\|Retrieving"; then
        # Debootstrap bosqichi
        local validated=$(grep -c "^I: Validating" "$log" 2>/dev/null); validated=${validated:-0}
        local pct=$((1 + validated / 30))
        [ $pct -gt 10 ] && pct=10
        echo "${pct}:Debootstrap (base system)"
    elif echo "$tail50" | grep -q "lb bootstrap\|debootstrap"; then
        echo "5:Bootstrap"
    elif echo "$tail50" | grep -q "lb config\|Configuration"; then
        echo "2:Konfiguratsiya"
    elif echo "$tail50" | grep -q "Paketlar o'rnatilmoqda"; then
        echo "1:Docker init"
    else
        echo "1:Boshlanmoqda"
    fi
}

# Asosiy monitoring sikli
monitor_build() {
    local last_pct=-1
    local last_phase=""

    clear
    echo ""
    echo -e "${RED}  ╦ ╦╔═╗╔═╗╦╔═╔╗╔╔═╗╦ ╦  ╔═╗╔═╗${NC}"
    echo -e "${RED}  ╠═╣╠═╣║  ╠╩╗║║║║ ║║║║  ║ ║╚═╗${NC}"
    echo -e "${RED}  ╩ ╩╩ ╩╚═╝╩ ╩╝╚╝╚═╝╚╩╝  ╚═╝╚═╝${NC}"
    echo ""
    echo -e "  HackNow OS Build Monitor"
    echo -e "  Log: $LOG_FILE"
    echo ""

    while true; do
        local phase_info=$(detect_phase "$LOG_FILE")
        local pct="${phase_info%%:*}"
        local phase="${phase_info#*:}"

        # Vaqt hisoblash
        local now=$(date +%s)
        local elapsed=$((now - START_TIME))

        # ETA — qolgan vaqt taxmini
        local eta=""
        if [ "$pct" -gt 5 ] && [ "$pct" -lt 100 ]; then
            local total_estimated=$((elapsed * 100 / pct))
            local remaining=$((total_estimated - elapsed))
            eta=$(format_time $remaining)
        elif [ "$pct" -ge 100 ]; then
            eta="0s"
        else
            eta="hisoblanmoqda..."
        fi

        # Bar chizish
        local bar=$(draw_bar "$pct")
        local color="$YELLOW"
        [ "$pct" -ge 80 ] && color="$GREEN"
        [ "$pct" -ge 100 ] && color="$CYAN"

        # Output
        printf "${CLEAR_LINE}${color}  [${bar}]${NC} %3d%%  " "$pct"
        printf "${CYAN}%s${NC}\n" "$phase"
        printf "  ${YELLOW}O'tdi:${NC} %-20s ${YELLOW}Qoldi:${NC} %s\033[1A\r" \
            "$(format_time $elapsed)" "$eta"

        # Tugashi
        if [ "$pct" -ge 100 ]; then
            echo ""
            echo ""
            echo -e "${GREEN}  ✓ BUILD TUGADI!${NC}"
            local iso="$BUILD_DIR/output/hacknow-os-amd64.hybrid.iso"
            if [ -f "$iso" ]; then
                local size=$(du -h "$iso" | cut -f1)
                local sha=$(sha256sum "$iso" 2>/dev/null | cut -d' ' -f1 | cut -c1-16)
                echo -e "  ${CYAN}ISO:${NC}    $iso"
                echo -e "  ${CYAN}Hajmi:${NC}  $size"
                echo -e "  ${CYAN}SHA256:${NC} ${sha}..."
                echo ""
                echo -e "  Ishga tushirish: ${YELLOW}./run.sh${NC}"
            fi
            echo ""
            break
        fi

        # Xato tekshirish
        if [ -f "$LOG_FILE" ] && tail -20 "$LOG_FILE" 2>/dev/null | grep -q "E: \|^\[!\] ISO yaratilmadi"; then
            echo ""
            echo ""
            echo -e "${RED}  ✗ BUILD XATO BILAN TUGADI!${NC}"
            echo ""
            echo "  Oxirgi xato:"
            tail -10 "$LOG_FILE" | grep "E: " | head -3 | sed 's/^/    /'
            echo ""
            break
        fi

        sleep 2
    done
}

# === Main ===
case "$MODE" in
    --watch|watch)
        if [ ! -f "$LOG_FILE" ]; then
            echo -e "${RED}Log fayl topilmadi: $LOG_FILE${NC}"
            echo "Avval build ishga tushiring: bash docker-build.sh minimal"
            exit 1
        fi
        # Eski log uchun START_TIME ni log fayl yaratilgan vaqtga moslash
        START_TIME=$(stat -c %Y "$LOG_FILE" 2>/dev/null || date +%s)
        monitor_build
        ;;

    --log)
        LOG_FILE="$2"
        monitor_build
        ;;

    --help|-h)
        cat << 'HELP'
HackNow OS Build Progress Monitor

Foydalanish:
    ./build-progress.sh           — yangi build + progress (default)
    ./build-progress.sh --watch   — mavjud build'ni kuzatish
    ./build-progress.sh --log <f> — log fayl bilan kuzatish
    ./build-progress.sh --help    — yordam

Bosqichlar:
    1-10%   Bootstrap (base system)
    10-45%  Paketlar yuklanmoqda
    45-65%  Paketlar ochilmoqda
    65-80%  Paketlar o'rnatilmoqda
    80-85%  Hook'lar
    85-97%  Squashfs siqish
    97-100% ISO yaratish

Misol:
    # Boshqa terminalda build ishga tushiring:
    bash docker-build.sh minimal

    # Bu terminalda progress'ni kuzating:
    ./scripts/build-progress.sh --watch
HELP
        exit 0
        ;;

    build|*)
        # Build'ni background'da ishga tushirish + monitor
        echo "Build ishga tushirilmoqda..."
        rm -f "$LOG_FILE" 2>/dev/null
        bash "$BUILD_DIR/docker-build.sh" minimal > /dev/null 2>&1 &
        BUILD_PID=$!
        echo "Build PID: $BUILD_PID"
        sleep 3
        monitor_build
        ;;
esac
