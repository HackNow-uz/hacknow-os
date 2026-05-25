#!/bin/bash
# HackNow OS Branding — O'rnatish
set -e

echo "[HackNow] Branding o'rnatilmoqda..."

# GRUB theme
GRUB_DIR="/usr/share/grub/themes/hacknow"
mkdir -p "$GRUB_DIR"
cp -r grub/hacknow/* "$GRUB_DIR/"

# Plymouth theme
PLYMOUTH_DIR="/usr/share/plymouth/themes/hacknow"
mkdir -p "$PLYMOUTH_DIR"
cp -r plymouth/hacknow/* "$PLYMOUTH_DIR/"

# Wallpapers
mkdir -p /usr/share/backgrounds/hacknow
cp wallpapers/*.{png,jpg} /usr/share/backgrounds/hacknow/ 2>/dev/null || true

# LightDM
cp lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

# GTK Theme
cp -r gtk-theme/hacknow-dark /usr/share/themes/HackNow-Dark

# Neofetch
mkdir -p /etc/neofetch
cp neofetch/config.conf /etc/neofetch/config.conf

echo "[HackNow] Branding o'rnatildi!"
