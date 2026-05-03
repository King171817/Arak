import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';
import '../models/models.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;

  const AppScaffold({super.key, required this.title, required this.body, this.actions, this.bottomNavigationBar, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Directionality(
      textDirection: textDirectionFor(app.selectedLang),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: actions ?? [
            IconButton(onPressed: app.toggleTheme, icon: Icon(app.isDarkMode ? Icons.light_mode : Icons.dark_mode)),
            IconButton(onPressed: app.logout, icon: const Icon(Icons.logout)),
          ],
        ),
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  const InfoCard({super.key, required this.title, required this.value, required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: Colors.green.withOpacity(.12), child: Icon(icon, color: Colors.green)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.currentUser;
    if (user == null) return const SizedBox.shrink();
    String roleKey = switch(user.role) { UserRole.student => 'student', UserRole.manager => 'manager', UserRole.professor => 'professor', UserRole.superAdmin => 'super_admin', _ => 'profile'};
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(tr(app.selectedLang, roleKey)),
              if (user.studentNumber != null) Text('${tr(app.selectedLang, 'student')}: ${user.studentNumber}'),
              if (user.passportNumber != null) Text('Passport: ${user.passportNumber}'),
            ])),
          ],
        ),
      ),
    );
  }
}
