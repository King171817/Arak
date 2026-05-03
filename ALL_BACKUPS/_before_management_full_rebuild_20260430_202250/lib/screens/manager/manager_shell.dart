import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_lang.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import '../services/other_services_screen.dart';
import '../tickets/tickets_screen.dart';
import 'classes/manager_classes_screen.dart';
import 'dashboard/manager_dashboard_screen.dart';
import 'messages/manager_messages_screen.dart';
import 'officers/manager_officers_screen.dart';
import 'reports/manager_reports_screen.dart';
import 'students/student_profile_management_screen.dart';

enum ManagerMorePage {
  menu,
  students,
  officers,
  reports,
  tickets,
  services,
}

class ManagerShell extends StatefulWidget {
  const ManagerShell({super.key});

  @override
  State<ManagerShell> createState() => _ManagerShellState();
}

class _ManagerShellState extends State<ManagerShell> {
  int currentIndex = 0;
  ManagerMorePage morePage = ManagerMorePage.menu;

  void setTab(int index) {
    setState(() {
      currentIndex = index;
      if (index != 3) {
        morePage = ManagerMorePage.menu;
      }
    });
  }

  void openMorePage(ManagerMorePage page) {
    setState(() {
      currentIndex = 3;
      morePage = page;
    });
  }

  void backToMoreMenu() {
    setState(() {
      morePage = ManagerMorePage.menu;
    });
  }

  void openTabByKey(String key) {
    if (key == 'classes') {
      setTab(1);
      return;
    }

    if (key == 'messages') {
      setTab(2);
      return;
    }

    if (key == 'students') {
      openMorePage(ManagerMorePage.students);
      return;
    }

    if (key == 'officers') {
      openMorePage(ManagerMorePage.officers);
      return;
    }

    if (key == 'reports') {
      openMorePage(ManagerMorePage.reports);
      return;
    }

    if (key == 'tickets') {
      openMorePage(ManagerMorePage.tickets);
      return;
    }

    if (key == 'services') {
      openMorePage(ManagerMorePage.services);
      return;
    }

    setTab(0);
  }

  Widget buildMoreBody(AppState appState) {
    switch (morePage) {
      case ManagerMorePage.students:
        return _WithInternalBack(
          title: appText(appState.selectedLang, 'students'),
          onBack: backToMoreMenu,
          child: const StudentProfileManagementScreen(),
        );

      case ManagerMorePage.officers:
        return _WithInternalBack(
          title: appText(appState.selectedLang, 'officers'),
          onBack: backToMoreMenu,
          child: const ManagerOfficersScreen(),
        );

      case ManagerMorePage.reports:
        return _WithInternalBack(
          title: appText(appState.selectedLang, 'reports'),
          onBack: backToMoreMenu,
          child: const ManagerReportsScreen(),
        );

      case ManagerMorePage.tickets:
        return _WithInternalBack(
          title: appText(appState.selectedLang, 'tickets'),
          onBack: backToMoreMenu,
          child: const TicketsScreen(),
        );

      case ManagerMorePage.services:
        return OtherServicesScreen(onBack: backToMoreMenu);

      case ManagerMorePage.menu:
        return _ManagerMoreMenu(
          onOpenStudents: () => openMorePage(ManagerMorePage.students),
          onOpenOfficers: () => openMorePage(ManagerMorePage.officers),
          onOpenReports: () => openMorePage(ManagerMorePage.reports),
          onOpenTickets: () => openMorePage(ManagerMorePage.tickets),
          onOpenServices: () => openMorePage(ManagerMorePage.services),
        );
    }
  }

