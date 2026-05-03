import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../core/theme/theme.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class StudentDashboardScreen extends StatelessWidget {
  final VoidCallback? onOpenWeeklySchedule;
  final VoidCallback? onOpenServices;
  final VoidCallback? onOpenUnits;
  final VoidCallback? onOpenTickets;
  final VoidCallback? onOpenExams;

  const StudentDashboardScreen({
    super.key,
    this.onOpenWeeklySchedule,
    this.onOpenServices,
    this.onOpenUnits,
    this.onOpenTickets,
    this.onOpenExams,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _StudentWelcomeCard(
            name: appState.currentUser?.displayName ?? 'دانشجو',
            lang: lang,
          ),
          const SizedBox(height: 16),
          _StudentQuickStats(
            classesCount: appState.getStudentClasses('s001').length,
            ticketsCount: appState.getTicketsForCurrentUser().length,
            unreadCount: appState.getUnreadNotificationCountForCurrentRole(),
          ),
          const SizedBox(height: 16),
          Text(
            isRtlLang(lang) ? 'دسترسی سریع' : 'Quick Access',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _DashboardGrid(
            children: <Widget>[
              _DashboardActionCard(
                title: appText(lang, 'weekly_schedule'),
                subtitle: isRtlLang(lang)
                    ? 'برنامه درسی و زمان کلاس‌ها'
                    : 'Weekly classes and schedule',
                icon: Icons.calendar_month_outlined,
                color: AppColors.primary,
                onTap: onOpenWeeklySchedule,
              ),
              _DashboardActionCard(
                title: appText(lang, 'units'),
                subtitle: isRtlLang(lang)
                    ? 'ارتباط با واحدهای دانشگاه'
                    : 'Contact university units',
                icon: Icons.account_balance_outlined,
                color: AppColors.secondary,
                onTap: onOpenUnits,
              ),
              _DashboardActionCard(
                title: appText(lang, 'tickets'),
                subtitle: isRtlLang(lang)
                    ? 'ثبت و پیگیری درخواست‌ها'
                    : 'Create and track requests',
                icon: Icons.confirmation_number_outlined,
                color: Colors.deepPurple,
                onTap: onOpenTickets,
              ),
              _DashboardActionCard(
                title: isRtlLang(lang) ? 'امتحانات' : 'Exams',
                subtitle: isRtlLang(lang)
                    ? 'مشاهده امتحانات و نتایج'
                    : 'View exams and results',
                icon: Icons.quiz_outlined,
                color: Colors.teal,
                onTap: onOpenExams,
              ),
              _DashboardActionCard(
                title: appText(lang, 'other_services'),
                subtitle: isRtlLang(lang)
                    ? 'خدمات رفاهی، ترجمه، تاکسی و...'
                    : 'Services, translation, taxi and more',
                icon: Icons.apps_outlined,
                color: Colors.orange,
                onTap: onOpenServices,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: isRtlLang(lang) ? 'آخرین وضعیت' : 'Latest Status',
            icon: Icons.info_outline,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: Text(appText(lang, 'classes')),
                  subtitle: Text(
                    isRtlLang(lang)
                        ? 'کلاس‌های ثبت‌شده شما در برنامه هفتگی قابل مشاهده است.'
                        : 'Your registered classes are available in weekly schedule.',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.confirmation_number_outlined),
                  title: Text(appText(lang, 'tickets')),
                  subtitle: Text(
                    isRtlLang(lang)
                        ? 'برای هر درخواست شماره پیگیری دریافت می‌کنید.'
                        : 'Each request receives a tracking number.',
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

class _StudentWelcomeCard extends StatelessWidget {
  final String name;
  final AppLang lang;

  const _StudentWelcomeCard({
    required this.name,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.headerDecoration,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.30),
              ),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isRtlLang(lang) ? 'خوش آمدید' : 'Welcome',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isRtlLang(lang)
                      ? 'از این بخش می‌توانید کلاس‌ها، درخواست‌ها و خدمات خود را مدیریت کنید.'
                      : 'Manage your classes, requests and services from here.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
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

class _StudentQuickStats extends StatelessWidget {
  final int classesCount;
  final int ticketsCount;
  final int unreadCount;

  const _StudentQuickStats({
    required this.classesCount,
    required this.ticketsCount,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return _DashboardGrid(
      children: <Widget>[
        _SmallStatCard(
          title: 'کلاس‌ها',
          value: '$classesCount',
          icon: Icons.school_outlined,
        ),
        _SmallStatCard(
          title: 'درخواست‌ها',
          value: '$ticketsCount',
          icon: Icons.confirmation_number_outlined,
        ),
        _SmallStatCard(
          title: 'اعلان‌ها',
          value: '$unreadCount',
          icon: Icons.notifications_none,
        ),
      ],
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  final List<Widget> children;

  const _DashboardGrid({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= 760;

        return GridView.count(
          crossAxisCount: wide ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: wide ? 1.85 : 1.45,
          children: children,
        );
      },
    );
  }
}

class _DashboardActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DashboardActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 42,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SmallStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}










