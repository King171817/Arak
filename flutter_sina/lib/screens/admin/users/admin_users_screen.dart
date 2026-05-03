import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/admin/backend_admin_user_model.dart';
import '../../../repositories/admin_advanced_repository.dart';
import '../../../state/app_state.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final repository = AdminAdvancedRepository();

  final searchController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passportController = TextEditingController();
  final studentNoController = TextEditingController();

  bool loading = true;
  String? error;
  String role = 'student';
  String unit = 'student';
  bool isLocked = false;
  BackendAdminUserModel? selectedUser;
  List<BackendAdminUserModel> users = <BackendAdminUserModel>[];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  void dispose() {
    searchController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passportController.dispose();
    studentNoController.dispose();
    super.dispose();
  }

  Future<void> loadUsers() async {
    try {
      final result = await repository.searchAdminUsers(searchController.text.trim());
      if (!mounted) return;
      setState(() {
        users = result;
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

  void clearForm() {
    setState(() {
      selectedUser = null;
      usernameController.clear();
      passwordController.clear();
      fullNameController.clear();
      emailController.clear();
      phoneController.clear();
      passportController.clear();
      studentNoController.clear();
      role = 'student';
      unit = 'student';
      isLocked = false;
    });
  }

  void selectUser(BackendAdminUserModel user) {
    setState(() {
      selectedUser = user;
      usernameController.text = user.username;
      passwordController.clear();
      fullNameController.text = user.fullName;
      emailController.text = user.email;
      phoneController.text = user.phone;
      passportController.text = user.passportNo;
      studentNoController.text = user.studentNo;
      role = user.role.isEmpty ? 'student' : user.role;
      unit = user.unit.isEmpty ? 'student' : user.unit;
      isLocked = user.isLocked;
    });
  }

  Future<void> saveUser() async {
    if (usernameController.text.trim().isEmpty || fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نام کاربری و نام کامل لازم است.')),
      );
      return;
    }

    try {
      if (selectedUser == null) {
        if (passwordController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('برای کاربر جدید رمز عبور لازم است.')),
          );
          return;
        }

        await repository.createAdminUser(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          fullName: fullNameController.text.trim(),
          role: role,
          unit: unit,
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          passportNo: passportController.text.trim(),
          studentNo: studentNoController.text.trim(),
          isLocked: isLocked,
        );
      } else {
        await repository.updateAdminUser(
          id: selectedUser!.id,
          fullName: fullNameController.text.trim(),
          role: role,
          unit: unit,
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          passportNo: passportController.text.trim(),
          studentNo: studentNoController.text.trim(),
          isLocked: isLocked,
        );

        if (passwordController.text.trim().isNotEmpty) {
          await repository.changeAdminUserPassword(
            id: selectedUser!.id,
            password: passwordController.text.trim(),
          );
        }
      }

      clearForm();
      await loadUsers();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اطلاعات کاربر ذخیره شد.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ذخیره کاربر: $e')),
      );
    }
  }

  Future<void> toggleLock(BackendAdminUserModel user) async {
    try {
      await repository.lockAdminUser(id: user.id, isLocked: !user.isLocked);
      await loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در قفل کاربر: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(
        title: Text(t(lang, 'students')),
        actions: [
          IconButton(onPressed: clearForm, icon: const Icon(Icons.add)),
          IconButton(onPressed: loadUsers, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text('خطا: $error'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final narrow = constraints.maxWidth < 850;
                      final list = _UserListPanel(
                        searchController: searchController,
                        users: users,
                        selectedUser: selectedUser,
                        onSearch: loadUsers,
                        onSelect: selectUser,
                        onLock: toggleLock,
                      );

                      final form = _UserFormPanel(
                        selectedUser: selectedUser,
                        usernameController: usernameController,
                        passwordController: passwordController,
                        fullNameController: fullNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        passportController: passportController,
                        studentNoController: studentNoController,
                        role: role,
                        unit: unit,
                        isLocked: isLocked,
                        onRoleChanged: (v) => setState(() => role = v),
                        onUnitChanged: (v) => setState(() => unit = v),
                        onLockChanged: (v) => setState(() => isLocked = v),
                        onSave: saveUser,
                      );

                      if (narrow) {
                        return ListView(
                          padding: const EdgeInsets.all(10),
                          children: [
                            SizedBox(height: 420, child: list),
                            const SizedBox(height: 10),
                            form,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          SizedBox(width: 380, child: list),
                          Expanded(child: form),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}

class _UserListPanel extends StatelessWidget {
  final TextEditingController searchController;
  final List<BackendAdminUserModel> users;
  final BackendAdminUserModel? selectedUser;
  final VoidCallback onSearch;
  final ValueChanged<BackendAdminUserModel> onSelect;
  final ValueChanged<BackendAdminUserModel> onLock;

  const _UserListPanel({
    required this.searchController,
    required this.users,
    required this.selectedUser,
    required this.onSearch,
    required this.onSelect,
    required this.onLock,
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
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(onPressed: onSearch, icon: const Icon(Icons.search)),
                labelText: 'جستجوی کاربر',
              ),
            ),
          ),
          Expanded(
            child: users.isEmpty
                ? const Center(child: Text('کاربری پیدا نشد.'))
                : ListView(
                    children: users.map((u) {
                      final selected = selectedUser?.id == u.id;
                      return ListTile(
                        dense: true,
                        selected: selected,
                        leading: Icon(u.isLocked ? Icons.lock : Icons.person_outline),
                        title: Text(u.fullName.isEmpty ? u.username : u.fullName),
                        subtitle: Text('${u.username} | ${u.role} | ${u.unit}'),
                        onTap: () => onSelect(u),
                        trailing: IconButton(
                          icon: Icon(u.isLocked ? Icons.lock_open : Icons.lock_outline),
                          onPressed: () => onLock(u),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _UserFormPanel extends StatelessWidget {
  final BackendAdminUserModel? selectedUser;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passportController;
  final TextEditingController studentNoController;
  final String role;
  final String unit;
  final bool isLocked;
  final ValueChanged<String> onRoleChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<bool> onLockChanged;
  final VoidCallback onSave;

  const _UserFormPanel({
    required this.selectedUser,
    required this.usernameController,
    required this.passwordController,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passportController,
    required this.studentNoController,
    required this.role,
    required this.unit,
    required this.isLocked,
    required this.onRoleChanged,
    required this.onUnitChanged,
    required this.onLockChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    selectedUser == null ? 'ایجاد کاربر جدید' : 'ویرایش کاربر',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: usernameController,
                  enabled: selectedUser == null,
                  decoration: const InputDecoration(labelText: 'نام کاربری'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: selectedUser == null ? 'رمز عبور' : 'رمز عبور جدید اختیاری',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(controller: fullNameController, decoration: const InputDecoration(labelText: 'نام کامل')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'نقش'),
                  items: const [
                    DropdownMenuItem(value: 'mainAdmin', child: Text('مدیر اصلی')),
                    DropdownMenuItem(value: 'educationManager', child: Text('مدیر آموزش')),
                    DropdownMenuItem(value: 'educationExpert', child: Text('کارشناس آموزش')),
                    DropdownMenuItem(value: 'unitManager', child: Text('مدیر واحد')),
                    DropdownMenuItem(value: 'professor', child: Text('استاد')),
                    DropdownMenuItem(value: 'student', child: Text('دانشجو')),
                  ],
                  onChanged: (v) => onRoleChanged(v ?? role),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: unit,
                  decoration: const InputDecoration(labelText: 'واحد'),
                  items: const [
                    DropdownMenuItem(value: 'main', child: Text('مدیریت اصلی')),
                    DropdownMenuItem(value: 'education', child: Text('آموزش')),
                    DropdownMenuItem(value: 'international', child: Text('امور بین‌الملل')),
                    DropdownMenuItem(value: 'consular', child: Text('کنسولی')),
                    DropdownMenuItem(value: 'student', child: Text('دانشجویی')),
                    DropdownMenuItem(value: 'other_services', child: Text('سایر خدمات')),
                  ],
                  onChanged: (v) => onUnitChanged(v ?? unit),
                ),
                const SizedBox(height: 8),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'ایمیل')),
                const SizedBox(height: 8),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'شماره تماس')),
                const SizedBox(height: 8),
                TextField(controller: passportController, decoration: const InputDecoration(labelText: 'شماره پاسپورت')),
                const SizedBox(height: 8),
                TextField(controller: studentNoController, decoration: const InputDecoration(labelText: 'شماره دانشجویی')),
                const SizedBox(height: 8),
                SwitchListTile(
                  dense: true,
                  value: isLocked,
                  onChanged: onLockChanged,
                  title: const Text('قفل کاربر'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.save),
                    label: const Text('ذخیره کاربر'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
