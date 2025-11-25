# WebP Converter - Release Script
# این اسکریپت فرآیند ساخت Release را خودکار می‌کند

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     WebP Converter - GitHub Release Creator               ║" -ForegroundColor Cyan
Write-Host "║     ساخت خودکار Release برای GitHub                      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# خواندن نسخه فعلی از package.json
$packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
$version = $packageJson.version
$tagName = "v$version"

Write-Host "📌 نسخه فعلی: $version" -ForegroundColor Green
Write-Host "🏷️  Tag: $tagName" -ForegroundColor Green
Write-Host ""

# بررسی وجود git
try {
    $null = git --version
} catch {
    Write-Host "❌ خطا: Git یافت نشد. لطفاً Git را نصب کنید." -ForegroundColor Red
    Write-Host "   دانلود از: https://git-scm.com/download/win" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "✓ Git یافت شد" -ForegroundColor Green
Write-Host ""

# بررسی وجود تغییرات uncommitted
$status = git status --porcelain
if ($status) {
    Write-Host "⚠️  تغییرات commit نشده وجود دارد:" -ForegroundColor Yellow
    Write-Host $status -ForegroundColor Gray
    Write-Host ""
    
    $response = Read-Host "آیا می‌خواهید تمام تغییرات را commit کنید؟ (Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        Write-Host ""
        Write-Host "📝 نوشتن پیام commit..." -ForegroundColor Cyan
        $commitMsg = Read-Host "پیام commit (Enter برای پیش‌فرض)"
        
        if ([string]::IsNullOrWhiteSpace($commitMsg)) {
            $commitMsg = "chore: prepare for release v$version"
        }
        
        Write-Host ""
        Write-Host "➕ اضافه کردن فایل‌ها..." -ForegroundColor Cyan
        git add .
        
        Write-Host "💾 Commit تغییرات..." -ForegroundColor Cyan
        git commit -m $commitMsg
        
        Write-Host "✓ Commit انجام شد" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# بررسی وجود tag
$existingTag = git tag -l $tagName
if ($existingTag) {
    Write-Host "⚠️  Tag $tagName قبلاً وجود دارد" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "آیا می‌خواهید tag قدیمی را حذف و دوباره ایجاد کنید؟ (Y/N)"
    
    if ($response -eq "Y" -or $response -eq "y") {
        Write-Host ""
        Write-Host "🗑️  حذف tag قدیمی از local..." -ForegroundColor Yellow
        git tag -d $tagName
        
        Write-Host "🗑️  حذف tag قدیمی از remote..." -ForegroundColor Yellow
        try {
            git push origin :refs/tags/$tagName 2>$null
        } catch {
            Write-Host "   (tag در remote وجود نداشت)" -ForegroundColor Gray
        }
        
        Write-Host "✓ Tag قدیمی حذف شد" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "❌ فرآیند لغو شد" -ForegroundColor Red
        pause
        exit 0
    }
}

Write-Host ""
Write-Host "🏷️  ایجاد Git Tag..." -ForegroundColor Cyan
$tagMessage = "Release version $version"
git tag -a $tagName -m $tagMessage

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Tag ایجاد شد" -ForegroundColor Green
} else {
    Write-Host "❌ خطا در ایجاد tag" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Push کردن
Write-Host "📤 Push کردن تغییرات و tag به GitHub..." -ForegroundColor Cyan
Write-Host ""

$response = Read-Host "آیا می‌خواهید تغییرات را به GitHub push کنید؟ (Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    Write-Host ""
    Write-Host "📤 Push کردن commits..." -ForegroundColor Cyan
    git push origin main
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  خطا در push کردن commits" -ForegroundColor Yellow
        Write-Host "   شاید branch دیگری active است؟" -ForegroundColor Gray
        
        $currentBranch = git branch --show-current
        Write-Host "   Branch فعلی: $currentBranch" -ForegroundColor Gray
        
        $response2 = Read-Host "آیا می‌خواهید branch فعلی را push کنید؟ (Y/N)"
        if ($response2 -eq "Y" -or $response2 -eq "y") {
            git push origin $currentBranch
        }
    }
    
    Write-Host "📤 Push کردن tag..." -ForegroundColor Cyan
    git push origin $tagName
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Push به GitHub موفق بود" -ForegroundColor Green
    } else {
        Write-Host "❌ خطا در push کردن tag" -ForegroundColor Red
        pause
        exit 1
    }
}

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# ساخت فایل نصبی
Write-Host "🔨 آیا می‌خواهید فایل نصبی را الان بسازید؟" -ForegroundColor Cyan
$response = Read-Host "(Y/N)"

if ($response -eq "Y" -or $response -eq "y") {
    Write-Host ""
    Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🔨 ساخت فایل نصبی..." -ForegroundColor Cyan
    Write-Host "   این ممکن است چند دقیقه طول بکشد..." -ForegroundColor Gray
    Write-Host ""
    
    # بررسی وجود npm
    try {
        $null = npm --version
        
        # اجرای build
        npm run build
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✓ ساخت فایل نصبی موفق بود" -ForegroundColor Green
            Write-Host ""
            
            # نمایش فایل‌های خروجی
            if (Test-Path "dist") {
                Write-Host "📁 فایل‌های خروجی:" -ForegroundColor Cyan
                Get-ChildItem "dist\*.exe" | ForEach-Object {
                    $size = [math]::Round($_.Length / 1MB, 2)
                    Write-Host "   📦 $($_.Name) - $size MB" -ForegroundColor Green
                }
                
                Write-Host ""
                
                # محاسبه checksum
                Write-Host "🔐 محاسبه Checksum (SHA256)..." -ForegroundColor Cyan
                Write-Host ""
                
                Get-ChildItem "dist\*.exe" | ForEach-Object {
                    $hash = Get-FileHash $_.FullName -Algorithm SHA256
                    Write-Host "   فایل: $($_.Name)" -ForegroundColor Yellow
                    Write-Host "   SHA256: $($hash.Hash)" -ForegroundColor Gray
                    Write-Host ""
                }
            }
        } else {
            Write-Host "❌ خطا در ساخت فایل نصبی" -ForegroundColor Red
            Write-Host "   لطفاً لاگ بالا را بررسی کنید" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️  npm یافت نشد" -ForegroundColor Yellow
        Write-Host "   می‌توانید بعداً دستور 'npm run build' را اجرا کنید" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ فرآیند آماده‌سازی Release تکمیل شد!" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 مراحل بعدی:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. به GitHub بروید:" -ForegroundColor White
Write-Host "   https://github.com/Mahdeep/webp-converter/releases/new" -ForegroundColor Blue
Write-Host ""
Write-Host "2. تنظیمات Release:" -ForegroundColor White
Write-Host "   - Tag: $tagName" -ForegroundColor Gray
Write-Host "   - Title: WebP Converter v$version" -ForegroundColor Gray
Write-Host "   - فایل نصبی را از پوشه dist آپلود کنید" -ForegroundColor Gray
Write-Host ""
Write-Host "3. برای راهنمای کامل:" -ForegroundColor White
Write-Host "   📖 GITHUB_RELEASE_GUIDE.md را مطالعه کنید" -ForegroundColor Gray
Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# باز کردن مرورگر (اختیاری)
$response = Read-Host "آیا می‌خواهید صفحه GitHub Release در مرورگر باز شود؟ (Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    $url = "https://github.com/Mahdeep/webp-converter/releases/new?tag=$tagName"
    Start-Process $url
    Write-Host ""
    Write-Host "✓ مرورگر باز شد" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 موفق باشید!" -ForegroundColor Green
Write-Host ""
pause
