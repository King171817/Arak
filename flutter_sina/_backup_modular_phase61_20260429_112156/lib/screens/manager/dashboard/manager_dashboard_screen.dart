import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ManagerDashboardScreen extends StatelessWidget {
  final VoidCallback? onOpenStudents;
  final VoidCallback? onOpenOfficers;
  final VoidCallback? onOpenReports;
  final VoidCallback? onOpenMessages;

  const ManagerDashboardScreen({
    super.key,
    this.onOpenStudents,
    this.onOpenOfficers,
    this.onOpenReports,
    this.onOpenMessages,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        DashboardCard(
          title: appText(lang, 'students'),
          subtitle: isRtlLang(lang)
              ? 'دسترسی سریع به اطلاعات دانشجویان'
              : 'Quick access to student information',
          icon: Icons.people_outline,
          onTap: onOpenStudents,
        ),
        DashboardCard(
          title: appText(lang, 'officers'),
          subtitle: isRtlLang(lang)
              ? 'تعریف کارشناس و مدیریت دسترسی‌ها'
              : 'Create officers and manage permissions',
          icon: Icons.admin_panel_settings_outlined,
          onTap: onOpenOfficers,
        ),
        DashboardCard(
          title: appText(lang, 'reports'),
          subtitle: isRtlLang(lang)
              ? 'گزارش‌ها و فیلترهای مدیریتی'
              : 'Reports and management filters',
          icon: Icons.analytics_outlined,
          onTap: onOpenReports,
        ),
        DashboardCard(
          title: appText(lang, 'managers_chat'),
          subtitle: isRtlLang(lang)
              ? 'گفتگو با مدیران واحدها و مدیر اصلی'
              : 'Chat with unit managers and super admin',
          icon: Icons.chat_outlined,
          onTap: onOpenMessages,
        ),
        if (appState.canSeeClassesInBottomNav)
          DashboardCard(
            title: appText(lang, 'classes'),
            subtitle: isRtlLang(lang)
                ? 'مدیریت کلاس‌ها و برنامه هفتگی'
                : 'Manage classes and weekly schedules',
            icon: Icons.school_outlined,
          ),
      ],
    );
  }
}
