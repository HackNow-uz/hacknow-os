# HackNow OS — Versiyalar yo'l xaritasi va checklist

Har versiya uchun rejalashtirilgan o'zgarishlar va checklist. Bajarilgan
elementlar `[x]`, hali bajarilmaganlari `[ ]` bilan belgilanadi.

---

## 🏷️ v0.1.0-alpha — "Birinchi Ishga Tushish" (RELEASED · 2026-05-15)

**Asos:** Debian Bookworm + Calamares + XFCE 4.18. Birinchi ishlovchi alpha.

- [x] HackNow-Dark GTK theme (qora/qizil #FF1744)
- [x] XFCE 4.18 + Picom compositor (rounded corners, shadows)
- [x] Plymouth boot splash (pulse animatsiya)
- [x] GRUB theme (qizil HackNow olmos)
- [x] LightDM frosted glass login
- [x] Wallpaper auto-rotate (30 min)
- [x] Papirus-Dark icons + Bibata cursor + Hack Nerd Font
- [x] zsh + Starship prompt
- [x] tmux + TPM + resurrect
- [x] 12 ta HackNow CLI tool (hn-info, hn-scope, hn-decode, hn-hash...)
- [x] 60+ pentest asbob (nmap, sqlmap, hydra, ...)
- [x] Calamares installer (asosiy)
- [x] GitHub release (prerelease) + ISO

> ISO: `hacknow-os-v0.1.0-alpha-amd64.iso` (3.7 GB)

---

## 🏷️ v0.1.0-alpha.2 — "Til va Dizayn" (RELEASED · 2026-05-30)

**Asos:** alpha bilan kompatibel. Asosiy fokus — installer, til, vizual dizayn.

### O'zbek tili (Calamares to'liq)
- [x] Custom Calamares deb (Qt resource'ga uz tarjima embed)
- [x] `lang/calamares_uz.ts` 882 string upstream (869 tarjima qilingan, 98%)
- [x] `_tx_good` CMakeLists.txt da uz qo'shildi
- [x] Docker bookworm konteynerda dpkg-buildpackage
- [x] wrapper script (`/usr/local/bin/hacknow-installer`) LANG=uz_UZ.UTF-8 majburlash
- [x] sudoers env_keep (LANG, LANGUAGE, LC_*, QT_*)
- [x] locale-gen + dpkg-reconfigure + localedef fallback
- [x] Welcome dialog faqat live'da (boot=live check + post-install autostart cleanup)

### Branding va dizayn
- [x] Stylesheet v2: Inter sans-serif, 8px radius, hover/pressed states
- [x] 5 slaydli slideshow + animatsion indicator
- [x] Custom SVG: qizil qilich (Red Team), ko'k qalqon (Blue Team), pushti olov (Purple Team), bayroq (CTF)
- [x] 11 sub-cat SVG (lupa, ko'z, globe+bug, star burst, lock+kalit, ...)
- [x] HackNow-Tools icon theme (577 ikon)
- [x] Kali themes-common: 7,143 SVG + 381 kali-* tool ikoni
- [x] Parrot Sec icons: 165 PNG (parrot_*.png → hacknow-*.png)
- [x] Athena OS: 31 kategoriya SVG (redteam, blueteam, social ...)
- [x] BlackArch: 3 unique ikon (cutter, tor, ostinato)

### Menu strukturasi
- [x] 4 ta katta kategoriya rootda: Red / Blue / Purple Team + CTF
- [x] Sub-kategoriyalar 4 cat ichida (12 ta jami)
- [x] XFCE Layout: HackNow yuqorida, Run Program shortcut'lar, keyin system
- [x] xfce-applications.menu MergeFile bilan hacknow-applications.menu'ni pulls in
- [x] hacknow-applications.menu `<Name>Xfce</Name>` (parent merge uchun)

### Klaviatura
- [x] us / uz(latin) / ru (uz-cyrillic olib tashlandi)
- [x] Alt+Shift cycle, grp_led:scroll
- [x] Calamares shellprocess.conf'da `hacknow-fix-keyboard` post-install
- [x] xkb panel plugin display-name 1 (qisqa kod)

### Tizim sozlamalari
- [x] `ssh-keygen -A` shellprocess.conf'da (host kalitlar avto)
- [x] First-login panel init script (xfconf canonical, duplikat fix)
- [x] xsettings Net/IconThemeName=HackNow-Tools (skel + init)
- [x] qemu-boot-disk.sh build skript (qcow2 disk uchun)
- [x] /etc/skel/.config/autostart/hacknow-panel-init.desktop

### Build pipeline
- [x] sync-installer.sh Qt6 lrelease6/lrelease-qt6 aniqlash
- [x] Build-time .qm kompilyatsiya
- [x] auto-deploy.sh: `/var/www/releases/` + SHA256 + GPG imzo + SHA256SUMS
- [x] Custom calamares deb `build/config/includes.chroot/root/debs/`

### QA / Test
- [x] QEMU live boot test
- [x] Calamares install muvaffaqiyatli (user 'red' yaratildi)
- [x] Yangi ISO'da fresh install + barcha menu/icon tasdiqlash
- [x] GitHub release tag v0.1.0-alpha.2

> ISO: `hacknow-os-v0.1.0-alpha.2-amd64.iso` (3.7 GB)  
> SHA256: `82bf52ac7b2482981e4341b6455e8a0608e1f93ed05d067111b60d78226a9021`

---

## 🏷️ v0.1.0-alpha.3 — "Foydalanuvchi tajribasi" (PLANNED)

**Asos:** alpha.2 stabilligi. Fokus — UX detalili va edge-case'lar.

- [ ] Calamares post-install: birinchi login welcome wizard (uzb)
- [ ] HackNow-Tools tema'ga Parrot PNG'larni ham bog'lash (`Icon=hacknow-TOOL`)
- [ ] BlackArch'dan qolgan unique tool ikonlarini qo'shish
- [ ] Plank dock (opsion alternatif panel-2 dock'iga)
- [ ] Tray indicator ikonlari (volume, network, bluetooth) custom theme bilan
- [ ] Login screen (LightDM) yangi banner + uzb tilida
- [ ] GRUB theme uzbek tilida
- [ ] Plymouth boot splash uzbek matn
- [ ] Conky widget'lar uzbek matn
- [ ] Tarjima sifatini yaxshilash (calamares_uz.ts 882/882 — 13 ta qolgan)
- [ ] Yangi tool ikonlari (pwndbg, exiftool, airodump-ng — hozir yo'q)
- [ ] Tester foydalanuvchilar fikrini yig'ish (Telegram canal)
- [ ] Bug-fix tartibi (issue tracker shakllantirish)

---

## 🏷️ v0.1.0-beta — "Beta" (PLANNED)

**Asos:** alpha sinov natijalari + bug fix. Production'ga yaqin.

- [ ] AI-powered onboarding (LMS bilan integratsiya)
- [ ] HackNow lab-runner integration (`hn-lab-connect`)
- [ ] CTF flag submit CLI (`hn-submit` API'ga ulanish)
- [ ] Live USB persistence opsiyasi
- [ ] Offline installer (apt mirror bundled)
- [ ] Calamares partition'da BTRFS + encryption opsiyasi
- [ ] LUKS support
- [ ] Wayland support (XFCE Wayland session)
- [ ] Boot performance optimizatsiya (5 sekunddan kam)
- [ ] Lighter VM iso (~2 GB) — minimal toollar bilan
- [ ] Full iso (~4 GB) — barcha pentest toollar
- [ ] Hardware uyg'unlik testlari (Intel, AMD, ARM64)
- [ ] Sertifikatlangan release imzosi
- [ ] Apparmor / SELinux profilelar
- [ ] Anti-forensics tools (secure shred, ramwipe)

---

## 🏷️ v0.1.0 — "Stable" (PLANNED)

**Asos:** beta sinov + community feedback. Birinchi rasmiy barqaror chiqishi.

- [ ] LTS qo'llab-quvvatlash siyosati (1 yil)
- [ ] Apt repo (`apt.hacknow.uz`) — HackNow tools va updates uchun
- [ ] Automatic security updates
- [ ] Crash reporter (apport-style)
- [ ] Yangiliklar widget (RSS feed os.hacknow.uz)
- [ ] HackNow OS guide PDF (uzbek)
- [ ] Video tutoriallar (YouTube/Telegram)
- [ ] Hardware sertifikat dasturi (HackNow OS Ready)
- [ ] Press release uzbek/ingliz/rus
- [ ] DistroWatch ro'yxatga kirish

---

## 🏷️ v0.2.0 — "Pentest+" (FUTURE)

**Asos:** stable foundation. Yangi katta funksiyalar.

- [ ] Cloud lab integration (HackNow platform direct boot)
- [ ] Containerized exploit playground (Docker-in-Docker)
- [ ] AI assistant (Claude/local LLM) CLI yordamchi
- [ ] Vulnerability scanner integration (OpenVAS / Greenbone)
- [ ] SIEM dashboard (Wazuh / Elastic)
- [ ] Forensics workstation profile (Volatility, Autopsy, sleuthkit)
- [ ] Red Team C2 framework (Sliver / Mythic)
- [ ] Blue Team detection rules (Sigma, YARA)
- [ ] Purple Team simulation (Atomic Red Team)
- [ ] CTF auto-deploy templates (Docker compose)
- [ ] Custom kernel (low-latency / hardened)
- [ ] Reproducible builds

---

## 📋 Release qadamlari (har versiya uchun)

1. **Spec** — ROADMAP.md'da yangi versiya bo'limi
2. **Develop** — har task uchun PR (test + review)
3. **Build** — `bash build/docker-build.sh full` (server'da)
4. **QA** — QEMU + real hardware sinovi
5. **Deploy** — `/var/www/releases/` + GPG imzo + SHA256SUMS
6. **Tag** — GitHub release + tag `vX.Y.Z`
7. **Announce** — Telegram, Twitter, DistroWatch
8. **Wiki** — `wiki/sources/<sana>-hacknow-os-<topic>.md` yozish

---

> **Eslatma:** Bu hujjat **manba haqiqat manbai**. Har commit'da kerakli
> checkbox'larni `[x]` ga o'tkazib turish. Versiya release qilishdan oldin
> shu fayl review qilinadi.
