import '../../core/constants/unit_keys.dart';
import '../../models/notifications/app_notification_model.dart';
import '../../models/notifications/chat_message_models.dart';
import '../../models/units/meeting_model.dart';

final List<AppNotificationModel> mockNotifications = <AppNotificationModel>[
  AppNotificationModel(
    id: 'n001',
    title: 'پیام جدید از آموزش',
    subtitle: 'درخواست گواهی شما بررسی شد.',
    unitKey: UnitKeys.education,
    createdAt: DateTime(2026, 4, 1, 9, 0),
    unread: true,
  ),
  AppNotificationModel(
    id: 'n002',
    title: 'پیام جدید از امور بین‌الملل',
    subtitle: 'مدارک پذیرش شما نیاز به تکمیل دارد.',
    unitKey: UnitKeys.international,
    createdAt: DateTime(2026, 4, 2, 10, 30),
    unread: true,
  ),
  AppNotificationModel(
    id: 'n003',
    title: 'پیام جدید از خدمات دانشجویی',
    subtitle: 'درخواست خوابگاه شما در حال پیگیری است.',
    unitKey: UnitKeys.studentServices,
    createdAt: DateTime(2026, 4, 3, 11, 0),
    unread: false,
  ),
];

final List<Meeting> mockMeetings = <Meeting>[
  Meeting(
    id: 'm001',
    title: 'جلسه هماهنگی مدیران',
    date: '1404/02/10',
    time: '10:00',
    targetUnit: UnitKeys.education,
    description: 'بررسی وضعیت درخواست‌های دانشجویان بین‌الملل',
  ),
  Meeting(
    id: 'm002',
    title: 'جلسه خدمات دانشجویی',
    date: '1404/02/12',
    time: '12:00',
    targetUnit: UnitKeys.studentServices,
    description: 'بررسی خوابگاه، رفاهی و پشتیبانی',
  ),
];

final List<InterManagerMessage> mockManagerMessages = <InterManagerMessage>[
  InterManagerMessage(
    id: 'im001',
    senderUnit: UnitKeys.education,
    receiverUnit: UnitKeys.international,
    senderName: 'مدیر آموزش',
    message: 'برای پرونده دانشجوی جدید، مدارک پذیرش نیاز به بررسی دارد.',
    sentAt: DateTime(2026, 4, 4, 8, 30),
    isRead: false,
  ),
  InterManagerMessage(
    id: 'im002',
    senderUnit: UnitKeys.adminMain,
    receiverUnit: UnitKeys.education,
    senderName: 'sina',
    message: 'لطفاً گزارش کلاس‌های هفته جاری را ارسال کنید.',
    sentAt: DateTime(2026, 4, 5, 9, 15),
    isRead: true,
  ),
];
