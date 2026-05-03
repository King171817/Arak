import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme.dart';
import '../../state/admin_control_state.dart';
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
  final AdminControlState adminControl = AdminControlState();
  int currentIndex = 0;

  void setTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return ChangeNotifierProvider<AdminControlState>.value(
      value: adminControl,
      child: Builder(
        builder: (BuildContext context) {
          final List<_AdminTab> tabs = <_AdminTab>[
            _AdminTab(
              label: 'کنترل',
              icon: Icons.admin_panel_settings_outlined,
              activeIcon: Icons.admin_panel_settings,
              page: _SuperAdminControlCenter(onOpenTab: setTab),
            ),
            const _AdminTab(
              label: 'کاربران',
              icon: Icons.people_alt_outlined,
              activeIcon: Icons.people_alt,
              page: _AdminUsersPage(),
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
        },
      ),
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
    final AdminControlState admin = context.watch<AdminControlState>();

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
                    'مرکز کنترل کامل مدیر اصلی',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
              _AdminStat(icon: Icons.people_alt_outlined, title: 'کاربران', value: '${admin.users.length}'),
              _AdminStat(icon: Icons.lock_outline, title: 'بخش‌های قفل‌شده', value: '${admin.sections.where((s) => s.locked).length}'),
              _AdminStat(icon: Icons.business_center_outlined, title: 'خدمات فعال', value: '${admin.services.where((s) => s.active).length}'),
              _AdminStat(icon: Icons.history_outlined, title: 'لاگ فعالیت', value: '${admin.logs.length}'),
              _AdminStat(icon: Icons.school_outlined, title: 'کلاس‌ها', value: '${appState.educationClasses.length}'),
              _AdminStat(icon: Icons.confirmation_number_outlined, title: 'تیکت‌ها', value: '${appState.studentTickets.length}'),
              _AdminStat(icon: Icons.support_agent_outlined, title: 'پشتیبانی', value: '${appState.supportRequests.length}'),
              _AdminStat(icon: Icons.tune_outlined, title: 'تنظیمات ظاهر', value: '${appState.uiSectionSettings.length}'),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionLabel(title: 'کنترل‌های اصلی', icon: Icons.flash_on_outlined),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 3.7,
            children: <Widget>[
              _AdminAction(icon: Icons.people_alt_outlined, title: 'مدیریت کاربران', subtitle: 'قفل، نقش، واحد و دسترسی', onTap: () => onOpenTab(1)),
              _AdminAction(icon: Icons.lock_outline, title: 'قفل بخش‌ها', subtitle: 'تعمیرات موقت و پیام', onTap: () => onOpenTab(4)),
              _AdminAction(icon: Icons.campaign_outlined, title: 'پیام شناور', subtitle: 'بخش، نقش، کاربر، زبان و زمان', onTap: () => onOpenTab(4)),
              _AdminAction(icon: Icons.design_services_outlined, title: 'ظاهر برنامه', subtitle: 'آیکون، فونت، لوگو و بک‌گراند', onTap: () => onOpenTab(2)),
              _AdminAction(icon: Icons.business_center_outlined, title: 'خدمات و شرکت‌ها', subtitle: 'فعال‌سازی، API، ارائه‌دهنده', onTap: () => onOpenTab(3)),
              _AdminAction(icon: Icons.support_agent_outlined, title: 'دیتاست پشتیبانی', subtitle: 'پرسش، پاسخ و ارجاع واحد', onTap: () => onOpenTab(4)),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionLabel(title: 'لاگ فعالیت‌ها', icon: Icons.history_outlined),
          const SizedBox(height: 8),
          if (admin.logs.isEmpty)
            const _AdminInfoTile(
              icon: Icons.info_outline,
              title: 'هنوز فعالیتی ثبت نشده است',
              subtitle: 'با قفل کاربر، تغییر خدمت، ثبت پیام شناور یا تغییر بخش، لاگ فعالیت ثبت می‌شود.',
            )
          else
            ...admin.logs.take(12).map((AdminActivityLog log) {
              return _AdminInfoTile(
                icon: Icons.history_outlined,
                title: log.action,
                subtitle: '${log.target} - ${log.createdAt}',
              );
            }),
        ],
      ),
    );
  }
}

