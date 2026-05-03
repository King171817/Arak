import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import '../reports/daily_activity_report_screen.dart';
import 'education_expert_management_screen.dart';

class EducationExpertPanelScreen extends StatelessWidget {
  const EducationExpertPanelScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'education_expert_panel'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _ExpertTile(
              icon: Icons.class_outlined,
              title: t(lang, 'classes'),
              subtitle: 'مدیریت کلاس‌های مجاز توسط مدیر آموزش',
              onTap: () {},
            ),
            _ExpertTile(
              icon: Icons.people_outline,
              title: t(lang, 'students'),
              subtitle: 'مشاهده و ویرایش اطلاعات مجاز دانشجویان',
              onTap: () {},
            ),
            _ExpertTile(
              icon: Icons.assignment_outlined,
              title: t(lang, 'daily_report'),
              subtitle: 'ثبت فعالیت روزانه با مهلت ویرایش ۴۸ ساعت',
              onTap: () => _open(context, const DailyActivityReportScreen()),
            ),
            _ExpertTile(
              icon: Icons.manage_accounts_outlined,
              title: t(lang, 'expert_management'),
              subtitle: 'فقط برای مدیر آموزش و مدیر اصلی',
              onTap: () => _open(context, const EducationExpertManagementScreen()),
            ),
            _ExpertTile(
              icon: Icons.chat_outlined,
              title: t(lang, 'managers_chat'),
              subtitle: 'گفتگوی داخلی با مدیر آموزش',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpertTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExpertTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}

