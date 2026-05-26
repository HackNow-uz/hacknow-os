# HackNow OS v0.1.0-alpha.2 — "Til va Dizayn"

> **Sana:** 2026-05-26
> **Asos:** v0.1.0-alpha bilan kompatibel (faqat installer yangilangan, bazaviy tizim o'zgarmagan)
> **Diqqat:** Bu alpha versiya — sinov uchun. Production yoki real ish uchun emas.

---

## 🆕 v0.1.0-alpha.2 yangiliklari (2026-05-26)

### O'zbek tili installer'da to'liq yoqildi

- Yangi `/usr/local/bin/hacknow-installer` wrapper — `LANG=uz_UZ.UTF-8` muhitini majburiy o'rnatadi
- `sudoers.d/hacknow-live` ga `env_keep` ro'yxati qo'shildi: LANG, LANGUAGE, LC_*, QT_*, BROWSER
- Asosiy sabab tuzatildi: `sudo` default'da `LANG` env'ni tashlab ketardi → Qt locale `C`/`en_US` ga tushardi → `.qm` topilsa ham ingliz interfeys
- Til tanlash menyusida birinchi qator: **O'zbekcha**
- Tarjima manbalari: `calamares_uz.ts` (882 string upstream) + `branding/uz.ts` (44 brending stringi)

### Calamares brending dizayni v2

- Stylesheet sans-serif (Inter / Noto Sans / DejaVu Sans) — eski monospace UI almashtirildi
- Sidebar item'larga 12px padding, 8px radius, 3px qizil chap accent border
- Tugmalarda 8px radius, aniqroq `hover`/`pressed`/`disabled` holatlari
- Checkbox/radio 18px, custom dropdown strelka, slider stilizatsiya
- Welcome rasm va asosiy oyna `900x560` o'lchamga sozlandi
- 5 slaydli slideshow + pastida animatsion slide indikator (250ms width animation)
- Slideshow mavzulari: Welcome, 63+ asboblar, HackNow platforma, O'zbek tili, Hamjamiyat

### Build pipeline yaxshilanishi

- `sync-installer.sh` Qt6 `lrelease6`/`lrelease-qt6` ham aniqlaydi (avval faqat Qt5)
- Build-time'da `.qm` kompilyatsiya qilinadi (chroot fallback'siz ham ishlaydi)
- Chroot hook'da Qt5 va Qt6 lrelease ikkalasi izlanadi
- `.gitignore` ga `*.qm` qo'shildi (build artefakti)

**Commit:** `f5e852c` — feat(installer): o'zbek tili va dizayn calamares installer'da to'liq yoqildi

---

## ✨ Asosiy yangiliklar

HackNow OS — **O'zbekistonning birinchi pentesting va kiberxavfsizlik distributivi**. Bu birinchi rasmiy alpha versiya.

### 🎨 Vizual

