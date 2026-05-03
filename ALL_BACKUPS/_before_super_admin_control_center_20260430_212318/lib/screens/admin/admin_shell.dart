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
        label: 'کنترل',
        icon: Icons.admin_panel_settings_outlined,
        activeIcon: Icons.admin_panel_settings,
        page: _SuperAdminControlCenter(onOpenTab: setTab),
      ),
      const _AdminTab(
        label: 'ظاهر',
        icon: Icons.design_services_outlined,
        activeIcon: Icons.design_services,
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

class _SuperAdminControlCenter extends StatelessWidget {
  final ValueChanged<int> onOpenTab;

  const _SuperAdminControlCenter({
    required this.onOpenTab,
  });

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
                Icon(Icons.security_outlined, color: Colors.white, size: 34),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مرکز کنترل مدیر اصلی سامانه',
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
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 4.5,
            children: <Widget>[
              _AdminStat(icon: Icons.school_outlined, title: 'کلاس‌ها', value: '${appState.educationClasses.length}'),
              _AdminStat(icon: Icons.confirmation_number_outlined, title: 'تیکت‌ها', value: '${appState.studentTickets.length}'),
              _AdminStat(icon: Icons.support_agent_outlined, title: 'پشتیبانی', value: '${appState.supportRequests.length}'),
              _AdminStat(icon: Icons.tune_outlined, title: 'تنظیمات UI', value: '${appState.uiSectionSettings.length}'),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionLabel(title: 'دسترسی‌های اصلی مدیر سامانه', icon: Icons.flash_on_outlined),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 3.7,
            children: <Widget>[
              _AdminAction(icon: Icons.people_alt_outlined, title: 'همه کاربران', subtitle: 'دانشجو، استاد، مدیر، کارشناس', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.lock_person_outlined, title: 'قفل کاربر', subtitle: 'بستن دسترسی فردی یا نقش', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.lock_outline, title: 'قفل بخش‌ها', subtitle: 'تعمیرات موقت و پیام بخش', onTap: () => onOpenTab(3)),
              _AdminAction(icon: Icons.campaign_outlined, title: 'پیام شناور', subtitle: 'زمان‌دار برای بخش، نقش یا فرد', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.analytics_outlined, title: 'گزارش لحظه‌ای', subtitle: 'فعالیت هر بخش و کاربر', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.history_outlined, title: 'لاگ فعالیت‌ها', subtitle: 'ذخیره فعالیت‌ها در دیتاست', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.chat_outlined, title: 'پیام خصوصی/گروهی', subtitle: 'ارسال به واحدها و افراد', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.support_agent_outlined, title: 'دیتاست پشتیبانی', subtitle: 'به‌روزرسانی پاسخ‌های هوشمند', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.storage_outlined, title: 'دیتابیس اصلی', subtitle: 'مدیریت داده‌ها و اتصال Supabase', onTap: () => _todo(context)),
              _AdminAction(icon: Icons.design_services_outlined, title: 'ظاهر برنامه', subtitle: 'فونت، آیکون، لوگو و بک‌گراند', onTap: () => onOpenTab(1)),
              _AdminAction(icon: Icons.business_center_outlined, title: 'خدمات و شرکت‌ها', subtitle: 'مدیریت سرویس‌های آینده', onTap: () => onOpenTab(2)),
              _AdminAction(icon: Icons.settings_applications_outlined, title: 'تنظیمات سیستم', subtitle: 'تعمیرات، ثبت‌نام، زبان و امنیت', onTap: () => onOpenTab(3)),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionLabel(title: 'کنترل و پایش سامانه', icon: Icons.monitor_heart_outlined),
          const SizedBox(height: 8),
          const _AdminInfoTile(
            icon: Icons.fact_check_outlined,
            title: 'گزارش دوره‌ای و لحظه‌ای',
            subtitle: 'در گام دیتابیس، فعالیت هر کاربر، هر تیکت، هر کلاس و هر تغییر در جدول activity_logs ذخیره می‌شود.',
          ),
          const _AdminInfoTile(
            icon: Icons.smart_toy_outlined,
            title: 'دستیار هوشمند و پشتیبانی',
            subtitle: 'مدیر اصلی می‌تواند دیتاست پاسخ‌های هوشمند را اضافه، اصلاح، غیرفعال یا به واحد مربوطه ارجاع دهد.',
          ),
          const _AdminInfoTile(
            icon: Icons.cloud_sync_outlined,
            title: 'هماهنگی با دیتابیس اصلی',
            subtitle: 'تمام تنظیمات، دسترسی‌ها، پیام‌های شناور و فایل‌های ظاهری باید در Supabase ذخیره شوند.',
          ),
        ],
      ),
    );
  }

  static void _todo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('این کنترل در UI آماده است و در گام دیتابیس به ذخیره‌سازی واقعی وصل می‌شود.'),
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
          Container(
            decoration: AppDecorations.cardDecoration,
            child: Column(
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
                const Divider(height: 1),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.campaign_outlined),
                  title: const Text('پیام شناور سراسری'),
                  subtitle: const Text('تنظیم پیام قابل نمایش در ورود کاربران'),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ویرایش پیام شناور در گام دیتابیس متصل می‌شود.')),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.logout),
                  title: const Text('خروج'),
                  onTap: appState.logout,
                ),
              ],
            ),
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
          Expanded(child: Text(title, style: const TextStyle(fontSize: 11))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _AdminAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminAction({
    required this.icon,
    required this.title,
    required this.subtitle,
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
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 19, color: AppColors.primary),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9)),
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
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionLabel({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
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
