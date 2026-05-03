import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ProfessorClassesScreen extends StatelessWidget {
  const ProfessorClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final professorId = appState.currentUser?.id ?? '';
    final classes = appState.getProfessorClasses(professorId);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'classes'),
          icon: Icons.school_outlined,
          child: classes.isEmpty
              ? const EmptyState(message: 'کلاسی برای شما ثبت نشده است.')
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
                          '${classItem.semester}',
                        ),
                        isThreeLine: true,
                        trailing: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('شروع'),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
