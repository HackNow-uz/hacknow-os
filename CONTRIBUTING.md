# Hissa qo'shish qo'llanmasi

HackNow OS loyihasiga hissa qo'shmoqchimisiz? Ajoyib! Quyidagi qoidalarga rioya qiling.

## Umumiy qoidalar

1. **O'zbek tilida yozing** — hujjatlar, UI matnlari, commit xabarlari o'zbek tilida bo'lsin
2. **Kichik PR'lar** — bitta PR bitta narsa qilsin
3. **Test qiling** — o'zgarishlaringiz ISO build'ni buzmayotganini tekshiring
4. **Issue oching** — katta o'zgarishlardan oldin issue ochib muhokama qiling

## Branch strategiyasi

```
main          — barqaror reliz
develop       — rivojlanish branchi
feature/*     — yangi funksiyalar
fix/*         — tuzatishlar
release/*     — relizga tayyorgarlik
```

## Qaysi katalogga hissa qo'shish kerak?

Monorepo strukturasida hammasi shu repo ichida:

| Nima qilmoqchisiz? | Katalog (yoki alohida repo) |
|---------------------|-----------------------------|
| Yangi tool qo'shish | `packages/` |
| Maxsus skript yozish | `tools/` |
| ISO build tuzatish | `build/` |
| Dizayn/wallpaper/GRUB | `branding/` |
| Installer (Calamares) tuzatish | `installer/` |
| Foydalanuvchi hujjati | [hacknow-os-docs](https://github.com/HackNow-uz/hacknow-os-docs) (alohida repo) |
| Sayt (os.hacknow.uz) | [hacknow-os-web](https://github.com/HackNow-uz/hacknow-os-web) (alohida repo) |

## Commit xabarlari

```
<tur>(<scope>): qisqa tavsif

Batafsil izoh (ixtiyoriy)
```

Turlar: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `ci`, `chore`

Misollar:
```
feat(packages): nmap va masscan qo'shildi
fix(build): live-build XFCE session xatosi tuzatildi
docs(readme): tool ro'yxati yangilandi
```

## Mahalliy build

```bash
# Monorepo'ni clone qilish
git clone https://github.com/HackNow-uz/hacknow-os.git
cd hacknow-os/build

# ISO yaratish (Debian live-build kerak)
sudo bash build.sh all

# Yoki Docker orqali (host'da lb o'rnatilmagan bo'lsa):
bash docker-build.sh
```

## Aloqa

- **Telegram:** [t.me/hacknow_uz](https://t.me/hacknow_uz)
- **GitHub Discussions:** Issues bo'limida
- **Email:** hacknow.uz@gmail.com
