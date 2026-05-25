#!/bin/bash
# HackNow OS — XFCE4 Panel konfiguratsiyasi
# Bu skript panel'ni qayta konfiguratsiya qiladi (live session yoki post-install)
# Foydalanish: bash setup-panel.sh

set -e

echo "[HackNow OS] Panel konfiguratsiyasi boshlanmoqda..."

# === 1. Plank (bottom dock) o'chirish ===
killall plank 2>/dev/null || true
rm -f ~/.config/autostart/plank.desktop 2>/dev/null || true
echo "  ✓ Plank o'chirildi"

# === 2. XFCE panel reset ===
xfce4-panel --quit 2>/dev/null || true
sleep 1

# === 3. Faqat 1 panel (top) ===
xfconf-query -c xfce4-panel -p /panels -t int -s 1 --create --force 2>/dev/null || true

# Panel 1 asosiy sozlamalar
xfconf-query -c xfce4-panel -p /panel-1/position -s "p=6;x=0;y=0" --create --force
xfconf-query -c xfce4-panel -p /panel-1/position-locked -t bool -s true --create --force
xfconf-query -c xfce4-panel -p /panel-1/length -t int -s 100 --create --force
xfconf-query -c xfce4-panel -p /panel-1/size -t int -s 32 --create --force
xfconf-query -c xfce4-panel -p /panel-1/icon-size -t int -s 20 --create --force
xfconf-query -c xfce4-panel -p /panel-1/background-style -t int -s 1 --create --force

# Panel fon rangi (#0a0a0a, 96% opacity)
xfconf-query -c xfce4-panel -p /panel-1/background-rgba \
  -t double -s 0.039 -t double -s 0.039 -t double -s 0.039 -t double -s 0.96 \
  --create --force

echo "  ✓ Panel-1 (top) sozlandi"

# === 4. Plugin'lar ===
# Plugin tartib: Menu | Sep | Terminal | Browser | Files | Editor | Tasklist | Sep(expand) | Systray | Notif | PulseAudio | Clock | Actions
xfconf-query -c xfce4-panel -p /panel-1/plugin-ids \
  -t int -s 1 -t int -s 2 -t int -s 10 -t int -s 11 -t int -s 12 -t int -s 13 \
  -t int -s 3 -t int -s 4 -t int -s 5 -t int -s 6 -t int -s 14 -t int -s 7 -t int -s 8 \
  --create --force

# Plugin 1: App Menu
xfconf-query -c xfce4-panel -p /plugins/plugin-1 -s "applicationsmenu" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -s "/usr/share/pixmaps/hacknow-logo.png" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-title -s "HACKNOW OS" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-button-title -t bool -s true --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-button-icon -t bool -s true --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-1/small -t bool -s false --create --force

# Plugin 2: Separator (chiziq)
xfconf-query -c xfce4-panel -p /plugins/plugin-2 -s "separator" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-2/style -t int -s 3 --create --force

# Plugin 10: Terminal launcher
xfconf-query -c xfce4-panel -p /plugins/plugin-10 -s "launcher" --create --force

# Plugin 11: Browser launcher
xfconf-query -c xfce4-panel -p /plugins/plugin-11 -s "launcher" --create --force

# Plugin 12: Thunar launcher
xfconf-query -c xfce4-panel -p /plugins/plugin-12 -s "launcher" --create --force

# Plugin 13: Editor launcher
xfconf-query -c xfce4-panel -p /plugins/plugin-13 -s "launcher" --create --force

# Plugin 3: Tasklist
xfconf-query -c xfce4-panel -p /plugins/plugin-3 -s "tasklist" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-3/flat-buttons -t bool -s true --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-3/show-labels -t bool -s true --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-3/grouping -t int -s 1 --create --force

# Plugin 4: Expanding separator
xfconf-query -c xfce4-panel -p /plugins/plugin-4 -s "separator" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-4/expand -t bool -s true --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-4/style -t int -s 0 --create --force

# Plugin 5: Systray
xfconf-query -c xfce4-panel -p /plugins/plugin-5 -s "systray" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-5/square-icons -t bool -s true --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-5/size-max -t int -s 20 --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-5/symbolic-icons -t bool -s true --create --force

# Plugin 6: Notifications
xfconf-query -c xfce4-panel -p /plugins/plugin-6 -s "notification-plugin" --create --force

# Plugin 14: PulseAudio
xfconf-query -c xfce4-panel -p /plugins/plugin-14 -s "pulseaudio" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-14/enable-keyboard-shortcuts -t bool -s true --create --force

# Plugin 7: Clock
xfconf-query -c xfce4-panel -p /plugins/plugin-7 -s "clock" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-7/mode -t int -s 2 --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-7/digital-format -s "%H:%M  %a %d %b" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-7/digital-time-format -s "%H:%M  %a %d %b" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-7/show-frame -t bool -s false --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-7/tooltip-format -s "%A, %d %B %Y" --create --force

# Plugin 8: Actions
xfconf-query -c xfce4-panel -p /plugins/plugin-8 -s "actions" --create --force
xfconf-query -c xfce4-panel -p /plugins/plugin-8/appearance -t int -s 0 --create --force

echo "  ✓ Plugin'lar sozlandi"

# === 5. Launcher .desktop fayllar ===
mkdir -p ~/.config/xfce4/panel/launcher-{10,11,12,13}

# Terminal
ln -sf /usr/share/applications/xfce4-terminal.desktop ~/.config/xfce4/panel/launcher-10/xfce4-terminal.desktop
# Browser
ln -sf /usr/share/applications/firefox-esr.desktop ~/.config/xfce4/panel/launcher-11/firefox-esr.desktop
# File Manager
ln -sf /usr/share/applications/thunar.desktop ~/.config/xfce4/panel/launcher-12/thunar.desktop
# Editor
ln -sf /usr/share/applications/mousepad.desktop ~/.config/xfce4/panel/launcher-13/mousepad.desktop

echo "  ✓ Launcher fayllar yaratildi"

# === 6. Panel qayta ishga tushirish ===
nohup xfce4-panel &>/dev/null &
sleep 2

echo "[HackNow OS] Panel konfiguratsiyasi tugadi!"
echo "  Layout: [Menu] [|] [Term] [Browser] [Files] [Editor] ... [Tray] [Vol] [Clock] [Power]"
