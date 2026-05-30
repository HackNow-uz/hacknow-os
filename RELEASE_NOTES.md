# HackNow OS v0.1.0-alpha.2 — "Til va Dizayn"

> **Sana:** 2026-05-30
> **Asos:** v0.1.0-alpha (2026-05-15) bilan kompatibel
> **Diqqat:** Alpha versiya — sinov uchun. Production yoki real ish uchun emas.
> **ISO:** `hacknow-os-v0.1.0-alpha.2-amd64.iso` (3.7 GiB)
> **SHA256:** `82bf52ac7b2482981e4341b6455e8a0608e1f93ed05d067111b60d78226a9021`
> **Yuklab olish:** https://os.hacknow.uz/releases/hacknow-os-v0.1.0-alpha.2-amd64.iso

---

## 🆕 Asosiy yangiliklar

### 1. Calamares installer to'liq O'zbek tilida

- **Custom calamares deb** — `lang/calamares_uz.ts` (882 string upstream, 869 tarjima) Qt resource'ga embed qilingan
- Docker bookworm konteynerda `dpkg-buildpackage` qilingan, `_tx_good` CMake ro'yxatiga `uz` qo'shilgan
- Welcome dialog: "HackNow OS 0.1.0-alpha.2 o'rnatuvchisiga xush kelibsiz"
- Sidebar: Xush kelibsiz / Joylashuv / Klaviatura / Bo'limlar / Foydalanuvchilar / Xulosa / O'rnatish / Tugatish
- Tugmalar: Ortga / Keyingi / Bekor qilish / Bajarildi
- locale-gen + dpkg-reconfigure + localedef 3 qator fallback
- Welcome dialog faqat live USB'da (boot=live check + autostart cleanup post-install)

### 2. Branding va dizayn

- Sidebar 250px keng, #logoApp 150px min-height + AlignTop
- Custom 280×280 HackNow bolt logo (toza, matnsiz)
- Stylesheet v2: Inter sans-serif, 8px radius, hover/pressed/disabled holatlar
- 5 slaydli slideshow + animatsion slide indikator
- Welcome rasm 900×560 — HackNow OS branded artwork

### 3. Icon theme: HackNow-Tools (577 ikon, 4 manba)

- **Athena OS** (31 SVG): blueteam, redteam, social, va 26 kategoriya
- **Kali Linux** (7,143 SVG, 381 kali-* tool ikon): Flat-Remix-Blue-Dark
- **Parrot Sec** (163 PNG): parrot-menu repo'sidan
- **BlackArch** (3 SVG): cutter, tor, ostinato
- **Custom HackNow SVG**: qizil qilich (Red Team), ko'k qalqon (Blue Team), pushti olov (Purple Team), bayroq (CTF)
- 11 sub-category custom SVG: lupa, ko'z, globe+bug, star burst, lock+key, wifi waves, toj, ...
- `xsettings Net/IconThemeName = HackNow-Tools` skel + first-login script

### 4. Menu strukturasi (4 cat + 12 sub)

```
🔴 Red Team
   ├─ Recon · OSINT · Web Application · Exploitation
   └─ Password Attacks · Wireless · Post Exploitation
🔵 Blue Team
   ├─ Forensics
   └─ Defense
🟣 Purple Team
   ├─ Network Analysis
   └─ MITM
🚩 CTF Tools
   ├─ CTF Challenges · Cryptography · Reverse Engineering
─────
Run Program · Terminal · File Manager · Mail · Web Browser
─────
Network · System · Development · Accessories · Settings · Graphics · Multimedia · Office · ...
```

XFCE Layout HackNow yuqorida, system kategoriyalar pastida.

### 5. Klaviatura

- `XKBLAYOUT="us,uz,ru"`, `XKBVARIANT=",latin,"` (uz cyrillic olib tashlandi)
- US default, Alt+Shift cycle, Scroll LED indicator
- Calamares shellprocess.conf post-install: `hacknow-fix-keyboard` skript
- Foydalanuvchi UZ tilini tanlasa ham klaviatura US+uz(latin) bo'lib qoladi

### 6. Tizim sozlamalari

