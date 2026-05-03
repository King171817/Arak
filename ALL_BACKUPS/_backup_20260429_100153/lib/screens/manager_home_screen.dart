import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';
import '../widgets/common_widgets.dart';
import 'education_classes_screen.dart';
import 'services_screen.dart';
import 'settings_screen.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});
  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    final pages = [_dashboard(context), if (app.canManageClasses) const EducationClassesScreen(), const ServicesScreen(), const SettingsScreen()];
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: tr(lang, 'dashboard')),
      if (app.canManageClasses) BottomNavigationBarItem(icon: const Icon(Icons.class_), label: tr(lang, 'classes')),
      BottomNavigationBarItem(icon: const Icon(Icons.apps), label: tr(lang, 'services')),
      BottomNavigationBarItem(icon: const Icon(Icons.settings), label: tr(lang, 'settings')),
    ];
    if (tab >= pages.length) tab = 0;
    return AppScaffold(
      title: tr(lang, 'manager'),
      body: pages[tab],
      bottomNavigationBar: BottomNavigationBar(currentIndex: tab, type: BottomNavigationBarType.fixed, onTap: (i) => setState(() => tab = i), items: items),
    );
  }

  Widget _dashboard(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    return ListView(padding: const EdgeInsets.all(16), children: [
      const UserHeader(),
      if (app.canManageClasses) InfoCard(title: tr(lang, 'classes'), value: appText(lang, 'مدیریت کلاس فقط برای واحد آموزش فعال است', 'Class management is enabled only for Education', 'إدارة الفصول للتعليم فقط'), icon: Icons.class_, onTap: () => setState(() => tab = 1)),
      InfoCard(title: tr(lang, 'services'), value: appText(lang, 'ترجمه، کتابخانه، ورزش و پرینت', 'Translation, library, sports and printing', 'الترجمة والمكتبة والرياضة والطباعة'), icon: Icons.apps),
    ]);
  }
}
