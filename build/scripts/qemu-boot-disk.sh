#!/bin/bash
# HackNow OS — O'rnatilgan tizimni qcow2 diskdan QEMU'da ishga tushirish
#
# Foydalanish:
#   ./scripts/qemu-boot-disk.sh
#   ./scripts/qemu-boot-disk.sh --disk path/to/installed.qcow2
#   ./scripts/qemu-boot-disk.sh --ram 4G
#
# Bu skript qcow2 diskni 'bootable disk' sifatida ishlatadi (ISO YO'Q).
# Foydali: ISO orqali installer'ni bajarib bo'lgandan keyin, o'rnatilgan
# tizimga kirish uchun.

set -u

# === Default parametrlar ===
DISK_PATH=""
RAM="8192"
CPU="6"
DISPLAY_MODE="gtk"
SSH_PORT="2224"
ENABLE_SSH="yes"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[QEMU]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
info() { echo -e "${CYAN}[i]${NC} $1"; }

# === Sudo ostida ishga tushirilganmi tekshirish ===
if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    warn "Sudo orqali ishga tushirildi — GTK display sudo'da ishlamaydi."
    warn "Sudo'siz qayta urinib ko'ring: bash scripts/qemu-boot-disk.sh"
    exit 1
fi

# === Argument parsing ===
while [ $# -gt 0 ]; do
    case "$1" in
        --disk)
            DISK_PATH="$2"; shift 2 ;;
        --ram)
            RAM="${2%G}"; RAM="${RAM}000"; shift 2 ;;
        --cpu)
            CPU="$2"; shift 2 ;;
        --vnc)
            DISPLAY_MODE="vnc"; shift ;;
        --no-ssh)
            ENABLE_SSH="no"; shift ;;
        --ssh-port)
            SSH_PORT="$2"; shift 2 ;;
        -h|--help)
            cat <<USAGE
Foydalanish: $0 [variantlar]

Variantlar:
  --disk PATH       qcow2 disk yo'li (default: output/*.qcow2 ichidan oxirgisi)
  --ram SIZE        RAM (default: 8G). Misol: --ram 4G
  --cpu N           CPU yadrolar (default: 6)
  --vnc             GTK o'rniga VNC (port 5901)
  --no-ssh          SSH port forward'siz
  --ssh-port PORT   SSH host port (default: 2224)
  -h, --help        Yordam

Misollar:
  $0
  $0 --ram 4G --cpu 4
  $0 --disk output/hacknow-os-v0.1.0-alpha.2-amd64.qcow2
USAGE
            exit 0 ;;
        *)
            err "Noma'lum argument: $1 (yordam: --help)" ;;
    esac
done

# === Disk yo'lini aniqlash ===
if [ -z "$DISK_PATH" ]; then
    REAL_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
    SCRIPT_DIR="$(dirname "$REAL_SCRIPT")"
    BUILD_DIR="$(dirname "$SCRIPT_DIR")"
    # output/ ichidagi eng yangi qcow2 ni topish
    DISK_PATH=$(ls -1t "$BUILD_DIR/output/"*.qcow2 2>/dev/null | head -1)
fi

if [ ! -f "$DISK_PATH" ]; then
    err "qcow2 disk topilmadi: '$DISK_PATH'
ISO orqali installer'ni bajarib qcow2 disk yarating, yoki --disk bilan yo'l bering."
fi

# === KVM tekshirish ===
KVM_ARGS=""
if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
    KVM_ARGS="-enable-kvm -cpu host"
    log "KVM: yoqilgan (hardware acceleration)"
else
    warn "KVM yo'q yoki ruxsat berilmagan — sekin TCG emulator ishlatamiz"
    KVM_ARGS="-cpu qemu64"
fi

# === Network argumentlari ===
NET_ARGS=""
if [ "$ENABLE_SSH" = "yes" ]; then
    NET_ARGS="-netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22 -device e1000,netdev=net0"
    info "SSH: ssh -p ${SSH_PORT} <username>@localhost"
    info "SSH yoqish (live'da bo'lmasa): sudo systemctl enable --now ssh"
else
    NET_ARGS="-netdev user,id=net0 -device e1000,netdev=net0"
fi

# === Display argumentlari ===
DISPLAY_ARGS=""
case "$DISPLAY_MODE" in
    gtk)
        DISPLAY_ARGS="-vga std -display gtk" ;;
    vnc)
        DISPLAY_ARGS="-vga std -display vnc=:1 -daemonize"
        info "VNC: vncviewer localhost:5901" ;;
esac

DISK_SIZE=$(du -h "$DISK_PATH" | cut -f1)
log "Disk: $DISK_PATH ($DISK_SIZE)"

cat <<BANNER

  ╦ ╦╔═╗╔═╗╦╔═╔╗╔╔═╗╦ ╦  ╔═╗╔═╗
  ╠═╣╠═╣║  ╠╩╗║║║║ ║║║║  ║ ║╚═╗
  ╩ ╩╩ ╩╚═╝╩ ╩╝╚╝╚═╝╚╩╝  ╚═╝╚═╝

  HackNow OS — O'rnatilgan tizim (qcow2)

BANNER

log "QEMU ishga tushirilmoqda..."
log "RAM: ${RAM}M | CPU: ${CPU} | Display: ${DISPLAY_MODE}"
echo ""

exec qemu-system-x86_64 \
    -drive file="$DISK_PATH",format=qcow2,if=virtio \
    -m "$RAM" -smp "$CPU" \
    $KVM_ARGS \
    $DISPLAY_ARGS \
    -boot c \
    $NET_ARGS \
    -name "HackNow OS (installed)" \
    -rtc base=localtime \
    -usb -device usb-tablet
