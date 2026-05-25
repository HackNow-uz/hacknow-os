# HackNow OS — Build System

HackNow OS — O'zbekiston kiberxavfsizlik hamjamiyati uchun Debian-asosli live distributiv.

Kali Linux / Parrot OS ga o'xshash, lekin O'zbek foydalanuvchilari uchun moslashtirilgan.

## Asosiy ma'lumotlar

- **Asos:** Debian 12 (Bookworm) stable
- **Desktop:** XFCE (yengil, pentesting uchun qulay)
- **Arxitektura:** amd64
- **Versiya:** 0.1

## Talab qilingan dasturlar

```bash
sudo apt install live-build debootstrap squashfs-tools xorriso
```

## ISO yaratish

### 1-usul: `build.sh` orqali (tavsiya etiladi)

```bash
git clone https://github.com/hacknow-uz/hacknow-os-build.git
cd hacknow-os-build
sudo ./build.sh all
```

### 2-usul: `make` orqali

```bash
sudo make build
```

### 3-usul: To'g'ridan-to'g'ri live-build

```bash
sudo lb config
sudo lb build
```

## Build bosqichlari

| Bosqich | Tavsif | Vaqt |
|---------|--------|------|
| `clean` | Avvalgi build qoldiqlarini tozalash | ~10 sek |
| `config` | live-build konfiguratsiyasi | ~5 sek |
| `build` | ISO yaratish (debootstrap + chroot + squashfs) | ~30-60 daqiqa |

## Papka tuzilmasi

```
hacknow-os-build/
├── auto/                    # live-build avtomatik skriptlar
│   ├── config               # lb config parametrlari
│   ├── build                # lb build wrapper
│   └── clean                # lb clean wrapper
├── config/
│   ├── package-lists/       # O'rnatiluvchi paketlar ro'yxati
│   ├── includes.chroot/     # Live fayl sistemasiga qo'shiladigan fayllar
│   ├── hooks/live/          # Build jarayonida ishlaydigan hook skriptlar
│   └── bootloaders/         # GRUB konfiguratsiyasi
├── build.sh                 # Qulay build skripti
├── Makefile                 # Make buyruqlari
└── .github/workflows/       # GitHub Actions CI
```

## O'rnatilgan vositalar

### Razvedka (Reconnaissance)
- nmap, masscan, netdiscover
- dnsrecon, dnsenum, whois
- theHarvester

### Web xavfsizlik
- sqlmap, nikto, dirb, gobuster, wfuzz

### Tarmoq hujumlari
- wireshark, tshark, tcpdump
- ettercap, netcat, socat
- proxychains4, tor

### Parol hujumlari
- john, hashcat, hydra, medusa
- wordlists, crunch

### Reverse Engineering
- gdb, radare2, binwalk, foremost

### Wireless
- aircrack-ng, kismet, reaver

### Forensics
- sleuthkit, autopsy, dc3dd, testdisk

### Python vositalar (pipx)
- impacket, pwntools, crackmapexec
- certipy-ad, bloodhound, updog

### Go vositalar
- nuclei, subfinder, httpx, ffuf
- waybackurls, gobuster

## Default foydalanuvchi

- **Username:** `hacknow`
- **Password:** `hacknow`
- **Sudo:** NOPASSWD (live sessiya uchun)

## GitHub Actions

`main` yoki `develop` branchga push qilganda ISO avtomatik yaratiladi.
Tag yaratganda (`v*`) GitHub Release ga yuklanadi.

## Litsenziya

HackNow Team — https://hacknow.uz
