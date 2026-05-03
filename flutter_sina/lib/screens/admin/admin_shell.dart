import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import '../classroom/live_class_screen.dart';
import '../services/other_services_screen.dart';
import 'access_management/admin_access_management_screen.dart';
import 'chat/admin_chat_management_screen.dart';
import 'reports/admin_reports_audit_screen.dart';
import 'sections/admin_section_locks_screen.dart';
import 'services_management/admin_services_management_screen.dart';
import 'settings/admin_global_settings_screen.dart';
import 'ui_settings/admin_ui_settings_screen.dart';
import 'users/admin_users_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int currentIndex = 0;

  void setTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<_AdminTab> tabs = <_AdminTab>[
      const _AdminTab(
        label: 'داشبورد',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        page: _AdminMainDashboard(),
      ),
      const _AdminTab(
        label: 'کاربران',
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        page: AdminUsersScreen(),
      ),
      const _AdminTab(
        label: 'ظاهر',
        icon: Icons.tune_outlined,
        activeIcon: Icons.tune,
        page: AdminUiSettingsScreen(),
      ),
      const _AdminTab(
        label: 'خدمات',
        icon: Icons.business_center_outlined,
        activeIcon: Icons.business_center,
        page: AdminServicesManagementScreen(),
      ),
      const _AdminTab(
        label: 'کنترل',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        page: _AdminControlHub(),
      ),
    ];

    if (currentIndex >= tabs.length) {
      currentIndex = 0;
    }

    return RoleShellLayout(
      titleKey: 'university_app',
      currentIndex: currentIndex,
      onBottomTap: setTab,
      body: tabs[currentIndex].page,
      bottomItems: tabs.map((_AdminTab tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}

class _AdminMainDashboard extends StatelessWidget {
  const _AdminMainDashboard();

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  void _openLiveClass(BuildContext context, AppState appState) {
    if (appState.educationClasses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('کلاسی در دادهٔ نمونه نیست؛ از مدیریت آموزش کلاس اضافه کنید.'),
        ),
      );
      return;
    }
    final c = appState.educationClasses.first;
    _push(
      context,
      LiveClassScreen(
        classId: c.id,
        classTitle: c.title,
        professorId: c.professorId,
        professorName: c.professorName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.white,
                  size: 34,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'پنل مدیر اصلی — دسترسی کامل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.35,
            children: <Widget>[
              _AdminStat(
                icon: Icons.school_outlined,
                title: 'کلاس‌ها',
                value: '${appState.educationClasses.length}',
              ),
              _AdminStat(
                icon: Icons.confirmation_number_outlined,
                title: 'درخواست‌ها',
                value: '${appState.studentTickets.length}',
              ),
              _AdminStat(
                icon: Icons.support_agent_outlined,
                title: 'پشتیبانی',
                value: '${appState.supportRequests.length}',
              ),
              _AdminStat(
                icon: Icons.widgets_outlined,
                title: 'بخش‌های UI',
                value: '${appState.uiSectionSettings.length}',
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'خدمات اساسی',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          _HubTile(
            icon: Icons.manage_accounts_outlined,
            title: 'کاربران، نقش‌ها و لاگ',
            subtitle: 'جستجو، قفل، دسترسی فردی',
            onTap: () => _push(context, const AdminUsersScreen()),
          ),
          _HubTile(
            icon: Icons.lock_clock_outlined,
            title: 'قفل بخش‌ها (تعمیرات)',
            subtitle: 'پیام اختصاصی هر بخش',
            onTap: () => _push(context, const AdminSectionLocksScreen()),
          ),
          _HubTile(
            icon: Icons.campaign_outlined,
            title: 'پیام شناور چندزبانه',
            subtitle: 'تب ظاهر — هدف‌گیری نقش و زمان',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('از تب «ظاهر» پیام شناور را تنظیم کنید.'),
                ),
              );
            },
          ),
          _HubTile(
            icon: Icons.verified_user_outlined,
            title: 'الگوی دسترسی نقش‌ها',
            subtitle: 'هماهنگ با دیتابیس در نسخهٔ بعد',
            onTap: () => _push(context, const AdminAccessManagementScreen()),
          ),
          _HubTile(
            icon: Icons.assessment_outlined,
            title: 'گزارش و ممیزی',
            onTap: () => _push(context, const AdminReportsAuditScreen()),
          ),
          _HubTile(
            icon: Icons.forum_outlined,
            title: 'ارتباط بین‌واحدی و تیکت',
            onTap: () => _push(context, const AdminChatManagementScreen()),
          ),
          _HubTile(
            icon: Icons.video_call_outlined,
            title: 'کلاس زنده (میوت، دست، حضور)',
            subtitle: 'جلسهٔ نمونه روی اولین کلاس',
            onTap: () => _openLiveClass(context, appState),
          ),
          _HubTile(
            icon: Icons.public_outlined,
            title: 'تنظیمات سراسری و تعمیرات',
            onTap: () => _push(context, const AdminGlobalSettingsScreen()),
          ),
          _HubTile(
            icon: Icons.apps_outlined,
            title: 'سایر خدمات (آینده سازمان/شرکت)',
            subtitle: 'بدون شکستن هستهٔ برنامه',
            onTap: () => _push(
              context,
              OtherServicesScreen(onBack: () => Navigator.of(context).pop()),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AdminControlHub extends StatelessWidget {
  const _AdminControlHub();

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(14),
            child: const Row(
              children: <Widget>[
                Icon(Icons.settings_suggest_outlined,
                    color: Colors.white, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'مرکز کنترل سریع',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: AppDecorations.cardDecoration,
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  title: const Text('حالت تعمیرات سراسری'),
                  subtitle: Text(appState.maintenanceMessageForCurrentLang()),
                  value: appState.maintenanceMode,
                  onChanged: appState.setMaintenanceMode,
                ),
                SwitchListTile(
                  title: const Text('ثبت‌نام فعال'),
                  value: appState.registrationEnabled,
                  onChanged: appState.setRegistrationEnabled,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _ControlLink(
            icon: Icons.lock_outline,
            title: 'قفل بخش‌ها',
            onTap: () => _push(context, const AdminSectionLocksScreen()),
          ),
          _ControlLink(
            icon: Icons.public,
            title: 'پیام تعمیرات چندزبانه',
            onTap: () => _push(context, const AdminGlobalSettingsScreen()),
          ),
          _ControlLink(
            icon: Icons.security,
            title: 'نقش‌ها و دسترسی',
            onTap: () => _push(context, const AdminAccessManagementScreen()),
          ),
          _ControlLink(
            icon: Icons.history,
            title: 'گزارش فعالیت',
            onTap: () => _push(context, const AdminReportsAuditScreen()),
          ),
          _ControlLink(
            icon: Icons.chat,
            title: 'پیام و هماهنگی واحدها',
            onTap: () => _push(context, const AdminChatManagementScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('خروج'),
            onTap: appState.logout,
          ),
        ],
      ),
    );
  }
}

class _ControlLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ControlLink({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _HubTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: AppDecorations.cardDecoration,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: <Widget>[
                  Icon(icon, color: AppColors.primary, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _AdminStat({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTab {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;

  const _AdminTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });
}
