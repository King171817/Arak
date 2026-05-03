import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../core/theme/theme.dart';
import '../../../models/classes/education_class_model.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

enum WeeklyScheduleViewMode {
  list,
  weekTable,
}

class StudentWeeklyScheduleScreen extends StatefulWidget {
  const StudentWeeklyScheduleScreen({super.key});

  @override
  State<StudentWeeklyScheduleScreen> createState() =>
      _StudentWeeklyScheduleScreenState();
}

class _StudentWeeklyScheduleScreenState
    extends State<StudentWeeklyScheduleScreen> {
  WeeklyScheduleViewMode mode = WeeklyScheduleViewMode.list;

  final List<String> weekDays = const <String>[
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنجشنبه',
  ];

  Map<String, List<EducationManagedClassModel>> groupByDay(
    List<EducationManagedClassModel> classes,
  ) {
    final Map<String, List<EducationManagedClassModel>> grouped =
        <String, List<EducationManagedClassModel>>{};

    for (final String day in weekDays) {
      grouped[day] = <EducationManagedClassModel>[];
    }

    for (final EducationManagedClassModel item in classes) {
      grouped.putIfAbsent(item.weekDay, () => <EducationManagedClassModel>[]);
      grouped[item.weekDay]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    final List<EducationManagedClassModel> classes =
        appState.getStudentClasses('s001');

    final Map<String, List<EducationManagedClassModel>> grouped =
        groupByDay(classes);

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _ScheduleHeader(
            lang: lang,
            mode: mode,
            onModeChanged: (WeeklyScheduleViewMode value) {
              setState(() {
                mode = value;
              });
            },
          ),
          const SizedBox(height: 16),
          if (classes.isEmpty)
            const SectionCard(
              title: 'برنامه هفتگی',
              icon: Icons.calendar_month_outlined,
              child: EmptyState(
                message: 'هنوز کلاسی برای شما ثبت نشده است.',
              ),
            )
          else if (mode == WeeklyScheduleViewMode.list)
            _WeeklyListView(
              grouped: grouped,
              weekDays: weekDays,
            )
          else
            _WeeklyTableView(
              grouped: grouped,
              weekDays: weekDays,
            ),
        ],
      ),
    );
  }
}

class _ScheduleHeader extends StatelessWidget {
  final AppLang lang;
  final WeeklyScheduleViewMode mode;
  final ValueChanged<WeeklyScheduleViewMode> onModeChanged;

  const _ScheduleHeader({
    required this.lang,
    required this.mode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool rtl = isRtlLang(lang);

    return Container(
      decoration: AppDecorations.headerDecoration,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.30),
                  ),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      rtl ? 'برنامه هفتگی کلاس‌ها' : 'Weekly Class Schedule',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      rtl
                          ? 'برنامه خود را به صورت لیست یا جدول کامل هفته ببینید.'
                          : 'View your schedule as a list or a full weekly table.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.84),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SegmentedButton<WeeklyScheduleViewMode>(
            selected: <WeeklyScheduleViewMode>{mode},
            onSelectionChanged: (Set<WeeklyScheduleViewMode> selected) {
              onModeChanged(selected.first);
            },
            segments: <ButtonSegment<WeeklyScheduleViewMode>>[
              ButtonSegment<WeeklyScheduleViewMode>(
                value: WeeklyScheduleViewMode.list,
                icon: const Icon(Icons.view_list_outlined),
                label: Text(rtl ? 'لیست روزانه' : 'Daily List'),
              ),
              ButtonSegment<WeeklyScheduleViewMode>(
                value: WeeklyScheduleViewMode.weekTable,
                icon: const Icon(Icons.table_chart_outlined),
                label: Text(rtl ? 'جدول هفته' : 'Week Table'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyListView extends StatelessWidget {
  final Map<String, List<EducationManagedClassModel>> grouped;
  final List<String> weekDays;

  const _WeeklyListView({
    required this.grouped,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: weekDays.map((String day) {
        final List<EducationManagedClassModel> dayClasses =
            grouped[day] ?? <EducationManagedClassModel>[];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SectionCard(
            title: day,
            icon: Icons.event_note_outlined,
            child: dayClasses.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('کلاسی در این روز ثبت نشده است.'),
                  )
                : Column(
                    children: dayClasses.map((EducationManagedClassModel item) {
                      return _ClassScheduleTile(item: item);
                    }).toList(),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _WeeklyTableView extends StatelessWidget {
  final Map<String, List<EducationManagedClassModel>> grouped;
  final List<String> weekDays;

  const _WeeklyTableView({
    required this.grouped,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 72,
          dataRowMaxHeight: 110,
          columns: weekDays.map((String day) {
            return DataColumn(
              label: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          rows: <DataRow>[
            DataRow(
              cells: weekDays.map((String day) {
                final List<EducationManagedClassModel> dayClasses =
                    grouped[day] ?? <EducationManagedClassModel>[];

                return DataCell(
                  SizedBox(
                    width: 180,
                    child: dayClasses.isEmpty
                        ? const Text(
                            '—',
                            textAlign: TextAlign.center,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dayClasses.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '${item.title}\n${formatTimeOfDay(item.startTime)} - ${formatTimeOfDay(item.endTime)}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassScheduleTile extends StatelessWidget {
  final EducationManagedClassModel item;

  const _ClassScheduleTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
        child: Icon(
          Icons.school_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'استاد: ${item.professorName}\n'
        '${formatTimeOfDay(item.startTime)} - ${formatTimeOfDay(item.endTime)} | ${item.semester}',
      ),
      isThreeLine: true,
    );
  }
}