- **First-login panel init**: xfconf-query canonical config (XFCE 4.18 duplikat bug fix)
- Panel-1 (top): size=32, icon=18, 10 plugin (apps menu, tasklist, systray, ...)
- Panel-2 (bottom dock): autohide, 8 launcher live'da / 7 installed'da
- Live session = Installed session: bir xil tajriba
- `tasklist grouping=0` (hamburger 3-chiziq yo'q)
- Installer dock+Desktop'da live'da, post-install avto-tozalanadi
- `ssh-keygen -A` post-install (host kalitlar avto)

### 7. Build pipeline yaxshilanishi

- `sync-installer.sh` Qt6 `lrelease6` aniqlash
- Build-time `.qm` kompilyatsiya
- `qemu-boot-disk.sh` skripti (qcow2 disk uchun)
- Auto-deploy: `/var/www/releases/` + SHA256 + GPG imzo + SHA256SUMS yangilash

---

## 🔧 Tuzatilgan muammolar

| # | Muammo | Yechim |
|---|--------|--------|
| 1 | Calamares ingliz tilida ochilardi | Custom deb Qt resource'ga uz embed |
| 2 | `sudo` LANG env'ni tashlardi | wrapper + sudoers `env_keep` |
| 3 | locale-archive uz_UZ yo'q edi | 3-fallback (locale-gen → reconfigure → localedef) |
| 4 | XFCE 4.18 xfconfd duplikat panel-1 | First-login script canonical write |
| 5 | Klaviatura UZ → kirill | XKBVARIANT="latin" + post-install script |
| 6 | SSH ishga tushmas (no host keys) | `ssh-keygen -A` post-install |
| 7 | Welcome dialog installed'da chiqardi | `boot=live` check + autostart cleanup |
| 8 | Tasklist hamburger ikon | `grouping=0` |
| 9 | install-debian.desktop Desktop'da | panel-init avto-tozalash |
| 10 | Calamares til o'rnatildi-yu, Cyrillic | glibc default `uz_UZ` aslida lotin (Bookworm) |

---

## ⬇️ Yuklab olish va o'rnatish

```bash
# Yuklab olish
wget https://os.hacknow.uz/releases/hacknow-os-v0.1.0-alpha.2-amd64.iso

# SHA256 tasdiqlash
sha256sum hacknow-os-v0.1.0-alpha.2-amd64.iso
# 82bf52ac7b2482981e4341b6455e8a0608e1f93ed05d067111b60d78226a9021

# GPG imzo tekshirish
wget https://os.hacknow.uz/releases/hacknow-os-signing-key.asc
gpg --import hacknow-os-signing-key.asc
gpg --verify hacknow-os-v0.1.0-alpha.2-amd64.iso.asc hacknow-os-v0.1.0-alpha.2-amd64.iso

# USB ga yozish (REAL hardware)
sudo dd if=hacknow-os-v0.1.0-alpha.2-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync

# QEMU'da sinash
qemu-system-x86_64 -m 4G -smp 4 -enable-kvm \
    -cdrom hacknow-os-v0.1.0-alpha.2-amd64.iso \
    -drive file=disk.qcow2,format=qcow2 -boot d -display gtk
```

---

## 🔁 v0.1.0-alpha'dan o'zgarmaganlar

- Asosiy tizim: Debian Bookworm 12 + Linux 6.1
- 60+ pentest asboblar (nmap, sqlmap, hydra, wireshark, ...)
- 12 HackNow CLI (hn-info, hn-scope, hn-decode, ...)
- Plymouth boot splash, GRUB theme, LightDM
- XFCE 4.18 + Picom + Conky widgets

---

## 🐛 Ma'lum cheklovlar

- `pwndbg`, `exiftool`, `airodump-ng` — HackNow-Tools temada custom icon yo'q (default ishlatiladi)
- Sertifikatlangan release imzosi (Code-Sign) hali yo'q — faqat GPG detached signature
- Wayland session qo'llab-quvvatlanmaydi (faqat X11)
- Live USB persistence yo'q (alpha.3'ga)

---

## 📋 Keyingi versiya — v0.1.0-alpha.3 (PLANNED)

- Plank dock alternatif sifatida
- LightDM login screen banner + uz
- GRUB theme uz tilida
- Conky widgetlar uz tilida
- Sertifikatlangan release
- Issue tracker + community feedback

To'liq yo'l xaritasi: [ROADMAP.md](./ROADMAP.md)

---

## 🙏 Manbalar va litsenziyalar

- **Kali Linux themes**: GPL-3.0+ (icon theme: Flat-Remix-Blue-Dark)
- **Athena OS**: GPL-3.0+ (kategoriya icon'lar)
- **Parrot Sec parrot-menu**: GPL-3.0+ (tool icon'lar)
- **BlackArch icons**: custom (3 ta unique)
- **Papirus icon theme**: GPL-3.0+
- **Calamares**: GPL-3.0+ (custom deb O'zbek tarjima bilan)
- **HackNow custom SVG**: MIT (4 cat + 11 sub-cat ikonlar)

Rahmat HackNow Team va barcha hissa qo'shganlar! 🚀
