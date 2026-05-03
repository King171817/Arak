import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/app_colors.dart';
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
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final tabs = <_AdminTab>[
      _AdminTab(
        label: t(lang, 'dashboard'),
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        page: const _AdminMainDashboard(),
      ),
      _AdminTab(
        label: t(lang, 'students'),
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        page: const AdminUsersScreen(),
      ),
      _AdminTab(
        label: t(lang, 'settings'),
        icon: Icons.tune_outlined,
        activeIcon: Icons.tune,
        page: const AdminUiSettingsScreen(),
      ),
      _AdminTab(
        label: t(lang, 'services'),
        icon: Icons.business_center_outlined,
        activeIcon: Icons.business_center,
        page: const AdminServicesManagementScreen(),
      ),
      _AdminTab(
        label: t(lang, 'admin_control_center'),
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        page: const _AdminControlHub(),
      ),
    ];

    if (currentIndex >= tabs.length) currentIndex = 0;

    return RoleShellLayout(
      titleKey: 'university_app',
      currentIndex: currentIndex,
      onBottomTap: setTab,
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

class _AdminMainDashboard extends StatelessWidget {
  const _AdminMainDashboard();

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _openLiveClass(BuildContext context, AppState appState) {
    if (appState.educationClasses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کلاسی ثبت نشده است.')),
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
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings_outlined, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t(lang, 'admin_control_center'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: isWide ? 3.8 : 3.1,
            children: [
              _AdminStat(
                icon: Icons.school_outlined,
                title: t(lang, 'classes'),
                value: '${appState.educationClasses.length}',
              ),
              _AdminStat(
                icon: Icons.confirmation_number_outlined,
                title: t(lang, 'tickets'),
                value: '${appState.studentTickets.length}',
              ),
              _AdminStat(
                icon: Icons.support_agent_outlined,
                title: t(lang, 'services'),
                value: '${appState.supportRequests.length}',
              ),
              _AdminStat(
                icon: Icons.widgets_outlined,
                title: t(lang, 'settings'),
                value: '${appState.uiSectionSettings.length}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            t(lang, 'services'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          _HubTile(
            icon: Icons.manage_accounts_outlined,
            title: t(lang, 'students'),
            subtitle: t(lang, 'profile'),
            onTap: () => _push(context, const AdminUsersScreen()),
          ),
          _HubTile(
            icon: Icons.lock_clock_outlined,
            title: t(lang, 'settings'),
            subtitle: t(lang, 'admin_control_center'),
            onTap: () => _push(context, const AdminSectionLocksScreen()),
          ),
          _HubTile(
            icon: Icons.campaign_outlined,
            title: t(lang, 'floating_announcement'),
            subtitle: t(lang, 'notifications'),
            onTap: () => _push(context, const AdminUiSettingsScreen()),
          ),
          _HubTile(
            icon: Icons.verified_user_outlined,
            title: t(lang, 'admin_control_center'),
            subtitle: t(lang, 'settings'),
            onTap: () => _push(context, const AdminAccessManagementScreen()),
          ),
          _HubTile(
            icon: Icons.assessment_outlined,
            title: t(lang, 'reports'),
            onTap: () => _push(context, const AdminReportsAuditScreen()),
          ),
          _HubTile(
            icon: Icons.forum_outlined,
            title: t(lang, 'managers_chat'),
            onTap: () => _push(context, const AdminChatManagementScreen()),
          ),
          _HubTile(
            icon: Icons.video_call_outlined,
            title: t(lang, 'classes'),
            onTap: () => _openLiveClass(context, appState),
          ),
          _HubTile(
            icon: Icons.public_outlined,
            title: t(lang, 'settings'),
            onTap: () => _push(context, const AdminGlobalSettingsScreen()),
          ),
          _HubTile(
            icon: Icons.apps_outlined,
            title: t(lang, 'other_services'),
            onTap: () => _push(
              context,
              OtherServicesScreen(onBack: () => Navigator.of(context).pop()),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminControlHub extends StatelessWidget {
  const _AdminControlHub();

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.settings_suggest_outlined, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t(lang, 'admin_control_center'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.cardDecoration,
            child: Column(
              children: [
                SwitchListTile(
                  dense: true,
                  title: Text(t(lang, 'settings'), style: const TextStyle(fontSize: 12)),
                  subtitle: Text(
                    appState.maintenanceMessageForCurrentLang(),
                    style: const TextStyle(fontSize: 10),
                  ),
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
          _ControlLink(
            icon: Icons.lock_outline,
            title: t(lang, 'settings'),
            onTap: () => _push(context, const AdminSectionLocksScreen()),
          ),
          _ControlLink(
            icon: Icons.public,
            title: t(lang, 'floating_announcement'),
            onTap: () => _push(context, const AdminGlobalSettingsScreen()),
          ),
          _ControlLink(
            icon: Icons.security,
            title: t(lang, 'admin_control_center'),
            onTap: () => _push(context, const AdminAccessManagementScreen()),
          ),
          _ControlLink(
            icon: Icons.history,
            title: t(lang, 'reports'),
            onTap: () => _push(context, const AdminReportsAuditScreen()),
          ),
          _ControlLink(
            icon: Icons.chat,
            title: t(lang, 'managers_chat'),
            onTap: () => _push(context, const AdminChatManagementScreen()),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.logout, color: Colors.red, size: 20),
            title: Text(t(lang, 'logout'), style: const TextStyle(fontSize: 12)),
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
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
        leading: Icon(icon, color: AppColors.primary, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_left, size: 18),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: AppDecorations.cardDecoration,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 21),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left, size: 18),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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


