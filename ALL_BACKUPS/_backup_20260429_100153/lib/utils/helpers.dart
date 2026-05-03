import 'package:flutter/material.dart';

enum AppLang { fa, en, ar }

String langCode(AppLang lang) {
  switch (lang) {
    case AppLang.fa: return 'فارسی';
    case AppLang.en: return 'English';
    case AppLang.ar: return 'العربية';
  }
}

bool isRtlLang(AppLang lang) {
  return lang == AppLang.fa || lang == AppLang.ar;
}

String _langKey(AppLang lang) {
  switch (lang) {
    case AppLang.fa: return 'FA';
    case AppLang.en: return 'EN';
    case AppLang.ar: return 'AR';
  }
}

String tr(AppLang lang, String key) {
  final Map<String, Map<String, String>> data = {
    'app_name': {'FA': 'دانشگاه اراک', 'EN': 'Arak University', 'AR': 'جامعة أراك'},
    'login': {'FA': 'ورود', 'EN': 'Login', 'AR': 'تسجيل الدخول'},
    'username': {'FA': 'نام کاربری', 'EN': 'Username', 'AR': 'اسم المستخدم'},
    'password': {'FA': 'رمز عبور', 'EN': 'Password', 'AR': 'كلمة المرور'},
    'language': {'FA': 'زبان', 'EN': 'Language', 'AR': 'اللغة'},
    'register': {'FA': 'ثبت‌نام', 'EN': 'Register', 'AR': 'التسجيل'},
    'student_id': {'FA': 'شماره دانشجویی', 'EN': 'Student ID', 'AR': 'رقم الطالب'},
    'email': {'FA': 'ایمیل', 'EN': 'Email', 'AR': 'البريد الإلكتروني'},
    'already_have_account': {'FA': 'قبلاً ثبت‌نام کرده‌ام', 'EN': 'I already have an account', 'AR': 'لدي حساب بالفعل'},
    'create_new_account': {'FA': 'ثبت‌نام کاربر جدید', 'EN': 'Create new account', 'AR': 'إنشاء حساب جديد'},
    'login_info': {'FA': 'دانشجو: admin / مدیران: admin1 تا admin4 / استاد: prof1, prof2 / رمز: 1234', 'EN': 'Student: admin / Managers: admin1 to admin4 / Professor: prof1, prof2 / Password: 1234', 'AR': 'الطالب: admin / المدراء: admin1 إلى admin4 / الأستاذ: prof1, prof2 / كلمة المرور: 1234'},
    'incorrect_credentials': {'FA': 'نام کاربری یا رمز عبور اشتباه است', 'EN': 'Username or password is incorrect', 'AR': 'اسم المستخدم أو كلمة المرور غير صحيحة'},
    'registration_conceptual': {'FA': 'ثبت‌نام فعلاً به‌صورت مفهومی انجام شد', 'EN': 'Registration is conceptual for now', 'AR': 'التسجيل افتراضي حالياً'},
    'professor': {'FA': 'استاد', 'EN': 'Professor', 'AR': 'أستاذ'},
  };
  return data[key]?[_langKey(lang)] ?? key;
}

String formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  if (now.difference(date).inHours < 24) {
    return formatTime(date);
  } else if (now.difference(date).inDays < 7) {
    return '${now.difference(date).inDays} روز پیش';
  } else {
    return '${date.month}/${date.day}';
  }
}

