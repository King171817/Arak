import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/entities.dart';
import '../utils/app_text.dart';

class StudentClassRoom extends StatelessWidget {
  final UniversityClass item;
  const StudentClassRoom({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final student = appState.currentStudent;
    final hasJoined = student != null && item.presentStudentIds.contains(student.id);

    return Scaffold(
      appBar: AppBar(title: Text(item.name), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('استاد: ${item.professorName}'),
                Text('زمان: ${item.schedule}'),
                Text('ترم: ${item.semester}'),
                const SizedBox(height: 16),
                if (item.isActive)
                  FilledButton.icon(
                    onPressed: hasJoined || student == null ? null : () => context.read<AppState>().joinClass(item.id, student.id),
                    icon: Icon(hasJoined ? Icons.check_circle : Icons.login),
                    label: Text(hasJoined ? 'حضور شما ثبت شد' : tr(appState.selectedLang, 'join_class')),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.withOpacity(.12), borderRadius: BorderRadius.circular(14)),
                    child: Text(tr(appState.selectedLang, 'waiting_class')),
                  ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.forum), title: Text('گفتگوی کلاس'), subtitle: Text('در این قسمت پیام‌های کلاس نمایش داده می‌شود.'))),
          const Card(child: ListTile(leading: Icon(Icons.attach_file), title: Text('فایل‌ها و تکالیف'), subtitle: Text('دریافت فایل‌ها و ارسال تکلیف'))),
        ],
      ),
    );
  }
}
