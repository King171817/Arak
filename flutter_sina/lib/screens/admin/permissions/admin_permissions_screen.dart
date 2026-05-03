import 'package:flutter/material.dart';

import '../access_management/admin_access_management_screen.dart';

/// نگه‌داری برای سازگاری مسیرها؛ همان مدیریت دسترسی نقش‌ها.
class AdminPermissionsScreen extends StatelessWidget {
  const AdminPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminAccessManagementScreen();
  }
}
