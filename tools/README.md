# HackNow OS Tools

HackNow OS bilan birga keladigan maxsus CLI toollar va utilitalar.

## Toollar

| Tool | Tavsif |
|---|---|
| `hn-lab-connect` | HackNow lab muhitiga ulanish va boshqarish |
| `hn-vpn` | VPN ulanish va uzish |
| `hn-submit` | CTF flag yuborish |
| `hn-update` | OS va toollarni yangilash |
| `hn-info` | Tizim va tool ma'lumotlari |
| `hn-scope` | Pentest scope boshqarish |

## O'rnatish

```bash
sudo bash install.sh
```

Yoki maxsus prefix bilan:

```bash
sudo PREFIX=/usr/local bash install.sh
```

## Konfiguratsiya

Barcha toollar `$HOME/.config/hacknow/` papkasidan konfiguratsiya o'qiydi.

- `~/.config/hacknow/token` — API autentifikatsiya tokeni (chmod 600)
- `~/.config/hacknow/vpn/` — VPN konfiguratsiya fayllari
- `~/.hacknow-scope` — Joriy pentest scope ro'yxati (override: `$HN_SCOPE_FILE`)

## Foydalanish

```bash
# Tizimga kirish
hn-lab-connect login

# Lab ishga tushirish
hn-lab-connect start 42

# Flag yuborish
hn-submit HN{bu_sizning_flagingiz}

# VPN holati
hn-vpn status

# Tizim ma'lumotlari
hn-info
```

## Versiya

0.1.0 — dastlabki chiqarish.

---

https://hacknow.uz | t.me/hacknow_uz
