class AppNotification {
  final String title;
  final String subtitle;
  final String unitKey;
  final bool unread;

  AppNotification({
    required this.title,
    required this.subtitle,
    required this.unitKey,
    this.unread = true,
  });
}

final List<AppNotification> appNotifications = <AppNotification>[
  AppNotification(
    title: 'پیام جدید از آموزش',
    subtitle: 'درخواست گواهی شما بررسی شد.',
    unitKey: 'education',
  ),
  AppNotification(
    title: 'پیام جدید از امور بین‌الملل',
    subtitle: 'مدارک پذیرش شما نیاز به تکمیل دارد.',
    unitKey: 'international',
  ),
  AppNotification(
    title: 'پیام جدید از خدمات دانشجویی',
    subtitle: 'درخواست خوابگاه شما در حال پیگیری است.',
    unitKey: 'student_services',
  ),
  AppNotification(
    title: 'تایید نهایی مدارک',
    subtitle: 'مدارک شما تایید شد.',
    unitKey: 'consular',
  ),
  AppNotification(
    title: 'یادآوری پرداخت شهریه',
    subtitle: 'تاریخ پرداخت: 15 روز دیگر',
    unitKey: 'education',
  ),
];

int getUnreadCountForUnit(String unitKey) {
  try {
    return appNotifications
        .where((AppNotification n) => n.unitKey == unitKey && n.unread)
        .length;
  } catch (e) {
    return 0;
  }
}
