import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../state/app_state.dart';

class ProfessorClassStudentsChatScreen extends StatefulWidget {
  const ProfessorClassStudentsChatScreen({super.key});

  @override
  State<ProfessorClassStudentsChatScreen> createState() => _ProfessorClassStudentsChatScreenState();
}

class _ProfessorClassStudentsChatScreenState extends State<ProfessorClassStudentsChatScreen> {
  String? selectedClassId;
  String? selectedStudentId;
  final messageController = TextEditingController();

  final messages = <_LocalClassMessage>[];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (selectedClassId == null || selectedStudentId == null || messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کلاس، دانشجو و متن پیام را کامل کنید.')),
      );
      return;
    }

    setState(() {
      messages.insert(
        0,
        _LocalClassMessage(
          classId: selectedClassId!,
          studentId: selectedStudentId!,
          body: messageController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final classes = appState.educationClasses;

    if (selectedClassId == null && classes.isNotEmpty) {
      selectedClassId = classes.first.id;
    }

    final selectedClass = classes.where((c) => c.id == selectedClassId).firstOrNull;
    final studentIds = selectedClass?.studentIds ?? <String>[];

    if (selectedStudentId == null && studentIds.isNotEmpty) {
      selectedStudentId = studentIds.first;
    }

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'messages'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: classes.isEmpty
            ? const Center(child: Text('برای استاد هنوز کلاسی ثبت نشده است.'))
            : Row(
                children: [
                  SizedBox(
                    width: 290,
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: ListView(
                        padding: const EdgeInsets.all(10),
                        children: [
                          const Text('کلاس‌های استاد', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...classes.map((c) {
                            final selected = c.id == selectedClassId;
                            return ListTile(
                              dense: true,
                              selected: selected,
                              leading: const Icon(Icons.class_outlined),
                              title: Text(c.title),
                              subtitle: Text(c.professorName),
                              onTap: () => setState(() {
                                selectedClassId = c.id;
                                selectedStudentId = c.studentIds.isEmpty ? null : c.studentIds.first;
                              }),
                            );
                          }),
                          const Divider(),
                          const Text('دانشجویان این کلاس', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          if (studentIds.isEmpty)
                            const Text('دانشجویی برای این کلاس ثبت نشده است.')
                          else
                            ...studentIds.map((studentId) {
                              final selected = studentId == selectedStudentId;
                              return ListTile(
                                dense: true,
                                selected: selected,
                                leading: const Icon(Icons.person_outline),
                                title: Text(studentId),
                                subtitle: const Text('دانشجوی کلاس'),
                                onTap: () => setState(() => selectedStudentId = studentId),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              selectedClass == null ? 'گفتگو' : 'گفتگو با دانشجوی کلاس: ${selectedClass.title}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView(
                              reverse: true,
                              padding: const EdgeInsets.all(10),
                              children: messages
                                  .where((m) => m.classId == selectedClassId && m.studentId == selectedStudentId)
                                  .map((m) => Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(m.body),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    decoration: const InputDecoration(labelText: 'پیام برای دانشجو'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FilledButton.icon(
                                  onPressed: sendMessage,
                                  icon: const Icon(Icons.send),
                                  label: const Text('ارسال'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _LocalClassMessage {
  final String classId;
  final String studentId;
  final String body;
  final DateTime createdAt;

  const _LocalClassMessage({
    required this.classId,
    required this.studentId,
    required this.body,
    required this.createdAt,
  });
}
