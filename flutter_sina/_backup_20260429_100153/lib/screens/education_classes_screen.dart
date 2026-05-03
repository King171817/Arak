import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class EducationClassesScreen extends StatefulWidget {
  const EducationClassesScreen({super.key});
  @override
  State<EducationClassesScreen> createState() => _EducationClassesScreenState();
}

class _EducationClassesScreenState extends State<EducationClassesScreen> {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    if (!app.canManageClasses) {
      return Center(child: Text(appText(lang, 'فقط مدیر یا کارشناس واحد آموزش اجازه مدیریت کلاس دارد.', 'Only Education manager/expert can manage classes.', 'مدير التعليم فقط يمكنه إدارة الفصول.')));
    }
    return ListView(padding: const EdgeInsets.all(16), children: [
      SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => _showCreateClassDialog(context), icon: const Icon(Icons.add), label: Text(tr(lang, 'create_class')))),
      const SizedBox(height: 12),
      ...app.classes.map((c) => Card(child: ListTile(
        leading: const Icon(Icons.class_, color: Colors.green),
        title: Text(c.name),
        subtitle: Text('${app.professorName(c.professorId)} | ${c.day} ${c.time} | ${c.semester}\n${c.studentIds.map(app.studentName).join(', ')}'),
        isThreeLine: true,
      ))),
    ]);
  }

  void _showCreateClassDialog(BuildContext context) {
    final app = context.read<AppState>();
    final lang = app.selectedLang;
    final nameCtrl = TextEditingController();
    final dayCtrl = TextEditingController(text: appText(lang, 'شنبه', 'Saturday', 'السبت'));
    final timeCtrl = TextEditingController(text: '10:00');
    final semesterCtrl = TextEditingController(text: '1403-1');
    String professorId = app.professors.first.id;
    final Set<String> selectedStudents = <String>{};
    String query = '';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModal) {
          final filtered = app.students.where((s) => s.name.contains(query) || s.studentNumber.contains(query)).toList();
          return AlertDialog(
            title: Text(tr(lang, 'create_class')),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(controller: nameCtrl, decoration: InputDecoration(labelText: appText(lang, 'نام کلاس', 'Class name', 'اسم الفصل'), border: const OutlineInputBorder())),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(value: professorId, decoration: InputDecoration(labelText: tr(lang, 'professor'), border: const OutlineInputBorder()), items: app.professors.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(), onChanged: (v) => setModal(() => professorId = v ?? professorId)),
                  const SizedBox(height: 8),
                  Row(children: [Expanded(child: TextField(controller: dayCtrl, decoration: InputDecoration(labelText: appText(lang, 'روز', 'Day', 'اليوم'), border: const OutlineInputBorder()))), const SizedBox(width: 8), Expanded(child: TextField(controller: timeCtrl, decoration: InputDecoration(labelText: appText(lang, 'ساعت', 'Time', 'الوقت'), border: const OutlineInputBorder())))]),
                  const SizedBox(height: 8),
                  TextField(controller: semesterCtrl, decoration: InputDecoration(labelText: appText(lang, 'ترم', 'Semester', 'الفصل الدراسي'), border: const OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: appText(lang, 'جستجو با نام یا شماره دانشجویی', 'Search by name or student number', 'البحث بالاسم أو الرقم'), border: const OutlineInputBorder()), onChanged: (v) => setModal(() => query = v)),
                  const SizedBox(height: 8),
                  ...filtered.map((s) => CheckboxListTile(value: selectedStudents.contains(s.id), title: Text(s.name), subtitle: Text(s.studentNumber), onChanged: (v) => setModal(() { if (v == true) { selectedStudents.add(s.id); } else { selectedStudents.remove(s.id); } }))),
                ]),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(appText(lang, 'انصراف', 'Cancel', 'إلغاء'))),
              FilledButton(onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                app.createClass(name: name, professorId: professorId, day: dayCtrl.text.trim(), time: timeCtrl.text.trim(), semester: semesterCtrl.text.trim(), studentIds: selectedStudents.toList());
                Navigator.pop(context);
              }, child: Text(tr(lang, 'create_class'))),
            ],
          );
        },
      ),
    );
  }
}
