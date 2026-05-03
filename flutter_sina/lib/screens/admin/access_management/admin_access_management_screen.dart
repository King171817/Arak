import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../state/app_state.dart';

class AdminAccessManagementScreen extends StatefulWidget {
  const AdminAccessManagementScreen({super.key});

  @override
  State<AdminAccessManagementScreen> createState() => _AdminAccessManagementScreenState();
}

class _AdminAccessManagementScreenState extends State<AdminAccessManagementScreen> {
  final searchController = TextEditingController();

  String selectedUnit = 'education';
  String selectedRole = 'educationExpert';
  String? selectedUserId;

  final users = <_AdminUser>[
    _AdminUser(id: 'sina', name: 'sina', role: 'mainAdmin', unit: 'main', username: 'sina'),
    _AdminUser(id: 'admin1', name: 'مدیر آموزش', role: 'educationManager', unit: 'education', username: 'admin1'),
    _AdminUser(id: 'expert1', name: 'کارشناس آموزش ۱', role: 'educationExpert', unit: 'education', username: 'expert1'),
    _AdminUser(id: 'prof1', name: 'استاد ۱', role: 'professor', unit: 'education', username: 'prof1'),
    _AdminUser(id: 'student1', name: 'دانشجو ۱', role: 'student', unit: 'student', username: 'student1'),
  ];

  final permissions = <String, bool>{
    'viewUsers': true,
    'editProfile': true,
    'changeRole': false,
    'lockUser': false,
    'manageClasses': true,
    'manageExperts': true,
    'viewReports': true,
    'editAfter48Hours': false,
    'datasetSettings': false,
  };

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<_AdminUser> get filteredUsers {
    final q = searchController.text.trim().toLowerCase();
    return users.where((u) {
      final matchUnit = selectedUnit == 'all' || u.unit == selectedUnit;
      final matchSearch = q.isEmpty ||
          u.name.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q) ||
          u.id.toLowerCase().contains(q);
      return matchUnit && matchSearch;
    }).toList();
  }

  void saveAccess() {
    final user = users.where((u) => u.id == selectedUserId).firstOrNull;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ابتدا یک کاربر را انتخاب کنید.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('دسترسی‌های ${user.name} ذخیره شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'admin_control_center'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: Row(
          children: [
            SizedBox(
              width: 330,
              child: Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          labelText: 'جستجوی فرد، یوزر یا شناسه',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedUnit,
                        decoration: const InputDecoration(labelText: 'انتخاب واحد'),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('همه واحدها')),
                          DropdownMenuItem(value: 'main', child: Text('مدیریت اصلی')),
                          DropdownMenuItem(value: 'education', child: Text('آموزش')),
                          DropdownMenuItem(value: 'international', child: Text('بین‌الملل')),
                          DropdownMenuItem(value: 'consular', child: Text('کنسولی')),
                          DropdownMenuItem(value: 'student', child: Text('دانشجویی')),
                        ],
                        onChanged: (v) => setState(() => selectedUnit = v ?? 'all'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: filteredUsers.map((u) {
                          final selected = selectedUserId == u.id;
                          return ListTile(
                            dense: true,
                            selected: selected,
                            leading: CircleAvatar(child: Text(u.name.characters.first)),
                            title: Text(u.name),
                            subtitle: Text('${u.username} | ${u.role} | ${u.unit}'),
                            onTap: () => setState(() {
                              selectedUserId = u.id;
                              selectedRole = u.role;
                            }),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('ویرایش نقش و دسترسی فرد منتخب', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            initialValue: selectedRole,
                            decoration: const InputDecoration(labelText: 'نقش جدید'),
                            items: const [
                              DropdownMenuItem(value: 'mainAdmin', child: Text('مدیر اصلی')),
                              DropdownMenuItem(value: 'educationManager', child: Text('مدیر آموزش')),
                              DropdownMenuItem(value: 'educationExpert', child: Text('کارشناس آموزش')),
                              DropdownMenuItem(value: 'unitManager', child: Text('مدیر واحد')),
                              DropdownMenuItem(value: 'professor', child: Text('استاد')),
                              DropdownMenuItem(value: 'student', child: Text('دانشجو')),
                            ],
                            onChanged: (v) => setState(() => selectedRole = v ?? selectedRole),
                          ),
                          const SizedBox(height: 12),
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
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: saveAccess,
                                  icon: const Icon(Icons.save),
                                  label: const Text('ذخیره نقش و دسترسی'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.lock),
                                label: const Text('قفل کاربر'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'در مرحله اتصال بک‌اند، همین تغییرات به جدول users / roles / permissions ارسال و ذخیره می‌شود.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _permissionFa(String key) {
    switch (key) {
      case 'viewUsers':
        return 'مشاهده کاربران';
      case 'editProfile':
        return 'ویرایش پروفایل';
      case 'changeRole':
        return 'تغییر نقش';
      case 'lockUser':
        return 'قفل کاربر';
      case 'manageClasses':
        return 'مدیریت کلاس‌ها';
      case 'manageExperts':
        return 'مدیریت کارشناسان';
      case 'viewReports':
        return 'مشاهده گزارشات';
      case 'editAfter48Hours':
        return 'ویرایش بعد از ۴۸ ساعت';
      case 'datasetSettings':
        return 'تنظیم دیتاست';
      default:
        return key;
    }
  }
}

class _AdminUser {
  final String id;
  final String name;
  final String role;
  final String unit;
  final String username;

  const _AdminUser({
    required this.id,
    required this.name,
    required this.role,
    required this.unit,
    required this.username,
  });
}
