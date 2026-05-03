import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../data/mock/mock_users.dart';
import '../../../models/classes/education_class_model.dart';
import '../../../models/permissions/permission_model.dart';
import '../../../models/users/professor_model.dart';
import '../../../models/users/student_in_class_model.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ManagerClassesScreen extends StatefulWidget {
  const ManagerClassesScreen({super.key});

  @override
  State<ManagerClassesScreen> createState() => _ManagerClassesScreenState();
}

class _ManagerClassesScreenState extends State<ManagerClassesScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController semesterCtrl =
      TextEditingController(text: 'نیمسال اول ۱۴۰۴');

  String selectedProfessorId = mockProfessors.first.id;
  String selectedWeekDay = 'شنبه';
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 11, minute: 30);
  final Set<String> selectedStudentIds = <String>{};

  final List<String> weekDays = const <String>[
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنجشنبه',
  ];

  @override
  void dispose() {
    titleCtrl.dispose();
    semesterCtrl.dispose();
    super.dispose();
  }

  Future<void> pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );

    if (picked == null) return;

    setState(() {
      selectedStartTime = picked;
    });
  }

  Future<void> pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );

    if (picked == null) return;

    setState(() {
      selectedEndTime = picked;
    });
  }

  Future<void> createClass(AppState appState) async {
    if (!appState.hasPermission(AppPermission.createClass)) {
      showMessage('شما دسترسی ایجاد کلاس ندارید.');
      return;
    }

    if (titleCtrl.text.trim().isEmpty) {
      showMessage('عنوان کلاس را وارد کنید.');
      return;
    }

    if (selectedStudentIds.isEmpty) {
      showMessage('حداقل یک دانشجو انتخاب کنید.');
      return;
    }

    final ProfessorModel professor = mockProfessors.firstWhere(
      (ProfessorModel item) => item.id == selectedProfessorId,
    );

    final List<StudentInClassModel> students = mockStudents
        .where((StudentInClassModel student) => selectedStudentIds.contains(student.id))
        .toList();

    await appState.addEducationClass(
      EducationManagedClassModel(
        id: 'ec${DateTime.now().millisecondsSinceEpoch}',
        title: titleCtrl.text.trim(),
        professorId: professor.id,
        professorName: professor.name,
        studentIds: students.map((StudentInClassModel s) => s.id).toList(),
        studentNames: students.map((StudentInClassModel s) => s.name).toList(),
        weekDay: selectedWeekDay,
        startTime: selectedStartTime,
        endTime: selectedEndTime,
        semester: semesterCtrl.text.trim(),
        createdAt: DateTime.now(),
        status: LiveClassStatus.scheduled,
      ),
    );

    titleCtrl.clear();
    selectedStudentIds.clear();

    setState(() {});
    showMessage('کلاس جدید ثبت شد.');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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

  Color statusColor(LiveClassStatus status) {
    switch (status) {
      case LiveClassStatus.scheduled:
        return Colors.blue;
      case LiveClassStatus.waitingForProfessor:
        return Colors.orange;
      case LiveClassStatus.active:
        return Colors.green;
      case LiveClassStatus.finished:
        return Colors.grey;
      case LiveClassStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (appState.hasPermission(AppPermission.createClass)) ...<Widget>[
          _buildCreateClassPanel(appState),
          const SizedBox(height: 16),
        ],
        SectionCard(
          title: appText(lang, 'classes'),
          icon: Icons.school_outlined,
          child: appState.educationClasses.isEmpty
              ? const EmptyState(message: 'کلاسی ثبت نشده است.')
              : Column(
                  children: appState.educationClasses.map((classItem) {
                    return _buildClassTile(appState, classItem);
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildCreateClassPanel(AppState appState) {
    return SectionCard(
      title: 'افزودن کلاس جدید',
      icon: Icons.add_circle_outline,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'عنوان کلاس',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: semesterCtrl,
              decoration: const InputDecoration(
                labelText: 'ترم',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedProfessorId,
              decoration: const InputDecoration(
                labelText: 'انتخاب استاد',
                border: OutlineInputBorder(),
              ),
              items: mockProfessors.map((ProfessorModel professor) {
                return DropdownMenuItem<String>(
                  value: professor.id,
                  child: Text(professor.name),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  selectedProfessorId = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedWeekDay,
              decoration: const InputDecoration(
                labelText: 'روز هفته',
                border: OutlineInputBorder(),
              ),
              items: weekDays.map((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  selectedWeekDay = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: pickStartTime,
                    icon: const Icon(Icons.access_time),
                    label: Text('شروع: ${formatTimeOfDay(selectedStartTime)}'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: pickEndTime,
                    icon: const Icon(Icons.access_time_filled),
                    label: Text('پایان: ${formatTimeOfDay(selectedEndTime)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'انتخاب دانشجویان',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 8),
            ...mockStudents.map((StudentInClassModel student) {
              final bool selected = selectedStudentIds.contains(student.id);

              return CheckboxListTile(
                value: selected,
                title: Text(student.name),
                subtitle: Text('شماره دانشجویی: ${student.studentId}'),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedStudentIds.add(student.id);
                    } else {
                      selectedStudentIds.remove(student.id);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => createClass(appState),
                icon: const Icon(Icons.save),
                label: const Text('ثبت کلاس'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddStudentDialog(
    AppState appState,
    EducationManagedClassModel classItem,
  ) {
    String? selectedStudentId;

    final List<StudentInClassModel> availableStudents = mockStudents
        .where((StudentInClassModel student) => !classItem.studentIds.contains(student.id))
        .toList();

    if (availableStudents.isEmpty) {
      showMessage('دانشجوی جدیدی برای افزودن وجود ندارد.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            selectedStudentId ??= availableStudents.first.id;

            return AlertDialog(
              title: const Text('افزودن دانشجو به کلاس'),
              content: DropdownButtonFormField<String>(
                initialValue: selectedStudentId,
                decoration: const InputDecoration(
                  labelText: 'انتخاب دانشجو',
                  border: OutlineInputBorder(),
                ),
                items: availableStudents.map((StudentInClassModel student) {
                  return DropdownMenuItem<String>(
                    value: student.id,
                    child: Text('${student.name} - ${student.studentId}'),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setDialogState(() {
                    selectedStudentId = value;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('انصراف'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final StudentInClassModel student = availableStudents.firstWhere(
                      (StudentInClassModel item) => item.id == selectedStudentId,
                    );

                    appState.addStudentToClass(
                      classId: classItem.id,
                      studentId: student.id,
                      studentName: student.name,
                    );

                    Navigator.pop(dialogContext);
                    showMessage('دانشجو به کلاس اضافه شد.');
                  },
                  icon: const Icon(Icons.person_add_alt),
                  label: const Text('افزودن'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildClassTile(
    AppState appState,
    EducationManagedClassModel classItem,
  ) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statusColor(classItem.status).withValues(alpha: 0.12),
          child: Icon(
            Icons.school_outlined,
            color: statusColor(classItem.status),
          ),
        ),
        title: Text(
          classItem.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'استاد: ${classItem.professorName}\n'
          '${classItem.weekDay} | ${formatTimeOfDay(classItem.startTime)} - ${formatTimeOfDay(classItem.endTime)}\n'
          'دانشجویان: ${classItem.studentNames.length} | ${classItem.semester}',
        ),
        childrenPadding: const EdgeInsets.all(12),
        trailing: Chip(
          label: Text(
            statusText(classItem.status),
            style: const TextStyle(fontSize: 11),
          ),
          backgroundColor: statusColor(classItem.status).withValues(alpha: 0.10),
        ),
        children: <Widget>[
          if (appState.hasPermission(AppPermission.editClass))
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => showAddStudentDialog(appState, classItem),
                icon: const Icon(Icons.person_add_alt),
                label: const Text('افزودن دانشجو به این کلاس'),
              ),
            ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'دانشجویان کلاس',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          ...List.generate(classItem.studentIds.length, (int index) {
            final String studentId = classItem.studentIds[index];
            final String studentName =
                index < classItem.studentNames.length ? classItem.studentNames[index] : studentId;

            return ListTile(
              dense: true,
              leading: const Icon(Icons.person_outline),
              title: Text(studentName),
              subtitle: Text(studentId),
              trailing: appState.hasPermission(AppPermission.editClass)
                  ? IconButton(
                      tooltip: 'حذف دانشجو از کلاس',
                      onPressed: () {
                        appState.removeStudentFromClass(
                          classId: classItem.id,
                          studentId: studentId,
                        );
                      },
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    )
                  : null,
            );
          }),
        ],
      ),
    );
  }
}




