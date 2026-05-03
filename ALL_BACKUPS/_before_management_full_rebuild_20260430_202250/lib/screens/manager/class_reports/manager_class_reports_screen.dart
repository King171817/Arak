import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../data/mock/mock_users.dart';
import '../../../models/classes/education_class_model.dart';
import '../../../models/users/professor_model.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ManagerClassReportsScreen extends StatefulWidget {
  const ManagerClassReportsScreen({super.key});

  @override
  State<ManagerClassReportsScreen> createState() =>
      _ManagerClassReportsScreenState();
}

class _ManagerClassReportsScreenState extends State<ManagerClassReportsScreen> {
  String selectedProfessorId = 'all';
  String selectedStatus = 'all';
  String selectedSemester = 'all';

  String statusText(LiveClassStatus status) {
    switch (status) {
      case LiveClassStatus.scheduled:
        return 'زمان‌بندی شده';
      case LiveClassStatus.waitingForProfessor:
        return 'در انتظار استاد';
      case LiveClassStatus.active:
        return 'فعال';
      case LiveClassStatus.finished:
        return 'پایان‌یافته';
      case LiveClassStatus.cancelled:
        return 'لغو شده';
    }
  }

  Duration classDuration(EducationManagedClassModel item) {
    final DateTime start = item.startedAt ?? item.createdAt;
    final DateTime finish = item.finishedAt ?? DateTime.now();
    return finish.difference(start);
  }

  List<EducationManagedClassModel> filteredPastClasses(
    List<EducationManagedClassModel> allClasses,
  ) {
    return allClasses.where((EducationManagedClassModel item) {
      final bool isPast = item.status == LiveClassStatus.finished ||
          item.status == LiveClassStatus.cancelled;

      if (!isPast) return false;

      if (selectedProfessorId != 'all' &&
          item.professorId != selectedProfessorId) {
        return false;
      }

      if (selectedStatus != 'all' && item.status.name != selectedStatus) {
        return false;
      }

      if (selectedSemester != 'all' && item.semester != selectedSemester) {
        return false;
      }

      return true;
    }).toList();
  }

  List<String> semesters(List<EducationManagedClassModel> classes) {
    final Set<String> values = <String>{};

    for (final EducationManagedClassModel item in classes) {
      if (item.semester.trim().isNotEmpty) {
        values.add(item.semester);
      }
    }

    return values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final List<EducationManagedClassModel> pastClasses =
        filteredPastClasses(appState.educationClasses);

    final List<String> semesterOptions = semesters(appState.educationClasses);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: 'فیلتر گزارش کلاس‌ها',
          icon: Icons.filter_alt_outlined,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  initialValue: selectedProfessorId,
                  decoration: const InputDecoration(
                    labelText: 'استاد',
                    border: OutlineInputBorder(),
                  ),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(
                      value: 'all',
                      child: Text('همه استادها'),
                    ),
                    ...mockProfessors.map((ProfessorModel professor) {
                      return DropdownMenuItem<String>(
                        value: professor.id,
                        child: Text(professor.name),
                      );
                    }),
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      selectedProfessorId = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'وضعیت',
                    border: OutlineInputBorder(),
                  ),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(
                      value: 'all',
                      child: Text('همه وضعیت‌ها'),
                    ),
                    DropdownMenuItem<String>(
                      value: LiveClassStatus.finished.name,
                      child: const Text('پایان‌یافته'),
                    ),
                    DropdownMenuItem<String>(
                      value: LiveClassStatus.cancelled.name,
                      child: const Text('لغو شده'),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedSemester,
                  decoration: const InputDecoration(
                    labelText: 'ترم',
                    border: OutlineInputBorder(),
                  ),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(
                      value: 'all',
                      child: Text('همه ترم‌ها'),
                    ),
                    ...semesterOptions.map((String semester) {
                      return DropdownMenuItem<String>(
                        value: semester,
                        child: Text(semester),
                      );
                    }),
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      selectedSemester = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'گزارش دقیق کلاس‌های گذشته',
          icon: Icons.history_edu_outlined,
          child: pastClasses.isEmpty
              ? const EmptyState(message: 'کلاسی با این فیلتر پیدا نشد.')
              : Column(
                  children: pastClasses.map((item) {
                    final Duration duration = classDuration(item);

                    return Card(
                      margin: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                      child: ExpansionTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.analytics_outlined),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'استاد: ${item.professorName}\n'
                          '${item.weekDay} | ${formatTimeOfDay(item.startTime)} - ${formatTimeOfDay(item.endTime)}',
                        ),
                        childrenPadding: const EdgeInsets.all(14),
                        children: <Widget>[
                          _ReportRow(title: 'وضعیت', value: statusText(item.status)),
                          _ReportRow(title: 'ترم', value: item.semester),
                          _ReportRow(
                            title: 'تعداد دانشجویان',
                            value: '${item.studentNames.length} نفر',
                          ),
                          _ReportRow(
                            title: 'شروع واقعی',
                            value: item.startedAt == null
                                ? 'ثبت نشده'
                                : formatDateTimeShort(item.startedAt!),
                          ),
                          _ReportRow(
                            title: 'پایان واقعی',
                            value: item.finishedAt == null
                                ? 'ثبت نشده'
                                : formatDateTimeShort(item.finishedAt!),
                          ),
                          _ReportRow(
                            title: 'مدت کلاس',
                            value: formatDurationMinutes(duration),
                          ),
                          const Divider(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'دانشجویان: ${item.studentNames.isEmpty ? '—' : item.studentNames.join('، ')}',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: appText(lang, 'reports'),
          icon: Icons.analytics_outlined,
          child: ListTile(
            leading: const Icon(Icons.summarize_outlined),
            title: const Text('خلاصه گزارش'),
            subtitle: Text('تعداد نتایج فیلتر شده: ${pastClasses.length}'),
          ),
        ),
      ],
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String title;
  final String value;

  const _ReportRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
