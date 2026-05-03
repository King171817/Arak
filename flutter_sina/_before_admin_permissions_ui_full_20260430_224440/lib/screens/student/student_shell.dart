import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_lang.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import '../services/other_services_screen.dart';
import '../tickets/tickets_screen.dart';
import '../units/communication/units_communication_screen.dart';
import '../units/units_screen.dart';
import 'classes/student_weekly_schedule_screen.dart';
import 'dashboard/student_dashboard_screen.dart';
import 'profile/student_profile_screen.dart';
import 'settings/student_settings_screen.dart';

enum StudentMorePage {
  menu,
  units,
  services,
  settings,
  profile,
  about,
  help,
  unitChat,
}

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int currentIndex = 0;
  StudentMorePage morePage = StudentMorePage.menu;
  String selectedUnitKey = 'education';

  void setTab(int index) {
    setState(() {
      currentIndex = index;
      if (index != 3) {
        morePage = StudentMorePage.menu;
      }
    });
  }

  void openMorePage(StudentMorePage page) {
    setState(() {
      currentIndex = 3;
      morePage = page;
    });
  }

  void openUnitChat(String unitKey) {
    setState(() {
      currentIndex = 3;
      selectedUnitKey = unitKey;
      morePage = StudentMorePage.unitChat;
    });
  }

  void backToMoreMenu() {
    setState(() {
      morePage = StudentMorePage.menu;
    });
  }

  void backToUnits() {
    setState(() {
      morePage = StudentMorePage.units;
    });
  }

  void openTabByKey(String key) {
    if (key == 'classes') {
      setTab(1);
    } else if (key == 'tickets') {
      setTab(2);
    } else {
      setTab(3);
    }
  }

  Widget buildMoreBody(AppState appState) {
    switch (morePage) {
      case StudentMorePage.units:
        return _WithInternalBack(
          title: appText(appState.selectedLang, 'units'),
          onBack: backToMoreMenu,
          child: UnitsScreen(onOpenUnit: openUnitChat),
        );

      case StudentMorePage.services:
        return OtherServicesScreen(onBack: backToMoreMenu);

      case StudentMorePage.settings:
        return _WithInternalBack(
          title: appText(appState.selectedLang, 'settings'),
          onBack: backToMoreMenu,
          child: const StudentSettingsScreen(),
        );

      case StudentMorePage.profile:
        return StudentProfileScreen(onBack: backToMoreMenu);

      case StudentMorePage.about:
        return _SimpleMorePage(
          title: 'درباره برنامه',
          icon: Icons.info_outline,
          onBack: backToMoreMenu,
          text:
              'اپلیکیشن ارتباط با دانشگاه برای ارتباط دانشجویان بین‌الملل با واحدهای دانشگاه طراحی شده است.',
        );

      case StudentMorePage.help:
        return _SimpleMorePage(
          title: 'راهنما',
          icon: Icons.help_outline,
          onBack: backToMoreMenu,
          text:
              'از داشبورد می‌توانید کلاس‌ها، درخواست‌ها، واحدها، خدمات، پروفایل و تنظیمات را مدیریت کنید.',
        );

      case StudentMorePage.unitChat:
        return _WithInternalBack(
          title: appText(appState.selectedLang, selectedUnitKey),
          onBack: backToUnits,
          child: UnitsCommunicationScreen(unitKey: selectedUnitKey),
        );

      case StudentMorePage.menu:
        return StudentMoreScreen(
          onOpenUnits: () => openMorePage(StudentMorePage.units),
          onOpenServices: () => openMorePage(StudentMorePage.services),
          onOpenSettings: () => openMorePage(StudentMorePage.settings),
          onOpenProfile: () => openMorePage(StudentMorePage.profile),
          onOpenAbout: () => openMorePage(StudentMorePage.about),
          onOpenHelp: () => openMorePage(StudentMorePage.help),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final List<_StudentTab> tabs = <_StudentTab>[
      _StudentTab(
        keyName: 'dashboard',
        labelKey: 'dashboard',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        page: StudentDashboardScreen(
          onOpenWeeklySchedule: () => openTabByKey('classes'),
          onOpenUnits: () => openMorePage(StudentMorePage.units),
          onOpenServices: () => openMorePage(StudentMorePage.services),
          onOpenTickets: () => openTabByKey('tickets'),
        ),
      ),
      const _StudentTab(
        keyName: 'classes',
        labelKey: 'classes',
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month,
        page: StudentWeeklyScheduleScreen(),
      ),
      const _StudentTab(
        keyName: 'tickets',
        labelKey: 'tickets',
        icon: Icons.confirmation_number_outlined,
        activeIcon: Icons.confirmation_number,
        page: TicketsScreen(),
      ),
      _StudentTab(
        keyName: 'more',
        labelKey: 'more',
        icon: Icons.more_horiz,
        activeIcon: Icons.more,
        page: buildMoreBody(appState),
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
      bottomItems: tabs.map((_StudentTab tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: appText(lang, tab.labelKey),
        );
      }).toList(),
    );
  }
}

class StudentMoreScreen extends StatelessWidget {
  final VoidCallback onOpenUnits;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenAbout;
  final VoidCallback onOpenHelp;

  const StudentMoreScreen({
    super.key,
    required this.onOpenUnits,
    required this.onOpenServices,
    required this.onOpenSettings,
    required this.onOpenProfile,
    required this.onOpenAbout,
    required this.onOpenHelp,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        _MoreTile(
          title: appText(lang, 'units'),
          subtitle: 'ارتباط با واحدهای دانشگاه',
          icon: Icons.account_balance_outlined,
          onTap: onOpenUnits,
        ),
        _MoreTile(
          title: appText(lang, 'other_services'),
          subtitle: 'ترجمه، تاکسی، رفاهی، بیمه، نقشه و...',
          icon: Icons.apps_outlined,
          onTap: onOpenServices,
        ),
        _MoreTile(
          title: appText(lang, 'settings'),
          subtitle: 'زبان، تم روز و شب، اعلان‌ها و امنیت',
          icon: Icons.settings_outlined,
          onTap: onOpenSettings,
        ),
        _MoreTile(
          title: appText(lang, 'profile'),
          subtitle: appState.currentUser?.displayName ?? '-',
          icon: Icons.person_outline,
          onTap: onOpenProfile,
        ),
        _MoreTile(
          title: 'راهنما',
          subtitle: 'راهنمای استفاده از برنامه',
          icon: Icons.help_outline,
          onTap: onOpenHelp,
        ),
        _MoreTile(
          title: 'درباره',
          subtitle: 'درباره اپلیکیشن و نسخه فعلی',
          icon: Icons.info_outline,
          onTap: onOpenAbout,
        ),
        _MoreTile(
          title: appText(lang, 'logout'),
          subtitle: 'خروج از حساب کاربری',
          icon: Icons.logout,
          onTap: appState.logout,
        ),
      ],
    );
  }
}

class _MoreTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MoreTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
      trailing: const Icon(Icons.chevron_right, size: 17),
      onTap: onTap,
    );
  }
}

class _WithInternalBack extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final Widget child;

  const _WithInternalBack({
    required this.title,
    required this.onBack,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          dense: true,
          leading: const Icon(Icons.arrow_back, size: 20),
          title: Text(title, style: const TextStyle(fontSize: 13)),
          onTap: onBack,
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}

class _SimpleMorePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;
  final VoidCallback onBack;

  const _SimpleMorePage({
    required this.title,
    required this.icon,
    required this.text,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        ListTile(
          dense: true,
          leading: const Icon(Icons.arrow_back, size: 20),
          title: const Text('بازگشت', style: TextStyle(fontSize: 13)),
          onTap: onBack,
        ),
        const Divider(height: 1),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(text),
        ),
      ],
    );
  }
}

class _StudentTab {
  final String keyName;
  final String labelKey;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;

  const _StudentTab({
    required this.keyName,
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });
}