  List<_ManagerTab> buildTabs(AppState appState) {
    final List<_ManagerTab> tabs = <_ManagerTab>[
      _ManagerTab(
        keyName: 'dashboard',
        labelKey: 'dashboard',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        page: ManagerDashboardScreen(
          onOpenClasses: () => openTabByKey('classes'),
          onOpenStudents: () => openMorePage(ManagerMorePage.students),
          onOpenOfficers: () => openMorePage(ManagerMorePage.officers),
          onOpenReports: () => openMorePage(ManagerMorePage.reports),
          onOpenMessages: () => openTabByKey('messages'),
        ),
      ),
    ];

    if (appState.canSeeClassesInBottomNav &&
        !appState.isSectionLocked('classes')) {
      tabs.add(
        const _ManagerTab(
          keyName: 'classes',
          labelKey: 'classes',
          icon: Icons.school_outlined,
          activeIcon: Icons.school,
          page: ManagerClassesScreen(),
        ),
      );
    }

    if (!appState.isSectionLocked('messages')) {
      tabs.add(
        const _ManagerTab(
          keyName: 'messages',
          labelKey: 'managers_chat',
          icon: Icons.chat_outlined,
          activeIcon: Icons.chat,
          page: ManagerMessagesScreen(),
        ),
      );
    }

    tabs.add(
      _ManagerTab(
        keyName: 'more',
        labelKey: 'more',
        icon: Icons.more_horiz,
        activeIcon: Icons.more,
        page: buildMoreBody(appState),
      ),
    );

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final List<_ManagerTab> tabs = buildTabs(appState);

    if (currentIndex >= tabs.length) {
      currentIndex = 0;
    }

    return RoleShellLayout(
      titleKey: appState.isEducationManager || appState.isEducationOfficer
          ? 'education'
          : appState.currentUnitKey,
      currentIndex: currentIndex,
      onBottomTap: setTab,
      body: tabs[currentIndex].page,
      bottomItems: tabs.map((_ManagerTab tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: appText(lang, tab.labelKey),
        );
      }).toList(),
    );
  }
}

class _ManagerMoreMenu extends StatelessWidget {
  final VoidCallback onOpenStudents;
  final VoidCallback onOpenOfficers;
  final VoidCallback onOpenReports;
  final VoidCallback onOpenTickets;
  final VoidCallback onOpenServices;

  const _ManagerMoreMenu({
    required this.onOpenStudents,
    required this.onOpenOfficers,
    required this.onOpenReports,
    required this.onOpenTickets,
    required this.onOpenServices,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        if (!appState.isSectionLocked('students'))
          _ManagerMoreTile(
            icon: Icons.people_outline,
            title: appText(lang, 'students'),
            subtitle: 'پرونده، کلاس‌ها و گزارش دانشجو',
            onTap: onOpenStudents,
          ),
        if (!appState.isSectionLocked('officers'))
          _ManagerMoreTile(
            icon: Icons.admin_panel_settings_outlined,
            title: appText(lang, 'officers'),
            subtitle: 'مدیریت کارشناس آموزش و دسترسی‌ها',
            onTap: onOpenOfficers,
          ),
        if (!appState.isSectionLocked('tickets'))
          _ManagerMoreTile(
            icon: Icons.confirmation_number_outlined,
            title: appText(lang, 'tickets'),
            subtitle: 'درخواست‌ها و شماره پیگیری',
            onTap: onOpenTickets,
          ),
        if (!appState.isSectionLocked('reports'))
          _ManagerMoreTile(
            icon: Icons.analytics_outlined,
            title: appText(lang, 'reports'),
            subtitle: 'گزارش کلاس‌ها و عملکرد',
            onTap: onOpenReports,
          ),
        if (!appState.isSectionLocked('services'))
          _ManagerMoreTile(
            icon: Icons.apps_outlined,
            title: appText(lang, 'other_services'),
            subtitle: 'خدمات پشتیبانی و رفاهی',
            onTap: onOpenServices,
          ),
        _ManagerMoreTile(
          icon: Icons.logout,
          title: appText(lang, 'logout'),
          subtitle: 'خروج از حساب کاربری',
          onTap: appState.logout,
        ),
      ],
    );
  }
}

class _ManagerMoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagerMoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
      leading: Icon(icon, size: 20),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 10),
      ),
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
          visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
          leading: const Icon(Icons.arrow_back, size: 20),
          title: Text(
            title,
            style: const TextStyle(fontSize: 13),
          ),
          onTap: onBack,
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}

class _ManagerTab {
  final String keyName;
  final String labelKey;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;

  const _ManagerTab({
    required this.keyName,
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });
}
