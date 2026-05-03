import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/admin/access_rule_model.dart';
import '../../../repositories/admin_advanced_repository.dart';
import '../../../state/app_state.dart';

class AdminAccessManagementScreen extends StatefulWidget {
  const AdminAccessManagementScreen({super.key});

  @override
  State<AdminAccessManagementScreen> createState() => _AdminAccessManagementScreenState();
}

class _AdminAccessManagementScreenState extends State<AdminAccessManagementScreen> {
  final repository = AdminAdvancedRepository();
  final searchController = TextEditingController();

  bool loading = true;
  String? error;

  List<AccessRuleModel> rules = <AccessRuleModel>[];

  String selectedUnit = 'education';
  String selectedRole = 'educationExpert';
  String selectedUserId = 'expert1';
  bool isLocked = false;

  final selectedPermissions = <String>{'manageClasses', 'viewStudents', 'dailyReport', 'chatWithManager'};

  final users = <_AdminUser>[
    _AdminUser(id: 'sina', name: 'sina', role: 'mainAdmin', unit: 'main', username: 'sina'),
    _AdminUser(id: 'admin1', name: 'مدیر آموزش', role: 'educationManager', unit: 'education', username: 'admin1'),
    _AdminUser(id: 'expert1', name: 'کارشناس آموزش ۱', role: 'educationExpert', unit: 'education', username: 'expert1'),
    _AdminUser(id: 'expert2', name: 'کارشناس آموزش ۲', role: 'educationExpert', unit: 'education', username: 'expert2'),
    _AdminUser(id: 'prof1', name: 'استاد ۱', role: 'professor', unit: 'education', username: 'prof1'),
    _AdminUser(id: 'student1', name: 'دانشجو ۱', role: 'student', unit: 'student', username: 'student1'),
  ];

