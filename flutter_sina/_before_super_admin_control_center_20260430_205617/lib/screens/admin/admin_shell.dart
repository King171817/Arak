import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import 'services_management/admin_services_management_screen.dart';
import 'ui_settings/admin_ui_settings_screen.dart';

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
    final AppState appState = context.watch<AppState>();

    final List<_AdminTab> tabs = <_AdminTab>[
      _AdminTab(
        label: 'داشبورد',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        page: const _AdminMainDashboard(),
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
      _AdminTab(
        label: 'سیستم',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        page: _AdminSystemPage(appState: appState),
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

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return Container(
      decoration: AppDecorations.pageBackground,
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
                    'پنل مدیر اصلی سامانه',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 820 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 4.4,
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
                icon: Icons.tune_outlined,
                title: 'تنظیمات UI',
                value: '${appState.uiSectionSettings.length}',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _AdminInfoTile(
            icon: Icons.tune_outlined,
            title: 'مدیریت ظاهر و نقش‌ها',
            subtitle:
                'مدیریت آیکون، فونت، نمایش و فعال بودن بخش‌ها برای هر نقش یا بخش',
          ),
          const _AdminInfoTile(
            icon: Icons.business_center_outlined,
            title: 'مدیریت خدمات آینده',
            subtitle:
                'تعریف شرکت‌ها، سازمان‌ها، پیمانکارها، API، قرارداد و وضعیت سرویس‌ها',
          ),
          const _AdminInfoTile(
            icon: Icons.security_outlined,
            title: 'کنترل سیستم',
            subtitle:
                'حالت تعمیرات، فعال بودن ثبت‌نام، اعلان سراسری و تنظیمات امنیتی',
          ),
        ],
      ),
    );
  }
}

class _AdminSystemPage extends StatelessWidget {
  final AppState appState;

  const _AdminSystemPage({
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.pageBackground,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          SwitchListTile(
            dense: true,
            title: const Text('حالت تعمیرات'),
            subtitle: Text(appState.maintenanceMessageForCurrentLang()),
            value: appState.maintenanceMode,
            onChanged: appState.setMaintenanceMode,
          ),
          SwitchListTile(
            dense: true,
            title: const Text('ثبت‌نام فعال باشد'),
            subtitle: const Text('فعال یا غیرفعال کردن ثبت‌نام کاربران جدید'),
            value: appState.registrationEnabled,
            onChanged: appState.setRegistrationEnabled,
          ),
          const Divider(),
          ListTile(
            dense: true,
            leading: const Icon(Icons.language),
            title: const Text('زبان فعلی'),
            subtitle: Text(appState.selectedLang.name.toUpperCase()),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.logout),
            title: const Text('خروج'),
            onTap: appState.logout,
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AdminInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppDecorations.cardDecoration,
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10),
        ),
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
