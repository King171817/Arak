import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../state/admin_control_state.dart';

/// جستجوی کاربران، ویرایش نقش/واحد، قفل حساب، دسترسی‌ها و مشاهدهٔ لاگ فعالیت.
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _match(AdminManagedUser u) {
    if (_query.isEmpty) return true;
    return u.name.toLowerCase().contains(_query) ||
        u.username.toLowerCase().contains(_query) ||
        u.role.toLowerCase().contains(_query) ||
        u.email.toLowerCase().contains(_query);
  }

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.watch<AdminControlState>();
    final List<AdminManagedUser> users =
        admin.users.where(_match).toList(growable: false);

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.manage_accounts_outlined,
                    color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت کاربران',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'جستجو: نام، نام کاربری، نقش، ایمیل…',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              '${users.length} کاربر · لاگ اخیر: ${admin.logs.length} رویداد',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: users.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _ActivityLogPreview(logs: admin.logs);
                }
                final AdminManagedUser u = users[index - 1];
                return _UserCard(user: u);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityLogPreview extends StatelessWidget {
  final List<AdminActivityLog> logs;

  const _ActivityLogPreview({required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.cardDecoration,
      child: ExpansionTile(
        leading: const Icon(Icons.history, color: AppColors.primary),
        title: const Text(
          'لاگ فعالیت مدیر (نمونهٔ محلی)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text('${logs.length} رویداد · اتصال دیتابیس در نسخهٔ بعد'),
        children: logs.take(25).map((AdminActivityLog log) {
          return ListTile(
            dense: true,
            title: Text(log.action, style: const TextStyle(fontSize: 12)),
            subtitle: Text(
              '${log.target} · ${log.createdAt}',
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final AdminManagedUser user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.watch<AdminControlState>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: AppDecorations.cardDecoration,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor:
              user.locked ? Colors.red.withValues(alpha: 0.15) : null,
          child: Icon(
            user.locked ? Icons.lock_outline : Icons.person_outline,
            size: 20,
            color: user.locked ? Colors.red : AppColors.primary,
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          '${user.username} · ${user.role} · ${user.unit}',
          style: const TextStyle(fontSize: 10),
        ),
        children: <Widget>[
          SwitchListTile(
            dense: true,
            title: const Text('قفل حساب'),
            value: user.locked,
            onChanged: (bool v) => admin.toggleUserLock(user.id, v),
          ),
          ListTile(
            dense: true,
            title: const Text('نقش'),
            subtitle: DropdownButton<String>(
              isExpanded: true,
              value: user.role,
              items: AdminControlState.roles
                  .map((String r) =>
                      DropdownMenuItem<String>(value: r, child: Text(r)))
                  .toList(),
              onChanged: (String? r) {
                if (r != null) admin.changeUserRole(user.id, r);
              },
            ),
          ),
          ListTile(
            dense: true,
            title: const Text('واحد'),
            subtitle: DropdownButton<String>(
              isExpanded: true,
              value: user.unit,
              items: <String>{
                ...AdminControlState.units,
                user.unit,
              }.map((String u) =>
                      DropdownMenuItem<String>(value: u, child: Text(u)))
                  .toList(),
              onChanged: (String? u) {
                if (u != null) admin.changeUserUnit(user.id, u);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'دسترسی‌های فردی',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: AdminControlState.allPermissions.map((String p) {
                final bool sel = user.permissions.contains(p);
                return FilterChip(
                  label: Text(p, style: const TextStyle(fontSize: 10)),
                  selected: sel,
                  onSelected: (bool v) {
                    admin.toggleUserPermission(user.id, p, v);
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: OutlinedButton.icon(
              onPressed: () => admin.applyRoleTemplateToUser(user.id),
              icon: const Icon(Icons.sync_outlined, size: 18),
              label: const Text('اعمال الگوی نقش فعلی'),
            ),
          ),
        ],
      ),
    );
  }
}