  @override
  void initState() {
    super.initState();
    loadRules();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRules() async {
    try {
      final result = await repository.fetchAccessRules();
      if (!mounted) return;
      setState(() {
        rules = result;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
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

  void selectUser(_AdminUser user) {
    final rule = rules.where((r) => r.userId == user.id).firstOrNull;
    setState(() {
      selectedUserId = user.id;
      selectedRole = rule?.role ?? user.role;
      selectedUnit = rule?.unit.isNotEmpty == true ? rule!.unit : user.unit;
      isLocked = rule?.isLocked ?? false;
      selectedPermissions
        ..clear()
        ..addAll(rule?.permissions ?? _defaultPermissionsFor(user.role));
    });
  }

  List<String> _defaultPermissionsFor(String role) {
    switch (role) {
      case 'mainAdmin':
        return ['viewUsers', 'editProfile', 'changeRole', 'lockUser', 'datasetSettings', 'viewReports', 'editAfter48Hours'];
      case 'educationManager':
        return ['manageClasses', 'manageExperts', 'viewStudents', 'viewReports', 'dailyReport'];
      case 'educationExpert':
        return ['manageClasses', 'viewStudents', 'dailyReport', 'chatWithManager'];
      case 'professor':
        return ['viewClasses', 'messageUnits', 'classStudentChat'];
      default:
        return ['editProfile'];
    }
  }

  Future<void> saveAccess() async {
    try {
      await repository.saveAccessRule(
        userId: selectedUserId,
        role: selectedRole,
        unit: selectedUnit == 'all' ? '' : selectedUnit,
        permissions: selectedPermissions.toList(),
        isLocked: isLocked,
        updatedBy: 'sina',
      );

      await loadRules();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نقش، قفل و دسترسی‌های کاربر در بک‌اند ذخیره شد.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ذخیره دسترسی: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(
        title: Text(t(lang, 'admin_control_center')),
        actions: [
          IconButton(onPressed: loadRules, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text('خطا در دریافت اطلاعات: $error'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final narrow = constraints.maxWidth < 760;
                      final leftPanel = _UsersPanel(
                        searchController: searchController,
                        selectedUnit: selectedUnit,
                        onUnitChanged: (v) => setState(() => selectedUnit = v),
                        users: filteredUsers,
                        selectedUserId: selectedUserId,
                        onUserTap: selectUser,
                      );

                      final rightPanel = _AccessEditor(
                        selectedUserId: selectedUserId,
                        selectedRole: selectedRole,
                        selectedUnit: selectedUnit,
                        isLocked: isLocked,
                        selectedPermissions: selectedPermissions,
                        onRoleChanged: (v) => setState(() => selectedRole = v),
                        onUnitChanged: (v) => setState(() => selectedUnit = v),
                        onLockedChanged: (v) => setState(() => isLocked = v),
                        onPermissionToggle: (key, value) => setState(() {
                          if (value) {
                            selectedPermissions.add(key);
                          } else {
                            selectedPermissions.remove(key);
                          }
                        }),
                        onSave: saveAccess,
                      );

                      if (narrow) {
                        return ListView(
                          padding: const EdgeInsets.all(10),
                          children: [
                            SizedBox(height: 390, child: leftPanel),
                            const SizedBox(height: 10),
                            rightPanel,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          SizedBox(width: 330, child: leftPanel),
                          Expanded(child: rightPanel),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}

class _UsersPanel extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedUnit;
  final ValueChanged<String> onUnitChanged;
  final List<_AdminUser> users;
  final String selectedUserId;
  final ValueChanged<_AdminUser> onUserTap;

  const _UsersPanel({
    required this.searchController,
    required this.selectedUnit,
    required this.onUnitChanged,
    required this.users,
    required this.selectedUserId,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: (_) => (context as Element).markNeedsBuild(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'جستجوی نام، یوزر یا شناسه',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              initialValue: selectedUnit,
              decoration: const InputDecoration(labelText: 'واحد'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('همه واحدها')),
                DropdownMenuItem(value: 'main', child: Text('مدیریت اصلی')),
                DropdownMenuItem(value: 'education', child: Text('آموزش')),
                DropdownMenuItem(value: 'international', child: Text('بین‌الملل')),
                DropdownMenuItem(value: 'consular', child: Text('کنسولی')),
                DropdownMenuItem(value: 'student', child: Text('دانشجویی')),
              ],
              onChanged: (v) => onUnitChanged(v ?? 'all'),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: users.map((u) {
                final selected = selectedUserId == u.id;
                return ListTile(
                  dense: true,
                  selected: selected,
                  leading: CircleAvatar(child: Text(u.name.characters.first)),
                  title: Text(u.name),
                  subtitle: Text('${u.username} | ${u.role} | ${u.unit}'),
                  onTap: () => onUserTap(u),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessEditor extends StatelessWidget {
  final String selectedUserId;
  final String selectedRole;
  final String selectedUnit;
  final bool isLocked;
  final Set<String> selectedPermissions;
  final ValueChanged<String> onRoleChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<bool> onLockedChanged;
  final void Function(String key, bool value) onPermissionToggle;
  final VoidCallback onSave;

  const _AccessEditor({
    required this.selectedUserId,
    required this.selectedRole,
    required this.selectedUnit,
    required this.isLocked,
    required this.selectedPermissions,
    required this.onRoleChanged,
    required this.onUnitChanged,
    required this.onLockedChanged,
    required this.onPermissionToggle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final permissions = <String, String>{
      'viewUsers': 'مشاهده کاربران',
      'editProfile': 'ویرایش پروفایل',
      'changeRole': 'تغییر نقش',
      'lockUser': 'قفل کاربر',
      'datasetSettings': 'تنظیم دیتاست',
      'manageClasses': 'مدیریت کلاس‌ها',
      'manageExperts': 'مدیریت کارشناسان',
      'viewStudents': 'مشاهده دانشجویان',
      'viewReports': 'مشاهده گزارشات',
      'dailyReport': 'ثبت گزارش روزانه',
      'editAfter48Hours': 'ویرایش گزارش بعد از ۴۸ ساعت',
      'chatWithManager': 'چت با مدیر آموزش',
      'viewClasses': 'مشاهده کلاس‌ها',
      'messageUnits': 'پیام به واحدها',
      'classStudentChat': 'گفتگو با دانشجویان کلاس',
    };

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('کاربر منتخب: $selectedUserId', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: const InputDecoration(labelText: 'نقش'),
                  items: const [
                    DropdownMenuItem(value: 'mainAdmin', child: Text('مدیر اصلی')),
                    DropdownMenuItem(value: 'educationManager', child: Text('مدیر آموزش')),
                    DropdownMenuItem(value: 'educationExpert', child: Text('کارشناس آموزش')),
                    DropdownMenuItem(value: 'unitManager', child: Text('مدیر واحد')),
                    DropdownMenuItem(value: 'professor', child: Text('استاد')),
                    DropdownMenuItem(value: 'student', child: Text('دانشجو')),
                  ],
                  onChanged: (v) => onRoleChanged(v ?? selectedRole),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedUnit,
                  decoration: const InputDecoration(labelText: 'واحد'),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('همه')),
                    DropdownMenuItem(value: 'main', child: Text('مدیریت اصلی')),
                    DropdownMenuItem(value: 'education', child: Text('آموزش')),
                    DropdownMenuItem(value: 'international', child: Text('بین‌الملل')),
                    DropdownMenuItem(value: 'consular', child: Text('کنسولی')),
                    DropdownMenuItem(value: 'student', child: Text('دانشجویی')),
                  ],
                  onChanged: (v) => onUnitChanged(v ?? selectedUnit),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  dense: true,
                  value: isLocked,
                  onChanged: onLockedChanged,
                  title: const Text('قفل حساب کاربر'),
                  subtitle: const Text('در صورت فعال بودن، کاربر نباید وارد پنل شود.'),
                ),
                const SizedBox(height: 10),
                const Text('دسترسی‌ها', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: permissions.entries.map((entry) {
                    return FilterChip(
                      label: Text(entry.value),
                      selected: selectedPermissions.contains(entry.key),
                      onSelected: (v) => onPermissionToggle(entry.key, v),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save),
                  label: const Text('ذخیره در بک‌اند'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
