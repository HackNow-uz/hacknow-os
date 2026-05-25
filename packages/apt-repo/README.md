# HackNow OS APT Repository

Custom paketlar uchun APT repo.

## Foydalanish

```bash
echo "deb [signed-by=/etc/apt/keyrings/hacknow.gpg] https://apt.hacknow.uz stable main" | sudo tee /etc/apt/sources.list.d/hacknow.list
sudo apt update
```

## Repo yaratish

```bash
# GPG kalit yaratish
gpg --full-generate-key

# Repo tuzish
apt-ftparchive packages pool/ > Packages
gzip -k Packages
apt-ftparchive release . > Release
gpg --armor --sign -o Release.gpg Release
gpg --clearsign -o InRelease Release
```
