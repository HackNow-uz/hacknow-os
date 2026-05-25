#!/bin/bash
# HackNow OS — QEMU orqali ISO ni ishga tushirish
# Foydalanish:
#   ./scripts/qemu-run.sh           — default sozlamalar bilan
#   ./scripts/qemu-run.sh --ram 4G  — 4GB RAM bilan
#   ./scripts/qemu-run.sh --no-ssh  — SSH port forward'siz
#   ./scripts/qemu-run.sh --vnc     — VNC mode (headless)
#
# DIQQAT: Sudo'siz ishga tushiring. KVM kerak bo'lsa user 'kvm' guruhda bo'lsin:
#   sudo usermod -aG kvm $USER && newgrp kvm

set -u

# === Default parametrlar ===
ISO_PATH=""
RAM="8192"
CPU="6"
DISPLAY_MODE="gtk"
SSH_PORT="2222"
ENABLE_SSH="yes"
VNC_PORT="5901"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[QEMU]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
info() { echo -e "${CYAN}[i]${NC} $1"; }

# === Sudo ostida ishga tushirilganmi tekshirish ===
if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    warn "Sudo orqali ishga tushirildi — GTK display sudo'da ishlamaydi."
    warn "Sudo'siz qayta urinib ko'ring: ./run.sh"
    warn ""
    warn "Agar KVM uchun root kerak bo'lsa:"
    warn "  1. sudo usermod -aG kvm \$USER"
    warn "  2. newgrp kvm  (yoki qayta login)"
    warn "  3. ./run.sh    (sudo'siz)"
    warn ""
    warn "Yoki VNC mode'da: ./run.sh --vnc"
    exit 1
fi

# === Argument parsing ===
while [ $# -gt 0 ]; do
    case "$1" in
        --ram)
            RAM="${2%G}"
            [ "$RAM" = "$2" ] || RAM="$((RAM * 1024))"
            shift 2
            ;;
        --cpu)
            CPU="$2"
            shift 2
            ;;
        --iso)
            ISO_PATH="$2"
            shift 2
            ;;
        --vnc)
            DISPLAY_MODE="vnc"
            shift
            ;;
        --no-ssh)
            ENABLE_SSH="no"
            shift
            ;;
        --ssh-port)
            SSH_PORT="$2"
            shift 2
            ;;
        --help|-h)
            cat << 'HELP'
HackNow OS QEMU Launcher

Foydalanish:
    ./qemu-run.sh [parametrlar]

Parametrlar:
    --iso <path>        ISO fayli (default: output/hacknow-os-amd64.hybrid.iso)
    --ram <size>        RAM hajmi (default: 2048 yoki 2G)
    --cpu <count>       CPU yadrolar soni (default: 2)
    --vnc               VNC mode (headless, port 5901)
    --no-ssh            SSH port forward'siz
    --ssh-port <port>   SSH port (default: 2222)
    --help, -h          Ushbu yordam

Misollar:
    ./qemu-run.sh                    # Default: 2GB RAM, GTK display, SSH 2222
    ./qemu-run.sh --ram 4G --cpu 4   # 4GB RAM, 4 CPU
    ./qemu-run.sh --vnc              # Headless mode

DIQQAT: sudo'siz ishlating. KVM uchun:
    sudo usermod -aG kvm $USER
    newgrp kvm  # yoki relogin

SSH bilan ulanish (boot'dan keyin):
    ssh -p 2222 hacknow@localhost
    # Parol: hacknow

QEMU ichida tugmalar:
    Ctrl+Alt+G   — sichqonchani QEMU'dan ozod qilish
    Ctrl+Alt+F   — fullscreen
    Ctrl+Alt+2   — QEMU monitor
HELP
            exit 0
            ;;
        *)
            err "Noma'lum parametr: $1 (--help bilan yordam)"
            ;;
    esac
done

# === ISO topish ===
if [ -z "$ISO_PATH" ]; then
    REAL_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
    SCRIPT_DIR="$(dirname "$REAL_SCRIPT")"
    BUILD_DIR="$(dirname "$SCRIPT_DIR")"
    ISO_PATH="$BUILD_DIR/output/hacknow-os-0.1-alpha.iso"
