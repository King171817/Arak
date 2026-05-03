import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class StudentDashboardScreen extends StatelessWidget {
  final VoidCallback? onOpenWeeklySchedule;
  final VoidCallback? onOpenServices;
  final VoidCallback? onOpenUnits;

  const StudentDashboardScreen({
    super.key,
    this.onOpenWeeklySchedule,
    this.onOpenServices,
    this.onOpenUnits,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        DashboardCard(
          title: appText(lang, 'weekly_schedule'),
          subtitle: isRtlLang(lang)
              ? 'مشاهده برنامه درسی و زمان کلاس‌ها'
              : 'View your weekly classes and schedule',
          icon: Icons.calendar_month_outlined,
          onTap: onOpenWeeklySchedule,
        ),
        DashboardCard(
          title: appText(lang, 'units'),
          subtitle: isRtlLang(lang)
              ? 'ارتباط با واحدهای دانشگاه'
              : 'Contact university units',
          icon: Icons.account_balance_outlined,
          onTap: onOpenUnits,
        ),
        DashboardCard(
          title: appText(lang, 'other_services'),
          subtitle: isRtlLang(lang)
              ? 'خدمات دانشجویی، ترجمه، تاکسی، هتل و...'
              : 'Student services, translation, taxi, hotel and more',
          icon: Icons.apps_outlined,
          onTap: onOpenServices,
        ),
        DashboardCard(
          title: appText(lang, 'notifications'),
          subtitle: isRtlLang(lang)
              ? 'اعلان‌ها و پیام‌های جدید'
              : 'Notifications and new messages',
          icon: Icons.notifications_none,
        ),
      ],
    );
  }
}

