# راهنمای فعال‌سازی Supabase برای Flutter Sina

## وضعیت فعلی

برنامه هنوز با Mock Repository اجرا می‌شود، اما ساختار Supabase آماده شده است.

## فایل‌های ساخته‌شده

- lib/config/supabase_config.dart
- lib/services/supabase_bootstrap.dart
- lib/repositories/supabase
- database/supabase_schema.sql
- database/supabase_seed.sql

## مراحل فعال‌سازی Supabase

### 1. ساخت پروژه در Supabase

در سایت Supabase یک پروژه جدید بساز.

### 2. اجرای SQL schema

در Supabase وارد بخش SQL Editor شو و محتوای این فایل را اجرا کن:

database/supabase_schema.sql

### 3. اجرای RLS توسعه

بعد از ساخت جدول‌ها، برای فعال‌سازی سیاست‌های اولیه توسعه، محتوای این فایل را اجرا کن:

database/supabase_rls_dev.sql

نکته: این policyها فقط برای توسعه هستند و برای نسخه production باید محدودتر شوند.

### 4. اجرای seed اولیه

بعد از ساخت جدول‌ها، محتوای این فایل را اجرا کن:

database/supabase_seed.sql

### 5. وارد کردن URL و anon key

در فایل زیر:

lib/config/supabase_config.dart

این دو مقدار را تغییر بده:

static const String url = 'YOUR_SUPABASE_URL';
static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';

به مقدارهای واقعی پروژه Supabase.

### 6. اجرای برنامه

بعد از تنظیم مقدارها:

flutter pub get
flutter analyze lib\main.dart lib\app lib\models lib\data lib\core lib\widgets lib\state lib\screens lib\repositories lib\services lib\config
flutter run -d chrome

## نکته مهم امنیتی

در نسخه فعلی، جدول app_users برای تست از password ساده استفاده می‌کند.  
برای نسخه واقعی باید ورود با Supabase Auth جایگزین شود و رمز عبور داخل جدول ذخیره نشود.

## برگشت به Mock

اگر مقدارهای SupabaseConfig را دوباره به این حالت برگردانی:

YOUR_SUPABASE_URL
YOUR_SUPABASE_ANON_KEY

برنامه دوباره با Mock Repository اجرا می‌شود.