fi

if [ ! -f "$ISO_PATH" ]; then
    err "ISO topilmadi: $ISO_PATH

ISO yaratish uchun:
    bash docker-build.sh minimal"
fi

ISO_SIZE=$(du -h "$ISO_PATH" | cut -f1)
log "ISO: $ISO_PATH ($ISO_SIZE)"

# === QEMU mavjudligini tekshirish ===
if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
    err "qemu-system-x86_64 topilmadi.

O'rnatish:
    Arch:   sudo pacman -S qemu-desktop
    Debian: sudo apt install qemu-system-x86 qemu-kvm
    Fedora: sudo dnf install qemu-kvm"
fi

# === KVM mavjudligini tekshirish ===
KVM_OPT=""
if [ -e /dev/kvm ] && [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
    KVM_OPT="-enable-kvm -cpu host"
    log "KVM: yoqilgan (hardware acceleration)"
elif [ -e /dev/kvm ]; then
    warn "KVM mavjud lekin ruxsat yo'q. User 'kvm' guruhga qo'shing:"
    warn "  sudo usermod -aG kvm \$USER && newgrp kvm"
    warn "Hozir software emulation ishlatiladi (sekin)"
else
    warn "KVM mavjud emas — sekin bo'ladi (software emulation)"
fi

# === Display ===
DISPLAY_OPT=""
case "$DISPLAY_MODE" in
    gtk)
        # X11/Wayland tekshirish
        if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
            warn "DISPLAY o'zgaruvchi yo'q — VNC mode'ga o'tilmoqda"
            DISPLAY_MODE="vnc"
            DISPLAY_OPT="-vnc :1"
        else
            DISPLAY_OPT="-display gtk"
        fi
        ;;
    vnc)
        DISPLAY_OPT="-vnc :1"
        info "VNC: localhost:$VNC_PORT (vncviewer bilan ulaning)"
        ;;
esac

# === Virtual Disk (installer test uchun) ===
DISK_PATH="${ISO_PATH%.iso}.qcow2"
DISK_OPT=""
if [ ! -f "$DISK_PATH" ]; then
    log "Virtual disk yaratilmoqda: $DISK_PATH (30GB)"
    qemu-img create -f qcow2 "$DISK_PATH" 30G
fi
DISK_OPT="-drive file=$DISK_PATH,format=qcow2,if=virtio"
info "Disk: $DISK_PATH (installer test uchun)"

# === Network — modern -netdev/-device syntax ===
NET_OPT=""
if [ "$ENABLE_SSH" = "yes" ]; then
    NET_OPT="-netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22 -device e1000,netdev=net0"
    info "SSH: ssh -p $SSH_PORT hacknow@localhost (parol: hacknow)"
    info "SSH yoqish (live'da): sudo systemctl start ssh"
else
    NET_OPT="-netdev user,id=net0 -device e1000,netdev=net0"
fi

# === io_uring muammoni oldini olish ===
ulimit -l unlimited 2>/dev/null || true

# === Banner ===
cat << 'BANNER'

  ╦ ╦╔═╗╔═╗╦╔═╔╗╔╔═╗╦ ╦  ╔═╗╔═╗
  ╠═╣╠═╣║  ╠╩╗║║║║ ║║║║  ║ ║╚═╗
  ╩ ╩╩ ╩╚═╝╩ ╩╝╚╝╚═╝╚╩╝  ╚═╝╚═╝

  HackNow OS v0.1-alpha — QEMU

BANNER

log "QEMU ishga tushirilmoqda..."
log "RAM: ${RAM}M | CPU: $CPU | Display: $DISPLAY_MODE"
echo ""

# === Boot ===
exec qemu-system-x86_64 \
    -cdrom "$ISO_PATH" \
    $DISK_OPT \
    -m "$RAM" \
    -smp "$CPU" \
    $KVM_OPT \
    -vga std \
    $DISPLAY_OPT \
    -boot d \
    $NET_OPT \
    -name "HackNow OS" \
    -rtc base=localtime \
    -usb \
    -device usb-tablet
