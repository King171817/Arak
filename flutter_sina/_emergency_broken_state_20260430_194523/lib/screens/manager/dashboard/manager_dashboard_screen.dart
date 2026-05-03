import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';

class ManagerDashboardScreen extends StatelessWidget {
  final VoidCallback onOpenClasses;
  final VoidCallback onOpenStudents;
  final VoidCallback onOpenOfficers;
  final VoidCallback onOpenReports;
  final VoidCallback onOpenMessages;

  const ManagerDashboardScreen({
    super.key,
    required this.onOpenClasses,
    required this.onOpenStudents,
    required this.onOpenOfficers,
    required this.onOpenReports,
    required this.onOpenMessages,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final rtl = isRtlLang(lang);

    return Container(
      decoration: AppDecorations.pageBackground,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [

          // هدر حرفه‌ای
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rtl ? 'مدیریت آموزش' : 'Education Management',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          // آمار سریع
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 4.8,
            children: [
              _stat('کلاس‌ها', appState.educationClasses.length.toString(), Icons.school),
              _stat('دانشجو', appState.studentTickets.length.toString(), Icons.people),
              _stat('کارشناس', appState.educationOfficers.length.toString(), Icons.admin_panel_settings),
              _stat('درخواست', appState.studentTickets.length.toString(), Icons.confirmation_number),
            ],
          ),

          const SizedBox(height: 12),

          // دسترسی سریع حرفه‌ای
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 4.2,
            children: [

              _action(Icons.school, 'کلاس‌ها', onOpenClasses),
              _action(Icons.people, 'دانشجویان', onOpenStudents),
              _action(Icons.admin_panel_settings, 'کارشناسان', onOpenOfficers),
              _action(Icons.analytics, 'گزارش‌ها', onOpenReports),
              _action(Icons.chat, 'پیام‌ها', onOpenMessages),

              _action(Icons.support_agent, 'پشتیبانی', () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('پشتیبانی در حال توسعه است')),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: AppDecorations.cardDecoration,
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 6),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: AppDecorations.cardDecoration,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}




