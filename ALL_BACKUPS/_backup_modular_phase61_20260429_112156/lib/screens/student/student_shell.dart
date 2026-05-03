import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import '../units/units_screen.dart';
import '../services/other_services_screen.dart';
import 'classes/student_weekly_schedule_screen.dart';
import 'dashboard/student_dashboard_screen.dart';
import 'settings/student_settings_screen.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
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
      StudentDashboardScreen(
        onOpenWeeklySchedule: () => setTab(1),
        onOpenUnits: () => setTab(2),
        onOpenServices: () => setTab(3),
      ),
      const StudentWeeklyScheduleScreen(),
      const UnitsScreen(),
      const OtherServicesScreen(),
      const StudentSettingsScreen(),
    ];

    return RoleShellLayout(
      titleKey: 'university_app',
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
          icon: const Icon(Icons.calendar_month_outlined),
          activeIcon: const Icon(Icons.calendar_month),
          label: appText(lang, 'classes'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_balance_outlined),
          activeIcon: const Icon(Icons.account_balance),
          label: appText(lang, 'units'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.apps_outlined),
          activeIcon: const Icon(Icons.apps),
          label: appText(lang, 'services'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: appText(lang, 'settings'),
        ),
      ],
    );
  }
}

