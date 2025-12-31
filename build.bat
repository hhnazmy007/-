@echo off
echo ========================================
echo    بناء تطبيق إدارة المديونيات
echo ========================================
echo.

REM التحقق من تثبيت Node.js
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [خطأ] Node.js غير مثبت!
    echo يرجى تحميله من: https://nodejs.org/
    pause
    exit /b 1
)

REM التحقق من تثبيت Cordova
where cordova >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [تثبيت] تثبيت Cordova...
    call npm install -g cordova
)

echo [1/8] إنشاء مجلد مشروع Cordova...
if exist temp rmdir /s /q temp
call cordova create temp com.mdiyoniyat.app "إدارة مديونيات"

echo [2/8] نسخ ملفات المشروع...
del /q temp\www\*.*
copy /y index.html temp\www\
copy /y app.js temp\www\
copy /y style.css temp\www\
copy /y شعار.png temp\www\
copy /y config.xml temp\

echo [3/8] الانتقال إلى مجلد المشروع...
cd temp

echo [4/8] إضافة منصة Android...
call cordova platform add android

echo [5/8] إضافة plugin جهات الاتصال...
call cordova plugin add cordova-plugin-contacts

echo [6/8] بناء التطبيق (Debug)...
call cordova build android

echo [7/8] بناء التطبيق (Release - غير موقّع)...
call cordova build android --release

echo [8/8] اكتمل البناء!
echo.
echo ========================================
echo    ملفات APK الجاهزة:
echo ========================================
echo.
echo Debug APK:
echo %cd%\platforms\android\app\build\outputs\apk\debug\app-debug.apk
echo.
echo Release APK (غير موقّع):
echo %cd%\platforms\android\app\build\outputs\apk\release\app-release-unsigned.apk
echo.
echo ========================================

cd ..
echo.
echo يمكنك الآن نقل ملف app-debug.apk إلى هاتفك وتثبيته!
echo.
pause
