# تطبيق إدارة المديونيات 📱

تطبيق أندرويد لإدارة المديونيات والسدادات مع إمكانية استيراد الأسماء من جهات الاتصال.

## المتطلبات 🛠️

قبل البدء في بناء التطبيق، تأكد من تثبيت:

1. **Node.js** (النسخة 14 أو أحدث)
   - تحميل من: https://nodejs.org/

2. **Java Development Kit (JDK)** (النسخة 11 أو 17)
   - تحميل من: https://www.oracle.com/java/technologies/downloads/

3. **Android Studio**
   - تحميل من: https://developer.android.com/studio
   - بعد التثبيت، افتح Android Studio وقم بتثبيت:
     - Android SDK
     - Android SDK Platform-Tools
     - Android SDK Build-Tools
     - Android Emulator (اختياري للتجربة)

4. **Gradle**
   - سيتم تثبيته تلقائياً مع Android Studio

## إعداد متغيرات البيئة 🌐

### في Windows:

1. افتح "System Properties" → "Advanced" → "Environment Variables"

2. أضف المتغيرات التالية:

```
JAVA_HOME = C:\Program Files\Java\jdk-17
ANDROID_HOME = C:\Users\<YourUsername>\AppData\Local\Android\Sdk
```

3. أضف إلى متغير `Path`:
```
%JAVA_HOME%\bin
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
%ANDROID_HOME%\build-tools\<version>
```

4. أعد تشغيل الكمبيوتر أو أغلق وافتح موجه الأوامر.

## خطوات بناء التطبيق (Build) خطوة بخطوة 🚀

### 1️⃣ تثبيت Cordova

افتح PowerShell أو Command Prompt في مجلد المشروع واكتب:

```bash
npm install -g cordova
```

### 2️⃣ تثبيت اعتماديات المشروع

```bash
npm install
```

### 3️⃣ إنشاء مشروع Cordova

```bash
cordova create temp com.mdiyoniyat.app "إدارة مديونيات"
```

### 4️⃣ نسخ الملفات إلى مجلد www

```bash
# في PowerShell
Remove-Item -Recurse -Force temp\www\*
Copy-Item index.html, app.js, style.css, شعار.png temp\www\

# نسخ ملف config.xml
Copy-Item config.xml temp\
```

### 5️⃣ الانتقال إلى مجلد المشروع

```bash
cd temp
```

### 6️⃣ إضافة منصة Android

```bash
cordova platform add android
```

### 7️⃣ إضافة Plugin جهات الاتصال

```bash
cordova plugin add cordova-plugin-contacts
```

### 8️⃣ بناء التطبيق (Debug Version)

```bash
cordova build android
```

ستجد ملف APK في:
```
temp\platforms\android\app\build\outputs\apk\debug\app-debug.apk
```

### 9️⃣ بناء نسخة Release (للنشر)

```bash
cordova build android --release
```

## توقيع التطبيق (للنشر على Google Play) 🔐

### إنشاء مفتاح التوقيع:

```bash
keytool -genkey -v -keystore mdiyoniyat.keystore -alias mdiyoniyat -keyalg RSA -keysize 2048 -validity 10000
```

### توقيع الـ APK:

1. أنشئ ملف `build.json` في مجلد `temp`:

```json
{
  "android": {
    "release": {
      "keystore": "../mdiyoniyat.keystore",
      "storePassword": "كلمة_السر_هنا",
      "alias": "mdiyoniyat",
      "password": "كلمة_السر_هنا"
    }
  }
}
```

2. قم بالبناء مع التوقيع:

```bash
cordova build android --release --buildConfig=build.json
```

ستجد ملف APK الموقّع في:
```
temp\platforms\android\app\build\outputs\apk\release\app-release.apk
```

## تثبيت التطبيق على الهاتف 📲

### عبر USB:

1. فعّل "خيارات المطور" و "تصحيح USB" على هاتفك
2. وصّل الهاتف بالكمبيوتر
3. نفذ:

```bash
cordova run android
```

### عبر ملف APK:

1. انسخ ملف APK إلى هاتفك
2. افتح الملف من متصفح الملفات
3. اسمح بالتثبيت من مصادر غير معروفة
4. اضغط "تثبيت"

## اختبار على المحاكي (Emulator) 🖥️

```bash
# إنشاء محاكي من Android Studio أو:
cordova run android --emulator
```

## الميزات ✨

- ✅ استيراد أسماء من جهات الاتصال
- ✅ تسجيل المديونيات مع التاريخ
- ✅ تسجيل السدادات
- ✅ عرض سجل كامل للمعاملات
- ✅ حساب الرصيد النهائي لكل شخص
- ✅ إجمالي المديونيات العام
- ✅ تخزين محلي (LocalStorage)
- ✅ واجهة عربية متجاوبة

## الأذونات المطلوبة 🔒

- **READ_CONTACTS**: لاستيراد الأسماء من جهات الاتصال

## استكشاف الأخطاء 🔧

### خطأ في ANDROID_HOME:
```bash
# تأكد من تعيين المتغير بشكل صحيح:
echo $env:ANDROID_HOME  # PowerShell
echo %ANDROID_HOME%     # CMD
```

### خطأ في Gradle:
- افتح Android Studio واذهب إلى File → Settings → Build Tools → Gradle
- تأكد من استخدام Gradle wrapper

### خطأ في تثبيت Plugin:
```bash
# احذف وأعد إضافة:
cordova plugin remove cordova-plugin-contacts
cordova plugin add cordova-plugin-contacts
```

## التحديثات المستقبلية 🔮

- [ ] تصدير البيانات إلى Excel
- [ ] إشعارات للمديونيات المتأخرة
- [ ] رسوم بيانية للإحصائيات
- [ ] نسخ احتياطي سحابي

## الدعم 💬

للمساعدة أو الإبلاغ عن مشكلة، يرجى فتح Issue على GitHub.

---

**تم التطوير بـ ❤️ للمجتمع العربي**
