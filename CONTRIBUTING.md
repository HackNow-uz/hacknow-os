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

## Qaysi repoga hissa qo'shish kerak?

| Nima qilmoqchisiz? | Repo |
|---------------------|------|
| Yangi tool qo'shish | `hacknow-os-packages` |
| Maxsus tool yozish | `hacknow-os-tools` |
| ISO build tuzatish | `hacknow-os-build` |
| Dizayn/wallpaper | `hacknow-os-branding` |
| Installer tuzatish | `hacknow-os-installer` |
| Hujjat yozish | `hacknow-os-docs` |
| Roadmap/umumiy | `hacknow-os` (shu repo) |

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
# Barcha repolarni clone qilish
for repo in hacknow-os-build hacknow-os-packages hacknow-os-tools hacknow-os-branding hacknow-os-installer; do
  git clone https://github.com/HackNow-uz/$repo.git
done

# ISO yaratish (Debian live-build kerak)
cd hacknow-os-build
sudo lb build
```

## Aloqa

- **Telegram:** [t.me/hacknow_uz](https://t.me/hacknow_uz)
- **GitHub Discussions:** Issues bo'limida
- **Email:** hacknow.uz@gmail.com
