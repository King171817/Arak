import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../models/auth/app_role.dart';
import '../screens/admin/admin_shell.dart';
import '../screens/auth/login_screen.dart';
import '../screens/manager/manager_shell.dart';
import '../screens/professor/professor_shell.dart';
import '../screens/student/student_shell.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';

class ModularApp extends StatelessWidget {
  const ModularApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: const _ModularAppView(),
    );
  }
}

class _ModularAppView extends StatelessWidget {
  const _ModularAppView();

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: GlobalAppBackground(
          child: appState.isLoggedIn
              ? (appState.maintenanceMode && appState.currentRole != AppRole.superAdmin
                  ? const _MaintenanceScreen()
                  : _HomeByRole(role: appState.currentRole))
              : const LoginScreen(),
        ),
    );
  }
}

class _HomeByRole extends StatelessWidget {
  final AppRole role;

  const _HomeByRole({
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case AppRole.student:
        return const StudentShell();

      case AppRole.professor:
        return const ProfessorShell();

      case AppRole.unitManager:
      case AppRole.unitOfficer:
      case AppRole.educationManager:
      case AppRole.educationOfficer:
        return const ManagerShell();

      case AppRole.superAdmin:
        return const AdminShell();

      case AppRole.guest:
        return const LoginScreen();
    }
  }
}


class _MaintenanceScreen extends StatelessWidget {
  const _MaintenanceScreen();

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return Directionality(
      textDirection: textDirectionOf(appState.selectedLang),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.construction_outlined,
                        size: 68,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        appState.maintenanceMessageForCurrentLang(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
                        onPressed: appState.logout,
                        icon: const Icon(Icons.logout),
                        label: Text(appText(appState.selectedLang, 'logout')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

