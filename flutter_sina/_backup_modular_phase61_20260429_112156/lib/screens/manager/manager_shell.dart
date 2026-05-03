import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import '../services/other_services_screen.dart';
import 'dashboard/manager_dashboard_screen.dart';
import 'classes/manager_classes_screen.dart';
import 'messages/manager_messages_screen.dart';
import 'officers/manager_officers_screen.dart';
import 'reports/manager_reports_screen.dart';
import 'students/student_profile_management_screen.dart';

class ManagerShell extends StatefulWidget {
  const ManagerShell({super.key});

  @override
  State<ManagerShell> createState() => _ManagerShellState();
}

class _ManagerShellState extends State<ManagerShell> {
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
    final bool canSeeClasses = appState.canSeeClassesInBottomNav;

    final List<Widget> pages = <Widget>[
      ManagerDashboardScreen(
        onOpenStudents: () => setTab(canSeeClasses ? 2 : 1),
        onOpenOfficers: () => setTab(canSeeClasses ? 3 : 2),
        onOpenReports: () => setTab(canSeeClasses ? 4 : 3),
        onOpenMessages: () => setTab(canSeeClasses ? 5 : 4),
      ),
      if (canSeeClasses)
        const ManagerClassesScreen(),
      const StudentProfileManagementScreen(),
      const ManagerOfficersScreen(),
      const ManagerReportsScreen(),
      const ManagerMessagesScreen(),
      const OtherServicesScreen(),
    ];

    final List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.dashboard_outlined),
        activeIcon: const Icon(Icons.dashboard),
        label: appText(lang, 'dashboard'),
      ),
      if (canSeeClasses)
        BottomNavigationBarItem(
          icon: const Icon(Icons.school_outlined),
          activeIcon: const Icon(Icons.school),
          label: appText(lang, 'classes'),
        ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.people_outline),
        activeIcon: const Icon(Icons.people),
        label: appText(lang, 'students'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.admin_panel_settings_outlined),
        activeIcon: const Icon(Icons.admin_panel_settings),
        label: appText(lang, 'officers'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.analytics_outlined),
        activeIcon: const Icon(Icons.analytics),
        label: appText(lang, 'reports'),
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
    ];

    return RoleShellLayout(
      titleKey: appState.isEducationManager || appState.isEducationOfficer
          ? 'education'
          : appState.currentUnitKey,
      currentIndex: currentIndex,
      onBottomTap: setTab,
      body: pages[currentIndex],
      bottomItems: items,
    );
  }
}

