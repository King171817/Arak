import '../../models/auth/app_lang.dart';

String appText(AppLang lang, String key) {
  final Map<String, Map<String, String>> data = {
    'app_name': {
      'FA': 'دانشگاه اراک',
      'EN': 'Arak University',
      'AR': 'جامعة أراك',
    },
    'university_app': {
      'FA': 'اپلیکیشن ارتباط با دانشگاه',
      'EN': 'University Communication App',
      'AR': 'تطبيق التواصل مع الجامعة',
    },
    'university_subtitle': {
      'FA': 'ارتباط ساده‌تر دانشجویان بین‌الملل با واحدهای دانشگاه',
      'EN': 'A simpler connection between international students and university units',
      'AR': 'تواصل أسهل بين الطلاب الدوليين ووحدات الجامعة',
    },
    'login': {
      'FA': 'ورود',
      'EN': 'Login',
      'AR': 'تسجيل الدخول',
    },
    'username': {
      'FA': 'نام کاربری',
      'EN': 'Username',
      'AR': 'اسم المستخدم',
    },
    'password': {
      'FA': 'رمز عبور',
      'EN': 'Password',
      'AR': 'كلمة المرور',
    },
    'language': {
      'FA': 'زبان',
      'EN': 'Language',
      'AR': 'اللغة',
    },
    'dashboard': {
      'FA': 'داشبورد',
      'EN': 'Dashboard',
      'AR': 'لوحة التحكم',
    },
    'classes': {
      'FA': 'کلاس‌ها',
      'EN': 'Classes',
      'AR': 'الفصول',
    },
    'exams': {
      'FA': 'امتحانات',
      'EN': 'Exams',
      'AR': 'الامتحانات',
    },
    'weekly_schedule': {
      'FA': 'برنامه هفتگی',
      'EN': 'Weekly Schedule',
      'AR': 'الجدول الأسبوعي',
    },
    'units': {
      'FA': 'واحدها',
      'EN': 'Units',
      'AR': 'الوحدات',
    },
    'services': {
      'FA': 'خدمات',
      'EN': 'Services',
      'AR': 'الخدمات',
    },
    'other_services': {
      'FA': 'سایر خدمات',
      'EN': 'Other Services',
      'AR': 'خدمات أخرى',
    },
    'settings': {
      'FA': 'تنظیمات',
      'EN': 'Settings',
      'AR': 'الإعدادات',
    },
    'more': {
      'FA': 'بیشتر',
      'EN': 'More',
      'AR': 'المزيد',
    },
    'back': {
      'FA': 'بازگشت',
      'EN': 'Back',
      'AR': 'رجوع',
    },
    'profile': {
      'FA': 'پروفایل',
      'EN': 'Profile',
      'AR': 'الملف الشخصي',
    },
    'notifications': {
      'FA': 'اعلان‌ها',
      'EN': 'Notifications',
      'AR': 'الإشعارات',
    },
    'managers_chat': {
      'FA': 'گفتگوی مدیران',
      'EN': 'Managers Chat',
      'AR': 'محادثة المديرين',
    },
    'officers': {
      'FA': 'کارشناسان',
      'EN': 'Officers',
      'AR': 'الموظفون',
    },
    'students': {
      'FA': 'دانشجویان',
      'EN': 'Students',
      'AR': 'الطلاب',
    },
    'reports': {
      'FA': 'گزارش‌ها',
      'EN': 'Reports',
      'AR': 'التقارير',
    },
    'admin_control_center': {
      'FA': 'مرکز کنترل مدیر اصلی',
      'EN': 'Super Admin Control Center',
      'AR': 'مركز تحكم المدير الرئيسي',
    },
    'floating_announcement': {
      'FA': 'اعلان شناور',
      'EN': 'Floating Announcement',
      'AR': 'الإعلان العائم',
    },
    'logout': {
      'FA': 'خروج',
      'EN': 'Logout',
      'AR': 'تسجيل الخروج',
    },
    'international': {
      'FA': 'امور بین‌الملل',
      'EN': 'International Affairs',
      'AR': 'الشؤون الدولية',
    },
    'education': {
      'FA': 'آموزش',
      'EN': 'Education',
      'AR': 'التعليم',
    },
    'student_services': {
      'FA': 'خدمات دانشجویی',
      'EN': 'Student Services',
      'AR': 'خدمات الطلاب',
    },
    'consular': {
      'FA': 'کنسولی',
      'EN': 'Consular',
      'AR': 'القنصلية',
    },
    'admin_main': {
      'FA': 'مدیر اصلی',
      'EN': 'Super Admin',
      'AR': 'المدير الرئيسي',
    },
    'education_officer': {
      'FA': 'کارشناس آموزش',
      'EN': 'Education Officer',
      'AR': 'موظف التعليم',
    },
    'money_exchange': {
      'FA': 'چنج پول',
      'EN': 'Money Exchange',
      'AR': 'تبديل العملات',
    },
    'money_exchange_subtitle': {
      'FA': 'درخواست خدمات تبدیل ارز',
      'EN': 'Currency exchange service request',
      'AR': 'طلب خدمة تحويل العملات',
    },
    'hotel': {
      'FA': 'هتل',
      'EN': 'Hotel',
      'AR': 'الفندق',
    },
    'hotel_subtitle': {
      'FA': 'رزرو و هماهنگی اقامت',
      'EN': 'Reservation and accommodation coordination',
      'AR': 'الحجز وتنسيق الإقامة',
    },
    'taxi': {
      'FA': 'تاکسی',
      'EN': 'Taxi',
      'AR': 'تاكسي',
    },
    'taxi_subtitle': {
      'FA': 'درخواست تاکسی دانشگاهی',
      'EN': 'University taxi request',
      'AR': 'طلب تاكسي الجامعة',
    },
    'translation': {
      'FA': 'ترجمه مدارک',
      'EN': 'Document Translation',
      'AR': 'ترجمة الوثائق',
    },
    'translation_subtitle': {
      'FA': 'ترجمه مدارک دانشجویی و اداری',
      'EN': 'Translation of academic and administrative documents',
      'AR': 'ترجمة الوثائق الدراسية والإدارية',
    },
    'air_ticket': {
      'FA': 'بلیط هواپیما',
      'EN': 'Air Ticket',
      'AR': 'تذكرة الطيران',
    },
    'air_ticket_subtitle': {
      'FA': 'راهنمای خرید و رزرو بلیط',
      'EN': 'Ticket booking and purchase guidance',
      'AR': 'إرشاد شراء وحجز التذاكر',
    },
    'courses': {
      'FA': 'دوره‌های آموزشی',
      'EN': 'Training Courses',
      'AR': 'الدورات التدريبية',
    },
    'courses_subtitle': {
      'FA': 'ثبت‌نام در دوره‌های آموزشی',
      'EN': 'Register for training courses',
      'AR': 'التسجيل في الدورات التدريبية',
    },
    'printing': {
      'FA': 'پرینت',
      'EN': 'Printing',
      'AR': 'الطباعة',
    },
    'printing_subtitle': {
      'FA': 'چاپ و تکثیر مدارک',
      'EN': 'Printing and copying documents',
      'AR': 'طباعة ونسخ الوثائق',
    },
    'welfare': {
      'FA': 'رفاهی',
      'EN': 'Welfare',
      'AR': 'الخدمات الرفاهية',
    },
    'welfare_subtitle': {
      'FA': 'خدمات رفاهی و پشتیبانی',
      'EN': 'Welfare and support services',
      'AR': 'خدمات الرفاه والدعم',
    },
    'enter_section': {
      'FA': 'ورود به بخش',
      'EN': 'Enter Section',
      'AR': 'الدخول إلى القسم',
    },
    'tickets': {
      'FA': 'درخواست‌ها',
      'EN': 'Requests',
      'AR': 'الطلبات',
    },
  };

  final String langValue = langKey(lang);
  return data[key]?[langValue] ?? key;
}

String tr(AppLang lang, String key) {
  return appText(lang, key);
}






