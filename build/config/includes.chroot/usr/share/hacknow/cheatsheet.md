# HackNow OS — Cheatsheet

## Tezkor klavishlar (Keyboard Shortcuts)

| Klavish | Vazifa |
|---------|--------|
| `Super + Enter` | Terminal |
| `Super + D` | Ilovalar menyusi (Rofi) |
| `Super + R` | Buyruq ishga tushirish |
| `Super + W` | Ochiq oynalar |
| `Super + E` | Fayl menejeri (Thunar) |
| `Super + B` | Browser (Firefox) |
| `Super + L` | Ekranni qulflash |
| `Super + 1-4` | Workspace almashish |
| `Super + ↑/↓/←/→` | Oynani tile qilish |
| `Alt + F4` | Oynani yopish |
| `Alt + Tab` | Oynalar orasida |
| `Print` | Screenshot |
| `Ctrl + Alt + T` | Terminal (alternative) |

## HackNow CLI Toollar

| Buyruq | Vazifa |
|--------|--------|
| `hn-info` | Tizim ma'lumotlari |
| `hn-lab-connect login` | HackNow hisobiga kirish |
| `hn-lab-connect start <id>` | Lab ishga tushirish |
| `hn-vpn connect` | VPN ulanish |
| `hn-submit HN{flag}` | CTF flag yuborish |
| `hn-update --all` | Hammasini yangilash |
| `hn-scope add <ip>` | Pentest target qo'shish |
| `hn-decode <string>` | Base64/Hex/URL/ROT13 dekod |
| `hn-hash - < file` | MD5/SHA/NTLM hash hisoblash |
| `hn-listen [port]` | Netcat listener + log |
| `hn-note [target]` | Pentest hisoboti yaratish |
| `hn-screenshot` | Screenshot olish |
| `hn-record` | Ekran yozib olish |

## Pentesting aliases

| Alias | Buyruq |
|-------|--------|
| `scan` | `nmap -sC -sV` |
| `quickscan` | `nmap -T4 -F` |
| `fullscan` | `nmap -sC -sV -p-` |
| `serve` | `python3 -m http.server 8080` |
| `myip` | Tashqi IP |
| `localip` | Mahalliy IP |
| `ports` | Ochiq portlar |
| `setip <ip>` | TARGET o'zgaruvchini saqlash |

## Wordlists

- `/usr/share/seclists/` — SecLists (agar o'rnatilgan)
- `/usr/share/wordlists/` — Symlink to SecLists
- `/usr/share/dirb/wordlists/` — Dirb wordlists
- `/usr/share/wfuzz/` — Wfuzz wordlists

## Default credentials

- User: `hacknow` / Parol: `hacknow`
- SSH default: **OFF** (yoqish: `sudo systemctl start ssh`)
- Sudo: NOPASSWD (live mode)

> **MUHIM:** O'rnatishdan keyin parolni o'zgartiring: `passwd`
