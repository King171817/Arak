import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';
import '../class_reports/manager_class_reports_screen.dart';

class ManagerReportsScreen extends StatelessWidget {
  const ManagerReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'reports'),
          icon: Icons.analytics_outlined,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('گزارش کلاس‌ها'),
                subtitle: Text('تعداد کلاس‌ها: '),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManagerClassReportsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('گزارش کارشناسان'),
                subtitle: Text('تعداد کارشناسان: ${appState.educationOfficers.length}'),
              ),
              const ListTile(
                leading: Icon(Icons.filter_alt_outlined),
                title: Text('فیلتر گزارش‌ها'),
                subtitle: Text('فیلتر بر اساس تاریخ، نقش، واحد و وضعیت'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

