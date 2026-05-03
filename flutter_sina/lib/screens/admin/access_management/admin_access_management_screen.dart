import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../state/admin_control_state.dart';

class AdminAccessManagementScreen extends StatelessWidget {
  const AdminAccessManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.security_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت نقش‌ها و دسترسی‌ها',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'در این بخش مدیر اصلی می‌تواند الگوی دسترسی هر نقش را ببیند و سپس در صفحه کاربران، دسترسی فردی هر کاربر را تغییر دهد.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ...AdminControlState.roles.map((String role) {
            final AdminControlState admin = context.watch<AdminControlState>();
            final List<String> suggested = admin.rolePermissionTemplates[role] ?? admin.defaultPermissionsForRole(role);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: AppDecorations.cardDecoration,
              child: ExpansionTile(
                leading: const Icon(Icons.verified_user_outlined, color: AppColors.primary),
                title: Text(
                  role,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  '${suggested.length} دسترسی در الگوی نقش',
                  style: const TextStyle(fontSize: 10),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: AdminControlState.allPermissions.map((String permission) {
                        final bool selected = suggested.contains(permission);

                        return FilterChip(
                          selected: selected,
                          label: Text(permission),
                          onSelected: (bool value) {
                            admin.toggleRoleTemplatePermission(role, permission, value);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.sync_outlined),
                        label: const Text('اعمال الگوی نقش به کاربران'),
                        onPressed: () => admin.applyRoleTemplateToRole(role),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Container(
            decoration: AppDecorations.cardDecoration,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(
                'ذخیره واقعی الگوی نقش‌ها',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'در دیتابیس، جدول role_permission_templates برای ذخیره الگوی نقش‌ها ساخته شده است.',
              ),
              trailing: const Icon(Icons.storage_outlined),
            ),
          ),
        ],
      ),
    );
  }

}




