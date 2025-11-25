# 🚀 راهنمای قدم به قدم ایجاد Release (بدون نیاز به خط فرمان)

## ❌ مشکل: Git یافت نشد

اگر خطای زیر را دریافت کردید:
```
git : The term 'git' is not recognized...
```

## ✅ راه‌حل: دو روش دارید

---

## 🎯 روش 1: استفاده از GitHub Desktop (ساده‌ترین روش - بدون خط فرمان)

### مرحله 1: نصب GitHub Desktop

1. به سایت زیر بروید:
   ```
   https://desktop.github.com/
   ```

2. **Download for Windows** را کلیک کنید

3. فایل دانلود شده را نصب کنید

4. GitHub Desktop را باز کنید

5. با حساب GitHub خود وارد شوید (Sign In)

### مرحله 2: اضافه کردن Repository

1. در GitHub Desktop، روی **File** → **Add Local Repository** کلیک کنید

2. مسیر پروژه را انتخاب کنید:
   ```
   C:\Users\Legend\Desktop\webp-converter
   ```

3. اگر Repository قبلاً clone نشده، گزینه **Create Repository** را انتخاب کنید

### مرحله 3: Commit کردن تغییرات

1. در GitHub Desktop، فایل‌های تغییر یافته را می‌بینید

2. در قسمت پایین سمت چپ:
   - **Summary**: یک عنوان بنویسید مثل:
     ```
     Add release documentation and build config
     ```
   - **Description** (اختیاری): توضیحات بیشتر

3. روی دکمه آبی **Commit to main** کلیک کنید

### مرحله 4: Push کردن

1. پس از Commit، دکمه **Push origin** را می‌بینید

2. روی آن کلیک کنید تا تغییرات به GitHub ارسال شود

### مرحله 5: ایجاد Tag و Release

#### راه A: از طریق GitHub Desktop

1. در GitHub Desktop، روی **Repository** → **Create Tag** کلیک کنید

2. اطلاعات را پر کنید:
   - **Tag name**: `v1.0.0`
   - **Description**: `Release version 1.0.0`

3. روی **Create Tag** کلیک کنید

4. سپس **Push origin** را بزنید تا Tag آپلود شود

#### راه B: از طریق وب GitHub (پیشنهادی)

1. به GitHub بروید:
   ```
   https://github.com/Mahdeep/webp-converter
   ```

2. روی **Releases** کلیک کنید (سمت راست)

3. روی **Draft a new release** کلیک کنید

4. در قسمت **Choose a tag**:
   - `v1.0.0` را تایپ کنید
   - روی **Create new tag: v1.0.0 on publish** کلیک کنید

5. **Release title**: `WebP Converter v1.0.0`

6. **Description**: فایل `RELEASE_NOTES.md` را در Notepad باز کنید و محتوای آن را کپی کنید

7. **Attach files**: 
   - اگر فایل نصبی ساخته‌اید، از پوشه `dist` فایل `.exe` را drag & drop کنید
   - اگر هنوز ندارید، می‌توانید بدون فایل منتشر کنید و بعداً اضافه کنید

8. روی **Publish release** کلیک کنید

✅ **تمام!** Release شما منتشر شد!

---

## 🎯 روش 2: نصب Git (اگر می‌خواهید از خط فرمان استفاده کنید)

### مرحله 1: دانلود و نصب Git

1. به سایت زیر بروید:
   ```
   https://git-scm.com/download/win
   ```

2. فایل نصبی را دانلود کنید (معمولاً دانلود خودکار شروع می‌شود)

3. فایل را اجرا کنید

4. در مراحل نصب:
   - **Select Components**: همه گزینه‌ها را فعال نگه دارید
   - **Choosing the default editor**: هر editor که می‌خواهید (پیش‌فرض: Vim)
   - **Adjusting your PATH**: گزینه دوم را انتخاب کنید: **"Git from the command line and also from 3rd-party software"**
   - بقیه گزینه‌ها را پیش‌فرض نگه دارید

5. روی **Install** کلیک کنید

### مرحله 2: Restart PowerShell

1. PowerShell/Terminal فعلی را ببندید

2. یک PowerShell جدید باز کنید

3. تست کنید:
   ```powershell
   git --version
   ```
   
   باید نسخه Git را نشان دهد (مثلاً `git version 2.43.0`)

### مرحله 3: تنظیمات اولیه Git

```powershell
# نام خود را تنظیم کنید
git config --global user.name "نام شما"

# ایمیل GitHub خود را تنظیم کنید
git config --global user.email "your-email@example.com"
```

### مرحله 4: اجرای دستورات Release

حالا می‌توانید دستورات راهنما را اجرا کنید:

```powershell
# اضافه کردن فایل‌ها
git add .

# Commit
git commit -m "feat: add release documentation and build config"

# Push
git push origin main

# ایجاد Tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push Tag
git push origin v1.0.0
```

سپس از وب GitHub Release را ایجاد کنید (مطابق راهنمای بالا).

---

## 📋 خلاصه: بهترین روش برای شما

### اگر Git تجربه ندارید → استفاده از GitHub Desktop

**مزایا:**
- ✅ رابط گرافیکی
- ✅ نیازی به یادگیری دستورات نیست
- ✅ آسان و سریع
- ✅ دیداری و قابل فهم

**دانلود:** https://desktop.github.com/

### اگر می‌خواهید دستورات یاد بگیرید → نصب Git

**مزایا:**
- ✅ قدرتمندتر
- ✅ اسکریپت‌نویسی
- ✅ استفاده در CI/CD
- ✅ مهارت حرفه‌ای

**دانلود:** https://git-scm.com/download/win

---

## 🎬 ویدیوهای آموزشی (فارسی)

برای آشنایی بیشتر با Git و GitHub:

- جستجو در YouTube: "آموزش Git فارسی"
- جستجو در YouTube: "آموزش GitHub Desktop فارسی"

---

## ❓ سوالات متداول

### Q: آیا باید حتماً Git نصب کنم؟
**A:** خیر! می‌توانید از GitHub Desktop استفاده کنید یا مستقیماً از وب GitHub کار کنید.

### Q: آیا می‌توانم فایل‌ها را مستقیماً در GitHub آپلود کنم؟
**A:** بله! می‌توانید از رابط وب GitHub استفاده کنید:
1. به repository بروید
2. روی **Add file** → **Upload files** کلیک کنید
3. فایل‌ها را drag & drop کنید
4. Commit کنید

### Q: اگر Repository را clone نکرده‌ام چه کنم؟
**A:** دو حالت دارد:

**حالت 1: Repository در GitHub وجود دارد**
1. در GitHub Desktop: **File** → **Clone Repository**
2. Repository را انتخاب کنید
3. Clone کنید
4. فایل‌های پروژه را به پوشه clone شده کپی کنید

**حالت 2: Repository جدید است**
1. فایل‌های پروژه را در GitHub Desktop به عنوان Local Repository اضافه کنید
2. Publish کنید

---

## 🆘 کمک بیشتر

اگر باز هم مشکلی دارید:

1. **GitHub Documentation**: https://docs.github.com/
2. **GitHub Desktop Help**: https://docs.github.com/en/desktop
3. **Git Documentation**: https://git-scm.com/doc

---

**موفق باشید! 🚀**
