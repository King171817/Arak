import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../state/app_state.dart';

class ProfessorUnitMessageScreen extends StatefulWidget {
  const ProfessorUnitMessageScreen({super.key});

  @override
  State<ProfessorUnitMessageScreen> createState() => _ProfessorUnitMessageScreenState();
}

class _ProfessorUnitMessageScreenState extends State<ProfessorUnitMessageScreen> {
  String targetUnit = 'education';
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();

  final sentMessages = <_LocalUnitMessage>[];

  @override
  void dispose() {
    subjectController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (subjectController.text.trim().isEmpty || bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عنوان و متن پیام را وارد کنید.')),
      );
      return;
    }

    setState(() {
      sentMessages.insert(
        0,
        _LocalUnitMessage(
          unit: targetUnit,
          subject: subjectController.text.trim(),
          body: bodyController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
    });

    subjectController.clear();
    bodyController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('پیام برای واحد انتخاب‌شده ثبت شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'messages'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: targetUnit,
                      decoration: const InputDecoration(labelText: 'انتخاب واحد مقصد'),
                      items: const [
                        DropdownMenuItem(value: 'education', child: Text('آموزش')),
                        DropdownMenuItem(value: 'international', child: Text('امور بین‌الملل')),
                        DropdownMenuItem(value: 'consular', child: Text('کنسولی')),
                        DropdownMenuItem(value: 'student_services', child: Text('خدمات دانشجویی')),
                        DropdownMenuItem(value: 'other_services', child: Text('سایر خدمات')),
                        DropdownMenuItem(value: 'main_admin', child: Text('مدیر اصلی')),
                      ],
                      onChanged: (v) => setState(() => targetUnit = v ?? 'education'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(labelText: 'عنوان پیام'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: bodyController,
                      maxLines: 5,
                      decoration: const InputDecoration(labelText: 'متن پیام'),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: sendMessage,
                        icon: const Icon(Icons.send),
                        label: const Text('ارسال پیام به واحد'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...sentMessages.map((m) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.mark_email_read_outlined),
                  title: Text(m.subject),
                  subtitle: Text('${_unitFa(m.unit)}\n${m.body}', maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
              );
            }),
            if (sentMessages.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('هنوز پیامی ارسال نشده است.'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _unitFa(String key) {
    switch (key) {
      case 'education':
        return 'آموزش';
      case 'international':
        return 'امور بین‌الملل';
      case 'consular':
        return 'کنسولی';
      case 'student_services':
        return 'خدمات دانشجویی';
      case 'other_services':
        return 'سایر خدمات';
      case 'main_admin':
        return 'مدیر اصلی';
      default:
        return key;
    }
  }
}

class _LocalUnitMessage {
  final String unit;
  final String subject;
  final String body;
  final DateTime createdAt;

  const _LocalUnitMessage({
    required this.unit,
    required this.subject,
    required this.body,
    required this.createdAt,
  });
}
