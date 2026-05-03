import 'package:flutter/material.dart';

class SimpleServicesPage extends StatelessWidget {
  const SimpleServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = <({IconData icon, String title})>[
      (icon: Icons.public, title: 'امور بین‌الملل'),
      (icon: Icons.school, title: 'آموزش'),
      (icon: Icons.support_agent, title: 'خدمات دانشجویی'),
      (icon: Icons.badge, title: 'کنسولی'),
      (icon: Icons.local_taxi, title: 'تاکسی'),
      (icon: Icons.translate, title: 'ترجمه مدارک'),
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.25),
      itemCount: services.length,
      itemBuilder: (context, index) => Card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(services[index].icon, size: 36, color: Colors.green), const SizedBox(height: 10), Text(services[index].title)]),
      ),
    );
  }
}

class SimpleCommunicationPage extends StatelessWidget {
  const SimpleCommunicationPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(child: ListTile(leading: const Icon(Icons.chat, color: Colors.green), title: Text(title), subtitle: const Text('ارسال پیام و پیگیری درخواست‌ها'))),
        Card(child: ListTile(leading: const Icon(Icons.notifications, color: Colors.orange), title: const Text('اعلان‌ها'), subtitle: const Text('پیام‌ها و اطلاعیه‌های جدید'))),
      ],
    );
  }
}

class SimpleProfilePage extends StatelessWidget {
  const SimpleProfilePage({super.key, required this.name, required this.role, required this.onLogout});
  final String name;
  final String role;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
              const SizedBox(height: 12),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(role),
              const SizedBox(height: 20),
              OutlinedButton.icon(onPressed: onLogout, icon: const Icon(Icons.logout), label: const Text('خروج')),
            ]),
          ),
        ),
      ],
    );
  }
}
