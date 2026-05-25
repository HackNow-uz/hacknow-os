# HackNow OS — Paketlar va Toolset

HackNow OS uchun pentesting toollar boshqaruvi.

## Struktura

```
toolsets/          — Kategoriya bo'yicha tool ro'yxatlari
packages/          — Custom .deb paketlar
scripts/           — Tool o'rnatish skriptlari
apt-repo/          — APT repository konfiguratsiyasi
```

## Tool qo'shish

1. `toolsets/` ichidagi tegishli kategoriya fayliga tool nomini qo'shing
2. Agar tool Debian repo'da bo'lmasa, `scripts/` ga o'rnatish skriptini yozing
3. PR yuboring
