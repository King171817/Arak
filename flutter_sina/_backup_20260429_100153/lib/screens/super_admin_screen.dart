import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';
import '../widgets/common_widgets.dart';
import 'education_classes_screen.dart';
import 'services_screen.dart';
import 'settings_screen.dart';

class SuperAdminScreen extends StatefulWidget {
  const SuperAdminScreen({super.key});
  @override
  State<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    final pages = [_dashboard(context), const EducationClassesScreen(), _users(context), _reports(context), const ServicesScreen(), const SettingsScreen()];
    return AppScaffold(
      title: tr(lang, 'super_admin'),
      body: pages[tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => tab = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: tr(lang, 'dashboard')),
          BottomNavigationBarItem(icon: const Icon(Icons.class_), label: tr(lang, 'classes')),
          BottomNavigationBarItem(icon: const Icon(Icons.people), label: tr(lang, 'users')),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: tr(lang, 'reports')),
          BottomNavigationBarItem(icon: const Icon(Icons.apps), label: tr(lang, 'services')),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: tr(lang, 'settings')),
        ],
      ),
    );
  }

  Widget _dashboard(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    return ListView(padding: const EdgeInsets.all(16), children: [
      const UserHeader(),
      InfoCard(title: tr(lang, 'users'), value: '${app.users.length}', icon: Icons.people),
      InfoCard(title: tr(lang, 'classes'), value: '${app.classes.length}', icon: Icons.class_),
      InfoCard(title: tr(lang, 'reports'), value: appText(lang, 'گزارش کامل همه بخش‌ها فعال است', 'Full reports for all sections are enabled', 'التقارير الكاملة مفعلة'), icon: Icons.bar_chart),
      InfoCard(title: tr(lang, 'access'), value: appText(lang, 'دسترسی کامل به همه قسمت‌ها', 'Full access to all sections', 'صلاحية كاملة'), icon: Icons.admin_panel_settings),
    ]);
  }

  Widget _users(BuildContext context) {
    final app = context.watch<AppState>();
    return ListView(padding: const EdgeInsets.all(16), children: app.users.map((u) => Card(child: ListTile(leading: const Icon(Icons.person), title: Text(u.name), subtitle: Text('${u.username} | ${u.role.name}'), trailing: const Icon(Icons.edit)))).toList());
  }

  Widget _reports(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    return ListView(padding: const EdgeInsets.all(16), children: [
      InfoCard(title: appText(lang, 'تعداد کاربران', 'User count', 'عدد المستخدمين'), value: '${app.users.length}', icon: Icons.people),
      InfoCard(title: appText(lang, 'تعداد کلاس‌ها', 'Class count', 'عدد الفصول'), value: '${app.classes.length}', icon: Icons.class_),
      InfoCard(title: appText(lang, 'کلاس‌های فعال', 'Live classes', 'الفصول المباشرة'), value: '${app.liveSessions.values.where((s) => s.isStarted).length}', icon: Icons.live_tv),
      InfoCard(title: appText(lang, 'اعلان‌ها', 'Notifications', 'الإشعارات'), value: '${app.notifications.length}', icon: Icons.notifications),
    ]);
  }
}
