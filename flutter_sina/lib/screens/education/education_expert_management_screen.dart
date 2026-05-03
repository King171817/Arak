import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../state/app_state.dart';

class EducationExpertManagementScreen extends StatefulWidget {
  const EducationExpertManagementScreen({super.key});

  @override
  State<EducationExpertManagementScreen> createState() => _EducationExpertManagementScreenState();
}

class _EducationExpertManagementScreenState extends State<EducationExpertManagementScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final experts = <_ExpertAccount>[];

  final permissions = <String, bool>{
    'manageClasses': true,
    'viewStudents': true,
    'editStudentProfile': false,
    'viewReports': true,
    'dailyReport': true,
    'chatWithManager': true,
  };

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void addExpert() {
    if (nameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      experts.add(
        _ExpertAccount(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: nameController.text.trim(),
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          permissions: Map<String, bool>.from(permissions),
        ),
      );
    });

    nameController.clear();
    usernameController.clear();
    passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('کارشناس آموزش ثبت شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'expert_management'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'نام کارشناس')),
                    const SizedBox(height: 8),
                    TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'نام کاربری')),
                    const SizedBox(height: 8),
                    TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'رمز عبور')),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: permissions.keys.map((key) {
                        return FilterChip(
                          label: Text(_permissionFa(key)),
                          selected: permissions[key] ?? false,
                          onSelected: (v) => setState(() => permissions[key] = v),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: addExpert,
                        icon: const Icon(Icons.person_add),
                        label: const Text('ثبت کارشناس و دسترسی‌ها'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...experts.map((expert) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.badge_outlined),
                  title: Text(expert.name),
                  subtitle: Text('یوزر: ${expert.username} | دسترسی‌ها: ${expert.permissions.entries.where((e) => e.value).length}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      nameController.text = expert.name;
                      usernameController.text = expert.username;
                      passwordController.text = expert.password;
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _permissionFa(String key) {
    switch (key) {
      case 'manageClasses':
        return 'مدیریت کلاس‌ها';
      case 'viewStudents':
        return 'مشاهده دانشجویان';
      case 'editStudentProfile':
        return 'ویرایش پروفایل دانشجو';
      case 'viewReports':
        return 'مشاهده گزارشات';
      case 'dailyReport':
        return 'ثبت گزارش روزانه';
      case 'chatWithManager':
        return 'چت با مدیر آموزش';
      default:
        return key;
    }
  }
}

class _ExpertAccount {
  final String id;
  final String name;
  final String username;
  final String password;
  final Map<String, bool> permissions;

  const _ExpertAccount({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.permissions,
  });
}
