import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/my_app.dart';
import 'models/auth/app_role.dart';
import 'state/app_state.dart';
import 'state/permissions/permission_state.dart';
import 'state/admin_control_state.dart';
import 'state/live_class_state.dart';
import 'screens/splash/app_splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/student/student_shell.dart';
import 'screens/professor/professor_shell.dart';
import 'screens/manager/manager_shell.dart';
import 'screens/admin/admin_shell.dart';
import 'services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBootstrap.initializeIfConfigured();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermissionState()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AdminControlState()),
        ChangeNotifierProvider(create: (_) => LiveClassState()),
      ],
      child: const RootApp(),
    ),
  );
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool splashFinished = false;

  Widget _buildHomeForRole(AppState appState) {
    // If no user is logged in, show login screen
    if (appState.currentUser == null) {
      return const LoginScreen();
    }

    final AppRole role = appState.currentRole;

    switch (role) {
      case AppRole.student:
        return const StudentShell();
      case AppRole.professor:
        return const ProfessorShell();
      case AppRole.educationManager:
      case AppRole.unitManager:
        return const ManagerShell();
      case AppRole.superAdmin:
        return const AdminShell();
      case AppRole.educationOfficer:
      case AppRole.unitOfficer:
        return const StudentShell(); // Default to student shell for officers
      case AppRole.guest:
      default:
        return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MyApp(
          home: splashFinished
              ? _buildHomeForRole(appState)
              : AppSplashScreen(
                  onFinished: () {
                    setState(() {
                      splashFinished = true;
                    });
                  },
                ),
        );
      },
    );
  }
}

