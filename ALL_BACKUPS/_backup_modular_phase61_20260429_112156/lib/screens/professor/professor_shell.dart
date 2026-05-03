import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_lang.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import 'classes/professor_classes_screen.dart';
import 'dashboard/professor_dashboard_screen.dart';
import 'messages/professor_messages_screen.dart';
import '../services/other_services_screen.dart';

class ProfessorShell extends StatefulWidget {
  const ProfessorShell({super.key});

  @override
  State<ProfessorShell> createState() => _ProfessorShellState();
}

class _ProfessorShellState extends State<ProfessorShell> {
  int currentIndex = 0;

  void setTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final List<Widget> pages = <Widget>[
      ProfessorDashboardScreen(
        onOpenClasses: () => setTab(1),
        onOpenMessages: () => setTab(2),
        onOpenServices: () => setTab(3),
      ),
      const ProfessorClassesScreen(),
      const ProfessorMessagesScreen(),
      const OtherServicesScreen(),
      _ProfessorMorePanel(onOpenServices: () => setTab(3)),
    ];

    return RoleShellLayout(
      titleKey: 'professor',
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
          icon: const Icon(Icons.school_outlined),
          activeIcon: const Icon(Icons.school),
          label: appText(lang, 'classes'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_outlined),
          activeIcon: const Icon(Icons.chat),
          label: appText(lang, 'managers_chat'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.apps_outlined),
          activeIcon: const Icon(Icons.apps),
          label: appText(lang, 'services'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.more_horiz),
          activeIcon: const Icon(Icons.more),
          label: appText(lang, 'more'),
        ),
      ],
    );
  }
}

class _ProfessorMorePanel extends StatelessWidget {
  final VoidCallback onOpenServices;

  const _ProfessorMorePanel({
    required this.onOpenServices,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        DashboardCard(
          title: appText(lang, 'settings'),
          subtitle: isRtlLang(lang) ? 'تنظیمات زبان و برنامه' : 'Language and app settings',
          icon: Icons.settings_outlined,
        ),
        DashboardCard(
          title: appText(lang, 'services'),
          subtitle: isRtlLang(lang) ? 'خدمات قابل استفاده استاد' : 'Professor available services',
          icon: Icons.apps_outlined,
          onTap: onOpenServices,
        ),
      ],
    );
  }
}


