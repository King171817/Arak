import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class StudentWeeklyScheduleScreen extends StatelessWidget {
  const StudentWeeklyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    final classes = appState.getStudentClasses('s001');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'weekly_schedule'),
          icon: Icons.calendar_month_outlined,
          child: classes.isEmpty
              ? EmptyState(
                  message: isRtlLang(lang)
                      ? 'برنامه‌ای برای شما ثبت نشده است.'
                      : 'No schedule has been registered for you.',
                )
              : Column(
                  children: classes.map((classItem) {
                    return Card(
                      margin: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.school_outlined),
                        ),
                        title: Text(
                          classItem.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${classItem.weekDay} | ${formatTimeOfDay(classItem.startTime)} - ${formatTimeOfDay(classItem.endTime)}\n'
                          '${classItem.professorName} | ${classItem.semester}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
