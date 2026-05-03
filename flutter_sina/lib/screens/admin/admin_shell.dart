import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import '../services/other_services_screen.dart';
import '../education/education_expert_panel_screen.dart';
import '../education/education_expert_management_screen.dart';
import '../reports/daily_activity_report_screen.dart';
import 'access_management/admin_access_management_screen.dart';
import 'chat/admin_chat_management_screen.dart';
import 'dataset/admin_dataset_settings_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final tabs = <_AdminTab>[
      _AdminTab(
        label: t(lang, 'dashboard'),
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        page: const _AdminDashboardSafe(),
      ),
      _AdminTab(
        label: t(lang, 'students'),
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        page: const _SafeAdminPage(child: AdminUsersScreen()),
      ),
      _AdminTab(
        label: t(lang, 'settings'),
        icon: Icons.palette_outlined,
        activeIcon: Icons.palette,
        page: const _SafeAdminPage(child: AdminUiSettingsScreen()),
      ),
      _AdminTab(
        label: t(lang, 'services'),
        icon: Icons.business_center_outlined,
        activeIcon: Icons.business_center,
        page: const _SafeAdminPage(child: AdminServicesManagementScreen()),
      ),
      _AdminTab(
        label: t(lang, 'admin_control_center'),
        icon: Icons.admin_panel_settings_outlined,
        activeIcon: Icons.admin_panel_settings,
        page: const _AdminControlSafe(),
      ),
    ];

    if (currentIndex >= tabs.length) currentIndex = 0;

    return RoleShellLayout(
      titleKey: 'university_app',
      currentIndex: currentIndex,
      onBottomTap: (i) => setState(() => currentIndex = i),
      body: tabs[currentIndex].page,
      bottomItems: tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}

class _SafeAdminPage extends StatelessWidget {
  final Widget child;

  const _SafeAdminPage({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: child,
      ),
    );
  }
}

class _AdminDashboardSafe extends StatelessWidget {
  const _AdminDashboardSafe();

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(child: page),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final width = MediaQuery.of(context).size.width;
    final columns = width > 1000 ? 4 : width > 650 ? 3 : 2;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Container(
          decoration: AppDecorations.pageBackground(context),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              _SmallHeader(title: t(lang, 'admin_control_center')),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 3.4,
                children: [
                  _MiniStat(icon: Icons.school_outlined, title: t(lang, 'classes'), value: '${appState.educationClasses.length}'),
                  _MiniStat(icon: Icons.confirmation_number_outlined, title: t(lang, 'tickets'), value: '${appState.studentTickets.length}'),
                  _MiniStat(icon: Icons.support_agent_outlined, title: t(lang, 'services'), value: '${appState.supportRequests.length}'),
                  _MiniStat(icon: Icons.tune_outlined, title: t(lang, 'settings'), value: '${appState.uiSectionSettings.length}'),
                ],
              ),
              const SizedBox(height: 8),
              _MiniAction(icon: Icons.people_outline, title: t(lang, 'students'), onTap: () => _open(context, const AdminUsersScreen())),
              _MiniAction(icon: Icons.badge_outlined, title: t(lang, 'education_expert_panel'), onTap: () => _open(context, const EducationExpertPanelScreen())),
              _MiniAction(icon: Icons.manage_accounts_outlined, title: t(lang, 'expert_management'), onTap: () => _open(context, const EducationExpertManagementScreen())),
              _MiniAction(icon: Icons.assignment_outlined, title: t(lang, 'daily_report'), onTap: () => _open(context, const DailyActivityReportScreen(isMainAdmin: true))),
              _MiniAction(icon: Icons.lock_outline, title: t(lang, 'settings'), onTap: () => _open(context, const AdminSectionLocksScreen())),
              _MiniAction(icon: Icons.campaign_outlined, title: t(lang, 'floating_announcement'), onTap: () => _open(context, const AdminGlobalSettingsScreen())),
              _MiniAction(icon: Icons.security_outlined, title: t(lang, 'admin_control_center'), onTap: () => _open(context, const AdminAccessManagementScreen())),
              _MiniAction(icon: Icons.storage_outlined, title: 'تنظیم دیتاست', onTap: () => _open(context, const AdminDatasetSettingsScreen())),
              _MiniAction(icon: Icons.assessment_outlined, title: t(lang, 'reports'), onTap: () => _open(context, const AdminReportsAuditScreen())),
              _MiniAction(icon: Icons.forum_outlined, title: t(lang, 'managers_chat'), onTap: () => _open(context, const AdminChatManagementScreen())),
              _MiniAction(
                icon: Icons.apps_outlined,
                title: t(lang, 'other_services'),
                onTap: () => _open(context, OtherServicesScreen(onBack: () => Navigator.of(context).pop())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminControlSafe extends StatelessWidget {
  const _AdminControlSafe();

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(child: page),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Container(
          decoration: AppDecorations.pageBackground(context),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              _SmallHeader(title: t(lang, 'admin_control_center')),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      dense: true,
                      title: Text(t(lang, 'settings'), style: const TextStyle(fontSize: 12)),
                      value: appState.maintenanceMode,
                      onChanged: appState.setMaintenanceMode,
                    ),
                    SwitchListTile(
                      dense: true,
                      title: Text(t(lang, 'login'), style: const TextStyle(fontSize: 12)),
                      value: appState.registrationEnabled,
                      onChanged: appState.setRegistrationEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _MiniAction(icon: Icons.lock_outline, title: t(lang, 'settings'), onTap: () => _open(context, const AdminSectionLocksScreen())),
              _MiniAction(icon: Icons.campaign_outlined, title: t(lang, 'floating_announcement'), onTap: () => _open(context, const AdminGlobalSettingsScreen())),
              _MiniAction(icon: Icons.security_outlined, title: t(lang, 'admin_control_center'), onTap: () => _open(context, const AdminAccessManagementScreen())),
              _MiniAction(icon: Icons.storage_outlined, title: 'تنظیم دیتاست', onTap: () => _open(context, const AdminDatasetSettingsScreen())),
              _MiniAction(icon: Icons.assessment_outlined, title: t(lang, 'reports'), onTap: () => _open(context, const AdminReportsAuditScreen())),
              _MiniAction(icon: Icons.forum_outlined, title: t(lang, 'managers_chat'), onTap: () => _open(context, const AdminChatManagementScreen())),
              _MiniAction(icon: Icons.logout, title: t(lang, 'logout'), onTap: appState.logout),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallHeader extends StatelessWidget {
  final String title;

  const _SmallHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.headerDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.admin_panel_settings_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        child: Row(
          children: [
            Icon(icon, size: 17, color: AppColors.primary),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 9),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MiniAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
        leading: Icon(icon, size: 19, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_left, size: 17),
        onTap: onTap,
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


