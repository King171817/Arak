import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    final isStudent = app.role == UserRole.student || app.role == UserRole.superAdmin;
    final services = allOtherServices.where((s) => isStudent ? true : s.audience == ServiceAudience.all).toList();
    return AppScaffold(
      title: tr(lang, 'services'),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180, mainAxisSpacing: 12, crossAxisSpacing: 12),
        itemCount: services.length,
        itemBuilder: (_, i) {
          final s = services[i];
          return Card(child: InkWell(onTap: () {}, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(s.icon, color: s.color, size: 34), const SizedBox(height: 10), Text(tr(lang, s.key), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))])));
        },
      ),
    );
  }
}
