import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/classes/exam_model.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class StudentExamsScreen extends StatelessWidget {
  const StudentExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final user = appState.currentUser;
    final exams = user == null ? <ExamModel>[] : appState.getStudentExams(user.id);

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
                    'امتحان‌های من',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (exams.isEmpty)
            const EmptyState(message: 'امتحانی برنامه‌ریزی نشده است.')
          else
            ...exams.map((ExamModel exam) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: AppDecorations.cardDecoration,
                child: ListTile(
                  leading: Icon(
                    exam.status == ExamStatus.scheduled
                        ? Icons.schedule_outlined
                        : exam.status == ExamStatus.inProgress
                            ? Icons.play_circle_outline
                            : Icons.check_circle_outline,
                    color: exam.status == ExamStatus.scheduled
                        ? Colors.blue
                        : exam.status == ExamStatus.inProgress
                            ? Colors.green
                            : Colors.grey,
                  ),
                  title: Text(exam.classTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${exam.examDate.toLocal().toString().split(' ')[0]} - ${exam.startTime.format(context)} تا ${exam.endTime.format(context)}'),
                      Text('وضعیت: ${exam.status == ExamStatus.scheduled ? 'برنامه‌ریزی شده' : exam.status == ExamStatus.inProgress ? 'در حال برگزاری' : exam.status == ExamStatus.completed ? 'تمام شده' : 'لغو شده'}'),
                      if (exam.status == ExamStatus.completed && exam.results != null && exam.results!.containsKey(user?.id))
                        Text('نمره: ${exam.results![user!.id]}'),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}