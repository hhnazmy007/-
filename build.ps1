# سكريبت بناء تطبيق إدارة المديونيات
# PowerShell Build Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   بناء تطبيق إدارة المديونيات" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# التحقق من تثبيت Node.js
Write-Host "[فحص] التحقق من Node.js..." -ForegroundColor Yellow
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[خطأ] Node.js غير مثبت!" -ForegroundColor Red
    Write-Host "يرجى تحميله من: https://nodejs.org/" -ForegroundColor White
    Read-Host "اضغط Enter للخروج"
    exit 1
}
$nodeVersion = node --version
Write-Host "[✓] Node.js مثبت: $nodeVersion" -ForegroundColor Green

# التحقق من تثبيت Cordova
Write-Host "[فحص] التحقق من Cordova..." -ForegroundColor Yellow
if (-not (Get-Command cordova -ErrorAction SilentlyContinue)) {
    if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
        Write-Host "[تثبيت] تثبيت Cordova عالمياً..." -ForegroundColor Yellow
        npm install -g cordova
    }
}
Write-Host "[✓] Cordova جاهز" -ForegroundColor Green

# التحقق من Android SDK
Write-Host "[فحص] التحقق من Android SDK..." -ForegroundColor Yellow
if (-not $env:ANDROID_HOME) {
    Write-Host "[تحذير] ANDROID_HOME غير معرّف!" -ForegroundColor Yellow
    Write-Host "يرجى تثبيت Android Studio وتعريف ANDROID_HOME" -ForegroundColor White
    Write-Host "راجع ملف 'دليل-البناء.md' للتفاصيل" -ForegroundColor Cyan
    $continue = Read-Host "هل تريد المتابعة؟ (y/n)"
    if ($continue -ne 'y') {
        exit 1
    }
} else {
    Write-Host "[✓] ANDROID_HOME: $env:ANDROID_HOME" -ForegroundColor Green
}

Write-Host ""
Write-Host "[1/6] نسخ الملفات إلى www..." -ForegroundColor Yellow
if (Test-Path www) {
    Remove-Item www -Recurse -Force
}
New-Item -ItemType Directory -Force -Path www | Out-Null
Copy-Item index.html, app.js, style.css, "شعار.png" -Destination www\ -Force
Write-Host "[✓] تم نسخ الملفات" -ForegroundColor Green

Write-Host ""
Write-Host "[2/6] التحقق من المنصات..." -ForegroundColor Yellow
$platformsExist = Test-Path "platforms\android"
if (-not $platformsExist) {
    Write-Host "[تثبيت] إضافة منصة Android..." -ForegroundColor Yellow
    npx cordova platform add android
    Write-Host "[✓] تم إضافة منصة Android" -ForegroundColor Green
} else {
    Write-Host "[✓] منصة Android موجودة" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/6] تحديث الإضافات..." -ForegroundColor Yellow
npx cordova prepare android
Write-Host "[✓] تم تحديث الإضافات" -ForegroundColor Green

Write-Host ""
Write-Host "[4/6] بناء نسخة Debug..." -ForegroundColor Yellow
npx cordova build android --debug
if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] تم بناء نسخة Debug بنجاح" -ForegroundColor Green
} else {
    Write-Host "[خطأ] فشل بناء نسخة Debug" -ForegroundColor Red
    Write-Host "راجع الأخطاء أعلاه" -ForegroundColor White
    Read-Host "اضغط Enter للخروج"
    exit 1
}

Write-Host ""
Write-Host "[5/6] بناء نسخة Release..." -ForegroundColor Yellow
npx cordova build android --release
if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] تم بناء نسخة Release بنجاح" -ForegroundColor Green
} else {
    Write-Host "[تحذير] فشل بناء نسخة Release (قد يكون طبيعياً)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   اكتمل البناء بنجاح!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# عرض مواقع الملفات
$debugApk = "platforms\android\app\build\outputs\apk\debug\app-debug.apk"
$releaseApk = "platforms\android\app\build\outputs\apk\release\app-release-unsigned.apk"

if (Test-Path $debugApk) {
    $debugSize = [math]::Round((Get-Item $debugApk).Length / 1MB, 2)
    Write-Host "[ملف Debug APK]" -ForegroundColor Green
    Write-Host "المسار: $(Resolve-Path $debugApk)" -ForegroundColor White
    Write-Host "الحجم: $debugSize MB" -ForegroundColor White
    Write-Host ""
}

if (Test-Path $releaseApk) {
    $releaseSize = [math]::Round((Get-Item $releaseApk).Length / 1MB, 2)
    Write-Host "[ملف Release APK]" -ForegroundColor Green
    Write-Host "المسار: $(Resolve-Path $releaseApk)" -ForegroundColor White
    Write-Host "الحجم: $releaseSize MB" -ForegroundColor White
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "للتثبيت على الهاتف:" -ForegroundColor Cyan
Write-Host "1. انسخ ملف app-debug.apk إلى هاتفك" -ForegroundColor White
Write-Host "2. افتحه من مدير الملفات" -ForegroundColor White
Write-Host "3. اسمح بتثبيت التطبيقات من مصادر غير معروفة" -ForegroundColor White
Write-Host ""

Read-Host "اضغط Enter للخروج"