String appText(AppLang lang, String key) {
  final Map<String, Map<String, String>> textData = {
    'university_app': {'FA': 'اپلیکیشن ارتباط با دانشگاه', 'EN': 'University Communication App', 'AR': 'تطبيق التواصل مع الجامعة'},
    'university_subtitle': {'FA': 'ارتباط ساده‌تر دانشجویان بین‌الملل با واحدهای دانشگاه', 'EN': 'A simpler connection between international students and university units', 'AR': 'تواصل أسهل بين الطلاب الدوليين ووحدات الجامعة'},
    'units': {'FA': 'واحدها', 'EN': 'Units', 'AR': 'الوحدات'},
    'support': {'FA': 'پشتیبانی', 'EN': 'Support', 'AR': 'الدعم'},
    'international': {'FA': 'امور بین‌الملل', 'EN': 'International Affairs', 'AR': 'الشؤون الدولية'},
    'student_services': {'FA': 'خدمات دانشجویی', 'EN': 'Student Services', 'AR': 'خدمات الطلاب'},
    'education': {'FA': 'آموزش', 'EN': 'Education', 'AR': 'التعليم'},
    'consular': {'FA': 'کنسولی', 'EN': 'Consular', 'AR': 'القنصلية'},
    'other_services': {'FA': 'سایر خدمات', 'EN': 'Other Services', 'AR': 'خدمات أخرى'},
    'enter_section': {'FA': 'ورود به بخش', 'EN': 'Enter', 'AR': 'الدخول إلى قسم'},
    'profile': {'FA': 'پروفایل', 'EN': 'Profile', 'AR': 'الملف الشخصي'},
    'notifications': {'FA': 'اعلان‌ها', 'EN': 'Notifications', 'AR': 'الإشعارات'},
    'unread': {'FA': 'اعلان نخوانده', 'EN': 'Unread notifications', 'AR': 'إشعارات غير مقروءة'},
    'taxi': {'FA': 'تاکسی دانشگاه', 'EN': 'University Taxi', 'AR': 'تاكسي الجامعة'},
    'translation': {'FA': 'خدمات ترجمه', 'EN': 'Translation Services', 'AR': 'خدمات الترجمة'},
    'insurance': {'FA': 'بیمه دانشجویی', 'EN': 'Student Insurance', 'AR': 'تأمين الطلاب'},
    'bank': {'FA': 'خدمات بانکی', 'EN': 'Banking Services', 'AR': 'الخدمات المصرفية'},
    'restaurant': {'FA': 'رستوران دانشگاه', 'EN': 'University Restaurant', 'AR': 'مطعم الجامعة'},
    'gym': {'FA': 'سالن ورزشی', 'EN': 'Gym', 'AR': 'صالة الألعاب الرياضية'},
    'library': {'FA': 'کتابخانه', 'EN': 'Library', 'AR': 'المكتبة'},
    'printing': {'FA': 'چاپ و تکثیر', 'EN': 'Printing Services', 'AR': 'خدمات الطباعة'},
    'my_conversations': {'FA': 'گفتگوهای من', 'EN': 'My Conversations', 'AR': 'محادثاتي'},
    'search_conversations': {'FA': 'جستجو در گفتگوها...', 'EN': 'Search conversations...', 'AR': 'البحث في المحادثات...'},
    'new_conversation': {'FA': 'گفتگوی جدید', 'EN': 'New Conversation', 'AR': 'محادثة جديدة'},
    'tracking': {'FA': 'پیگیری', 'EN': 'Tracking', 'AR': 'متابعة'},
    'quick_access': {'FA': 'دسترسی سریع', 'EN': 'Quick Access', 'AR': 'وصول سريع'},
    'common_items': {'FA': 'موارد پرکاربرد', 'EN': 'Common Items', 'AR': 'العناصر الشائعة'},
    'unit_info': {'FA': 'اطلاعات واحد', 'EN': 'Unit Information', 'AR': 'معلومات الوحدة'},
    'response_hours': {'FA': 'ساعت پاسخگویی: 8 الی 16', 'EN': 'Response hours: 8 to 16', 'AR': 'ساعات الرد: 8 إلى 16'},
    'contact_unit': {'FA': 'تماس با واحد', 'EN': 'Contact Unit', 'AR': 'الاتصال بالوحدة'},
    'write_message': {'FA': 'پیام خود را بنویسید...', 'EN': 'Write your message...', 'AR': 'اكتب رسالتك...'},
    'message_received': {'FA': 'پیام شما دریافت شد و توسط کارشناس بررسی می‌شود.', 'EN': 'Your message has been received and will be reviewed by the staff.', 'AR': 'تم استلام رسالتك وسيتم فحصها من قبل الموظف المختص.'},
    'welcome_message': {'FA': 'سلام 👋\nبه این بخش خوش آمدید. لطفاً درخواست خود را کامل توضیح دهید.', 'EN': 'Hello!\nWelcome to this section. Please describe your request completely.', 'AR': 'مرحباً!\nأهلاً بك في هذا القسم. يرجى شرح طلبك بشكل كامل.'},
    'sample_user_message': {'FA': 'سلام، من یک درخواست اداری دارم. لطفاً راهنمایی کنید چه مدارکی لازم است.', 'EN': 'Hello, I have an administrative request. Please tell me what documents are required.', 'AR': 'مرحباً، لدي طلب إداري. يرجى إرشادي إلى المستندات المطلوبة.'},
    'sample_staff_message': {'FA': 'برای ثبت درخواست، لطفاً نوع درخواست را مشخص کنید و مدارک مرتبط را ارسال نمایید.', 'EN': 'To register the request, please specify the request type and send the related documents.', 'AR': 'لتسجيل الطلب، يرجى تحديد نوع الطلب وإرسال المستندات ذات الصلة.'},
    'request_about': {'FA': 'درخواست درباره', 'EN': 'Request about', 'AR': 'طلب حول'},
    'request_registered': {'FA': 'درخواست شما ثبت شد. لطفاً جزئیات بیشتری ارسال کنید.', 'EN': 'Your request has been registered. Please send more details.', 'AR': 'تم تسجيل طلبك. يرجى إرسال المزيد من التفاصيل.'},
    'support_chat_welcome': {'FA': 'سلام! من دستیار پشتیبانی دانشگاه هستم. چطور می‌تونم کمکتون کنم؟', 'EN': 'Hello! I am the university support assistant. How can I help you?', 'AR': 'مرحباً! أنا مساعد الدعم بالجامعة. كيف يمكنني مساعدتك؟'},
    'support_chat_certificate_response': {'FA': 'برای دریافت گواهی اشتغال به تحصیل، لطفاً به بخش آموزش مراجعه کنید.', 'EN': 'To get a student certificate, please visit the Education section.', 'AR': 'للحصول على شهادة قيد دراسي، يرجى زيارة قسم التعليم.'},
    'support_chat_dormitory_response': {'FA': 'درخواست خوابگاه از طریق بخش خدمات دانشجویی انجام می‌شود.', 'EN': 'Dormitory requests are made through the Student Services section.', 'AR': 'Dormitory requests are made through the Student Services section.'},
    'support_chat_visa_response': {'FA': 'برای تمدید یا صدور ویزا، لطفاً با بخش کنسولی ارتباط بگیرید.', 'EN': 'To extend or issue a visa, please contact the Consular section.', 'AR': 'لتمديد أو إصدار تأشيرة، يرجى التواصل مع القسم القنصلي.'},
    'support_chat_grade_response': {'FA': 'برای دریافت ریز نمرات، از بخش آموزش درخواست دهید.', 'EN': 'To get your transcript, request it from the Education section.', 'AR': 'للحصول على كشف درجاتك، اطلبه من قسم التعليم.'},
    'support_chat_greeting_response': {'FA': 'سلام! خوشحالم که با شما صحبت می‌کنم.', 'EN': 'Hello! Nice to talk to you.', 'AR': 'مرحباً! يسعدني التحدث إليك.'},
    'support_chat_thanks_response': {'FA': 'خواهش می‌کنم! هر وقت سوالی داشتید در خدمتم.', 'EN': 'You\'re welcome! I\'m here whenever you have a question.', 'AR': 'عفواً! أنا هنا كلما كان لديك سؤال.'},
    'support_chat_unclear_response': {'FA': 'متوجه نشدم. لطفاً سوال خود را واضح‌تر بپرسید.', 'EN': 'I didn\'t understand. Please ask your question more clearly.', 'AR': 'لم أفهم. يرجى طرح سؤالك بشكل أوضح.'},
    'professor_home_title': {'FA': 'کلاس‌های من', 'EN': 'My Classes', 'AR': 'فصولي الدراسية'},
    'professor_class_title': {'FA': 'گفتگو با دانشجویان', 'EN': 'Conversations with Students', 'AR': 'محادثات مع الطلاب'},
    'class_students': {'FA': 'دانشجویان کلاس', 'EN': 'Class Students', 'AR': 'طلاب الفصل'},
    'class_messages': {'FA': 'گفتگوهای کلاس', 'EN': 'Class Messages', 'AR': 'محادثات الفصل'},
    'class_info': {'FA': 'اطلاعات کلاس', 'EN': 'Class Info', 'AR': 'معلومات الفصل'},
    'class_programming_desc': {'FA': 'این کلاس به مباحث پیشرفته برنامه نویسی می‌پردازد.', 'EN': 'This class covers advanced programming topics.', 'AR': 'يتناول هذا الفصل مواضيع البرمجة المتقدمة.'},
    'class_database_desc': {'FA': 'اصول طراحی و پیاده‌سازی پایگاه داده.', 'EN': 'Principles of database design and implementation.', 'AR': 'مبادئ تصميم وتطبيق قواعد البيانات.'},
    'class_datastructure_desc': {'FA': 'آشنایی با ساختمان داده‌ها و الگوریتم‌ها.', 'EN': 'Introduction to data structures and algorithms.', 'AR': 'مقدمة في هياكل البيانات والخوارزميات.'},
    'student_conversation_intro': {'FA': 'سلام! چطور می‌توانم در این درس به شما کمک کنم؟', 'EN': 'Hello! How can I assist you with this course?', 'AR': 'مرحباً! كيف يمكنني مساعدتك في هذا المقرر؟'},
    'prof_sample_student_msg': {'FA': 'استاد، من در تمرین شماره 5 مشکل دارم.', 'EN': 'Professor, I\'m having trouble with assignment 5.', 'AR': 'أستاذ، لدي مشكلة في الواجب رقم 5.'},
    'prof_sample_response': {'FA': 'لطفاً جزئیات بیشتری از مشکلتان را توضیح دهید.', 'EN': 'Please elaborate on the issue you are facing.', 'AR': 'يرجى تقديم مزيد من التفاصيل حول المشكلة التي تواجهها.'},
  };
  return textData[key]?[_langKey(lang)] ?? key;
}
