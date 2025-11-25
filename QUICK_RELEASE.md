# 🚀 راهنمای سریع ایجاد Release

## دستورات کلیدی

### 1️⃣ Commit و Push تغییرات

```bash
git add .
git commit -m "chore: prepare for release v1.0.0"
git push origin main
```

### 2️⃣ ایجاد Tag

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

### 3️⃣ ساخت فایل نصبی

```bash
npm run build
```

یا دابل‌کلیک روی `build.bat`

### 4️⃣ محاسبه Checksum

```powershell
Get-FileHash "dist\WebP Converter-Setup-1.0.0.exe" -Algorithm SHA256
```

### 5️⃣ ایجاد Release در GitHub

1. برو به: https://github.com/Mahdeep/webp-converter/releases/new
2. Tag: `v1.0.0` را انتخاب کن
3. Title: `WebP Converter v1.0.0`
4. Description: محتوای `RELEASE_NOTES.md` را کپی کن
5. فایل `WebP Converter-Setup-1.0.0.exe` را از پوشه `dist` آپلود کن
6. Checksum را اضافه کن
7. کلیک روی "Publish release"

---

## 🎯 استفاده از اسکریپت خودکار

**ساده‌ترین روش:**

```powershell
.\create-release.ps1
```

این اسکریپت تمام مراحل بالا را خودکار انجام می‌دهد!

---

## 📋 Checklist

قبل از انتشار Release:

- [ ] تمام تغییرات commit شده‌اند
- [ ] فایل‌های مستندات به‌روز هستند
- [ ] نسخه در `package.json` درست است
- [ ] فایل نصبی ساخته و تست شده
- [ ] Checksum محاسبه شده
- [ ] Release Notes آماده است

---

برای جزئیات بیشتر: `GITHUB_RELEASE_GUIDE.md`