- **HackNow-Dark GTK theme** — qora/qizil (#FF1744) palitra
- **HackNow xfwm4 theme** — 45 ta custom asset (close/min/max buttons)
- **Plymouth boot splash** — pulse animatsiya bilan logo
- **GRUB theme** — qizil HackNow olmos logosi
- **LightDM login screen** — frosted glass effekt
- **Wallpapers** — cyberpunk + terminal style (auto-rotate 30min)
- **Papirus-Dark icons** + **Bibata-Modern-Classic** kursor
- **Hack Nerd Font** terminal va shell uchun

### 🖥️ Desktop muhit

- **XFCE 4.18** + **Picom compositor** (rounded corners, shadows)
- **Rofi** app launcher (Super+D)
- **Tilda** drop-down terminal (F12)
- **Plank** dock (auto-hide, 5 launcher)
- **Conky** HUD widget — VPN, Tor, Target, Scope status
- **Dunst** notifications — qizil accent

### 🐚 Shell tajriba

- **zsh** default + **Starship prompt** (HackNow theme)
- **tmux** + TPM + resurrect + continuum (15min auto-save)
- **fzf**, **bat**, **exa**, **ripgrep**, **fd**, **zoxide**, **tldr**, **thefuck**
- **btop** — HackNow theme
- Custom aliases — t/td/tk, dl/dt/pt/home, ezsh/etmux

### 🔧 HackNow CLI toollar (12 ta)

```
hn-info        — System info + HackNow banner
hn-scope       — Pentest target scope manager
hn-decode      — Universal decoder (base64/hex/url/rot13/binary)
hn-hash        — Multi-hash (MD5/SHA1/SHA256/SHA512/NTLM)
hn-listen      — Netcat listener + IP banner + auto-log
hn-record      — Screen recording (gif/video)
hn-screenshot  — Auto timestamp + target naming
hn-note        — Markdown pentest report template
hn-update      — System + tools + HackNow update
hn-vpn         — OpenVPN wrapper (PID file based)
hn-lab-connect — HackNow Lab integration (API kutilmoqda)
hn-submit      — CTF flag submission (API kutilmoqda)
```

### 🛠️ Pentest toollar (60+)

| Kategoriya | Misol toollar |
|-----------|---------------|
| Razvedka | nmap, masscan, dnsrecon, dnsenum, nbtscan, smbclient |
| Web | sqlmap, nikto, dirb, wfuzz, whatweb, wafw00f |
| Tarmoq | wireshark, ettercap, tcpdump, socat, hping3, mitmproxy |
| Parol | john, hashcat, hydra, medusa, crunch, cewl |
| Exploit | python3-impacket, python3-scapy, python3-pwntools |
| Reverse | gdb, binwalk, foremost, strace, ltrace, xxd |
| Wireless | aircrack-ng, reaver, pixiewps |
| Forensics | sleuthkit, dc3dd, testdisk, steghide, exiftool |
| Kriptografiya | hashid, python3-pycryptodome |

### 🚀 Build pipeline

- **Docker-based build** — bir komandada ISO yaratish
- **GitHub Actions CI** — auto-build push'da
- **progress.sh** — real-time build progress monitor
- **qemu-run.sh** — bir komandada QEMU'da test
- **sync-branding.sh** — branding repo'dan avto sync

### 🛡️ Xavfsizlik

- SSH **default OFF** (live session'da)
- Sudo NOPASSWD (live mode)
- JSON injection fix (hn-lab-connect, hn-submit)
- MOTD'da warning + default creds info
- SAST audit + tuzatishlar (C+ grade)

---

## 📦 Yuklab olish

| Fayl | Hajm | SHA256 |
|------|------|--------|
| `hacknow-os-amd64.hybrid.iso` | ~2.5 GB | (build natijasi) |

**O'rnatish:**
```bash
# USB ga yozish (Linux)
sudo dd if=hacknow-os-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress

# yoki QEMU'da
qemu-system-x86_64 -cdrom hacknow-os-amd64.hybrid.iso -m 2048 -enable-kvm
```

**Login:**
- User: `hacknow` / Parol: `hacknow`
- ⚠️ **Birinchi loginda parolni o'zgartiring:** `passwd`

---

## 🔧 Tizim talablari

| | Minimal | Tavsiya |
|---|---------|---------|
| CPU | 2 yadro 64-bit | 4+ yadro |
| RAM | 2 GB | 8 GB |
| Disk | 20 GB | 50 GB SSD |
| Boot | UEFI/BIOS | UEFI |

---

## 🐛 Ma'lum muammolar

- **hn-lab-connect/hn-submit** — backend API hali yo'q (lab.hacknow.uz development)
- **Picom GLX** — VM'da xrender fallback'ga o'tadi (real HW da GLX ishlaydi)
- **Online dependencies** — Starship, Nerd Font, Bibata cursor build vaqtida internet kerak
- **Calamares installer** — hali to'liq integratsiya qilinmagan (Faza 2)
- **Metasploit, Ghidra, Burp** — hook orqali, lekin minimal rejimda yo'q

---

## 🚀 Keyingi versiyalar

### v0.5-beta (Faza 2 — ~2 oy)
- 250+ pentesting tool (pip/go hooks)
- Calamares installer + o'zbek tilida
- APT repo (apt.hacknow.uz)
- Oh-my-zsh + powerlevel10k

### v1.0 "Cyber" (Faza 3 — ~4 oy)
- 500+ tool
- Hardened kernel
- Anonimlik rejimi (hn-anon)
- AI yordamchi (hn-ai)
- HackNow Platform GUI integratsiya

---

## 🤝 Hamjamiyat

- **Website:** [hacknow.uz](https://hacknow.uz) | [os.hacknow.uz](https://os.hacknow.uz)
- **Telegram:** [t.me/hacknow_uz](https://t.me/hacknow_uz)
- **GitHub:** [github.com/HackNow-uz](https://github.com/HackNow-uz)
- **Email:** hacknow.uz@gmail.com

---

## 📜 Litsenziya

GPL-3.0 — ochiq kodli, har kim hissa qo'shishi mumkin.

> **Muhim:** HackNow OS faqat **qonuniy maqsadlar**, ta'lim va **ruxsat berilgan pentesting** uchun mo'ljallangan. Noqonuniy foydalanish man etiladi.

---

**Rise Up! Let the storm, break loose!**

— HackNow Team
