import 'package:flutter/material.dart';

enum AppLang { fa, en, ar }

String langCode(AppLang lang) {
  switch (lang) {
    case AppLang.fa:
      return 'فارسی';
    case AppLang.en:
      return 'English';
    case AppLang.ar:
      return 'العربية';
  }
}

bool isRtlLang(AppLang lang) => lang == AppLang.fa || lang == AppLang.ar;

String appText(AppLang lang, String fa, String en, String ar) {
  switch (lang) {
    case AppLang.fa:
      return fa;
    case AppLang.en:
      return en;
    case AppLang.ar:
      return ar;
  }
}

String tr(AppLang lang, String key) {
  final map = <String, List<String>>{
    'app_name': ['دانشگاه اراک', 'Arak University', 'جامعة أراك'],
    'app_title': ['اپلیکیشن ارتباط با دانشگاه', 'University Communication App', 'تطبيق التواصل مع الجامعة'],
    'login': ['ورود', 'Login', 'تسجيل الدخول'],
    'username': ['نام کاربری', 'Username', 'اسم المستخدم'],
    'password': ['رمز عبور', 'Password', 'كلمة المرور'],
    'language': ['زبان', 'Language', 'اللغة'],
    'settings': ['تنظیمات', 'Settings', 'الإعدادات'],
    'profile': ['پروفایل', 'Profile', 'الملف الشخصي'],
    'notifications': ['اعلان‌ها', 'Notifications', 'الإشعارات'],
    'dashboard': ['داشبورد', 'Dashboard', 'لوحة التحكم'],
    'classes': ['کلاس‌ها', 'Classes', 'الفصول'],
    'services': ['خدمات', 'Services', 'الخدمات'],
    'reports': ['گزارش‌ها', 'Reports', 'التقارير'],
    'users': ['کاربران', 'Users', 'المستخدمون'],
    'access': ['سطوح دسترسی', 'Access', 'الصلاحيات'],
    'logout': ['خروج', 'Logout', 'خروج'],
    'dark_mode': ['حالت شب', 'Dark mode', 'الوضع الداكن'],
    'font_size': ['اندازه فونت', 'Font size', 'حجم الخط'],
    'reminders': ['یادآوری‌ها', 'Reminders', 'التذكيرات'],
    'privacy': ['حریم خصوصی', 'Privacy', 'الخصوصية'],
    'student': ['دانشجو', 'Student', 'طالب'],
    'professor': ['استاد', 'Professor', 'أستاذ'],
    'manager': ['مدیر واحد', 'Unit manager', 'مدير الوحدة'],
    'super_admin': ['مدیر کل', 'Super admin', 'المدير العام'],
    'education': ['آموزش', 'Education', 'التعليم'],
    'international': ['امور بین‌الملل', 'International Affairs', 'الشؤون الدولية'],
    'student_services': ['خدمات دانشجویی', 'Student Services', 'خدمات الطلاب'],
    'consular': ['کنسولی', 'Consular', 'القنصلية'],
    'other_services': ['سایر خدمات', 'Other Services', 'خدمات أخرى'],
    'taxi': ['تاکسی دانشگاه', 'University Taxi', 'تاكسي الجامعة'],
    'translation': ['ترجمه', 'Translation', 'الترجمة'],
    'library': ['کتابخانه', 'Library', 'المكتبة'],
    'gym': ['ورزش', 'Sports', 'الرياضة'],
    'printing': ['پرینت', 'Printing', 'الطباعة'],
    'hotel': ['هتل', 'Hotel', 'الفندق'],
    'flight': ['بلیط هواپیما', 'Flight ticket', 'تذكرة الطيران'],
    'money_exchange': ['چنج پول', 'Money exchange', 'صرف العملات'],
    'course': ['دوره آموزشی', 'Training course', 'دورة تدريبية'],
    'create_class': ['ایجاد کلاس', 'Create class', 'إنشاء فصل'],
    'start_class': ['شروع کلاس', 'Start class', 'بدء الفصل'],
    'end_class': ['پایان کلاس', 'End class', 'إنهاء الفصل'],
    'join_class': ['ورود به کلاس', 'Join class', 'دخول الفصل'],
    'leave_class': ['خروج از کلاس', 'Leave class', 'الخروج من الفصل'],
    'class_not_started': ['کلاس هنوز توسط استاد شروع نشده است.', 'Class has not been started by the professor yet.', 'لم يبدأ الأستاذ الفصل بعد.'],
    'class_live': ['کلاس در حال برگزاری است', 'Class is live', 'الفصل مباشر'],
    'chat': ['گفتگو', 'Chat', 'الدردشة'],
    'students': ['دانشجویان', 'Students', 'الطلاب'],
    'control': ['کنترل', 'Control', 'التحكم'],
    'contact': ['ارتباط', 'Contact', 'التواصل'],
    'announcement': ['اعلان', 'Announcement', 'إعلان'],
    'send': ['ارسال', 'Send', 'إرسال'],
    'mic': ['میکروفن', 'Microphone', 'الميكروفون'],
    'camera': ['دوربین', 'Camera', 'الكاميرا'],
    'record': ['ضبط کلاس', 'Record class', 'تسجيل الفصل'],
    'allow_speak': ['اجازه صحبت', 'Allow speaking', 'السماح بالكلام'],
    'mute': ['قطع صدا', 'Mute', 'كتم'],
    'unmute': ['وصل صدا', 'Unmute', 'إلغاء الكتم'],
    'restrict': ['محدود کردن', 'Restrict', 'تقييد'],
    'remove_restrict': ['رفع محدودیت', 'Remove restriction', 'إلغاء التقييد'],
    'present': ['حاضر', 'Present', 'حاضر'],
    'not_joined': ['وارد نشده', 'Not joined', 'لم يدخل'],
  };
  final values = map[key];
  if (values == null) return key;
  return values[lang.index];
}

TextDirection textDirectionFor(AppLang lang) => isRtlLang(lang) ? TextDirection.rtl : TextDirection.ltr;
