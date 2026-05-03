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
  final VoidCallback? onOpenTickets;
  final VoidCallback? onOpenServices;

  const ManagerDashboardScreen({
    super.key,
    required this.onOpenClasses,
    required this.onOpenStudents,
    required this.onOpenOfficers,
    required this.onOpenReports,
    required this.onOpenMessages,
    this.onOpenTickets,
    this.onOpenServices,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final bool rtl = isRtlLang(lang);

    return Container(
      decoration: AppDecorations.pageBackground,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          _ManagerHero(
            title: rtl ? 'مرکز عملیات مدیریت آموزش' : 'Education Operations Center',
            subtitle: rtl
                ? 'مدیریت کلاس‌ها، استادان، دانشجویان، درخواست‌ها، گزارش‌ها و ارتباطات آموزشی'
                : 'Manage classes, professors, students, requests, reports and education communications',
          ),
          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 780 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 5.2,
            children: <Widget>[
              _MiniStat(
                icon: Icons.school_outlined,
                title: rtl ? 'کلاس‌ها' : 'Classes',
                value: '${appState.educationClasses.length}',
              ),
              _MiniStat(
                icon: Icons.confirmation_number_outlined,
                title: rtl ? 'درخواست‌ها' : 'Tickets',
                value: '${appState.studentTickets.length}',
              ),
              _MiniStat(
                icon: Icons.admin_panel_settings_outlined,
                title: rtl ? 'کارشناسان' : 'Officers',
                value: '${appState.educationOfficers.length}',
              ),
              _MiniStat(
                icon: Icons.warning_amber_outlined,
                title: rtl ? 'پیگیری‌ها' : 'Follow-ups',
                value: '${appState.supportRequests.length}',
              ),
            ],
          ),

          const SizedBox(height: 12),
          _SectionHeader(
            icon: Icons.flash_on_outlined,
            title: rtl ? 'دسترسی سریع عملیاتی' : 'Operational Quick Access',
          ),
          const SizedBox(height: 8),

          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 880 ? 3 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 3.9,
            children: <Widget>[
              _CompactAction(
                icon: Icons.event_available_outlined,
                title: rtl ? 'مدیریت کلاس‌ها' : 'Class Management',
                subtitle: rtl ? 'ایجاد، ویرایش، شروع و گزارش' : 'Create, edit, start, report',
                color: AppColors.primary,
                onTap: onOpenClasses,
              ),
              _CompactAction(
                icon: Icons.person_pin_outlined,
                title: rtl ? 'ارتباط با استاد' : 'Professor Contact',
                subtitle: rtl ? 'پیام، وضعیت کلاس و گزارش استاد' : 'Message, class status, report',
                color: Colors.blueGrey,
                onTap: onOpenMessages,
              ),
              _CompactAction(
                icon: Icons.people_outline,
                title: rtl ? 'پرونده دانشجویان' : 'Student Files',
                subtitle: rtl ? 'کلاس‌ها، وضعیت، پیگیری آموزشی' : 'Classes, status, follow-up',
                color: Colors.deepPurple,
                onTap: onOpenStudents,
              ),
              _CompactAction(
                icon: Icons.support_agent_outlined,
                title: rtl ? 'ارتباط با دانشجو' : 'Student Contact',
                subtitle: rtl ? 'پاسخ، ارجاع و پیگیری مشکل' : 'Reply, route, follow issue',
                color: Colors.green,
                onTap: onOpenStudents,
              ),
              _CompactAction(
                icon: Icons.admin_panel_settings_outlined,
                title: rtl ? 'کارشناسان آموزش' : 'Education Officers',
                subtitle: rtl ? 'تعریف دسترسی و نقش' : 'Roles and permissions',
                color: Colors.teal,
                onTap: onOpenOfficers,
              ),
              _CompactAction(
                icon: Icons.confirmation_number_outlined,
                title: rtl ? 'درخواست‌ها' : 'Requests',
                subtitle: rtl ? 'تیکت، شماره پیگیری، پاسخ' : 'Ticket, tracking, response',
                color: Colors.orange,
                onTap: onOpenTickets ?? onOpenStudents,
              ),
              _CompactAction(
                icon: Icons.analytics_outlined,
                title: rtl ? 'گزارش‌های آموزشی' : 'Education Reports',
                subtitle: rtl ? 'فعال، گذشته، استاد، دانشجو' : 'Active, past, professor, student',
                color: Colors.indigo,
                onTap: onOpenReports,
              ),
              _CompactAction(
                icon: Icons.chat_bubble_outline,
                title: rtl ? 'چت مدیریتی' : 'Manager Chat',
                subtitle: rtl ? 'مدیر، کارشناس، مدیر اصلی' : 'Manager, officer, super admin',
                color: Colors.pink,
                onTap: onOpenMessages,
              ),
              _CompactAction(
                icon: Icons.apps_outlined,
                title: rtl ? 'خدمات مرتبط' : 'Related Services',
                subtitle: rtl ? 'خدمات دانشجویی و سازمانی' : 'Student and partner services',
                color: Colors.brown,
                onTap: onOpenServices ?? onOpenStudents,
              ),
            ],
          ),

          const SizedBox(height: 12),
          _SectionHeader(
            icon: Icons.notification_important_outlined,
            title: rtl ? 'هشدارها و کارهای فوری' : 'Alerts and urgent tasks',
          ),
          const SizedBox(height: 8),
          _AlertRow(
            icon: Icons.play_circle_outline,
            title: rtl ? 'کنترل شروع کلاس‌ها' : 'Class start control',
            subtitle: rtl
                ? 'استاد باید کلاس را شروع کند تا دانشجو بتواند وارد شود.'
                : 'Professor must start the class before students join.',
            color: Colors.blue,
          ),
          _AlertRow(
            icon: Icons.person_search_outlined,
            title: rtl ? 'پیگیری دانشجویان مشکل‌دار' : 'Student follow-up',
            subtitle: rtl
                ? 'درخواست‌های حل‌نشده و وضعیت حضور باید بررسی شود.'
                : 'Unresolved requests and attendance status should be reviewed.',
            color: Colors.orange,
          ),
          _AlertRow(
            icon: Icons.manage_accounts_outlined,
            title: rtl ? 'بازبینی دسترسی کارشناسان' : 'Review officer permissions',
            subtitle: rtl
                ? 'دسترسی‌های کارشناس آموزش باید دوره‌ای بررسی شود.'
                : 'Education officer permissions should be reviewed regularly.',
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}

class _ManagerHero extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ManagerHero({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.headerDecoration,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
            ),
            child: const Icon(Icons.school_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CompactAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CompactAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _AlertRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      decoration: AppDecorations.cardDecoration,
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: -1, vertical: -3),
        leading: Icon(icon, size: 20, color: color),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}

