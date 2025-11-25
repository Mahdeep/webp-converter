@echo off
chcp 65001 >nul
echo ╔════════════════════════════════════════════════════════════╗
echo ║        WebP Converter - Build Script                      ║
echo ║        ساخت فایل نصبی برای ویندوز                         ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM بررسی وجود Node.js
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ خطا: Node.js یافت نشد. لطفاً ابتدا Node.js را نصب کنید.
    echo    دانلود از: https://nodejs.org/
    pause
    exit /b 1
)

echo ✓ Node.js یافت شد
node --version
echo.

REM بررسی وجود npm
where npm >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ خطا: npm یافت نشد.
    pause
    exit /b 1
)

echo ✓ npm یافت شد
npm --version
echo.

REM بررسی وجود node_modules
if not exist "node_modules" (
    echo 📦 نصب وابستگی‌ها...
    call npm install
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ خطا در نصب وابستگی‌ها
        pause
        exit /b 1
    )
    echo.
)

REM بررسی وجود آیکون
if not exist "icon.ico" (
    echo.
    echo ⚠️  هشدار: فایل icon.ico یافت نشد
    echo.
    echo برای ساخت آیکون، یکی از روش‌های زیر را انتخاب کنید:
    echo.
    echo 1. استفاده از ابزار آنلاین:
    echo    - به https://convertio.co/png-ico/ بروید
    echo    - یک تصویر PNG را تبدیل به ICO کنید
    echo    - فایل icon.ico را در این پوشه کپی کنید
    echo.
    echo 2. استفاده از فایل SVG موجود:
    echo    - فایل icon.svg را به PNG تبدیل کنید
    echo    - سپس PNG را به ICO تبدیل کنید
    echo.
    choice /C YN /M "آیا می‌خواهید بدون آیکون ادامه دهید؟ (Y=بله, N=خیر)"
    if errorlevel 2 (
        echo.
        echo ساخت فایل نصبی لغو شد.
        pause
        exit /b 0
    )
    echo.
    echo ⚠️  ادامه بدون آیکون...
    echo.
)

echo ══════════════════════════════════════════════════════════════
echo.
echo 🔨 شروع ساخت فایل نصبی...
echo.
echo این فرآیند ممکن است چند دقیقه طول بکشد.
echo لطفاً صبر کنید...
echo.
echo ══════════════════════════════════════════════════════════════
echo.

REM ساخت فایل نصبی
call npm run build

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ خطا در ساخت فایل نصبی
    echo.
    echo راه‌حل‌های پیشنهادی:
    echo 1. مطمئن شوید تمام فایل‌های پروژه موجود هستند
    echo 2. دستور npm install را مجدداً اجرا کنید
    echo 3. فایل package.json را بررسی کنید
    echo 4. لاگ خطا را به دقت بخوانید
    echo.
    pause
    exit /b 1
)

echo.
echo ══════════════════════════════════════════════════════════════
echo.
echo ✅ ساخت فایل نصبی با موفقیت انجام شد!
echo.
echo 📁 فایل‌های خروجی در پوشه dist قرار دارند:
echo.

if exist "dist" (
    dir /B "dist\*.exe" 2>nul
    echo.
    echo ══════════════════════════════════════════════════════════════
    echo.
    echo 📊 اطلاعات فایل:
    echo.
    for %%F in (dist\*.exe) do (
        echo    نام فایل: %%~nxF
        echo    حجم: %%~zF بایت
        echo.
    )
) else (
    echo ⚠️  پوشه dist یافت نشد!
    echo.
)

echo ══════════════════════════════════════════════════════════════
echo.
echo 🎉 مراحل بعدی:
echo.
echo 1. فایل نصبی را از پوشه dist اجرا و تست کنید
echo 2. برنامه را بر روی سیستم‌های مختلف امتحان کنید
echo 3. در صورت رضایت، فایل را منتشر کنید
echo.
echo 💡 نکته: کاربران ممکن است هشدار Windows SmartScreen دریافت کنند
echo    چون فایل با گواهی دیجیتال امضا نشده است.
echo.
echo ══════════════════════════════════════════════════════════════
echo.

pause
