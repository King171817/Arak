import 'package:flutter/material.dart';

import 'ui_settings/admin_ui_settings_screen.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پنل مدیریت'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminUiSettingsScreen(),
              ),
            );
          },
          child: const Text('تنظیمات مدیریت ظاهر'),
        ),
      ),
    );
  }
}







