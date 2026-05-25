# HackNow OS

HackNow OS — Debian asosidagi kiber xavfsizlik distributivi. Penetratsion test, CTF mashqi va xavfsizlik o'rganish uchun mo'ljallangan.

## Struktura

| Katalog | Mazmun |
|---|---|
| [build/](build/) | live-build konfiguratsiyasi, ISO yig'ish skriptlari |
| [branding/](branding/) | GRUB, GTK, Plymouth, LightDM, neofetch brending |
| [installer/](installer/) | Calamares installer brending va i18n |
| [packages/](packages/) | apt repository, paketlar ro'yxati, toolsets |
| [tools/](tools/) | HackNow OS CLI skriptlari (`/usr/local/bin`) |

## Bog'liq repolar

- [hacknow-os-docs](https://github.com/HackNow-uz/hacknow-os-docs) — foydalanuvchi va developer hujjatlari
- [hacknow-os-web](https://github.com/HackNow-uz/hacknow-os-web) — `os.hacknow.uz` sayti

## Boshlash

```bash
git clone https://github.com/HackNow-uz/hacknow-os.git
cd hacknow-os/build
sudo bash build.sh all
```

Tafsilotlar — [CONTRIBUTING.md](CONTRIBUTING.md) va [build/README.md](build/README.md).

## Litsenziya

GPL-3.0 (yoki sub-katalog README'larida ko'rsatilgan).
