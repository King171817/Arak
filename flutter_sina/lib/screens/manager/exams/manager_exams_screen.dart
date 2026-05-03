import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/classes/exam_model.dart';
import '../../../models/classes/education_class_model.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ManagerExamsScreen extends StatefulWidget {
  const ManagerExamsScreen({super.key});

  @override
  State<ManagerExamsScreen> createState() => _ManagerExamsScreenState();
}

class _ManagerExamsScreenState extends State<ManagerExamsScreen> {
  final TextEditingController descriptionCtrl = TextEditingController();
  String? selectedClassId;
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 30);

  @override
  void dispose() {
    descriptionCtrl.dispose();
    super.dispose();
  }

  void approveExam(ExamModel exam, AppState appState) {
    final updatedExam = exam.copyWith(
      status: ExamStatus.scheduled,
      approvedBy: appState.currentUser?.id,
      approvedAt: DateTime.now(),
    );
    appState.updateExam(updatedExam);
  }

  void rejectExam(ExamModel exam, AppState appState) {
    final updatedExam = exam.copyWith(status: ExamStatus.cancelled);
    appState.updateExam(updatedExam);
  }

  void scheduleExam(AppState appState) {
    if (selectedClassId == null || descriptionCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمام فیلدها را پر کنید.')),
      );
      return;
    }

    final EducationManagedClassModel? classItem = appState.educationClasses
        .where((c) => c.id == selectedClassId)
        .cast<EducationManagedClassModel?>()
        .firstWhere((c) => true, orElse: () => null);

    if (classItem == null) return;

    final ExamModel exam = ExamModel(
      id: 'exam_${DateTime.now().millisecondsSinceEpoch}',
      classId: classItem.id,
      classTitle: classItem.title,
      professorId: classItem.professorId,
      professorName: classItem.professorName,
      studentIds: classItem.studentIds,
      examDate: selectedDate,
      startTime: startTime,
      endTime: endTime,
      description: descriptionCtrl.text,
      status: ExamStatus.scheduled,
      createdAt: DateTime.now(),
      approvedBy: appState.currentUser?.id,
      approvedAt: DateTime.now(),
    );

    appState.addExam(exam);

    descriptionCtrl.clear();
    setState(() {
      selectedClassId = null;
      selectedDate = DateTime.now();
      startTime = const TimeOfDay(hour: 9, minute: 0);
      endTime = const TimeOfDay(hour: 10, minute: 30);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('امتحان برنامه‌ریزی شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final exams = appState.exams;

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.quiz_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت امتحان‌ها',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'برنامه‌ریزی امتحان جدید',
            icon: Icons.add_outlined,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'کلاس',
                    ),
                    items: appState.educationClasses.map((classItem) {
                      return DropdownMenuItem<String>(
                        value: classItem.id,
                        child: Text(classItem.title),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedClassId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'توضیحات امتحان',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => scheduleExam(appState),
                      icon: const Icon(Icons.schedule),
                      label: const Text('برنامه‌ریزی امتحان'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'امتحان‌های برنامه‌ریزی شده',
            icon: Icons.list_outlined,
            child: exams.isEmpty
                ? const EmptyState(message: 'امتحانی برنامه‌ریزی نشده است.')
                : Column(
                    children: exams.map((exam) {
                      return ListTile(
                        leading: Icon(
                          exam.status == ExamStatus.scheduled
                              ? Icons.schedule_outlined
                              : exam.status == ExamStatus.inProgress
                                  ? Icons.play_circle_outline
                                  : Icons.check_circle_outline,
                        ),
                        title: Text(exam.classTitle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${exam.examDate.toLocal().toString().split(' ')[0]} - ${exam.startTime.format(context)} تا ${exam.endTime.format(context)}'),
                            Text('استاد: ${exam.professorName}'),
                            Text('وضعیت: ${exam.status == ExamStatus.scheduled ? 'برنامه‌ریزی شده' : exam.status == ExamStatus.inProgress ? 'در حال برگزاری' : exam.status == ExamStatus.completed ? 'تمام شده' : 'لغو شده'}'),
                          ],
                        ),
                        trailing: exam.status == ExamStatus.scheduled
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => approveExam(exam, appState),
                                    tooltip: 'تایید',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => rejectExam(exam, appState),
                                    tooltip: 'لغو',
                                  ),
                                ],
                              )
                            : null,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}