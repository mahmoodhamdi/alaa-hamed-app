# خطة إصلاح مشاكل الأمان

## المشكلة الأولى: Access Token بدون تشفير

### الوضع الحالي:
- الـ Access Token يتم تخزينه في الـ state فقط
- عند إغلاق التطبيق يضيع الـ token
- لا يوجد تشفير

### الحل:
استخدام `flutter_secure_storage` لتخزين الـ tokens بشكل آمن ومشفر

### خطوات التنفيذ:

#### 1. إضافة الـ dependency
```yaml
# pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.2.2
```

#### 2. إنشاء SecureStorageService
```
lib/core/services/secure_storage_service.dart
```
- حفظ الـ access token
- جلب الـ access token
- حذف الـ token (logout)
- التحقق من وجود token

#### 3. تحديث AuthCubit
- استخدام SecureStorageService بدلاً من حفظ في الـ state فقط
- جلب الـ token عند بدء التطبيق
- حفظ الـ token بعد تسجيل الدخول بنجاح

#### 4. تحديث Service Locator
- تسجيل SecureStorageService

#### 5. إضافة الاختبارات
- Unit tests للـ SecureStorageService
- تحديث auth tests

---

## المشكلة الثانية: API Key غير محمي

### الوضع الحالي:
- الـ API Key موجود في ملف `.env`
- يمكن استخراجه من الـ APK بسهولة

### الحل المثالي:
إنشاء Backend Proxy (خارج نطاق التطبيق)

### الحل المؤقت في التطبيق:
1. **Obfuscation**: تشويش الكود
2. **Certificate Pinning**: للحماية من MITM attacks
3. **API Key Rotation**: تغيير الـ key دورياً

### ملاحظة:
الحل الحقيقي يتطلب backend server يتعامل مع YouTube API
التطبيق يتصل بالـ backend فقط بدون معرفة الـ API Key

---

## ترتيب التنفيذ:

1. ✅ flutter_secure_storage للـ tokens (سأنفذه الآن)
2. ⏳ Backend proxy (يحتاج server - خارج النطاق حالياً)

---

## الملفات التي ستتأثر:

```
pubspec.yaml                                    (إضافة dependency)
lib/core/services/secure_storage_service.dart   (جديد)
lib/core/depandancy_injection/service_locator.dart (تحديث)
lib/features/auth/presentation/logic/auth_cubit.dart (تحديث)
lib/features/auth/presentation/logic/auth_state.dart (تحديث)
test/core/services/secure_storage_service_test.dart (جديد)
```

---

## سياق العمل بعد التنفيذ:

1. عند تسجيل الدخول:
   - المستخدم يسجل دخول بـ Google
   - نحصل على access token
   - نحفظه في secure storage (مشفر)
   - نحدث الـ state

2. عند فتح التطبيق:
   - نتحقق من وجود token في secure storage
   - إذا موجود → المستخدم مسجل دخول
   - إذا غير موجود → نعرض شاشة تسجيل الدخول

3. عند تسجيل الخروج:
   - نحذف الـ token من secure storage
   - نمسح الـ state
   - نعرض شاشة تسجيل الدخول
