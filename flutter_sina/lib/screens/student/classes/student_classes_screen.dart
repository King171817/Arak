import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../state/app_state.dart';
import '../../classroom/live_class_screen.dart';

class StudentClassesScreen extends StatelessWidget {
  const StudentClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final user = appState.currentUser;
    final classes = user == null
        ? []
        : appState.getStudentClasses(user.id);

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
                Icon(Icons.school_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'کلاس‌های من',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (classes.isEmpty)
            const _EmptyClasses()
          else
            ...classes.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: AppDecorations.cardDecoration,
                child: ListTile(
                  leading: const Icon(Icons.event_available_outlined),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '${item.professorName} / ${item.weekDay} / ${item.startTime}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  trailing: FilledButton.tonalIcon(
                    onPressed: user == null
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LiveClassScreen(
                                  classId: item.id,
                                  classTitle: item.title,
                                  professorId: item.professorId,
                                  professorName: item.professorName,
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.login, size: 17),
                    label: const Text('ورود'),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _EmptyClasses extends StatelessWidget {
  const _EmptyClasses();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: const Column(
        children: <Widget>[
          Icon(Icons.info_outline, size: 36),
          SizedBox(height: 8),
          Text(
            'هنوز کلاسی برای شما ثبت نشده است.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'کلاس‌ها باید توسط مدیریت آموزش برای دانشجو تعریف شوند.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


