# راهنمای ساخت فایل نصبی (Installer) برای WebP Converter

## پیش‌نیازها

1. نصب Node.js و npm
2. نصب بسته‌های پروژه:
```bash
npm install
```

## مراحل ساخت فایل نصبی

### مرحله 1: آماده‌سازی آیکون

برنامه به یک فایل `icon.ico` نیاز دارد. دو روش برای ساخت آن:

#### روش اول: استفاده از ابزار آنلاین
1. یک تصویر PNG برای آیکون برنامه آماده کنید (توصیه: 256x256 پیکسل)
2. به سایت https://convertio.co/png-ico/ یا https://icoconvert.com/ بروید
3. فایل PNG را تبدیل به ICO کنید
4. فایل `icon.ico` را در ریشه پروژه کپی کنید

#### روش دوم: استفاده از ImageMagick (اگر نصب دارید)
```bash
magick convert icon.png -define icon:auto-resize=256,128,96,64,48,32,16 icon.ico
```

### مرحله 2: ساخت فایل نصبی

پس از آماده شدن آیکون، دستورات زیر را اجرا کنید:

#### ساخت فایل نصبی استاندارد (NSIS Installer)
```bash
npm run build
```

این دستور فایل نصبی با فرمت `.exe` در پوشه `dist` ایجاد می‌کند.

#### ساخت نسخه قابل حمل (Portable)
```bash
npm run build-portable
```

این نسخه بدون نیاز به نصب قابل اجرا است.

#### ساخت برای معماری‌های 32 و 64 بیتی
```bash
npm run build-all
```

## فایل‌های خروجی

پس از اجرای موفقیت‌آمیز دستور build، فایل‌های زیر در پوشه `dist` ایجاد می‌شوند:

- `WebP Converter-Setup-1.0.0.exe` - فایل نصبی
- `WebP Converter-Portable-1.0.0.exe` - نسخه portable (اگر build-portable اجرا شود)
- پوشه‌های دیگر شامل فایل‌های unpacked

## تنظیمات NSIS Installer

فایل نصبی با ویژگی‌های زیر ساخته می‌شود:

✅ قابلیت انتخاب مسیر نصب
✅ ایجاد میانبر در دسکتاپ
✅ ایجاد میانبر در منوی Start
✅ امکان حذف نصب (Uninstaller)
✅ نمایش لایسنس در هنگام نصب

## عیب‌یابی

### خطا: "Application entry file does not exist"
- اطمینان حاصل کنید که فایل `main.js` در ریشه پروژه وجود دارد

### خطا: "icon.ico not found"
- یک فایل آیکون با نام `icon.ico` در ریشه پروژه ایجاد کنید

### خطا: مشکل با ماژول Sharp
- اگر خطای مربوط به `sharp` دریافت کردید، آن را rebuild کنید:
```bash
npm rebuild sharp
```

### حجم فایل نصبی بزرگ است
- این طبیعی است چون Electron و Node.js در فایل نصبی قرار می‌گیرند
- حجم معمولاً بین 100-200 مگابایت است

## اطلاعات فنی

- **Platform**: Windows x64
- **Installer Type**: NSIS (Nullsoft Scriptable Install System)
- **Electron Version**: ^28.0.0
- **Output Directory**: `dist/`

## توزیع برنامه

پس از ساخت فایل نصبی:

1. فایل `.exe` در پوشه `dist` را تست کنید
2. می‌توانید آن را در GitHub Releases، Google Drive یا هر سرویس دیگری منتشر کنید
3. توصیه می‌شود checksum (SHA256) فایل را نیز منتشر کنید

## نکات امنیتی

- فایل نصبی با code signature امضا نشده است
- کاربران ممکن است هشدار Windows SmartScreen دریافت کنند
- برای حذف هشدار، نیاز به خرید گواهی code signing دارید

## پشتیبانی

اگر مشکلی در ساخت فایل نصبی داشتید:
1. لاگ‌های خطا را بررسی کنید
2. نسخه Node.js و npm خود را چک کنید
3. مطمئن شوید تمام dependencies نصب شده‌اند
