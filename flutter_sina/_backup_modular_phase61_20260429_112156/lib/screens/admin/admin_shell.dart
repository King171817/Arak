import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_lang.dart';
import '../../models/notifications/floating_announcement_model.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';

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
    final AppLang lang = appState.selectedLang;

    final List<Widget> pages = <Widget>[
      _AdminDashboard(onOpenSettings: () => setTab(1), onOpenReports: () => setTab(2)),
      const _AdminGlobalSettings(),
      const _AdminReports(),
      const _AdminUsers(),
      const _AdminPermissions(),
    ];

    return RoleShellLayout(
      titleKey: 'admin_control_center',
      currentIndex: currentIndex,
      onBottomTap: setTab,
      body: pages[currentIndex],
      bottomItems: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          activeIcon: const Icon(Icons.dashboard),
          label: appText(lang, 'dashboard'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: appText(lang, 'settings'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.analytics_outlined),
          activeIcon: const Icon(Icons.analytics),
          label: appText(lang, 'reports'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.people_outline),
          activeIcon: const Icon(Icons.people),
          label: appText(lang, 'students'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.security_outlined),
          activeIcon: const Icon(Icons.security),
          label: appText(lang, 'officers'),
        ),
      ],
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenReports;

  const _AdminDashboard({
    required this.onOpenSettings,
    required this.onOpenReports,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        DashboardCard(
          title: appText(lang, 'floating_announcement'),
          subtitle: isRtlLang(lang)
              ? 'پیام شناور چندزبانه، زمان‌دار و هدفمند'
              : 'Multilingual timed targeted floating message',
          icon: Icons.campaign_outlined,
          onTap: onOpenSettings,
        ),
        DashboardCard(
          title: appText(lang, 'reports'),
          subtitle: isRtlLang(lang)
              ? 'گزارش‌گیری، فیلتر و بررسی عملکرد'
              : 'Reports, filters and activity review',
          icon: Icons.analytics_outlined,
          onTap: onOpenReports,
        ),
        DashboardCard(
          title: isRtlLang(lang) ? 'مدیریت نقش‌ها و دسترسی‌ها' : 'Roles and Permissions',
          subtitle: isRtlLang(lang)
              ? 'ویرایش نقش‌ها، وظایف و مجوزها'
              : 'Edit roles, duties and permissions',
          icon: Icons.security_outlined,
        ),
        DashboardCard(
          title: isRtlLang(lang) ? 'قفل کاربران و بخش‌ها' : 'Lock Users and Sections',
          subtitle: isRtlLang(lang)
              ? 'قفل کردن شخص، واحد یا بخش برنامه'
              : 'Lock a person, unit or app section',
          icon: Icons.lock_outline,
        ),
        DashboardCard(
          title: isRtlLang(lang) ? 'تغییر آرم و بک‌گراند' : 'Logo and Background',
          subtitle: isRtlLang(lang)
              ? 'تغییر ظاهر برنامه برای دانشگاه یا مناسبت‌ها'
              : 'Change app appearance for university or events',
          icon: Icons.palette_outlined,
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('sina'),
            subtitle: Text(
              'Classes: ${appState.educationClasses.length} | Officers: ${appState.educationOfficers.length} | Messages: ${appState.managerMessages.length}',
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminGlobalSettings extends StatefulWidget {
  const _AdminGlobalSettings();

  @override
  State<_AdminGlobalSettings> createState() => _AdminGlobalSettingsState();
}

class _AdminGlobalSettingsState extends State<_AdminGlobalSettings> {
  final TextEditingController faCtrl = TextEditingController();
  final TextEditingController enCtrl = TextEditingController();
  final TextEditingController arCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController(text: '4');

  FloatingAnnouncementTarget selectedTarget = FloatingAnnouncementTarget.all;
  String durationType = 'hours';

  @override
  void dispose() {
    faCtrl.dispose();
    enCtrl.dispose();
    arCtrl.dispose();
    durationCtrl.dispose();
    super.dispose();
  }

  DateTime? buildExpiresAt() {
    final int value = int.tryParse(durationCtrl.text.trim()) ?? 0;

    if (value <= 0) return null;

    if (durationType == 'days') {
      return DateTime.now().add(Duration(days: value));
    }

    return DateTime.now().add(Duration(hours: value));
  }

  void saveAnnouncement() {
    final AppState appState = context.read<AppState>();

    appState.setFloatingAnnouncement(
      FloatingAnnouncementModel(
        id: 'fa_${DateTime.now().millisecondsSinceEpoch}',
        textFa: faCtrl.text.trim().isEmpty ? 'اطلاعیه جدید دانشگاه' : faCtrl.text.trim(),
        textEn: enCtrl.text.trim().isEmpty ? 'New university announcement' : enCtrl.text.trim(),
        textAr: arCtrl.text.trim().isEmpty ? 'إعلان جامعي جديد' : arCtrl.text.trim(),
        target: selectedTarget,
        createdAt: DateTime.now(),
        expiresAt: buildExpiresAt(),
        isActive: true,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('اعلان شناور ذخیره شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'floating_announcement'),
          icon: Icons.campaign_outlined,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: faCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'متن فارسی',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: enCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'English text',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: arCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'النص العربي',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<FloatingAnnouncementTarget>(
                  initialValue: selectedTarget,
                  decoration: const InputDecoration(
                    labelText: 'گروه هدف',
                    border: OutlineInputBorder(),
                  ),
                  items: FloatingAnnouncementTarget.values.map((target) {
                    return DropdownMenuItem(
                      value: target,
                      child: Text(target.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedTarget = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: durationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'مدت نمایش',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: durationType,
                        decoration: const InputDecoration(
                          labelText: 'نوع زمان',
                          border: OutlineInputBorder(),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(value: 'hours', child: Text('ساعت')),
                          DropdownMenuItem(value: 'days', child: Text('روز')),
                          DropdownMenuItem(value: 'unlimited', child: Text('نامحدود')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            durationType = value;
                            if (value == 'unlimited') {
                              durationCtrl.text = '0';
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: saveAnnouncement,
                    icon: const Icon(Icons.save),
                    label: const Text('ذخیره و اعمال برای کاربران'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: isRtlLang(lang) ? 'قفل سیستم و ثبت‌نام' : 'System Lock and Registration',
          icon: Icons.lock_outline,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text('حالت تعمیرات سیستم'),
                subtitle: Text(appState.maintenanceMessageForCurrentLang()),
                value: appState.maintenanceMode,
                onChanged: appState.setMaintenanceMode,
              ),
              SwitchListTile(
                title: const Text('فعال بودن ثبت‌نام'),
                subtitle: const Text('اگر خاموش شود، ثبت‌نام کاربران جدید غیرفعال می‌شود.'),
                value: appState.registrationEnabled,
                onChanged: appState.setRegistrationEnabled,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  onPressed: () {
                    appState.setMaintenanceMessages(
                      fa: 'سامانه طبق تنظیم مدیر اصلی در حال بروزرسانی است.',
                      en: 'The system is under maintenance based on super admin settings.',
                      ar: 'النظام قيد الصيانة حسب إعدادات المدير الرئيسي.',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('پیام تعمیرات ذخیره شد.')),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('ذخیره پیام تعمیرات پیش‌فرض'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: isRtlLang(lang) ? 'ظاهر سیستم' : 'System Appearance',
          icon: Icons.palette_outlined,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: Text(isRtlLang(lang) ? 'حالت تیره' : 'Dark mode'),
                value: appState.isDarkMode,
                onChanged: (_) => appState.toggleTheme(),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<String>(
                  initialValue: appState.selectedLogoKey,
                  decoration: const InputDecoration(
                    labelText: 'آرم برنامه',
                    border: OutlineInputBorder(),
                  ),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: 'default', child: Text('آرم پیش‌فرض دانشگاه')),
                    DropdownMenuItem(value: 'international', child: Text('آرم بین‌الملل')),
                    DropdownMenuItem(value: 'education', child: Text('آرم آموزشی')),
                    DropdownMenuItem(value: 'event', child: Text('آرم مناسبتی')),
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;
                    appState.setLogoKey(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<String>(
                  initialValue: appState.selectedBackgroundKey,
                  decoration: const InputDecoration(
                    labelText: 'بک‌گراند سیستم',
                    border: OutlineInputBorder(),
                  ),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: 'spring', child: Text('بهاری')),
                    DropdownMenuItem(value: 'classic', child: Text('کلاسیک دانشگاهی')),
                    DropdownMenuItem(value: 'dark_glow', child: Text('تیره با نقاط نورانی')),
                    DropdownMenuItem(value: 'minimal', child: Text('مینیمال')),
                    DropdownMenuItem(value: 'event', child: Text('مناسبتی')),
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;
                    appState.setBackgroundKey(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdminReports extends StatelessWidget {
  const _AdminReports();

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'reports'),
          icon: Icons.analytics_outlined,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.class_outlined),
                title: const Text('گزارش کلاس‌ها'),
                subtitle: Text('تعداد کلاس‌ها: ${appState.educationClasses.length}'),
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: const Text('گزارش کارشناسان'),
                subtitle: Text('تعداد کارشناسان: ${appState.educationOfficers.length}'),
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('گزارش پیام‌ها'),
                subtitle: Text('تعداد پیام‌ها: ${appState.managerMessages.length}'),
              ),
              const ListTile(
                leading: Icon(Icons.filter_alt_outlined),
                title: Text('فیلتر پیشرفته'),
                subtitle: Text('واحد، نقش، تاریخ، وضعیت و نوع گزارش'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdminUsers extends StatelessWidget {
  const _AdminUsers();

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'students'),
          icon: Icons.people_outline,
          child: Column(
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.search),
                title: Text('جستجو و فیلتر کاربران'),
                subtitle: Text('دانشجو، استاد، مدیر، کارشناس'),
              ),
              ...appState.educationOfficers.map((officer) {
                return ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: Text(officer.name),
                  subtitle: Text(officer.username),
                  trailing: const Icon(Icons.lock_open_outlined),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdminPermissions extends StatelessWidget {
  const _AdminPermissions();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: isRtlLang(lang) ? 'نقش‌ها و دسترسی‌ها' : 'Roles and Permissions',
          icon: Icons.security_outlined,
          child: const Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.manage_accounts_outlined),
                title: Text('مدیریت نقش‌ها'),
                subtitle: Text('دانشجو، استاد، مدیر واحد، کارشناس، مدیر اصلی'),
              ),
              ListTile(
                leading: Icon(Icons.rule_outlined),
                title: Text('مدیریت وظایف و مجوزها'),
                subtitle: Text('فعال/غیرفعال کردن کوچک‌ترین بخش‌ها'),
              ),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('قفل شخص یا بخش'),
                subtitle: Text('قفل کاربر، صفحه، واحد یا قابلیت خاص'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



