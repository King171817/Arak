/// پیکربندی Supabase — **هرگز** کلید واقعی را در کد قرار ندهید.
///
/// اجرا:
/// ```text
/// flutter run -d chrome `
///   --dart-define=SUPABASE_URL=https://xxxx.supabase.co `
///   --dart-define=SUPABASE_ANON_KEY=eyJ...
/// ```
///
/// رمز اتصال PostgreSQL (`postgres://...`) فقط برای ابزارهای دیتابیس است؛
/// اپ فلتر فقط به `url` و `anonKey` نیاز دارد.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// هر دو مقدار باید از `--dart-define` (یا CI secrets) پر شوند.
  static bool get isConfigured {
    final String u = url.trim();
    final String k = anonKey.trim();
    if (u.isEmpty || k.isEmpty) return false;
    if (!u.startsWith('https://')) return false;
    return true;
  }
}