class _AdminUsersPage extends StatelessWidget {
  const _AdminUsersPage();

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.watch<AdminControlState>();

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
                Icon(Icons.people_alt_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت کاربران، نقش‌ها و قفل دسترسی',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...admin.users.map((AdminManagedUser user) {
            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              decoration: AppDecorations.cardDecoration,
              child: SwitchListTile(
                dense: true,
                secondary: Icon(user.locked ? Icons.lock_outline : Icons.lock_open_outlined),
                title: Text(user.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text('${user.role} / ${user.unit}', style: const TextStyle(fontSize: 10)),
                value: user.locked,
                onChanged: (bool value) {
                  admin.toggleUserLock(user.id, value);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AdminSystemPage extends StatefulWidget {
  final AppState appState;

  const _AdminSystemPage({
    required this.appState,
  });

  @override
  State<_AdminSystemPage> createState() => _AdminSystemPageState();
}

class _AdminSystemPageState extends State<_AdminSystemPage> {
  final TextEditingController sectionMessageCtrl = TextEditingController();
  final TextEditingController floatingTitleCtrl = TextEditingController();
  final TextEditingController floatingMessageCtrl = TextEditingController();
  final TextEditingController supportQuestionCtrl = TextEditingController();
  final TextEditingController supportAnswerCtrl = TextEditingController();

  String selectedSectionId = 'dashboard';
  String floatingTargetType = 'section';
  String floatingTargetKey = 'dashboard';
  String floatingLang = 'FA';
  int floatingDays = 7;

  @override
  void dispose() {
    sectionMessageCtrl.dispose();
    floatingTitleCtrl.dispose();
    floatingMessageCtrl.dispose();
    supportQuestionCtrl.dispose();
    supportAnswerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.watch<AdminControlState>();

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
                  title: const Text('حالت تعمیرات کل سامانه'),
                  subtitle: Text(widget.appState.maintenanceMessageForCurrentLang()),
                  value: widget.appState.maintenanceMode,
                  onChanged: widget.appState.setMaintenanceMode,
                ),
                SwitchListTile(
                  dense: true,
                  title: const Text('ثبت‌نام فعال باشد'),
                  value: widget.appState.registrationEnabled,
                  onChanged: widget.appState.setRegistrationEnabled,
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.logout),
                  title: const Text('خروج'),
                  onTap: widget.appState.logout,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionLabel(title: 'قفل بخش و پیام تعمیرات', icon: Icons.lock_outline),
          const SizedBox(height: 8),
          ...admin.sections.map((AdminManagedSection section) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: AppDecorations.cardDecoration,
              child: ExpansionTile(
                leading: Icon(section.icon, size: 22),
                title: Text(section.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text(
                  section.locked ? 'قفل است: ${section.maintenanceMessage}' : 'فعال است',
                  style: const TextStyle(fontSize: 10),
                ),
                children: <Widget>[
                  SwitchListTile(
                    dense: true,
                    title: const Text('این بخش قفل شود'),
                    value: section.locked,
                    onChanged: (bool value) {
                      admin.toggleSectionLock(section.id, value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: TextEditingController(text: section.maintenanceMessage),
                      decoration: const InputDecoration(
                        labelText: 'پیام تعمیرات این بخش',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (String value) {
                        admin.updateSectionMessage(section.id, value);
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          _SectionLabel(title: 'ساخت پیام شناور زمان‌دار', icon: Icons.campaign_outlined),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.cardDecoration,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: floatingTargetType,
                        decoration: const InputDecoration(labelText: 'نوع هدف'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(value: 'section', child: Text('بخش')),
                          DropdownMenuItem(value: 'role', child: Text('نقش')),
                          DropdownMenuItem(value: 'user', child: Text('کاربر')),
                        ],
                        onChanged: (String? value) {
                          if (value == null) return;
                          setState(() => floatingTargetType = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'کلید هدف'),
                        controller: TextEditingController(text: floatingTargetKey),
                        onSubmitted: (String value) {
                          floatingTargetKey = value.trim();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: floatingTitleCtrl,
                  decoration: const InputDecoration(labelText: 'عنوان پیام شناور'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: floatingMessageCtrl,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'متن پیام شناور'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: floatingLang,
                        decoration: const InputDecoration(labelText: 'زبان'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(value: 'FA', child: Text('FA')),
                          DropdownMenuItem(value: 'EN', child: Text('EN')),
                          DropdownMenuItem(value: 'AR', child: Text('AR')),
                        ],
                        onChanged: (String? value) {
                          if (value == null) return;
                          setState(() => floatingLang = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 30,
                        divisions: 29,
                        label: '$floatingDays روز',
                        value: floatingDays.toDouble(),
                        onChanged: (double value) {
                          setState(() => floatingDays = value.round());
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      admin.addFloatingMessage(
                        targetType: floatingTargetType,
                        targetKey: floatingTargetKey.trim().isEmpty ? 'dashboard' : floatingTargetKey.trim(),
                        lang: floatingLang,
                        title: floatingTitleCtrl.text.trim(),
                        message: floatingMessageCtrl.text.trim(),
                        activeDays: floatingDays,
                      );
                      floatingTitleCtrl.clear();
                      floatingMessageCtrl.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('ثبت پیام شناور'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...admin.floatingMessages.map((AdminFloatingMessage item) {
            return SwitchListTile(
              dense: true,
              title: Text(item.title),
              subtitle: Text('${item.targetType}/${item.targetKey} - ${item.lang} - تا ${item.endAt}'),
              value: item.active,
              onChanged: (bool value) {
                admin.toggleFloatingMessage(item.id, value);
              },
            );
          }),
          const SizedBox(height: 12),
          _SectionLabel(title: 'دیتاست پشتیبانی هوشمند', icon: Icons.smart_toy_outlined),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.cardDecoration,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: supportQuestionCtrl,
                  decoration: const InputDecoration(labelText: 'کلید سؤال / عبارت کاربر'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: supportAnswerCtrl,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'پاسخ هوشمند'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      admin.addSupportKnowledge(
                        question: supportQuestionCtrl.text.trim(),
                        answer: supportAnswerCtrl.text.trim(),
                        targetUnit: 'support',
                      );
                      supportQuestionCtrl.clear();
                      supportAnswerCtrl.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('افزودن به دیتاست پشتیبانی'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...admin.supportKnowledge.map((AdminSupportKnowledge item) {
            return SwitchListTile(
              dense: true,
              title: Text(item.question),
              subtitle: Text(item.answer),
              value: item.active,
              onChanged: (bool value) {
                admin.toggleSupportKnowledge(item.id, value);
              },
            );
          }),
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

