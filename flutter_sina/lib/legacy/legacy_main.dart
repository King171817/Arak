import 'package:flutter/material.dart';
import 'dart:async'; // Required for Future.delayed
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

BuildContext? globalContext;
// --- Enums & Helpers ---
Future<Uint8List> _loadImageBytes(String path) async {
  return await rootBundle.load(path).then((data) => data.buffer.asUint8List());
}

enum AppLang { fa, en, ar }

String langCode(AppLang lang) {
  switch (lang) {
    case AppLang.fa:
      return 'فارسی';
    case AppLang.en:
      return 'English';
    case AppLang.ar:
      return 'العربية';
  }
}

bool isRtlLang(AppLang lang) {
  return lang == AppLang.fa || lang == AppLang.ar;
}

String _langKey(AppLang lang) {
  switch (lang) {
    case AppLang.fa:
      return 'FA';
    case AppLang.en:
      return 'EN';
    case AppLang.ar:
      return 'AR';
  }
}

String tr(AppLang lang, String key) {
  final Map<String, Map<String, String>> data = {
    'app_name': {
      'FA': 'دانشگاه اراک',
      'EN': 'Arak University',
      'AR': 'جامعة أراك',
    },
    'login': {'FA': 'ورود', 'EN': 'Login', 'AR': 'تسجيل الدخول'},
    'username': {'FA': 'نام کاربری', 'EN': 'Username', 'AR': 'اسم المستخدم'},
    'password': {'FA': 'رمز عبور', 'EN': 'Password', 'AR': 'كلمة المرور'},
    'language': {'FA': 'زبان', 'EN': 'Language', 'AR': 'اللغة'},
    'register': {'FA': 'ثبت‌نام', 'EN': 'Register', 'AR': 'التسجيل'},
    'student_id': {
      'FA': 'شماره دانشجویی',
      'EN': 'Student ID',
      'AR': 'رقم الطالب',
    },
    'email': {'FA': 'ایمیل', 'EN': 'Email', 'AR': 'البريد الإلكتروني'},
    'already_have_account': {
      'FA': 'قبلاً ثبت‌نام کرده‌ام',
      'EN': 'I already have an account',
      'AR': 'لدي حساب بالفعل',
    },
    'create_new_account': {
      'FA': 'ثبت‌نام کاربر جدید',
      'EN': 'Create new account',
      'AR': 'إنشاء حساب جديد',
    },
    'login_info': {
      'FA': 'ادمین سیستم: sina / دانشجو: admin / مدیران: admin1 تا admin5 / استاد: prof1, prof2 / رمز: 1234',
      'EN': 'System Admin: sina / Student: admin / Managers: admin1 to admin5 / Professor: prof1, prof2 / Password: 1234',
      'AR': 'مسؤول النظام: sina / الطالب: admin / المدراء: admin1 إلى admin5 / الأستاذ: prof1, prof2 / كلمة المرور: 1234',
    },
    'incorrect_credentials': {
      'FA': 'نام کاربری یا رمز عبور اشتباه است',
      'EN': 'Username or password is incorrect',
      'AR': 'اسم المستخدم أو كلمة المرور غير صحيحة',
    },
    'registration_conceptual': {
      'FA': 'ثبت‌نام فعلاً به‌صورت مفهومی انجام شد',
      'EN': 'Registration is conceptual for now',
      'AR': 'التسجيل افتراضي حالياً',
    },
    'professor': {
      'FA': 'استاد',
      'EN': 'Professor',
      'AR': 'أستاذ',
    },
  };

  return data[key]?[_langKey(lang)] ?? key;
}

class EducationClassManagementScreen extends StatefulWidget {
  const EducationClassManagementScreen({super.key});

  @override
  State<EducationClassManagementScreen> createState() =>
      _EducationClassManagementScreenState();
}

class _EducationClassManagementScreenState
    extends State<EducationClassManagementScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  String selectedProfessorId = mockProfessors.first.id;
  String selectedWeekDay = 'شنبه';
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 11, minute: 30);

  final Set<String> selectedStudentIds = {};

  final List<String> weekDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنجشنبه',
  ];

  @override
  void initState() {
    super.initState();
    semesterController.text = 'نیمسال اول ۱۴۰۴';
  }

  @override
  void dispose() {
    titleController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  Future<void> pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );

    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );

    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  void createClass(AppState appState) {
    if (!appState.hasEducationPermission(EducationPermission.createClass)) {
      showMessage('شما دسترسی ایجاد کلاس جدید را ندارید.');
      return;
    }

    if (titleController.text.trim().isEmpty) {
      showMessage('عنوان کلاس را وارد کنید.');
      return;
    }

    if (selectedStudentIds.isEmpty) {
      showMessage('حداقل یک دانشجو انتخاب کنید.');
      return;
    }

    final ProfessorModel professor =
        mockProfessors.firstWhere((p) => p.id == selectedProfessorId);

    final List<StudentInClassModel> selectedStudents = mockStudents
        .where((student) => selectedStudentIds.contains(student.id))
        .toList();

    appState.addEducationClass(
      title: titleController.text.trim(),
      professorId: professor.id,
      professorName: professor.name,
      studentIds: selectedStudents.map((s) => s.id).toList(),
      studentNames: selectedStudents.map((s) => s.name).toList(),
      weekDay: selectedWeekDay,
      startTime: selectedStartTime,
      endTime: selectedEndTime,
      semester: semesterController.text.trim(),
    );

    titleController.clear();
    selectedStudentIds.clear();

    showMessage('کلاس جدید با موفقیت ایجاد شد.');
    setState(() {});
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
    final AppState appState = Provider.of<AppState>(context);
    final AppLang lang = appState.selectedLang;
    final bool isRtl = isRtlLang(lang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مدیریت کلاس‌های آموزش'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'بازگشت',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        body: !appState.canAccessEducationClassManagement
            ? const Center(
                child: Text(
                  'شما به مدیریت کلاس‌های آموزش دسترسی ندارید.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final bool wide = constraints.maxWidth >= 980;

                  if (wide) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildMainReports(appState),
                        ),
                        Container(
                          width: 420,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: _buildCreateClassPanel(appState),
                        ),
                      ],
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildCreateClassPanel(appState),
                      const SizedBox(height: 16),
                      _buildMainReports(appState),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildMainReports(AppState appState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCards(appState),
        const SizedBox(height: 16),
        _buildActiveClasses(appState),
        const SizedBox(height: 16),
        _buildPastClasses(appState),
        const SizedBox(height: 16),
        _buildClassReports(appState),
      ],
    );
  }

  Widget _buildSummaryCards(AppState appState) {
    final int activeCount = appState.activeEducationClasses.length;
    final int pastCount = appState.pastEducationClasses.length;
    final int reportsCount = appState.educationClassReports.length;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildSummaryCard(
          title: 'کلاس‌های فعال',
          value: activeCount.toString(),
          icon: Icons.play_circle_outline,
          color: Colors.green,
        ),
        _buildSummaryCard(
          title: 'کلاس‌های گذشته',
          value: pastCount.toString(),
          icon: Icons.history,
          color: Colors.blueGrey,
        ),
        _buildSummaryCard(
          title: 'گزارش‌های ثبت‌شده',
          value: reportsCount.toString(),
          icon: Icons.assignment_outlined,
          color: Colors.deepPurple,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveClasses(AppState appState) {
    final List<EducationManagedClassModel> classes =
        appState.activeEducationClasses;

    return _buildSectionCard(
      title: 'کلاس‌های فعال و زمان‌بندی‌شده',
      icon: Icons.event_available,
      child: classes.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('کلاس فعالی ثبت نشده است.'),
            )
          : Column(
              children: classes.map((c) {
                return _buildClassTile(
                  appState: appState,
                  classItem: c,
                  showCancel: true,
                );
              }).toList(),
            ),
    );
  }

  Widget _buildPastClasses(AppState appState) {
    final List<EducationManagedClassModel> classes =
        appState.pastEducationClasses;

    return _buildSectionCard(
      title: 'کلاس‌های گذشته',
      icon: Icons.history,
      child: classes.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('کلاس گذشته‌ای ثبت نشده است.'),
            )
          : Column(
              children: classes.map((c) {
                return _buildClassTile(
                  appState: appState,
                  classItem: c,
                  showCancel: false,
                );
              }).toList(),
            ),
    );
  }

  Widget _buildClassTile({
    required AppState appState,
    required EducationManagedClassModel classItem,
    required bool showCancel,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor(classItem.status).withValues(alpha: 0.15),
          child: Icon(
            Icons.school_outlined,
            color: statusColor(classItem.status),
          ),
        ),
        title: Text(
          classItem.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'استاد: ${classItem.professorName}\n'
            'روز: ${classItem.weekDay} | ساعت: ${formatTime(classItem.startTime)} تا ${formatTime(classItem.endTime)}\n'
            'دانشجویان: ${classItem.studentNames.length} نفر | ترم: ${classItem.semester}',
          ),
        ),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 6,
          children: [
            Chip(
              label: Text(
                statusText(classItem.status),
                style: const TextStyle(fontSize: 11),
              ),
              backgroundColor:
                  statusColor(classItem.status).withValues(alpha: 0.12),
            ),
            if (appState.hasEducationPermission(EducationPermission.manageStudents))
              IconButton(
                tooltip: 'مدیریت دانشجویان کلاس',
                icon: const Icon(Icons.group_add_outlined, color: Colors.green),
                onPressed: () => _showManageStudentsDialog(appState, classItem),
              ),
            if (showCancel &&
                appState.hasEducationPermission(EducationPermission.editClass))
              IconButton(
                tooltip: 'لغو کلاس',
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                onPressed: () {
                  appState.cancelEducationClass(classItem.id);
                  showMessage('کلاس لغو شد.');
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showManageStudentsDialog(
    AppState appState,
    EducationManagedClassModel classItem,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final List<StudentInClassModel> enrolled = mockStudents
                .where((s) => classItem.studentIds.contains(s.id))
                .toList();
            final List<StudentInClassModel> available = mockStudents
                .where((s) => !classItem.studentIds.contains(s.id))
                .toList();
            StudentInClassModel? selected = available.isEmpty ? null : available.first;
            return AlertDialog(
              title: Text('مدیریت دانشجویان کلاس ${classItem.title}'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('دانشجویان فعلی', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (enrolled.isEmpty)
                        const Text('دانشجویی در این کلاس ثبت نشده است.')
                      else
                        ...enrolled.map((student) => Card(
                              child: ListTile(
                                leading: const Icon(Icons.person_outline),
                                title: Text(student.name),
                                subtitle: Text('شماره دانشجویی: ${student.studentId}'),
                                trailing: IconButton(
                                  tooltip: 'حذف از کلاس',
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () {
                                    appState.removeStudentFromEducationClass(
                                      classId: classItem.id,
                                      studentId: student.id,
                                    );
                                    setState(() {});
                                    setDialogState(() {});
                                  },
                                ),
                              ),
                            )),
                      const Divider(height: 24),
                      const Text('افزودن دانشجو', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (available.isEmpty)
                        const Text('همه دانشجویان موجود به کلاس اضافه شده‌اند.')
                      else
                        DropdownButtonFormField<StudentInClassModel>(
                          value: selected,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'انتخاب دانشجو',
                          ),
                          items: available.map((student) {
                            return DropdownMenuItem<StudentInClassModel>(
                              value: student,
                              child: Text('${student.name} - ${student.studentId}'),
                            );
                          }).toList(),
                          onChanged: (value) => selected = value,
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('بستن'),
                ),
                ElevatedButton.icon(
                  onPressed: available.isEmpty
                      ? null
                      : () {
                          if (selected == null) return;
                          appState.addStudentToEducationClass(
                            classId: classItem.id,
                            student: selected!,
                          );
                          setState(() {});
                          setDialogState(() {});
                          showMessage('دانشجو به کلاس اضافه شد.');
                        },
                  icon: const Icon(Icons.add),
                  label: const Text('افزودن'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildClassReports(AppState appState) {
    final List<EducationClassReportModel> reports =
        appState.educationClassReports;

    return _buildSectionCard(
      title: 'گزارش دقیق کلاس‌های برگزارشده',
      icon: Icons.analytics_outlined,
      child: reports.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('هنوز گزارشی ثبت نشده است.'),
            )
          : Column(
              children: reports.map(_buildReportTile).toList(),
            ),
    );
  }

  Widget _buildReportTile(EducationClassReportModel report) {
    final int minutes = report.classDuration.inMinutes;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: const CircleAvatar(
          child: Icon(Icons.description_outlined),
        ),
        title: Text(
          report.classTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'استاد: ${report.professorName} | حاضر: ${report.presentStudents}/${report.totalStudents}',
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          _buildReportRow('تعداد کل دانشجویان', report.totalStudents.toString()),
          _buildReportRow('حاضرین', report.presentStudents.toString()),
          _buildReportRow('غایبین', report.absentStudents.toString()),
          _buildReportRow('تعداد پیام‌ها', report.totalMessages.toString()),
          _buildReportRow('فایل‌های ارسال‌شده', report.uploadedFiles.toString()),
          _buildReportRow('مدت کلاس', '$minutes دقیقه'),
          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'حاضرین: ${report.presentStudentNames.isEmpty ? '—' : report.presentStudentNames.join('، ')}',
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'غایبین: ${report.absentStudentNames.isEmpty ? '—' : report.absentStudentNames.join('، ')}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateClassPanel(AppState appState) {
    final bool canCreate =
        appState.hasEducationPermission(EducationPermission.createClass);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildSectionCard(
        title: 'افزودن کلاس جدید',
        icon: Icons.add_circle_outline,
        child: !canCreate
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Text('شما دسترسی افزودن کلاس جدید را ندارید.'),
              )
            : Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان کلاس',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: semesterController,
                      decoration: InputDecoration(
                        labelText: 'ترم',
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedProfessorId,
                      decoration: InputDecoration(
                        labelText: 'انتخاب استاد',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: mockProfessors.map((professor) {
                        return DropdownMenuItem<String>(
                          value: professor.id,
                          child: Text(professor.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          selectedProfessorId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedWeekDay,
                      decoration: InputDecoration(
                        labelText: 'روز هفته',
                        prefixIcon: const Icon(Icons.event),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: weekDays.map((day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          selectedWeekDay = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickStartTime,
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              'شروع: ${formatTime(selectedStartTime)}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickEndTime,
                            icon: const Icon(Icons.access_time_filled),
                            label: Text(
                              'پایان: ${formatTime(selectedEndTime)}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'انتخاب دانشجویان',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...mockStudents.map((student) {
                      final bool selected = selectedStudentIds.contains(student.id);

                      return CheckboxListTile(
                        value: selected,
                        title: Text(student.name),
                        subtitle: Text('شماره دانشجویی: ${student.studentId}'),
                        onChanged: (value) {
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => createClass(appState),
                        icon: const Icon(Icons.save),
                        label: const Text('ثبت کلاس جدید'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
class EducationPrivateChatScreen extends StatefulWidget {
  const EducationPrivateChatScreen({super.key});

  @override
  State<EducationPrivateChatScreen> createState() =>
      _EducationPrivateChatScreenState();
}

class _EducationPrivateChatScreenState extends State<EducationPrivateChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String currentUserId(AppState appState) {
    if (appState.isEducationManager) {
      return 'education_manager';
    }

    if (appState.isEducationOfficer) {
      return 'education_officer';
    }

    if (appState.userRole == 'admin') {
      return 'system_admin';
    }

    return appState.userIdentifier;
  }

  String currentUserName(AppState appState) {
    if (appState.isEducationManager) {
      return 'مدیر آموزش';
    }

    if (appState.isEducationOfficer) {
      return 'کارشناس آموزش';
    }

    if (appState.userRole == 'admin') {
      return 'مدیر اصلی';
    }

    return appState.userIdentifier;
  }

  String otherUserId(AppState appState) {
    if (appState.isEducationManager || appState.userRole == 'admin') {
      return 'education_officer';
    }

    return 'education_manager';
  }

  String otherUserName(AppState appState) {
    if (appState.isEducationManager || appState.userRole == 'admin') {
      return 'کارشناس آموزش';
    }

    return 'مدیر آموزش';
  }

  void sendMessage(AppState appState) {
    final String text = messageController.text.trim();
    if (text.isEmpty) return;

    appState.sendEducationPrivateMessage(
      senderId: currentUserId(appState),
      senderName: currentUserName(appState),
      receiverId: otherUserId(appState),
      receiverName: otherUserName(appState),
      message: text,
    );

    messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} - '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang lang = appState.selectedLang;
    final bool isRtl = isRtlLang(lang);

    final String meId = currentUserId(appState);
    final String otherId = otherUserId(appState);

    final List<EducationPrivateChatMessageModel> messages =
        appState.getEducationPrivateChatBetween(
      firstUserId: meId,
      secondUserId: otherId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.markEducationPrivateChatAsRead(
        currentUserId: meId,
        otherUserId: otherId,
      );
    });

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('چت خصوصی با ${otherUserName(appState)}'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildHeader(appState),
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        'هنوز پیامی ثبت نشده است.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final EducationPrivateChatMessageModel msg =
                            messages[index];

                        final bool isMine = msg.senderId == meId;

                        return _buildMessageBubble(
                          message: msg,
                          isMine: isMine,
                        );
                      },
                    ),
            ),
            _buildInput(appState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppState appState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: Colors.green.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.lock_outline, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'گفتگوی داخلی آموزش بین ${currentUserName(appState)} و ${otherUserName(appState)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Chip(
            label: Text('خصوصی'),
            avatar: Icon(Icons.verified_user, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required EducationPrivateChatMessageModel message,
    required bool isMine,
  }) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine
              ? Colors.green.withValues(alpha: 0.14)
              : Colors.grey.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMine
                ? Colors.green.withValues(alpha: 0.25)
                : Colors.grey.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMine ? Colors.green.shade700 : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.message,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              formatDateTime(message.sentAt),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(AppState appState) {
    final bool canChat =
        appState.hasEducationPermission(EducationPermission.privateChat) ||
            appState.userRole == 'admin';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              enabled: canChat,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: canChat
                    ? 'پیام خود را بنویسید...'
                    : 'شما دسترسی ارسال پیام خصوصی را ندارید.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (_) => sendMessage(appState),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            width: 48,
            child: ElevatedButton(
              onPressed: canChat ? () => sendMessage(appState) : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
class ProfessorLiveClassScreen extends StatefulWidget {
  final String classId;

  const ProfessorLiveClassScreen({
    super.key,
    required this.classId,
  });

  @override
  State<ProfessorLiveClassScreen> createState() =>
      _ProfessorLiveClassScreenState();
}

class _ProfessorLiveClassScreenState extends State<ProfessorLiveClassScreen> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
  final ScrollController messagesScrollController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    fileNameController.dispose();
    messagesScrollController.dispose();
    super.dispose();
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} - '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String statusText(LiveClassStatus status) {
    switch (status) {
      case LiveClassStatus.scheduled:
        return 'زمان‌بندی شده';
      case LiveClassStatus.waitingForProfessor:
        return 'در انتظار استاد';
      case LiveClassStatus.active:
        return 'در حال برگزاری';
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

  void sendTextMessage(AppState appState) {
    final String text = messageController.text.trim();
    if (text.isEmpty) return;

    final EducationManagedClassModel? classItem = findClass(appState);
    if (classItem == null) return;

    appState.sendLiveClassMessage(
      classId: classItem.id,
      senderId: appState.userIdentifier,
      senderName: classItem.professorName,
      text: text,
    );

    messageController.clear();
    scrollMessagesToBottom();
  }

  void sendFileMessage(AppState appState) {
    final String fileName = fileNameController.text.trim();
    if (fileName.isEmpty) {
      showMessage('نام فایل را وارد کنید.');
      return;
    }

    final EducationManagedClassModel? classItem = findClass(appState);
    if (classItem == null) return;

    appState.sendLiveClassMessage(
      classId: classItem.id,
      senderId: appState.userIdentifier,
      senderName: classItem.professorName,
      text: 'فایل ارسال شد: $fileName',
      hasFile: true,
      fileName: fileName,
    );

    fileNameController.clear();
    Navigator.pop(context);
    scrollMessagesToBottom();
  }

  void scrollMessagesToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messagesScrollController.hasClients) {
        messagesScrollController.animateTo(
          messagesScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  EducationManagedClassModel? findClass(AppState appState) {
    try {
      return appState.educationClasses.firstWhere(
        (c) => c.id == widget.classId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang lang = appState.selectedLang;
    final bool isRtl = isRtlLang(lang);

    final EducationManagedClassModel? classItem = findClass(appState);

    if (classItem == null) {
      return const Scaffold(
        body: Center(
          child: Text('کلاس پیدا نشد.'),
        ),
      );
    }

    final List<LiveClassParticipantModel> participants =
        appState.getClassParticipants(classItem.id);

    final List<LiveClassMessageModel> messages =
        appState.getClassMessages(classItem.id);

    final bool isProfessorOwner =
        appState.userRole == 'professor' &&
        appState.userIdentifier == classItem.professorId;

    final bool classIsActive = classItem.status == LiveClassStatus.active;
    final bool classIsFinished = classItem.status == LiveClassStatus.finished ||
        classItem.status == LiveClassStatus.cancelled;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(classItem.title),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                label: Text(statusText(classItem.status)),
                backgroundColor:
                    statusColor(classItem.status).withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool wide = constraints.maxWidth >= 950;

            if (wide) {
              return Row(
                children: [
                  SizedBox(
                    width: 330,
                    child: _buildParticipantsPanel(
                      appState: appState,
                      classItem: classItem,
                      participants: participants,
                      classIsActive: classIsActive,
                    ),
                  ),
                  Expanded(
                    child: _buildClassMainArea(
                      appState: appState,
                      classItem: classItem,
                      messages: messages,
                      isProfessorOwner: isProfessorOwner,
                      classIsActive: classIsActive,
                      classIsFinished: classIsFinished,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                SizedBox(
                  height: 190,
                  child: _buildParticipantsPanel(
                    appState: appState,
                    classItem: classItem,
                    participants: participants,
                    classIsActive: classIsActive,
                    compact: true,
                  ),
                ),
                Expanded(
                  child: _buildClassMainArea(
                    appState: appState,
                    classItem: classItem,
                    messages: messages,
                    isProfessorOwner: isProfessorOwner,
                    classIsActive: classIsActive,
                    classIsFinished: classIsFinished,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildClassMainArea({
    required AppState appState,
    required EducationManagedClassModel classItem,
    required List<LiveClassMessageModel> messages,
    required bool isProfessorOwner,
    required bool classIsActive,
    required bool classIsFinished,
  }) {
    return Column(
      children: [
        _buildClassHeader(
          appState: appState,
          classItem: classItem,
          isProfessorOwner: isProfessorOwner,
          classIsActive: classIsActive,
          classIsFinished: classIsFinished,
        ),
        Expanded(
          child: _buildMessagesArea(messages),
        ),
        _buildMessageInput(
          appState: appState,
          classItem: classItem,
          enabled: classIsActive && !classIsFinished,
        ),
      ],
    );
  }

  Widget _buildClassHeader({
    required AppState appState,
    required EducationManagedClassModel classItem,
    required bool isProfessorOwner,
    required bool classIsActive,
    required bool classIsFinished,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: Colors.green.withValues(alpha: 0.2)),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(
            avatar: const Icon(Icons.person, size: 18),
            label: Text('استاد: ${classItem.professorName}'),
          ),
          Chip(
            avatar: const Icon(Icons.event, size: 18),
            label: Text(classItem.weekDay),
          ),
          Chip(
            avatar: const Icon(Icons.access_time, size: 18),
            label: Text(
              '${formatTime(classItem.startTime)} تا ${formatTime(classItem.endTime)}',
            ),
          ),
          Chip(
            avatar: const Icon(Icons.groups, size: 18),
            label: Text('${classItem.studentNames.length} دانشجو'),
          ),
          if (classItem.startedAt != null)
            Chip(
              avatar: const Icon(Icons.play_arrow, size: 18),
              label: Text('شروع: ${formatDateTime(classItem.startedAt!)}'),
            ),
          if (classItem.finishedAt != null)
            Chip(
              avatar: const Icon(Icons.stop, size: 18),
              label: Text('پایان: ${formatDateTime(classItem.finishedAt!)}'),
            ),
          const SizedBox(width: 8),
          if (isProfessorOwner && !classIsActive && !classIsFinished)
            ElevatedButton.icon(
              onPressed: () {
                appState.startLiveClass(classItem.id);
                showMessage('کلاس شروع شد. دانشجویان اکنون می‌توانند وارد شوند.');
              },
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('شروع کلاس'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          if (isProfessorOwner && classIsActive)
            ElevatedButton.icon(
              onPressed: () {
                appState.finishLiveClass(classItem.id);
                showMessage('کلاس پایان یافت و گزارش آن ثبت شد.');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('پایان کلاس'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(List<LiveClassMessageModel> messages) {
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'هنوز پیامی در کلاس ثبت نشده است.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      controller: messagesScrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final LiveClassMessageModel msg = messages[index];

        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            constraints: const BoxConstraints(maxWidth: 620),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: msg.hasFile
                  ? Colors.blue.withValues(alpha: 0.10)
                  : Colors.green.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: msg.hasFile
                    ? Colors.blue.withValues(alpha: 0.25)
                    : Colors.green.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      msg.hasFile
                          ? Icons.attach_file
                          : Icons.chat_bubble_outline,
                      size: 18,
                      color: msg.hasFile ? Colors.blue : Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        msg.senderName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '${msg.sentAt.hour.toString().padLeft(2, '0')}:${msg.sentAt.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(msg.text),
                if (msg.hasFile && msg.fileName != null) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_present),
                    label: Text(msg.fileName!),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput({
    required AppState appState,
    required EducationManagedClassModel classItem,
    required bool enabled,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'ارسال فایل',
            onPressed: enabled ? () => _showFileDialog(appState) : null,
            icon: const Icon(Icons.attach_file),
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: enabled
                    ? 'پیام کلاس را بنویسید...'
                    : 'تا زمانی که استاد کلاس را شروع نکند، امکان تعامل وجود ندارد.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (_) => sendTextMessage(appState),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            height: 48,
            child: ElevatedButton(
              onPressed: enabled ? () => sendTextMessage(appState) : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }

  void _showFileDialog(AppState appState) {
    fileNameController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ارسال فایل در کلاس'),
          content: TextField(
            controller: fileNameController,
            decoration: InputDecoration(
              labelText: 'نام فایل',
              hintText: 'مثلاً lesson.pdf',
              prefixIcon: const Icon(Icons.file_present),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف'),
            ),
            ElevatedButton.icon(
              onPressed: () => sendFileMessage(appState),
              icon: const Icon(Icons.upload_file),
              label: const Text('ارسال'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParticipantsPanel({
    required AppState appState,
    required EducationManagedClassModel classItem,
    required List<LiveClassParticipantModel> participants,
    required bool classIsActive,
    bool compact = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          left: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.08),
              border: Border(
                bottom: BorderSide(
                  color: Colors.blueGrey.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.groups_2_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'دانشجویان کلاس (${participants.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: participants.isEmpty
                ? const Center(child: Text('دانشجویی ثبت نشده است.'))
                : ListView.builder(
                    scrollDirection: compact ? Axis.horizontal : Axis.vertical,
                    padding: const EdgeInsets.all(10),
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final LiveClassParticipantModel p = participants[index];

                      if (compact) {
                        return SizedBox(
                          width: 250,
                          child: _buildParticipantTile(
                            appState: appState,
                            classItem: classItem,
                            participant: p,
                            classIsActive: classIsActive,
                          ),
                        );
                      }

                      return _buildParticipantTile(
                        appState: appState,
                        classItem: classItem,
                        participant: p,
                        classIsActive: classIsActive,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantTile({
    required AppState appState,
    required EducationManagedClassModel classItem,
    required LiveClassParticipantModel participant,
    required bool classIsActive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: participant.isOnline
                      ? Colors.green.withValues(alpha: 0.18)
                      : Colors.grey.withValues(alpha: 0.18),
                  child: Icon(
                    participant.isOnline ? Icons.person : Icons.person_off,
                    color: participant.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participant.studentName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        participant.studentId,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (participant.raisedHand)
                  const Icon(Icons.pan_tool_alt, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Chip(
                  label: Text(
                    participant.isOnline ? 'آنلاین' : 'غایب',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: participant.isOnline
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.grey.withValues(alpha: 0.12),
                ),
                Chip(
                  label: Text(
                    participant.isMuted ? 'بی‌صدا' : 'دارای صدا',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: participant.isMuted
                      ? Colors.red.withValues(alpha: 0.10)
                      : Colors.green.withValues(alpha: 0.10),
                ),
                Chip(
                  label: Text(
                    participant.canSpeak ? 'اجازه صحبت دارد' : 'بدون اجازه صحبت',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: classIsActive
                        ? () {
                            appState.toggleStudentMute(
                              classId: classItem.id,
                              studentId: participant.studentId,
                            );
                          }
                        : null,
                    icon: Icon(
                      participant.isMuted ? Icons.mic_off : Icons.mic,
                    ),
                    label: Text(
                      participant.isMuted ? 'فعال‌سازی صدا' : 'قطع صدا',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: classIsActive
                        ? () {
                            appState.allowStudentToSpeak(
                              classId: classItem.id,
                              studentId: participant.studentId,
                              allow: !participant.canSpeak,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.record_voice_over_outlined),
                    label: Text(
                      participant.canSpeak
                          ? 'لغو اجازه صحبت'
                          : 'اجازه صحبت',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// --- App State Management ---

class AppState extends ChangeNotifier {
  AppLang _selectedLang = AppLang.fa;
  String _userRole = 'guest';
  String _userIdentifier = '';
  bool _isDarkMode = false;
  bool _isLoggedIn = false;

  String _globalFloatingMessage = 'پیام مدیر اصلی: لطفاً اعلان‌ها، برنامه هفتگی و وضعیت کلاس‌ها را بررسی کنید.';
  DateTime? _globalFloatingMessageExpiresAt;
  bool _globalFloatingMessageEnabled = true;
  String _globalFloatingMessageTargetRole = 'all';
  String _systemBackgroundMode = 'spring';
  String _systemLogoMode = 'arak_default';
  bool _systemMaintenanceMode = false;
  bool _systemAllowRegistration = true;
  final List<AdminSystemAuditLog> _adminAuditLogs = <AdminSystemAuditLog>[];

  final List<AppNotification> _managerNotifications = [];
  final List<AppNotification> _professorNotifications = [];
  final List<AppNotification> _studentNotifications = [];
  final List<AppNotification> _adminNotifications = [];

  final List<EducationOfficerModel> _educationOfficers = [
    EducationOfficerModel(
      id: 'eo001',
      name: 'کارشناس آموزش',
      username: 'admin5',
      permissions: [
        EducationPermission.viewReports,
        EducationPermission.manageClasses,
        EducationPermission.createClass,
        EducationPermission.manageStudents,
        EducationPermission.privateChat,
        EducationPermission.viewClassHistory,
      ],
    ),
  ];

  final List<EducationManagedClassModel> _educationClasses = [
    EducationManagedClassModel(
      id: 'ec001',
      title: 'برنامه‌نویسی پیشرفته',
      professorId: 'p001',
      professorName: 'دکتر محمدی',
      studentIds: ['s001', 's002'],
      studentNames: ['رضا حسینی', 'علی احمدی'],
      weekDay: 'شنبه',
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 30),
      semester: 'نیمسال اول ۱۴۰۴',
      createdAt: DateTime(2026, 4, 1),
      status: LiveClassStatus.scheduled,
    ),
    EducationManagedClassModel(
      id: 'ec002',
      title: 'پایگاه داده',
      professorId: 'p001',
      professorName: 'دکتر محمدی',
      studentIds: ['s001', 's003', 's004'],
      studentNames: ['رضا حسینی', 'فاطمه رضایی', 'Sara Smith'],
      weekDay: 'دوشنبه',
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
      semester: 'نیمسال اول ۱۴۰۴',
      createdAt: DateTime(2026, 4, 2),
      status: LiveClassStatus.finished,
      startedAt: DateTime(2026, 4, 20, 14, 0),
      finishedAt: DateTime(2026, 4, 20, 15, 28),
    ),
  ];

  final Map<String, List<LiveClassParticipantModel>> _classParticipants = {};
  final Map<String, List<LiveClassMessageModel>> _classMessages = {};
  final List<EducationClassReportModel> _educationClassReports = [];
  final List<EducationPrivateChatMessageModel> _educationPrivateChats = [];

  AppLang get selectedLang => _selectedLang;
  String get userRole => _userRole;
  String get userIdentifier => _userIdentifier;
  bool get isDarkMode => _isDarkMode;
  bool get isLoggedIn => _isLoggedIn;
  String get globalFloatingMessage => _globalFloatingMessage;
  DateTime? get globalFloatingMessageExpiresAt => _globalFloatingMessageExpiresAt;
  bool get globalFloatingMessageEnabled => _globalFloatingMessageEnabled;
  String get globalFloatingMessageTargetRole => _globalFloatingMessageTargetRole;
  String get systemBackgroundMode => _systemBackgroundMode;
  String get systemLogoMode => _systemLogoMode;
  bool get systemMaintenanceMode => _systemMaintenanceMode;
  bool get systemAllowRegistration => _systemAllowRegistration;
  List<AdminSystemAuditLog> get adminAuditLogs => List.unmodifiable(_adminAuditLogs);

  bool get isGlobalFloatingMessageActive {
    if (!_globalFloatingMessageEnabled) return false;
    if (_globalFloatingMessage.trim().isEmpty) return false;
    final DateTime? expires = _globalFloatingMessageExpiresAt;
    if (expires == null) return true;
    return DateTime.now().isBefore(expires);
  }

  bool get shouldShowGlobalFloatingMessageForCurrentUser {
    if (!isGlobalFloatingMessageActive) return false;
    switch (_globalFloatingMessageTargetRole) {
      case 'all':
        return true;
      case 'student':
        return _userRole == 'student';
      case 'manager':
        return _userRole == 'manager';
      case 'education':
        return isEducationManager || isEducationOfficer;
      case 'professor':
        return _userRole == 'professor';
      case 'admin':
        return _userRole == 'admin';
      default:
        return true;
    }
  }

  String get globalFloatingMessageTargetText {
    switch (_globalFloatingMessageTargetRole) {
      case 'student':
        return 'دانشجویان';
      case 'manager':
        return 'همه مدیران واحدها';
      case 'education':
        return 'مدیر و کارشناسان آموزش';
      case 'professor':
        return 'اساتید';
      case 'admin':
        return 'مدیر اصلی';
      default:
        return 'همه کاربران';
    }
  }

  String get globalFloatingMessageRemainingText {
    final DateTime? expires = _globalFloatingMessageExpiresAt;
    if (expires == null) return 'بدون محدودیت زمانی';
    final Duration left = expires.difference(DateTime.now());
    if (left.isNegative) return 'پایان‌یافته';
    if (left.inDays >= 1) return '${left.inDays} روز و ${left.inHours % 24} ساعت باقی‌مانده';
    if (left.inHours >= 1) return '${left.inHours} ساعت و ${left.inMinutes % 60} دقیقه باقی‌مانده';
    return '${left.inMinutes.clamp(0, 59)} دقیقه باقی‌مانده';
  }

  List<AppNotification> get managerNotifications => List.unmodifiable(_managerNotifications);
  List<AppNotification> get professorNotifications => List.unmodifiable(_professorNotifications);
  List<AppNotification> get studentNotifications => List.unmodifiable(_studentNotifications);
  List<AppNotification> get adminNotifications => List.unmodifiable(_adminNotifications);

  List<EducationOfficerModel> get educationOfficers => List.unmodifiable(_educationOfficers);
  List<EducationManagedClassModel> get educationClasses => List.unmodifiable(_educationClasses);
  List<EducationClassReportModel> get educationClassReports => List.unmodifiable(_educationClassReports);
  List<EducationPrivateChatMessageModel> get educationPrivateChats => List.unmodifiable(_educationPrivateChats);

  List<EducationManagedClassModel> get activeEducationClasses {
    return _educationClasses
        .where((c) =>
            c.status == LiveClassStatus.scheduled ||
            c.status == LiveClassStatus.waitingForProfessor ||
            c.status == LiveClassStatus.active)
        .toList();
  }

  List<EducationManagedClassModel> get pastEducationClasses {
    return _educationClasses
        .where((c) =>
            c.status == LiveClassStatus.finished ||
            c.status == LiveClassStatus.cancelled)
        .toList();
  }

  bool get isEducationManager {
    return _userRole == 'manager' && _userIdentifier == 'education';
  }

  bool get isEducationOfficer {
    return _userRole == 'manager' && _userIdentifier == 'education_officer';
  }

  bool get canAccessEducationClassManagement {
    return isEducationManager || isEducationOfficer || _userRole == 'admin';
  }

  bool get canSeeClassBottomNav {
    return _userRole == 'student' ||
        _userRole == 'professor' ||
        isEducationManager ||
        isEducationOfficer;
  }

  bool get canEditEducationStudentProfile {
    return isEducationManager ||
        isEducationOfficer ||
        _userRole == 'admin';
  }

  bool get canEditEducationFinancialOrDiscipline {
    return false;
  }

  EducationOfficerModel? get currentEducationOfficer {
    if (!isEducationOfficer) return null;

    try {
      return _educationOfficers.firstWhere(
        (officer) => officer.username == _userIdentifier || officer.id == _userIdentifier,
      );
    } catch (_) {
      try {
        return _educationOfficers.firstWhere((officer) => officer.username == 'admin5');
      } catch (_) {
        return null;
      }
    }
  }

  bool hasEducationPermission(EducationPermission permission) {
    if (_userRole == 'admin') return true;
    if (isEducationManager) return true;

    final EducationOfficerModel? officer = currentEducationOfficer;
    if (officer == null) return false;

    return officer.hasPermission(permission);
  }

  void addEducationOfficer({
    required String name,
    required String username,
    required List<EducationPermission> permissions,
  }) {
    if (!isEducationManager && _userRole != 'admin') return;
    final String id = 'eo${DateTime.now().millisecondsSinceEpoch}';
    _educationOfficers.add(EducationOfficerModel(
      id: id,
      name: name,
      username: username,
      permissions: permissions,
    ));
    addNotificationForRole('manager', AppNotification(
      title: 'کارشناس آموزش جدید',
      subtitle: '$name با نام کاربری $username تعریف شد.',
      unitKey: 'education',
      unread: true,
    ));
    notifyListeners();
  }

  void addStudentToEducationClass({
    required String classId,
    required StudentInClassModel student,
  }) {
    if (!hasEducationPermission(EducationPermission.manageStudents)) return;
    final int index = _educationClasses.indexWhere((c) => c.id == classId);
    if (index == -1) return;
    final EducationManagedClassModel current = _educationClasses[index];
    if (current.studentIds.contains(student.id)) return;
    final List<String> ids = List<String>.from(current.studentIds)..add(student.id);
    final List<String> names = List<String>.from(current.studentNames)..add(student.name);
    _educationClasses[index] = current.copyWith(studentIds: ids, studentNames: names);
    final List<LiveClassParticipantModel> participants = List<LiveClassParticipantModel>.from(_classParticipants[classId] ?? []);
    participants.add(LiveClassParticipantModel(
      studentId: student.id,
      studentName: student.name,
      isOnline: false,
      isMuted: true,
      canSpeak: false,
      raisedHand: false,
    ));
    _classParticipants[classId] = participants;
    notifyListeners();
  }

  void removeStudentFromEducationClass({
    required String classId,
    required String studentId,
  }) {
    if (!hasEducationPermission(EducationPermission.manageStudents)) return;
    final int index = _educationClasses.indexWhere((c) => c.id == classId);
    if (index == -1) return;
    final EducationManagedClassModel current = _educationClasses[index];
    final int studentIndex = current.studentIds.indexOf(studentId);
    if (studentIndex == -1) return;
    final List<String> ids = List<String>.from(current.studentIds)..removeAt(studentIndex);
    final List<String> names = List<String>.from(current.studentNames)..removeAt(studentIndex);
    _educationClasses[index] = current.copyWith(studentIds: ids, studentNames: names);
    final List<LiveClassParticipantModel> participants = List<LiveClassParticipantModel>.from(_classParticipants[classId] ?? []);
    participants.removeWhere((p) => p.studentId == studentId);
    _classParticipants[classId] = participants;
    notifyListeners();
  }


  void _addAdminAuditLog(String action, String detail) {
    _adminAuditLogs.insert(
      0,
      AdminSystemAuditLog(
        id: 'audit${DateTime.now().millisecondsSinceEpoch}',
        action: action,
        detail: detail,
        actor: _userRole == 'admin' ? 'sina' : _userIdentifier,
        createdAt: DateTime.now(),
      ),
    );
    if (_adminAuditLogs.length > 100) {
      _adminAuditLogs.removeRange(100, _adminAuditLogs.length);
    }
  }

  void setGlobalFloatingMessage({
    required String message,
    required Duration? duration,
    bool enabled = true,
    String targetRole = 'all',
  }) {
    if (_userRole != 'admin') return;
    _globalFloatingMessage = message.trim();
    _globalFloatingMessageEnabled = enabled;
    _globalFloatingMessageTargetRole = targetRole;
    _globalFloatingMessageExpiresAt = duration == null ? null : DateTime.now().add(duration);
    _addAdminAuditLog(
      'تنظیم پیام شناور',
      duration == null
          ? 'پیام برای گروه ${globalFloatingMessageTargetText} بدون محدودیت زمانی ثبت شد.'
          : 'پیام برای گروه ${globalFloatingMessageTargetText} به مدت ${duration.inHours} ساعت ثبت شد.',
    );

    final AppNotification notification = AppNotification(
      title: 'پیام جدید مدیر اصلی',
      subtitle: _globalFloatingMessage.length > 70 ? '${_globalFloatingMessage.substring(0, 70)}...' : _globalFloatingMessage,
      unitKey: 'admin',
      unread: true,
    );

    if (targetRole == 'all') {
      addNotificationForRole('student', notification);
      addNotificationForRole('manager', notification);
      addNotificationForRole('professor', notification);
      addNotificationForRole('admin', notification);
    } else if (targetRole == 'education' || targetRole == 'manager') {
      addNotificationForRole('manager', notification);
    } else {
      addNotificationForRole(targetRole, notification);
    }
    notifyListeners();
  }

  void clearGlobalFloatingMessage() {
    if (_userRole != 'admin') return;
    _globalFloatingMessage = '';
    _globalFloatingMessageEnabled = false;
    _globalFloatingMessageExpiresAt = null;
    _globalFloatingMessageTargetRole = 'all';
    _addAdminAuditLog('حذف پیام شناور', 'پیام شناور عمومی برنامه حذف شد.');
    notifyListeners();
  }

  void setSystemVisualSettings({
    required String backgroundMode,
    required String logoMode,
    required bool maintenanceMode,
    required bool allowRegistration,
  }) {
    if (_userRole != 'admin') return;
    _systemBackgroundMode = backgroundMode;
    _systemLogoMode = logoMode;
    _systemMaintenanceMode = maintenanceMode;
    _systemAllowRegistration = allowRegistration;
    _addAdminAuditLog('تغییر ظاهر و تنظیمات سیستم', 'آرم: $logoMode، بک‌گراند: $backgroundMode، تعمیرات: $maintenanceMode، ثبت‌نام: $allowRegistration');
    notifyListeners();
  }

  void setLanguage(AppLang lang) {
    if (_selectedLang != lang) {
      _selectedLang = lang;
      notifyListeners();
    }
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void login(String role, String identifier) {
    _userRole = role;
    _userIdentifier = identifier;
    _isLoggedIn = true;
    _loadNotificationsForRole(role);
    _prepareDefaultLiveClassData();
    notifyListeners();
  }

  void logout() {
    _userRole = 'guest';
    _userIdentifier = '';
    _isLoggedIn = false;
    notifyListeners();
  }

  void addEducationClass({
    required String title,
    required String professorId,
    required String professorName,
    required List<String> studentIds,
    required List<String> studentNames,
    required String weekDay,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String semester,
  }) {
    if (!hasEducationPermission(EducationPermission.createClass)) return;

    final String id = 'ec${DateTime.now().millisecondsSinceEpoch}';

    final EducationManagedClassModel newClass = EducationManagedClassModel(
      id: id,
      title: title,
      professorId: professorId,
      professorName: professorName,
      studentIds: studentIds,
      studentNames: studentNames,
      weekDay: weekDay,
      startTime: startTime,
      endTime: endTime,
      semester: semester,
      createdAt: DateTime.now(),
      status: LiveClassStatus.scheduled,
    );

    _educationClasses.add(newClass);

    _classParticipants[id] = List.generate(studentIds.length, (index) {
      return LiveClassParticipantModel(
        studentId: studentIds[index],
        studentName: studentNames[index],
        isOnline: false,
        isMuted: true,
        canSpeak: false,
        raisedHand: false,
      );
    });

    addNotificationForRole(
      'professor',
      AppNotification(
        title: 'کلاس جدید',
        subtitle: 'کلاس $title برای شما تعریف شد.',
        unitKey: 'education',
        unread: true,
      ),
    );

    addAdminNotification(
      title: 'کلاس جدید ایجاد شد',
      subtitle: 'کلاس $title توسط واحد آموزش ایجاد شد.',
      unitKey: 'education',
    );

    notifyListeners();
  }

  void updateEducationOfficerPermissions({
    required String officerId,
    required List<EducationPermission> permissions,
  }) {
    if (!isEducationManager && _userRole != 'admin') return;

    final int index = _educationOfficers.indexWhere((o) => o.id == officerId);
    if (index == -1) return;

    _educationOfficers[index] = _educationOfficers[index].copyWith(
      permissions: permissions,
    );

    addNotificationForRole(
      'manager',
      AppNotification(
        title: 'تغییر دسترسی کارشناس آموزش',
        subtitle: 'دسترسی‌های کارشناس آموزش به‌روزرسانی شد.',
        unitKey: 'education_officer',
        unread: true,
      ),
    );

    notifyListeners();
  }

  void startLiveClass(String classId) {
    final int index = _educationClasses.indexWhere((c) => c.id == classId);
    if (index == -1) return;

    final EducationManagedClassModel current = _educationClasses[index];

    if (_userRole != 'professor' || current.professorId != _userIdentifier) return;

    _educationClasses[index] = current.copyWith(
      status: LiveClassStatus.active,
      startedAt: DateTime.now(),
    );

    _prepareParticipantsForClass(current);

    addNotificationForRole(
      'student',
      AppNotification(
        title: 'کلاس شروع شد',
        subtitle: 'کلاس ${current.title} آغاز شد. اکنون می‌توانید وارد شوید.',
        unitKey: 'education',
        unread: true,
      ),
    );

    notifyListeners();
  }

  void finishLiveClass(String classId) {
    final int index = _educationClasses.indexWhere((c) => c.id == classId);
    if (index == -1) return;

    final EducationManagedClassModel current = _educationClasses[index];

    if (_userRole != 'professor' && !isEducationManager && _userRole != 'admin') return;

    final DateTime now = DateTime.now();

    _educationClasses[index] = current.copyWith(
      status: LiveClassStatus.finished,
      finishedAt: now,
    );

    _createClassReport(classId);

    addNotificationForRole(
      'manager',
      AppNotification(
        title: 'گزارش کلاس آماده شد',
        subtitle: 'گزارش کلاس ${current.title} ثبت شد.',
        unitKey: 'education',
        unread: true,
      ),
    );

    notifyListeners();
  }

  void cancelEducationClass(String classId) {
    if (!hasEducationPermission(EducationPermission.editClass)) return;

    final int index = _educationClasses.indexWhere((c) => c.id == classId);
    if (index == -1) return;

    _educationClasses[index] = _educationClasses[index].copyWith(
      status: LiveClassStatus.cancelled,
      finishedAt: DateTime.now(),
    );

    notifyListeners();
  }

  List<EducationManagedClassModel> getProfessorClasses(String professorId) {
    return _educationClasses.where((c) => c.professorId == professorId).toList();
  }

  List<EducationManagedClassModel> getStudentClasses(String studentId) {
    return _educationClasses.where((c) => c.studentIds.contains(studentId)).toList();
  }

  List<LiveClassParticipantModel> getClassParticipants(String classId) {
    return List.unmodifiable(_classParticipants[classId] ?? []);
  }

  List<LiveClassMessageModel> getClassMessages(String classId) {
    return List.unmodifiable(_classMessages[classId] ?? []);
  }

  void setStudentOnlineInClass({
    required String classId,
    required String studentId,
    required bool isOnline,
  }) {
    final List<LiveClassParticipantModel> participants =
        List<LiveClassParticipantModel>.from(_classParticipants[classId] ?? []);

    final int index = participants.indexWhere((p) => p.studentId == studentId);
    if (index == -1) return;

    participants[index] = participants[index].copyWith(isOnline: isOnline);
    _classParticipants[classId] = participants;

    notifyListeners();
  }

  void toggleStudentMute({
    required String classId,
    required String studentId,
  }) {
    final List<LiveClassParticipantModel> participants =
        List<LiveClassParticipantModel>.from(_classParticipants[classId] ?? []);

    final int index = participants.indexWhere((p) => p.studentId == studentId);
    if (index == -1) return;

    final LiveClassParticipantModel current = participants[index];

    participants[index] = current.copyWith(
      isMuted: !current.isMuted,
      canSpeak: current.isMuted,
    );

    _classParticipants[classId] = participants;
    notifyListeners();
  }

  void allowStudentToSpeak({
    required String classId,
    required String studentId,
    required bool allow,
  }) {
    final List<LiveClassParticipantModel> participants =
        List<LiveClassParticipantModel>.from(_classParticipants[classId] ?? []);

    final int index = participants.indexWhere((p) => p.studentId == studentId);
    if (index == -1) return;

    participants[index] = participants[index].copyWith(
      canSpeak: allow,
      isMuted: !allow,
    );

    _classParticipants[classId] = participants;
    notifyListeners();
  }

  void raiseHand({
    required String classId,
    required String studentId,
    required bool raised,
  }) {
    final List<LiveClassParticipantModel> participants =
        List<LiveClassParticipantModel>.from(_classParticipants[classId] ?? []);

    final int index = participants.indexWhere((p) => p.studentId == studentId);
    if (index == -1) return;

    participants[index] = participants[index].copyWith(raisedHand: raised);
    _classParticipants[classId] = participants;

    notifyListeners();
  }

  void sendLiveClassMessage({
    required String classId,
    required String senderId,
    required String senderName,
    required String text,
    bool hasFile = false,
    String? fileName,
  }) {
    if (text.trim().isEmpty && !hasFile) return;

    final LiveClassMessageModel message = LiveClassMessageModel(
      id: 'msg${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      text: text.trim(),
      sentAt: DateTime.now(),
      hasFile: hasFile,
      fileName: fileName,
    );

    final List<LiveClassMessageModel> messages =
        List<LiveClassMessageModel>.from(_classMessages[classId] ?? []);

    messages.add(message);
    _classMessages[classId] = messages;

    notifyListeners();
  }

  void sendEducationPrivateMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String message,
  }) {
    if (message.trim().isEmpty) return;

    _educationPrivateChats.add(
      EducationPrivateChatMessageModel(
        id: 'chat${DateTime.now().millisecondsSinceEpoch}',
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        receiverName: receiverName,
        message: message.trim(),
        sentAt: DateTime.now(),
        unread: true,
      ),
    );

    addNotificationForRole(
      'manager',
      AppNotification(
        title: 'پیام خصوصی آموزش',
        subtitle: message.length > 60 ? '${message.substring(0, 60)}...' : message,
        unitKey: 'education',
        unread: true,
      ),
    );

    notifyListeners();
  }

  List<EducationPrivateChatMessageModel> getEducationPrivateChatBetween({
    required String firstUserId,
    required String secondUserId,
  }) {
    return _educationPrivateChats.where((msg) {
      final bool direct =
          msg.senderId == firstUserId && msg.receiverId == secondUserId;
      final bool reverse =
          msg.senderId == secondUserId && msg.receiverId == firstUserId;
      return direct || reverse;
    }).toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  void markEducationPrivateChatAsRead({
    required String currentUserId,
    required String otherUserId,
  }) {
    for (int i = 0; i < _educationPrivateChats.length; i++) {
      final EducationPrivateChatMessageModel msg = _educationPrivateChats[i];

      if (msg.receiverId == currentUserId && msg.senderId == otherUserId) {
        _educationPrivateChats[i] = msg.copyWith(unread: false);
      }
    }

    notifyListeners();
  }

  List<AppNotification> getCurrentRoleNotifications() {
    switch (_userRole) {
      case 'admin':
        return _adminNotifications;
      case 'manager':
        return _managerNotifications;
      case 'professor':
        return _professorNotifications;
      case 'student':
        return _studentNotifications;
      default:
        return [];
    }
  }

  int getUnreadNotificationCountForCurrentRole() {
    return getCurrentRoleNotifications().where((n) => n.unread).length;
  }

  void addNotificationForRole(String role, AppNotification notification) {
    switch (role) {
      case 'admin':
        _adminNotifications.add(notification);
        break;
      case 'manager':
        _managerNotifications.add(notification);
        break;
      case 'professor':
        _professorNotifications.add(notification);
        break;
      case 'student':
        _studentNotifications.add(notification);
        break;
    }

    notifyListeners();
  }

  void addAdminNotification({
    required String title,
    required String subtitle,
    required String unitKey,
  }) {
    _adminNotifications.add(
      AppNotification(
        title: title,
        subtitle: subtitle,
        unitKey: unitKey,
        unread: true,
      ),
    );

    notifyListeners();
  }

  void markNotificationAsRead(String notificationTitle, String role) {
    List<AppNotification> targetList;

    switch (role) {
      case 'admin':
        targetList = _adminNotifications;
        break;
      case 'manager':
        targetList = _managerNotifications;
        break;
      case 'professor':
        targetList = _professorNotifications;
        break;
      default:
        targetList = _studentNotifications;
    }

    final int index = targetList.indexWhere((n) => n.title == notificationTitle);
    if (index == -1) return;

    targetList[index] = AppNotification(
      title: targetList[index].title,
      subtitle: targetList[index].subtitle,
      unitKey: targetList[index].unitKey,
      unread: false,
    );

    notifyListeners();
  }

  void _loadNotificationsForRole(String role) {
    if (_managerNotifications.isEmpty) {
      _managerNotifications.addAll([
        AppNotification(
          title: 'جلسه مدیریتی',
          subtitle: 'جلسه هماهنگی مدیران فردا ساعت 10 برگزار می‌شود.',
          unitKey: 'education',
          unread: true,
        ),
        AppNotification(
          title: 'درخواست جدید',
          subtitle: 'درخواست همکاری بین‌المللی نیاز به بررسی دارد.',
          unitKey: 'international',
          unread: true,
        ),
      ]);
    }

    if (_professorNotifications.isEmpty) {
      _professorNotifications.addAll([
        AppNotification(
          title: 'کلاس برنامه نویسی',
          subtitle: 'کلاس برنامه‌نویسی پیشرفته در داشبورد شما قرار گرفت.',
          unitKey: 'education',
          unread: true,
        ),
      ]);
    }

    if (_studentNotifications.isEmpty) {
      _studentNotifications.addAll([
        AppNotification(
          title: 'نتیجه درخواست',
          subtitle: 'درخواست گواهی شما صادر شد.',
          unitKey: 'education',
          unread: true,
        ),
      ]);
    }

    if (_adminNotifications.isEmpty) {
      _adminNotifications.addAll([
        AppNotification(
          title: 'بررسی دسترسی کاربران',
          subtitle: 'پنل مدیر اصلی آماده مدیریت نقش‌ها و اعلان‌ها است.',
          unitKey: 'admin',
          unread: true,
        ),
      ]);
    }
  }

  void _prepareDefaultLiveClassData() {
    for (final EducationManagedClassModel c in _educationClasses) {
      _prepareParticipantsForClass(c);
      _classMessages.putIfAbsent(c.id, () => []);
    }

    if (_educationClassReports.isEmpty) {
      for (final EducationManagedClassModel c in _educationClasses) {
        if (c.status == LiveClassStatus.finished) {
          _createClassReport(c.id, notify: false);
        }
      }
    }
  }

  void _prepareParticipantsForClass(EducationManagedClassModel c) {
    _classParticipants.putIfAbsent(c.id, () {
      return List.generate(c.studentIds.length, (index) {
        return LiveClassParticipantModel(
          studentId: c.studentIds[index],
          studentName: c.studentNames[index],
          isOnline: index == 0,
          isMuted: true,
          canSpeak: false,
          raisedHand: false,
        );
      });
    });
  }

  void _createClassReport(String classId, {bool notify = true}) {
    final EducationManagedClassModel? classItem = _getEducationClassById(classId);
    if (classItem == null) return;

    final bool alreadyExists =
        _educationClassReports.any((report) => report.classId == classId);
    if (alreadyExists) return;

    final List<LiveClassParticipantModel> participants =
        _classParticipants[classId] ?? [];

    final List<LiveClassMessageModel> messages =
        _classMessages[classId] ?? [];

    final List<LiveClassParticipantModel> present =
        participants.where((p) => p.isOnline).toList();

    final List<LiveClassParticipantModel> absent =
        participants.where((p) => !p.isOnline).toList();

    final int uploadedFiles = messages.where((m) => m.hasFile).length;

    final DateTime start = classItem.startedAt ?? classItem.createdAt;
    final DateTime finish = classItem.finishedAt ?? DateTime.now();

    _educationClassReports.add(
      EducationClassReportModel(
        id: 'rep${DateTime.now().millisecondsSinceEpoch}',
        classId: classItem.id,
        classTitle: classItem.title,
        professorName: classItem.professorName,
        reportDate: DateTime.now(),
        totalStudents: classItem.studentIds.length,
        presentStudents: present.length,
        absentStudents: absent.length,
        totalMessages: messages.length,
        uploadedFiles: uploadedFiles,
        classDuration: finish.difference(start),
        finalStatus: LiveClassStatus.finished,
        presentStudentNames: present.map((p) => p.studentName).toList(),
        absentStudentNames: absent.map((p) => p.studentName).toList(),
      ),
    );

    if (notify) {
      notifyListeners();
    }
  }

  EducationManagedClassModel? _getEducationClassById(String classId) {
    try {
      return _educationClasses.firstWhere((c) => c.id == classId);
    } catch (_) {
      return null;
    }
  }

  String getUnitName(String unitKey) {
    switch (unitKey) {
      case 'international':
        return 'امور بین‌الملل';
      case 'education':
        return 'آموزش';
      case 'education_officer':
        return 'کارشناس آموزش';
      case 'student_services':
        return 'خدمات دانشجویی';
      case 'consular':
        return 'کنسولی';
      case 'admin':
        return 'مدیر اصلی';
      default:
        return unitKey;
    }
  }

  void addManagerMessage(String targetUnit, String message) {
    addNotificationForRole(
      'manager',
      AppNotification(
        title: 'پیام جدید از ${getUnitName(_userIdentifier)}',
        subtitle: message.length > 50 ? '${message.substring(0, 50)}...' : message,
        unitKey: targetUnit,
        unread: true,
      ),
    );
  }

  void addMeeting(String title, String date, String time, String targetUnit) {
    addNotificationForRole(
      'manager',
      AppNotification(
        title: 'جلسه جدید: $title',
        subtitle: 'تاریخ: $date - ساعت: $time',
        unitKey: targetUnit,
        unread: true,
      ),
    );
  }

  void sendMessageToManager(String targetUnit, String message, String professorName) {
    addNotificationForRole(
      'manager',
      AppNotification(
        title: 'پیام از استاد $professorName',
        subtitle: message.length > 50 ? '${message.substring(0, 50)}...' : message,
        unitKey: targetUnit,
        unread: true,
      ),
    );
  }

  void sendMessageToProfessor(String professorId, String message, String unitName) {
    addNotificationForRole(
      'professor',
      AppNotification(
        title: 'پیام از واحد $unitName',
        subtitle: message.length > 50 ? '${message.substring(0, 50)}...' : message,
        unitKey: 'education',
        unread: true,
      ),
    );
  }
}

// --- Main App ---

void main() {
  runApp(
    ChangeNotifierProvider<AppState>(
      create: (BuildContext context) {
        // مقداردهی globalContext
        globalContext = context;
        return AppState();
      },
      builder: (BuildContext context, Widget? child) => const MyApp(),
    ),
  );
}

class AnimatedAppBackground extends StatefulWidget {
  final Widget child;

  const AnimatedAppBackground({super.key, required this.child});

  @override
  State<AnimatedAppBackground> createState() => _AnimatedAppBackgroundState();
}

class _AnimatedAppBackgroundState extends State<AnimatedAppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: dark
                  ? <Color>[
                      const Color(0xFF0F172A),
                      const Color(0xFF1E3A5F),
                      const Color(0xFF0A1929),
                    ]
                  : <Color>[
                      const Color(0xFFE8F5E9),
                      const Color(0xFFC8E6C9),
                      const Color(0xFFA5D6A7),
                    ],
              stops: <double>[0, 0.45 + controller.value * 0.15, 1],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 80 + controller.value * 30,
                right: -60,
                child: _GlowCircle(
                  size: 190,
                  color: dark
                      ? Colors.green.withOpacity(0.15)
                      : Colors.green.withOpacity(0.12),
                ),
              ),
              Positioned(
                bottom: 120 - controller.value * 25,
                left: -70,
                child: _GlowCircle(
                  size: 220,
                  color: dark
                      ? Colors.blue.withOpacity(0.10)
                      : Colors.blue.withOpacity(0.08),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: <BoxShadow>[BoxShadow(color: color, blurRadius: 70, spreadRadius: 25)],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showSplash = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
              surface: const Color(0xFFFFFFFF),
              background: const Color(0xFFF3F4F6),
            ),
            scaffoldBackgroundColor: const Color(0xFFF3F4F6),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Color(0xFF111827)),
              bodyLarge: TextStyle(color: Color(0xFF111827)),
              titleMedium: TextStyle(color: Color(0xFF111827)),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
              primary: Colors.green.shade400,
              secondary: Colors.teal.shade300,
              surface: const Color(0xFF1E293B),
              background: const Color(0xFF0F172A),
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E293B),
              elevation: 0,
              centerTitle: true,
            ),
            
            cardTheme: const CardThemeData(
              color: Color(0xFF1E293B),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Color(0xFFF1F5F9)),
              bodyLarge: TextStyle(color: Color(0xFFF1F5F9)),
              titleMedium: TextStyle(color: Color(0xFFF1F5F9)),
              titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
          home: showSplash
              ? SplashScreen(
                  onFinish: () {
                    setState(() {
                      showSplash = false;
                    });
                  },
                )
              : !appState.isLoggedIn
                  ? const LoginScreen()
                  : _buildConfiguredHome(appState, _buildHomeForRole(appState)),
        );
      },
    );
  }


  Widget _buildConfiguredHome(AppState appState, Widget child) {
    final bool dark = appState.isDarkMode;
    return Stack(
      children: [
        Positioned.fill(child: _systemBackground(appState.systemBackgroundMode, dark)),
        Positioned.fill(child: child),
        if (appState.shouldShowGlobalFloatingMessageForCurrentUser)
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50.withValues(alpha: 0.97),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      children: [
                        _systemLogoIcon(appState.systemLogoMode, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(appState.globalFloatingMessage, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                              const SizedBox(height: 2),
                              Text(appState.globalFloatingMessageRemainingText, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _systemBackground(String mode, bool dark) {
    switch (mode) {
      case 'ceremony':
        return Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFFFFF7ED), Color(0xFFFDE68A), Color(0xFFBBF7D0)])));
      case 'dark_glow':
        return Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF020617), Color(0xFF0F766E), Color(0xFF111827)])));
      case 'minimal':
        return Container(color: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC));
      case 'classic':
        return Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFEFF6FF), Color(0xFFFFFFFF)])));
      case 'spring':
      default:
        return const AnimatedAppBackground(child: SizedBox.expand());
    }
  }

  Widget _systemLogoIcon(String logoMode, {double size = 38}) {
    IconData icon;
    Color color;
    switch (logoMode) {
      case 'science':
        icon = Icons.science_outlined;
        color = Colors.indigo;
        break;
      case 'ceremony':
        icon = Icons.celebration_outlined;
        color = Colors.orange;
        break;
      case 'international':
        icon = Icons.public_outlined;
        color = Colors.blue;
        break;
      case 'arak_default':
      default:
        icon = Icons.account_balance_outlined;
        color = Colors.green;
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color.withValues(alpha: 0.14),
      child: Icon(icon, size: size * 0.64, color: color),
    );
  }

  Widget _buildHomeForRole(AppState appState) {
    switch (appState.userRole) {
      case 'admin':
        return const AdminDashboardScreen();
      case 'student':
        return const HomeScreen();
      case 'manager':
        return ManagerHomeScreen(managerUnitKey: appState.userIdentifier);
      case 'professor':
        return ProfessorHomeScreen(professorId: appState.userIdentifier);
      default:
        return const LoginScreen();
    }
  }
}

// --- Splash Screen ---

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<double> scale;
  late Animation<double> rotate;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    );

    fade = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    scale = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    rotate = Tween<double>(
      begin: -0.08,
      end: 0.08,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();

    Future<void>.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      await controller.reverse();
      if (mounted) widget.onFinish();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: ScaleTransition(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Transform.rotate(
                          angle: rotate.value,
                          child: Container(
                            width: 118,
                            height: 118,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.92),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.24),
                                  blurRadius: 34,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.account_balance_outlined,
                              size: 64,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          tr(selectedLang, 'app_name'),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(AppLang.en, 'app_name'),
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: 170,
                          child: LinearProgressIndicator(
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// --- Login Screen ---

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// در فایل main.dart، کلاس _LoginScreenState را با این نسخه جایگزین کنید:

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController chatController = TextEditingController();
  
  bool passwordVisible = false;
  bool showRegister = false;
  bool showSupportChat = false;
  final List<SupportChatMessage> chatMessages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  void _addWelcomeMessage() {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    
    setState(() {
      chatMessages.add(SupportChatMessage(
        text: isRtl 
          ? 'سلام! 👋\nمن دستیار پشتیبانی دانشگاه اراک هستم.\nچطور می‌توانم به شما کمک کنم؟'
          : 'Hello! 👋\nI am Arak University support assistant.\nHow can I help you?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendChatMessage() {
    final String text = chatController.text.trim();
    if (text.isEmpty) return;
    
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    
    setState(() {
      chatMessages.add(SupportChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      chatController.clear();
    });
    
    _scrollToBottom();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        final response = SupportService.getAutoResponse(text, selectedLang);
        setState(() {
          chatMessages.add(SupportChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  void _sendSuggestedQuestion(String question) {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    
    setState(() {
      chatMessages.add(SupportChatMessage(
        text: question,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    
    _scrollToBottom();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final response = SupportService.getAutoResponse(question, selectedLang);
        setState(() {
          chatMessages.add(SupportChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void login() {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    final String username = userCtrl.text.trim();
    final String password = passCtrl.text.trim();
    final AppLang selectedLang = appState.selectedLang;

    if (password != '1234') {
      showError(tr(selectedLang, 'incorrect_credentials'));
      return;
    }

    // Super Admin
    if (username == 'sina') {
      appState.login('admin', 'sina');
      return;
    }
    // Student
    if (username == 'admin') {
      appState.login('student', 'admin');
      return;
    }
    // Managers by unit
    if (username == 'admin1') {
      appState.login('manager', 'international');
      return;
    }
    if (username == 'admin2') {
      appState.login('manager', 'education');
      return;
    }
    if (username == 'admin3') {
      appState.login('manager', 'student_services');
      return;
    }
    if (username == 'admin4') {
      appState.login('manager', 'consular');
      return;
    }
    if (username == 'admin5') {
      appState.login('manager', 'education_officer');
      return;
    }
    // Professors
    if (username == 'prof1') {
      appState.login('professor', 'p001');
      return;
    }
    if (username == 'prof2') {
      appState.login('professor', 'p002');
      return;
    }

    showError(tr(selectedLang, 'incorrect_credentials'));
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.start)),
    );
  }

  void register() {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    showError(tr(selectedLang, 'registration_conceptual'));

    setState(() {
      showRegister = false;
      userCtrl.clear();
      passCtrl.clear();
    });
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.lock_reset, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                isRtl ? 'بازیابی رمز عبور' : 'Reset Password',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.email, size: 50, color: Colors.green),
              const SizedBox(height: 12),
              Text(
                isRtl 
                  ? 'ایمیل خود را وارد کنید. رمز جدید برای شما ارسال خواهد شد.'
                  : 'Enter your email. A new password will be sent to you.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: isRtl ? 'example@araku.ac.ir' : 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: Text(isRtl ? 'انصراف' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty && emailController.text.contains('@')) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Icon(Icons.check_circle, size: 50, color: Colors.green),
                        content: Text(
                          isRtl 
                            ? 'رمز جدید به ایمیل شما ارسال شد. لطفاً صندوق خود را بررسی کنید.'
                            : 'A new password has been sent to your email.',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(isRtl ? 'باشه' : 'OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRtl ? 'لطفاً ایمیل معتبر وارد کنید' : 'Please enter a valid email'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isRtl ? 'ارسال' : 'Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double formPadding = screenWidth < 380 ? 16 : 24;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Stack(
          children: [
            // محتوای اصلی - محو شده در وسط صفحه
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight - 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // لوگو
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.account_balance_outlined,
                            size: 50,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // عنوان برنامه
                      Text(
                        tr(AppLang.fa, 'app_name'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tr(AppLang.en, 'app_name'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // فرم ورود/ثبت نام یا چت پشتیبانی
                      if (!showSupportChat)
                        _buildLoginForm(selectedLang, isRtl, formPadding, appState)
                      else
                        _buildSupportChat(selectedLang, isRtl),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            
            // دکمه پشتیبانی دایره‌ای در پایین صفحه (فقط در حالت فرم لاگین)
            if (!showSupportChat)
              Positioned(
                bottom: 20,
                right: isRtl ? null : 20,
                left: isRtl ? 20 : null,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showSupportChat = true;
                      if (chatMessages.isEmpty) {
                        _addWelcomeMessage();
                      }
                    });
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.support_agent, color: Colors.white),
                  tooltip: isRtl ? 'پشتیبانی' : 'Support',
                ),
              ),
            
            // دکمه بازگشت در پایین صفحه (فقط در حالت چت)
            if (showSupportChat)
              Positioned(
                bottom: 20,
                right: isRtl ? null : 20,
                left: isRtl ? 20 : null,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showSupportChat = false;
                    });
                  },
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: isRtl ? 'بازگشت' : 'Back',
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildLoginForm(AppLang selectedLang, bool isRtl, double formPadding, AppState appState) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 460),
      width: double.infinity,
      padding: EdgeInsets.all(formPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              showRegister ? tr(selectedLang, 'register') : tr(selectedLang, 'login'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          const SizedBox(height: 22),
          
          // انتخاب زبان
          Text(
            tr(selectedLang, 'language'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppLang.values.map<Widget>((AppLang lang) {
              return ChoiceChip(
                label: Text(langCode(lang)),
                selected: selectedLang == lang,
                onSelected: (bool _) => appState.setLanguage(lang),
                selectedColor: Colors.green.shade100,
                backgroundColor: Colors.grey.shade50,
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          
          // فیلد نام کاربری
          TextField(
            controller: userCtrl,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: tr(selectedLang, 'username'),
              hintText: tr(selectedLang, 'username'),
              prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // فیلد رمز عبور
          TextField(
            controller: passCtrl,
            obscureText: !passwordVisible,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: tr(selectedLang, 'password'),
              hintText: tr(selectedLang, 'password'),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                icon: Icon(
                  passwordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          
          // لینک فراموشی رمز
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: Text(
                isRtl ? 'رمز عبور خود را فراموش کرده‌اید؟' : 'Forgot Password?',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          
          if (showRegister) ...<Widget>[
            const SizedBox(height: 12),
            TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: tr(selectedLang, 'student_id'),
                prefixIcon: const Icon(Icons.badge_outlined, color: Colors.green),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: tr(selectedLang, 'email'),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.green),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 22),
          
          // دکمه ورود/ثبت نام
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: showRegister ? register : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Text(
                showRegister ? tr(selectedLang, 'register') : tr(selectedLang, 'login'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // دکمه تغییر بین ورود و ثبت نام (در داخل فرم)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  showRegister = !showRegister;
                  userCtrl.clear();
                  passCtrl.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                showRegister
                    ? tr(selectedLang, 'already_have_account')
                    : tr(selectedLang, 'create_new_account'),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // اطلاعات ورود
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tr(selectedLang, 'login_info'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSupportChat(AppLang selectedLang, bool isRtl) {
    final suggestedQuestions = SupportService.getSuggestedQuestions(selectedLang);
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 460),
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // هدر چت
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.support_agent, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isRtl ? 'پشتیبانی دانشگاه اراک' : 'Arak University Support',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'آنلاین',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          
          // سوالات پیشنهادی
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: suggestedQuestions.map((q) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(q.title, style: const TextStyle(fontSize: 12)),
                    onSelected: (_) => _sendSuggestedQuestion(q.question),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.green.shade100,
                    side: BorderSide(color: Colors.green.shade200),
                  ),
                )).toList(),
              ),
            ),
          ),
          
          // لیست پیام‌ها
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final msg = chatMessages[index];
                return _buildMessageBubble(msg, isRtl);
              },
            ),
          ),
          
          // ورودی پیام
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    decoration: InputDecoration(
                      hintText: isRtl ? 'پیام خود را بنویسید...' : 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendChatMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: _sendChatMessage,
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(SupportChatMessage msg, bool isRtl) {
    return Align(
      alignment: msg.isUser
          ? (isRtl ? Alignment.centerRight : Alignment.centerLeft)
          : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: msg.isUser ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg.timestamp),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
// --- Models & Data ---

class UnitModel {
  final String keyName;
  final IconData icon;
  final int unread;

  UnitModel({required this.keyName, required this.icon, this.unread = 0});
}

final List<UnitModel> units = <UnitModel>[
  UnitModel(keyName: 'international', icon: Icons.public, unread: 2),
  UnitModel(keyName: 'student_services', icon: Icons.support_agent, unread: 1),
  UnitModel(keyName: 'education', icon: Icons.school, unread: 3),
  UnitModel(keyName: 'education_officer', icon: Icons.manage_accounts, unread: 0),
  UnitModel(keyName: 'consular', icon: Icons.badge, unread: 0),
  UnitModel(keyName: 'other_services', icon: Icons.apps, unread: 0),
];
class StudentLiveClassScreen extends StatefulWidget {
  final String classId;
  final String studentId;

  const StudentLiveClassScreen({
    super.key,
    required this.classId,
    required this.studentId,
  });

  @override
  State<StudentLiveClassScreen> createState() => _StudentLiveClassScreenState();
}

class _StudentLiveClassScreenState extends State<StudentLiveClassScreen> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AppState appState = Provider.of<AppState>(context, listen: false);
      final EducationManagedClassModel? classItem = findClass(appState);

      if (classItem != null && classItem.status == LiveClassStatus.active) {
        appState.setStudentOnlineInClass(
          classId: widget.classId,
          studentId: widget.studentId,
          isOnline: true,
        );
      }
    });
  }

  @override
  void dispose() {
    final AppState? appState = globalContext == null
        ? null
        : Provider.of<AppState>(globalContext!, listen: false);

    if (appState != null) {
      appState.setStudentOnlineInClass(
        classId: widget.classId,
        studentId: widget.studentId,
        isOnline: false,
      );
    }

    messageController.dispose();
    fileNameController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  EducationManagedClassModel? findClass(AppState appState) {
    try {
      return appState.educationClasses.firstWhere(
        (c) => c.id == widget.classId,
      );
    } catch (_) {
      return null;
    }
  }

  LiveClassParticipantModel? findMe(AppState appState) {
    try {
      return appState
          .getClassParticipants(widget.classId)
          .firstWhere((p) => p.studentId == widget.studentId);
    } catch (_) {
      return null;
    }
  }

  String studentName(AppState appState) {
    final LiveClassParticipantModel? me = findMe(appState);
    return me?.studentName ?? 'دانشجو';
  }

  void sendMessage(AppState appState) {
    final String text = messageController.text.trim();
    if (text.isEmpty) return;

    appState.sendLiveClassMessage(
      classId: widget.classId,
      senderId: widget.studentId,
      senderName: studentName(appState),
      text: text,
    );

    messageController.clear();
    scrollToBottom();
  }

  void sendFile(AppState appState) {
    final String fileName = fileNameController.text.trim();

    if (fileName.isEmpty) {
      showMessage('نام فایل را وارد کنید.');
      return;
    }

    appState.sendLiveClassMessage(
      classId: widget.classId,
      senderId: widget.studentId,
      senderName: studentName(appState),
      text: 'فایل ارسال شد: $fileName',
      hasFile: true,
      fileName: fileName,
    );

    fileNameController.clear();
    Navigator.pop(context);
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final bool isRtl = isRtlLang(appState.selectedLang);

    final EducationManagedClassModel? classItem = findClass(appState);
    final LiveClassParticipantModel? me = findMe(appState);
    final List<LiveClassMessageModel> messages =
        appState.getClassMessages(widget.classId);

    if (classItem == null) {
      return const Scaffold(
        body: Center(
          child: Text('کلاس پیدا نشد.'),
        ),
      );
    }

    final bool canEnter = classItem.status == LiveClassStatus.active;
    final bool canSendMessage = canEnter;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(classItem.title),
          centerTitle: true,
        ),
        body: !canEnter
            ? _buildWaitingPage(classItem)
            : Column(
                children: [
                  _buildClassStatusPanel(appState, classItem, me),
                  Expanded(
                    child: _buildMessages(messages),
                  ),
                  _buildInputPanel(appState, canSendMessage),
                ],
              ),
      ),
    );
  }

  Widget _buildWaitingPage(EducationManagedClassModel classItem) {
    String message;

    if (classItem.status == LiveClassStatus.scheduled ||
        classItem.status == LiveClassStatus.waitingForProfessor) {
      message = 'کلاس هنوز توسط استاد شروع نشده است.';
    } else if (classItem.status == LiveClassStatus.finished) {
      message = 'این کلاس پایان یافته است.';
    } else if (classItem.status == LiveClassStatus.cancelled) {
      message = 'این کلاس لغو شده است.';
    } else {
      message = 'امکان ورود به کلاس وجود ندارد.';
    }

    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_clock_outlined,
                  size: 72,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'پس از اینکه استاد دکمه «شروع کلاس» را بزند، ورود و تعامل دانشجویان فعال می‌شود.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('بازگشت'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassStatusPanel(
    AppState appState,
    EducationManagedClassModel classItem,
    LiveClassParticipantModel? me,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: Colors.green.withValues(alpha: 0.20)),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(
            avatar: const Icon(Icons.person, size: 18),
            label: Text('استاد: ${classItem.professorName}'),
          ),
          Chip(
            avatar: const Icon(Icons.circle, size: 14, color: Colors.green),
            label: const Text('کلاس فعال است'),
          ),
          Chip(
            avatar: Icon(
              me?.isMuted == true ? Icons.mic_off : Icons.mic,
              size: 18,
            ),
            label: Text(me?.isMuted == true ? 'صدای شما قطع است' : 'اجازه صحبت دارید'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              appState.raiseHand(
                classId: widget.classId,
                studentId: widget.studentId,
                raised: !(me?.raisedHand ?? false),
              );
            },
            icon: Icon(
              me?.raisedHand == true
                  ? Icons.pan_tool_alt
                  : Icons.pan_tool_alt_outlined,
            ),
            label: Text(
              me?.raisedHand == true ? 'لغو درخواست صحبت' : 'درخواست صحبت',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(List<LiveClassMessageModel> messages) {
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'هنوز پیامی در کلاس ثبت نشده است.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final LiveClassMessageModel msg = messages[index];
        final bool isMine = msg.senderId == widget.studentId;

        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            constraints: const BoxConstraints(maxWidth: 620),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMine
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.blueGrey.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isMine
                    ? Colors.green.withValues(alpha: 0.22)
                    : Colors.blueGrey.withValues(alpha: 0.18),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      msg.hasFile ? Icons.attach_file : Icons.chat_outlined,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      msg.senderName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatTime(msg.sentAt),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(msg.text),
                if (msg.hasFile && msg.fileName != null) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_present),
                    label: Text(msg.fileName!),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputPanel(AppState appState, bool enabled) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'ارسال فایل',
            onPressed: enabled ? () => _showFileDialog(appState) : null,
            icon: const Icon(Icons.attach_file),
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'پیام خود را بنویسید...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (_) => sendMessage(appState),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            height: 48,
            child: ElevatedButton(
              onPressed: enabled ? () => sendMessage(appState) : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }

  void _showFileDialog(AppState appState) {
    fileNameController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ارسال فایل'),
          content: TextField(
            controller: fileNameController,
            decoration: InputDecoration(
              labelText: 'نام فایل',
              hintText: 'مثلاً homework.pdf',
              prefixIcon: const Icon(Icons.file_present),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف'),
            ),
            ElevatedButton.icon(
              onPressed: () => sendFile(appState),
              icon: const Icon(Icons.upload_file),
              label: const Text('ارسال'),
            ),
          ],
        );
      },
    );
  }
}
// مدل کلاس جدید برای مدیریت
// مدل کلاس مدیریت شده - با فیلدهای قابل تغییر
class ManagedClassModel {
  final String id;
  final String name;
  final String professorId;
  final String professorName;
  final List<String> studentIds;
  final List<String> studentNames;
  final String semester;
  final int capacity;
  final String scheduleDay;
  final String scheduleTime;
  String status;  // changed to non-final (mutable)
  final DateTime createdAt;
  DateTime? completedAt;  // changed to non-final (mutable)

  ManagedClassModel({
    required this.id,
    required this.name,
    required this.professorId,
    required this.professorName,
    required this.studentIds,
    required this.studentNames,
    required this.semester,
    required this.capacity,
    this.scheduleDay = 'نامشخص',
    this.scheduleTime = 'نامشخص',
    required this.status,
    required this.createdAt,
    this.completedAt,
  });
}

// مدل گزارش کلاس
class ClassReportModel {
  final String classId;
  final String className;
  final String professorName;
  final int totalStudents;
  final int activeStudents;
  final int totalMessages;
  final DateTime date;
  final double attendanceRate;
  final String status;
  final String scheduleDay;
  final String scheduleTime;

  ClassReportModel({
    required this.classId,
    required this.className,
    required this.professorName,
    required this.totalStudents,
    required this.activeStudents,
    required this.totalMessages,
    required this.date,
    required this.attendanceRate,
    required this.status,
    required this.scheduleDay,
    required this.scheduleTime,
  });
}
enum EducationPermission {
  manageClasses,
  viewReports,
  createClass,
  editClass,
  deleteClass,
  manageStudents,
  manageProfessors,
  privateChat,
  viewClassHistory,
}

enum LiveClassStatus {
  scheduled,
  waitingForProfessor,
  active,
  finished,
  cancelled,
}

class EducationOfficerModel {
  final String id;
  final String name;
  final String username;
  final List<EducationPermission> permissions;

  EducationOfficerModel({
    required this.id,
    required this.name,
    required this.username,
    required this.permissions,
  });

  bool hasPermission(EducationPermission permission) {
    return permissions.contains(permission);
  }

  EducationOfficerModel copyWith({
    String? id,
    String? name,
    String? username,
    List<EducationPermission>? permissions,
  }) {
    return EducationOfficerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      permissions: permissions ?? this.permissions,
    );
  }
}

class EducationManagedClassModel {
  final String id;
  final String title;
  final String professorId;
  final String professorName;
  final List<String> studentIds;
  final List<String> studentNames;
  final String weekDay;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String semester;
  final DateTime createdAt;
  final LiveClassStatus status;
  final DateTime? startedAt;
  final DateTime? finishedAt;

  EducationManagedClassModel({
    required this.id,
    required this.title,
    required this.professorId,
    required this.professorName,
    required this.studentIds,
    required this.studentNames,
    required this.weekDay,
    required this.startTime,
    required this.endTime,
    required this.semester,
    required this.createdAt,
    required this.status,
    this.startedAt,
    this.finishedAt,
  });

  EducationManagedClassModel copyWith({
    String? id,
    String? title,
    String? professorId,
    String? professorName,
    List<String>? studentIds,
    List<String>? studentNames,
    String? weekDay,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? semester,
    DateTime? createdAt,
    LiveClassStatus? status,
    DateTime? startedAt,
    DateTime? finishedAt,
  }) {
    return EducationManagedClassModel(
      id: id ?? this.id,
      title: title ?? this.title,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      studentIds: studentIds ?? this.studentIds,
      studentNames: studentNames ?? this.studentNames,
      weekDay: weekDay ?? this.weekDay,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      semester: semester ?? this.semester,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}

class LiveClassParticipantModel {
  final String studentId;
  final String studentName;
  final bool isOnline;
  final bool isMuted;
  final bool canSpeak;
  final bool raisedHand;

  LiveClassParticipantModel({
    required this.studentId,
    required this.studentName,
    this.isOnline = false,
    this.isMuted = true,
    this.canSpeak = false,
    this.raisedHand = false,
  });

  LiveClassParticipantModel copyWith({
    String? studentId,
    String? studentName,
    bool? isOnline,
    bool? isMuted,
    bool? canSpeak,
    bool? raisedHand,
  }) {
    return LiveClassParticipantModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      isOnline: isOnline ?? this.isOnline,
      isMuted: isMuted ?? this.isMuted,
      canSpeak: canSpeak ?? this.canSpeak,
      raisedHand: raisedHand ?? this.raisedHand,
    );
  }
}

class LiveClassMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime sentAt;
  final bool hasFile;
  final String? fileName;

  LiveClassMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.sentAt,
    this.hasFile = false,
    this.fileName,
  });
}

class EducationClassReportModel {
  final String id;
  final String classId;
  final String classTitle;
  final String professorName;
  final DateTime reportDate;
  final int totalStudents;
  final int presentStudents;
  final int absentStudents;
  final int totalMessages;
  final int uploadedFiles;
  final Duration classDuration;
  final LiveClassStatus finalStatus;
  final List<String> presentStudentNames;
  final List<String> absentStudentNames;

  EducationClassReportModel({
    required this.id,
    required this.classId,
    required this.classTitle,
    required this.professorName,
    required this.reportDate,
    required this.totalStudents,
    required this.presentStudents,
    required this.absentStudents,
    required this.totalMessages,
    required this.uploadedFiles,
    required this.classDuration,
    required this.finalStatus,
    required this.presentStudentNames,
    required this.absentStudentNames,
  });
}

class EducationPrivateChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String message;
  final DateTime sentAt;
  final bool unread;

  EducationPrivateChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.message,
    required this.sentAt,
    this.unread = true,
  });

  EducationPrivateChatMessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? receiverName,
    String? message,
    DateTime? sentAt,
    bool? unread,
  }) {
    return EducationPrivateChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      unread: unread ?? this.unread,
    );
  }
}
// ==================== کلاس‌های پشتیبانی ====================

// کلاس SuggestedQuestion برای سوالات پیشنهادی
class SuggestedQuestion {
  final String title;
  final String subtitle;
  final IconData icon;
  final String question;
  
  SuggestedQuestion({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.question,
  });
}

// کلاس SupportService برای پاسخ‌های خودکار
class SupportService {
  static String getAutoResponse(String userMessage, AppLang selectedLang) {
    final lowerMsg = userMessage.toLowerCase();
    final bool isRtl = isRtlLang(selectedLang);
    
    if (lowerMsg.contains('سلام') || lowerMsg.contains('hi') || lowerMsg.contains('hello')) {
      return isRtl 
        ? 'سلام! 👋\nچطور می‌توانم به شما کمک کنم؟ سوالات خود را بپرسید.'
        : 'Hello! 👋\nHow can I help you? Ask your questions.';
    }
    
    if (lowerMsg.contains('ورود') || lowerMsg.contains('login')) {
      return isRtl
        ? '🔐 **راهنمای ورود:**\n\n• دانشجو: admin\n• مدیران: admin1 تا admin4\n• استاد: prof1 یا prof2\n• رمز عبور همه: 1234'
        : '🔐 **Login Guide:**\n\n• Student: admin\n• Managers: admin1 to admin4\n• Professor: prof1 or prof2\n• Password for all: 1234';
    }
    
    if (lowerMsg.contains('ثبت نام') || lowerMsg.contains('register')) {
      return isRtl
        ? '📝 **ثبت نام:**\n\nبرای ثبت نام جدید، لطفاً با واحد آموزش دانشگاه تماس بگیرید.\n\n📞 شماره تماس: ۰۸۶-۳۲۲۳۰۴۲۱\n✉️ ایمیل: education@araku.ac.ir'
        : '📝 **Registration:**\n\nFor new registration, please contact the Education department.\n\n📞 Phone: 086-32230421\n✉️ Email: education@araku.ac.ir';
    }
    
    if (lowerMsg.contains('رمز') || lowerMsg.contains('password') || lowerMsg.contains('فراموش')) {
      return isRtl
        ? '🔑 **بازیابی رمز عبور:**\n\n1. روی گزینه "رمز عبور را فراموش کرده‌اید؟" کلیک کنید\n2. ایمیل خود را وارد کنید\n3. رمز جدید برای شما ارسال می‌شود\n\n📞 پشتیبانی: ۰۸۶-۳۲۲۳۰۴۲۱\n✉️ support@araku.ac.ir'
        : '🔑 **Password Recovery:**\n\n1. Click on "Forgot Password"\n2. Enter your email\n3. New password will be sent to you\n\n📞 Support: 086-32230421\n✉️ support@araku.ac.ir';
    }
    
    if (lowerMsg.contains('تماس') || lowerMsg.contains('شماره') || lowerMsg.contains('phone')) {
      return isRtl
        ? '📞 **اطلاعات تماس:**\n\nپشتیبانی: ۰۸۶-۳۲۲۳۰۴۲۱\nآموزش: ۰۸۶-۳۲۲۳۰۴۲۲\nبین‌الملل: ۰۸۶-۳۲۲۳۰۴۲۳\n\n🕐 ساعت پاسخگویی: ۸ صبح تا ۱۶ عصر'
        : '📞 **Contact Information:**\n\nSupport: 086-32230421\nEducation: 086-32230422\nInternational: 086-32230423\n\n🕐 Hours: 8 AM to 4 PM';
    }
    
    if (lowerMsg.contains('ایمیل') || lowerMsg.contains('email')) {
      return isRtl
        ? '✉️ **ایمیل‌های دانشگاه:**\n\nپشتیبانی: support@araku.ac.ir\nآموزش: education@araku.ac.ir\nبین‌الملل: intl@araku.ac.ir\nاطلاعات: info@araku.ac.ir'
        : '✉️ **University Emails:**\n\nSupport: support@araku.ac.ir\nEducation: education@araku.ac.ir\nInternational: intl@araku.ac.ir\nInfo: info@araku.ac.ir';
    }
    
    if (lowerMsg.contains('مشکل') || lowerMsg.contains('problem') || lowerMsg.contains('error')) {
      return isRtl
        ? '⚠️ **ثبت مشکل:**\n\nمشکل شما ثبت شد. لطفاً جزئیات بیشتری ارسال کنید.\nکارشناسان ما در اسرع وقت با شما تماس می‌گیرند.\n\nبرای پیگیری سریع‌تر، شماره تماس خود را وارد کنید.'
        : '⚠️ **Report Issue:**\n\nYour issue has been recorded. Please send more details.\nOur experts will contact you soon.\n\nFor faster follow-up, please enter your phone number.';
    }
    
    if (lowerMsg.contains('خداحافظ') || lowerMsg.contains('bye')) {
      return isRtl
        ? '👋 خداحافظ! هر زمان نیاز داشتید، ما اینجا هستیم.\nموفق باشید!'
        : '👋 Goodbye! We are here whenever you need us.\nGood luck!';
    }
    
    if (lowerMsg.contains('ممنون') || lowerMsg.contains('thank')) {
      return isRtl
        ? '🙏 خواهش می‌کنم! خوشحالم که توانستم کمک کنم.\n\nاگر سوال دیگری دارید، در خدمتم.'
        : '🙏 You\'re welcome! Glad I could help.\n\nIf you have any other questions, I\'m here.';
    }
    
    return isRtl
        ? '🤔 **سوال شما را متوجه نشدم.**\n\nلطفاً یکی از موارد زیر را مشخص کنید:\n\n🔐 راهنمای ورود\n📝 ثبت نام\n🔑 فراموشی رمز\n📞 شماره تماس\n✉️ ایمیل\n⚠️ مشکل فنی\n\nیا سوال خود را دقیق‌تر بپرسید.'
        : '🤔 **I didn\'t understand.**\n\nPlease specify one of these topics:\n\n🔐 Login guide\n📝 Registration\n🔑 Forgot password\n📞 Phone number\n✉️ Email\n⚠️ Technical issue\n\nOr ask your question more clearly.';
  }
  
  static List<SuggestedQuestion> getSuggestedQuestions(AppLang selectedLang) {
    final bool isRtl = isRtlLang(selectedLang);
    return [
      SuggestedQuestion(
        title: isRtl ? 'راهنمای ورود' : 'Login Guide',
        subtitle: isRtl ? 'اطلاعات ورود به سیستم' : 'Login information',
        icon: Icons.login,
        question: isRtl ? 'راهنمای ورود به سیستم' : 'Login guide',
      ),
      SuggestedQuestion(
        title: isRtl ? 'ثبت نام' : 'Registration',
        subtitle: isRtl ? 'نحوه ثبت نام جدید' : 'New registration',
        icon: Icons.app_registration,
        question: isRtl ? 'راهنمای ثبت نام' : 'Registration guide',
      ),
      SuggestedQuestion(
        title: isRtl ? 'فراموشی رمز' : 'Forgot Password',
        subtitle: isRtl ? 'بازیابی رمز عبور' : 'Password recovery',
        icon: Icons.lock_reset,
        question: isRtl ? 'فراموشی رمز عبور' : 'Forgot password',
      ),
      SuggestedQuestion(
        title: isRtl ? 'تماس با ما' : 'Contact Us',
        subtitle: isRtl ? 'شماره تماس و ایمیل' : 'Phone & email',
        icon: Icons.contact_phone,
        question: isRtl ? 'اطلاعات تماس' : 'Contact information',
      ),
    ];
  }
}

// کلاس SupportChatMessage برای پیام‌های چت (با نام متفاوت برای جلوگیری از تداخل)
class SupportChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  
  SupportChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
class AdminSystemAuditLog {
  final String id;
  final String action;
  final String detail;
  final String actor;
  final DateTime createdAt;

  AdminSystemAuditLog({
    required this.id,
    required this.action,
    required this.detail,
    required this.actor,
    required this.createdAt,
  });
}

class AppNotification {
  final String title;
  final String subtitle;
  final String unitKey;
  final bool unread;

  AppNotification({
    required this.title,
    required this.subtitle,
    required this.unitKey,
    this.unread = true,
  });
}

final List<AppNotification> appNotifications = <AppNotification>[
  AppNotification(
    title: 'پیام جدید از آموزش',
    subtitle: 'درخواست گواهی شما بررسی شد.',
    unitKey: 'education',
  ),
  AppNotification(
    title: 'پیام جدید از امور بین‌الملل',
    subtitle: 'مدارک پذیرش شما نیاز به تکمیل دارد.',
    unitKey: 'international',
  ),
  AppNotification(
    title: 'پیام جدید از خدمات دانشجویی',
    subtitle: 'درخواست خوابگاه شما در حال پیگیری است.',
    unitKey: 'student_services',
  ),
  AppNotification(
    title: 'تایید نهایی مدارک',
    subtitle: 'مدارک شما تایید شد.',
    unitKey: 'consular',
  ),
  AppNotification(
    title: 'یادآوری پرداخت شهریه',
    subtitle: 'تاریخ پرداخت: 15 روز دیگر',
    unitKey: 'education',
  ),
];

int getUnreadCountForUnit(String unitKey) {
  // بازنویسی این تابع برای جلوگیری از خطا
  try {
    return appNotifications
        .where((AppNotification n) => n.unitKey == unitKey && n.unread)
        .length;
  } catch (e) {
    return 0;
  }
}
// New Models for Professors/Classes
class StudentInClassModel {
  final String id;
  final String name;
  final String studentId;
  final String? profileImageUrl;

  StudentInClassModel({
    required this.id,
    required this.name,
    required this.studentId,
    this.profileImageUrl,
  });
}
class UnitChatScreen extends StatelessWidget {
  final String unitKey;

  const UnitChatScreen({
    super.key,
    required this.unitKey,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final bool isRtl = isRtlLang(appState.selectedLang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appText(appState.selectedLang, unitKey)),
          centerTitle: true,
        ),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'صفحه گفتگو و خدمات ${appText(appState.selectedLang, unitKey)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class StudentClassesPanel extends StatelessWidget {
  final String studentId;

  const StudentClassesPanel({
    super.key,
    required this.studentId,
  });

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String statusText(LiveClassStatus status) {
    switch (status) {
      case LiveClassStatus.scheduled:
        return 'هنوز شروع نشده';
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
    final AppState appState = Provider.of<AppState>(context);
    final List<EducationManagedClassModel> classes =
        appState.getStudentClasses(studentId);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.video_call_outlined, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'کلاس‌های من',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          if (classes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('کلاسی برای شما ثبت نشده است.'),
            )
          else
            Column(
              children: classes.map((classItem) {
                final bool canEnter =
                    classItem.status == LiveClassStatus.active;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        statusColor(classItem.status).withValues(alpha: 0.14),
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
                    '${classItem.weekDay} | ${formatTime(classItem.startTime)} تا ${formatTime(classItem.endTime)}',
                  ),
                  isThreeLine: true,
                  trailing: ElevatedButton(
                    onPressed: classItem.status == LiveClassStatus.cancelled
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentLiveClassScreen(
                                  classId: classItem.id,
                                  studentId: studentId,
                                ),
                              ),
                            );
                          },
                    child: Text(canEnter ? 'ورود' : statusText(classItem.status)),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
class ClassModel {
  final String id;
  final String name;
  final String professorId;
  final List<String> studentIds;
  final String descriptionKey;

  ClassModel({
    required this.id,
    required this.name,
    required this.professorId,
    required this.studentIds,
    required this.descriptionKey,
  });
}

class ProfessorModel {
  final String id;
  final String name;
  final List<String> classIds;

  ProfessorModel({required this.id, required this.name, required this.classIds});
}

// Mock Data
final List<StudentInClassModel> mockStudents = <StudentInClassModel>[
  StudentInClassModel(id: 's001', name: 'رضا حسینی', studentId: '40210001'),
  StudentInClassModel(id: 's002', name: 'علی احمدی', studentId: '40210002'),
  StudentInClassModel(id: 's003', name: 'فاطمه رضایی', studentId: '40210003'),
  StudentInClassModel(id: 's004', name: 'Sara Smith', studentId: '40210004'),
];

final List<ClassModel> mockClasses = <ClassModel>[
  ClassModel(
    id: 'c001',
    name: 'برنامه نویسی پیشرفته',
    professorId: 'p001',
    studentIds: <String>['s001', 's002'],
    descriptionKey: 'class_programming_desc',
  ),
  ClassModel(
    id: 'c002',
    name: 'پایگاه داده',
    professorId: 'p001',
    studentIds: <String>['s001', 's003', 's004'],
    descriptionKey: 'class_database_desc',
  ),
  ClassModel(
    id: 'c003',
    name: 'Data Structures',
    professorId: 'p002',
    studentIds: <String>['s002', 's004'],
    descriptionKey: 'class_datastructure_desc',
  ),
];

final List<ProfessorModel> mockProfessors = <ProfessorModel>[
  ProfessorModel(
    id: 'p001',
    name: 'دکتر محمدی',
    classIds: <String>['c001', 'c002'],
  ),
  ProfessorModel(
    id: 'p002',
    name: 'Dr. Johnson',
    classIds: <String>['c003'],
  ),
];

String appText(AppLang lang, String key) {
  final Map<String, Map<String, String>> data = {
    'university_app': {
      'FA': 'اپلیکیشن ارتباط با دانشگاه',
      'EN': 'University Communication App',
      'AR': 'تطبيق التواصل مع الجامعة',
    },
    'university_subtitle': {
      'FA': 'ارتباط ساده‌تر دانشجویان بین‌الملل با واحدهای دانشگاه',
      'EN': 'A simpler connection between international students and university units',
      'AR': 'تواصل أسهل بين الطلاب الدوليين ووحدات الجامعة',
    },
    'units': {'FA': 'واحدها', 'EN': 'Units', 'AR': 'الوحدات'},
    'support': {'FA': 'پشتیبانی', 'EN': 'Support', 'AR': 'الدعم'},
    'international': {
      'FA': 'امور بین‌الملل',
      'EN': 'International Affairs',
      'AR': 'الشؤون الدولية',
    },
    'student_services': {
      'FA': 'خدمات دانشجویی',
      'EN': 'Student Services',
      'AR': 'خدمات الطلاب',
    },
    'education': {'FA': 'آموزش', 'EN': 'Education', 'AR': 'التعليم'},
    'education_officer': {'FA': 'کارشناس آموزشی', 'EN': 'Training Officer', 'AR': 'مسؤول التدريب'},
    'consular': {'FA': 'کنسولی', 'EN': 'Consular', 'AR': 'القنصلية'},
    'other_services': {
      'FA': 'سایر خدمات',
      'EN': 'Other Services',
      'AR': 'خدمات أخرى',
    },
    'admin_main': {
      'FA': 'مدیر اصلی سیستم',
      'EN': 'System Admin',
      'AR': 'مدير النظام الرئيسي',
    },
    'enter_section': {
      'FA': 'ورود به بخش',
      'EN': 'Enter',
      'AR': 'الدخول إلى قسم',
    },
    'profile': {'FA': 'پروفایل', 'EN': 'Profile', 'AR': 'الملف الشخصي'},
    'notifications': {
      'FA': 'اعلان‌ها',
      'EN': 'Notifications',
      'AR': 'الإشعارات',
    },
    'unread': {
      'FA': 'اعلان نخوانده',
      'EN': 'Unread notifications',
      'AR': 'إشعارات غير مقروءة',
    },
    'taxi': {
      'FA': 'تاکسی دانشگاه',
      'EN': 'University Taxi',
      'AR': 'تاكسي الجامعة',
    },
    'translation': {
      'FA': 'خدمات ترجمه',
      'EN': 'Translation Services',
      'AR': 'خدمات الترجمة',
    },
    'insurance': {
      'FA': 'بیمه دانشجویی',
      'EN': 'Student Insurance',
      'AR': 'تأمين الطلاب',
    },
    'bank': {
      'FA': 'خدمات بانکی',
      'EN': 'Banking Services',
      'AR': 'الخدمات المصرفية',
    },
    'restaurant': {
      'FA': 'رستوران دانشگاه',
      'EN': 'University Restaurant',
      'AR': 'مطعم الجامعة',
    },
    'gym': {'FA': 'سالن ورزشی', 'EN': 'Gym', 'AR': 'صالة الألعاب الرياضية'},
    'library': {'FA': 'کتابخانه', 'EN': 'Library', 'AR': 'المكتبة'},
    'printing': {
      'FA': 'چاپ و تکثیر',
      'EN': 'Printing Services',
      'AR': 'خدمات الطباعة',
    },

    'welfare': {
      'FA': 'خدمات رفاهی',
      'EN': 'Welfare Services',
      'AR': 'الخدمات الرفاهية',
    },
    'money_exchange': {
      'FA': 'چنج پول',
      'EN': 'Money Exchange',
      'AR': 'صرف العملات',
    },
    'hotel': {
      'FA': 'هتل',
      'EN': 'Hotel',
      'AR': 'فندق',
    },
    'flight_ticket': {
      'FA': 'بلیط هواپیما',
      'EN': 'Flight Ticket',
      'AR': 'تذكرة طيران',
    },
    'training_courses': {
      'FA': 'دوره‌های آموزشی',
      'EN': 'Training Courses',
      'AR': 'الدورات التدريبية',
    },
    'my_conversations': {
      'FA': 'گفتگوهای من',
      'EN': 'My Conversations',
      'AR': 'محادثاتي',
    },
    'search_conversations': {
      'FA': 'جستجو در گفتگوها...',
      'EN': 'Search conversations...',
      'AR': 'البحث في المحادثات...',
    },
    'new_conversation': {
      'FA': 'گفتگوی جدید',
      'EN': 'New Conversation',
      'AR': 'محادثة جديدة',
    },
    'tracking': {'FA': 'پیگیری', 'EN': 'Tracking', 'AR': 'متابعة'},
    'quick_access': {
      'FA': 'دسترسی سریع',
      'EN': 'Quick Access',
      'AR': 'وصول سريع',
    },
    'common_items': {
      'FA': 'موارد پرکاربرد',
      'EN': 'Common Items',
      'AR': 'العناصر الشائعة',
    },
    'unit_info': {
      'FA': 'اطلاعات واحد',
      'EN': 'Unit Information',
      'AR': 'معلومات الوحدة',
    },
    'response_hours': {
      'FA': 'ساعت پاسخگویی: 8 الی 16',
      'EN': 'Response hours: 8 to 16',
      'AR': 'ساعات الرد: 8 إلى 16',
    },
    'contact_unit': {
      'FA': 'تماس با واحد',
      'EN': 'Contact Unit',
      'AR': 'الاتصال بالوحدة',
    },
    'write_message': {
      'FA': 'پیام خود را بنویسید...',
      'EN': 'Write your message...',
      'AR': 'اكتب رسالتك...',
    },
    'message_received': {
      'FA': 'پیام شما دریافت شد و توسط کارشناس بررسی می‌شود.',
      'EN': 'Your message has been received and will be reviewed by the staff.',
      'AR': 'تم استلام رسالتك وسيتم فحصها من قبل الموظف المختص.',
    },
    'welcome_message': {
      'FA': 'سلام 👋\nبه این بخش خوش آمدید. لطفاً درخواست خود را کامل توضیح دهید.',
      'EN': 'Hello!\nWelcome to this section. Please describe your request completely.',
      'AR': 'مرحباً!\nأهلاً بك في هذا القسم. يرجى شرح طلبك بشكل كامل.',
    },
    'sample_user_message': {
      'FA': 'سلام، من یک درخواست اداری دارم. لطفاً راهنمایی کنید چه مدارکی لازم است.',
      'EN': 'Hello, I have an administrative request. Please tell me what documents are required.',
      'AR': 'مرحباً، لدي طلب إداري. يرجى إرشادي إلى المستندات المطلوبة.',
    },
    'sample_staff_message': {
      'FA': 'برای ثبت درخواست، لطفاً نوع درخواست را مشخص کنید و مدارک مرتبط را ارسال نمایید. پس از بررسی، نتیجه از همین گفتگو اعلام می‌شود.',
      'EN': 'To register the request, please specify the request type and send the related documents. The result will be announced in this conversation after review.',
      'AR': 'لتسجيل الطلب، يرجى تحديد نوع الطلب وإرسال المستندات ذات الصلة. سيتم إعلان النتيجة في هذه المحادثة بعد المراجعة.',
    },
    'request_about': {
      'FA': 'درخواست درباره',
      'EN': 'Request about',
      'AR': 'طلب حول',
    },
    'request_registered': {
      'FA': 'درخواست شما ثبت شد. لطفاً جزئیات بیشتری ارسال کنید.',
      'EN': 'Your request has been registered. Please send more details.',
      'AR': 'تم تسجيل طلبك. يرجى إرسال المزيد من التفاصيل.',
    },
    'conv_certificate': {
      'FA': 'درخواست گواهی اشتغال به تحصیل',
      'EN': 'Student Status Certificate Request',
      'AR': 'طلب شهادة قيد دراسي',
    },
    'conv_lms': {
      'FA': 'مشکل در سامانه آموزشیار',
      'EN': 'Academic System Issue',
      'AR': 'مشكلة في النظام التعليمي',
    },
    'conv_transcript': {
      'FA': 'ریز نمرات ترم گذشته',
      'EN': 'Previous Semester Transcript',
      'AR': 'كشف درجات الفصل السابق',
    },
    'conv_extension': {
      'FA': 'تمدید معرفی‌نامه',
      'EN': 'Introduction Letter Extension',
      'AR': 'تمديد خطاب التعريف',
    },
    'topic_certificate': {
      'FA': 'گواهی اشتغال به تحصیل',
      'EN': 'Student Status Certificate',
      'AR': 'شهادة قيد دراسي',
    },
    'topic_certificate_sub': {
      'FA': 'درخواست و پیگیری گواهی',
      'EN': 'Request and follow certificate',
      'AR': 'طلب ومتابعة الشهادة',
    },
    'topic_transcript': {
      'FA': 'ریز نمرات',
      'EN': 'Transcript',
      'AR': 'كشف الدرجات',
    },
    'topic_transcript_sub': {
      'FA': 'درخواست ریز نمرات ترمی',
      'EN': 'Request semester transcript',
      'AR': 'طلب كشف درجات الفصل',
    },
    'topic_lms': {
      'FA': 'مشکل در سامانه LMS',
      'EN': 'LMS Issue',
      'AR': 'مشكلة في نظام LMS',
    },
    'topic_lms_sub': {
      'FA': 'مشکلات آموزشیار و LMS',
      'EN': 'Academic system and LMS problems',
      'AR': 'مشكلات النظام التعليمي و LMS',
    },
    'topic_new_request': {
      'FA': 'ثبت درخواست جدید',
      'EN': 'New Request',
      'AR': 'تسجيل طلب جديد',
    },
    'topic_new_request_sub': {
      'FA': 'ایجاد درخواست عمومی',
      'EN': 'Create a general request',
      'AR': 'إنشاء طلب عام',
    },
    'support_chat_welcome': {
      'FA': 'سلام! من دستیار پشتیبانی دانشگاه هستم. چطور می‌تونم کمکتون کنم؟',
      'EN': 'Hello! I am the university support assistant. How can I help you?',
      'AR': 'مرحباً! أنا مساعد الدعم بالجامعة. كيف يمكنني مساعدتك؟',
    },
    'support_chat_certificate_response': {
      'FA': 'برای دریافت گواهی اشتغال به تحصیل، لطفاً به بخش آموزش مراجعه کنید و درخواست خود را ثبت نمایید. معمولاً ظرف 3 روز کاری صادر می‌شود.',
      'EN': 'To get a student certificate, please visit the Education section and register your request. It is usually issued within 3 business days.',
      'AR': 'للحصول على شهادة قيد دراسي، يرجى زيارة قسم التعليم وتسجيل طلبك. عادة ما تصدر في غضون 3 أيام عمل.',
    },
    'support_chat_dormitory_response': {
      'FA': 'درخواست خوابگاه از طریق بخش خدمات دانشجویی انجام می‌شود. شما می‌توانید فرم آنلاین را پر کنید.',
      'EN': 'Dormitory requests are made through the Student Services section. You can fill out the online form.',
      'AR': 'Dormitory requests are made through the Student Services section. You can fill out the online form.',
    },
    'support_chat_visa_response': {
      'FA': 'برای تمدید یا صدور ویزا، لطفاً با بخش کنسولی ارتباط بگیرید. مدارک شما بررسی می‌شود.',
      'EN': 'To extend or issue a visa, please contact the Consular section. Your documents will be reviewed.',
      'AR': 'لتمديد أو إصدار تأشيرة، يرجى التواصل مع القسم القنصلي. سيتم مراجعة وثائقك.',
    },
    'support_chat_grade_response': {
      'FA': 'برای دریافت ریز نمرات، از بخش آموزش درخواست دهید یا از سامانه آموزشیار دانلود کنید.',
      'EN': 'To get your transcript, request it from the Education section or download it from the academic system.',
      'AR': 'للحصول على كشف درجاتك، اطلبه من قسم التعليم أو قم بتنزيله من النظام الأكاديمي.',
    },
    'support_chat_greeting_response': {
      'FA': 'سلام! خوشحالم که با شما صحبت می‌کنم. در چه موضوعی می‌تونم راهنماییتون کنم؟',
      'EN': 'Hello! Nice to talk to you. What subject can I help you with?',
      'AR': 'مرحباً! يسعدني التحدث إليك. في أي موضوع يمكنني مساعدتك؟',
    },
    'support_chat_thanks_response': {
      'FA': 'خواهش می‌کنم! هر وقت سوالی داشتید در خدمتم.',
      'EN': 'You\'re welcome! I\'m here whenever you have a question.',
      'AR': 'عفواً! أنا هنا كلما كان لديك سؤال.',
    },
    'support_chat_unclear_response': {
      'FA': 'متوجه نشدم. می‌تونید سوالتون رو واضح‌تر بپرسید؟ مثلاً درباره گواهی، خوابگاه، ویزا، نمرات یا...',
      'EN': 'I didn\'t understand. Can you ask your question more clearly? For example, about certificates, dormitories, visas, grades, etc.',
      'AR': 'لم أفهم. هل يمكنك طرح سؤالك بشكل أوضح؟ على سبيل المثال، حول الشهادات، السكن الجامعي، التأشيرات، الدرجات، إلخ.',
    },
    'professor_home_title': {
      'FA': 'کلاس‌های من',
      'EN': 'My Classes',
      'AR': 'فصولي الدراسية',
    },
    'professor_class_title': {
      'FA': 'گفتگو با دانشجویان',
      'EN': 'Conversations with Students',
      'AR': 'محادثات مع الطلاب',
    },
    'class_students': {
      'FA': 'دانشجویان کلاس',
      'EN': 'Class Students',
      'AR': 'طلاب الفصل',
    },
    'class_messages': {
      'FA': 'گفتگوهای کلاس',
      'EN': 'Class Messages',
      'AR': 'محادثات الفصل',
    },
    'class_info': {
      'FA': 'اطلاعات کلاس',
      'EN': 'Class Info',
      'AR': 'معلومات الفصل',
    },
    'class_programming_desc': {
      'FA': 'این کلاس به مباحث پیشرفته برنامه نویسی می‌پردازد.',
      'EN': 'This class covers advanced programming topics.',
      'AR': 'يتناول هذا الفصل مواضيع البرمجة المتقدمة.',
    },
    'class_database_desc': {
      'FA': 'اصول طراحی و پیاده‌سازی پایگاه داده.',
      'EN': 'Principles of database design and implementation.',
      'AR': 'مبادئ تصميم وتطبيق قواعد البيانات.',
    },
    'class_datastructure_desc': {
      'FA': 'آشنایی با ساختمان داده‌ها و الگوریتم‌ها.',
      'EN': 'Introduction to data structures and algorithms.',
      'AR': 'مقدمة في هياكل البيانات والخوارزميات.',
    },
    'student_conversation_intro': {
      'FA': 'سلام! چطور می‌توانم در این درس به شما کمک کنم؟',
      'EN': 'Hello! How can I assist you with this course?',
      'AR': 'مرحباً! كيف يمكنني مساعدتك في هذا المقرر؟',
    },
    'prof_sample_student_msg': {
      'FA': 'استاد، من در تمرین شماره 5 مشکل دارم.',
      'EN': 'Professor, I\'m having trouble with assignment 5.',
      'AR': 'أستاذ، لدي مشكلة في الواجب رقم 5.',
    },
    'prof_sample_response': {
      'FA': 'لطفاً جزئیات بیشتری از مشکلتان را توضیح دهید.',
      'EN': 'Please elaborate on the issue you are facing.',
      'AR': 'يرجى تقديم مزيد من التفاصيل حول المشكلة التي تواجهها.',
    },
  };

  return data[key]?[_langKey(lang)] ?? key;
}
// --- بهبود HomeScreen برای مدیریت نقش‌ها ---
// حذف تعریف تکراری _ManagerChatCard - فقط یک بار در انتهای فایل نگه دارید
// مطمئن شوید HomeScreen کلاس دارد

// --- Admin Dashboard Screen ---

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int selectedTab = 0;
  String roleFilter = 'all';
  String unitFilter = 'all';
  String reportFilter = 'all';
  bool showFloatingMessage = true;
  bool maintenanceMode = false;
  bool allowRegistration = true;
  bool financeEditLocked = true;
  String backgroundMode = 'spring';
  String logoMode = 'arak_default';
  String floatingDurationMode = 'hours';
  String floatingTargetRole = 'all';
  final TextEditingController searchCtrl = TextEditingController();
  final TextEditingController floatingMessageCtrl = TextEditingController(
    text: 'پیام مدیر اصلی: لطفاً اعلان‌ها، برنامه هفتگی و وضعیت کلاس‌ها را بررسی کنید.',
  );
  final TextEditingController floatingDurationCtrl = TextEditingController(text: '4');
  final Set<String> lockedSections = <String>{};
  final Set<String> lockedUsers = <String>{};

  @override
  void dispose() {
    searchCtrl.dispose();
    floatingMessageCtrl.dispose();
    floatingDurationCtrl.dispose();
    super.dispose();
  }

  List<_AdminUserAccessItem> get allUsers => <_AdminUserAccessItem>[
        _AdminUserAccessItem(username: 'sina', name: 'مدیر اصلی سیستم', role: 'admin', section: 'کل سیستم', active: !lockedUsers.contains('sina')),
        _AdminUserAccessItem(username: 'admin', name: 'دانشجو نمونه', role: 'student', section: 'پنل دانشجو', active: !lockedUsers.contains('admin')),
        _AdminUserAccessItem(username: 'admin1', name: 'مدیر امور بین‌الملل', role: 'manager', section: 'امور بین‌الملل', active: !lockedUsers.contains('admin1')),
        _AdminUserAccessItem(username: 'admin2', name: 'مدیر آموزش', role: 'manager', section: 'آموزش', active: !lockedUsers.contains('admin2')),
        _AdminUserAccessItem(username: 'admin3', name: 'مدیر خدمات دانشجویی', role: 'manager', section: 'خدمات دانشجویی', active: !lockedUsers.contains('admin3')),
        _AdminUserAccessItem(username: 'admin4', name: 'مدیر کنسولی', role: 'manager', section: 'کنسولی', active: !lockedUsers.contains('admin4')),
        _AdminUserAccessItem(username: 'admin5', name: 'کارشناس آموزش', role: 'manager', section: 'کارشناس آموزش', active: !lockedUsers.contains('admin5')),
        _AdminUserAccessItem(username: 'prof1', name: 'دکتر محمدی', role: 'professor', section: 'پنل استاد', active: !lockedUsers.contains('prof1')),
        _AdminUserAccessItem(username: 'prof2', name: 'Dr. Johnson', role: 'professor', section: 'پنل استاد', active: !lockedUsers.contains('prof2')),
      ];

  List<Map<String, dynamic>> get managedSections => <Map<String, dynamic>>[
        {'key': 'student_dashboard', 'title': 'داشبورد دانشجو', 'unit': 'student', 'icon': Icons.home_outlined},
        {'key': 'student_weekly_schedule', 'title': 'برنامه هفتگی دانشجو', 'unit': 'education', 'icon': Icons.calendar_month_outlined},
        {'key': 'manager_dashboard', 'title': 'داشبورد مدیران', 'unit': 'manager', 'icon': Icons.dashboard_customize_outlined},
        {'key': 'education_management', 'title': 'مدیریت آموزش و کلاس‌ها', 'unit': 'education', 'icon': Icons.school_outlined},
        {'key': 'education_student_file', 'title': 'پرونده آموزشی دانشجو', 'unit': 'education', 'icon': Icons.badge_outlined},
        {'key': 'professor_dashboard', 'title': 'داشبورد استاد', 'unit': 'professor', 'icon': Icons.person_pin_outlined},
        {'key': 'services_panel', 'title': 'سایر خدمات', 'unit': 'services', 'icon': Icons.apps_outlined},
        {'key': 'header_menus', 'title': 'هدر، پروفایل، زبان و اعلان‌ها', 'unit': 'system', 'icon': Icons.web_asset_outlined},
        {'key': 'notifications', 'title': 'اعلان‌ها و پیام‌ها', 'unit': 'system', 'icon': Icons.notifications_outlined},
        {'key': 'admin_control_center', 'title': 'مرکز کنترل sina', 'unit': 'admin', 'icon': Icons.admin_panel_settings_outlined},
      ];

  List<_AdminUserAccessItem> get filteredUsers {
    final String q = searchCtrl.text.trim().toLowerCase();
    return allUsers.where((user) {
      final bool roleOk = roleFilter == 'all' || user.role == roleFilter;
      final bool queryOk = q.isEmpty ||
          user.username.toLowerCase().contains(q) ||
          user.name.toLowerCase().contains(q) ||
          user.section.toLowerCase().contains(q);
      return roleOk && queryOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang lang = appState.selectedLang;
    final bool isRtl = isRtlLang(lang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مرکز کنترل مدیر اصلی - sina'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'اعلان‌ها',
              onPressed: () => _showAdminNotifications(context, appState),
              icon: Badge(
                label: Text(appState.adminNotifications.where((n) => n.unread).length.toString()),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
            IconButton(
              tooltip: 'خروج',
              onPressed: appState.logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Stack(
          children: [
            AnimatedAppBackground(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool wide = constraints.maxWidth >= 1120;
                  if (wide) {
                    return Row(
                      children: [
                        SizedBox(width: 340, child: _buildAdminSidePanel(context, appState)),
                        Expanded(child: _buildSelectedPage(context, appState)),
                      ],
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildAdminSidePanel(context, appState, compact: true),
                      const SizedBox(height: 16),
                      _buildSelectedPage(context, appState, embedded: true),
                    ],
                  );
                },
              ),
            ),
            if (appState.isGlobalFloatingMessageActive)
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.campaign_outlined, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(appState.globalFloatingMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(appState.globalFloatingMessageRemainingText, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'حذف پیام',
                          onPressed: appState.clearGlobalFloatingMessage,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminSidePanel(BuildContext context, AppState appState, {bool compact = false}) {
    final List<String> titles = const <String>[
      'نمای کلی',
      'صفحات و اجزا',
      'نقش‌ها و دسترسی‌ها',
      'اشخاص',
      'گزارش‌ها و فیلتر',
      'کنترل سیستم',
      'آموزش و کلاس‌ها',
    ];
    final List<IconData> icons = const <IconData>[
      Icons.dashboard_customize_outlined,
      Icons.view_quilt_outlined,
      Icons.rule_folder_outlined,
      Icons.people_alt_outlined,
      Icons.analytics_outlined,
      Icons.settings_applications_outlined,
      Icons.school_outlined,
    ];

    return Container(
      height: compact ? null : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.95),
        border: compact ? null : Border(left: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      ),
      child: Column(
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.deepPurple.withValues(alpha: 0.14),
            child: const Icon(Icons.admin_panel_settings_outlined, size: 46, color: Colors.deepPurple),
          ),
          const SizedBox(height: 12),
          const Text('مدیر اصلی سیستم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          const Text('نام کاربری: sina', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _miniChip('کاربران', allUsers.length.toString(), Icons.people_alt_outlined, Colors.blue),
              _miniChip('بخش‌ها', managedSections.length.toString(), Icons.widgets_outlined, Colors.green),
              _miniChip('قفل‌ها', (lockedUsers.length + lockedSections.length).toString(), Icons.lock_outline, Colors.red),
              _miniChip('کلاس‌ها', appState.educationClasses.length.toString(), Icons.school_outlined, Colors.deepPurple),
            ],
          ),
          const SizedBox(height: 12),
          if (compact)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(titles.length, (index) {
                return ChoiceChip(
                  selected: selectedTab == index,
                  label: Text(titles[index]),
                  onSelected: (_) => setState(() => selectedTab = index),
                );
              }),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  final bool selected = selectedTab == index;
                  return Card(
                    elevation: selected ? 2 : 0,
                    color: selected ? Colors.deepPurple.withValues(alpha: 0.10) : Colors.transparent,
                    child: ListTile(
                      leading: Icon(icons[index], color: selected ? Colors.deepPurple : null),
                      title: Text(titles[index], style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                      trailing: selected ? const Icon(Icons.chevron_left) : null,
                      onTap: () => setState(() => selectedTab = index),
                    ),
                  );
                },
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: appState.logout,
              icon: const Icon(Icons.logout),
              label: const Text('خروج'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPage(BuildContext context, AppState appState, {bool embedded = false}) {
    final List<Widget> pages = [
      _buildOverview(context, appState),
      _buildPageEditor(context),
      _buildRoleAccess(context, appState),
      _buildPeopleCenter(context),
      _buildReports(context, appState),
      _buildSystemControl(context, appState),
      _buildEducationGateway(context, appState),
    ];
    if (embedded) return pages[selectedTab];
    return ListView(padding: const EdgeInsets.all(16), children: [pages[selectedTab]]);
  }

  Widget _buildOverview(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroCard(
          'مرکز کنترل جامع sina',
          'مدیریت کامل برنامه از یک نقطه: ویرایش صفحه‌ها، کوچک‌ترین اجزا، اشخاص، نقش‌ها، وظایف، دسترسی‌ها، قفل‌ها، گزارش‌ها، پیام شناور و بک‌گراند سیستم.',
          Icons.security_outlined,
          Colors.deepPurple,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _statCard('کاربران', allUsers.length.toString(), Icons.people_alt_outlined, Colors.blue),
            _statCard('مدیران', allUsers.where((u) => u.role == 'manager').length.toString(), Icons.manage_accounts_outlined, Colors.orange),
            _statCard('استادان', allUsers.where((u) => u.role == 'professor').length.toString(), Icons.person_pin_outlined, Colors.green),
            _statCard('دانشجویان', allUsers.where((u) => u.role == 'student').length.toString(), Icons.school_outlined, Colors.teal),
            _statCard('کلاس‌ها', appState.educationClasses.length.toString(), Icons.video_call_outlined, Colors.indigo),
            _statCard('گزارش کلاس', appState.educationClassReports.length.toString(), Icons.analytics_outlined, Colors.deepPurple),
            _statCard('بخش‌های قفل', lockedSections.length.toString(), Icons.lock_outline, Colors.red),
            _statCard('کاربران قفل', lockedUsers.length.toString(), Icons.person_off_outlined, Colors.redAccent),
          ],
        ),
        const SizedBox(height: 16),
        _sectionCard(
          title: 'دسترسی سریع مدیر اصلی',
          icon: Icons.flash_on_outlined,
          color: Colors.deepPurple,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _actionCard('صفحات و اجزا', 'قفل، ویرایش و بررسی هر صفحه', Icons.view_quilt_outlined, Colors.blue, () => setState(() => selectedTab = 1)),
                _actionCard('نقش‌ها و دسترسی‌ها', 'تعریف نقش، وظیفه و سطح دسترسی', Icons.rule_folder_outlined, Colors.orange, () => setState(() => selectedTab = 2)),
                _actionCard('کاربران و اشخاص', 'جستجو، فیلتر، قفل و ویرایش شخص', Icons.people_alt_outlined, Colors.green, () => setState(() => selectedTab = 3)),
                _actionCard('گزارش‌گیری', 'فیلتر گزارش‌های سیستم و آموزش', Icons.analytics_outlined, Colors.deepPurple, () => setState(() => selectedTab = 4)),
                _actionCard('پیام شناور و بک‌گراند', 'اعمال پیام و ظاهر سیستم', Icons.campaign_outlined, Colors.red, () => setState(() => selectedTab = 5)),
                _actionCard('آموزش و کلاس‌ها', 'کلاس، دانشجو، برنامه هفتگی و کارشناسان', Icons.school_outlined, Colors.teal, () => setState(() => selectedTab = 6)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _auditLog(appState),
      ],
    );
  }

  Widget _buildPageEditor(BuildContext context) {
    final sections = managedSections.where((s) => unitFilter == 'all' || s['unit'] == unitFilter).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header('مدیریت صفحه‌ها و اجزای کوچک', 'هر صفحه، هدر، نوار پایین، کارت، دکمه، سرویس یا بخش قابل قفل و ویرایش نمایشی است.', Icons.view_quilt_outlined, Colors.blue),
        const SizedBox(height: 12),
        _dropdownFilter(
          label: 'فیلتر بخش',
          value: unitFilter,
          values: const ['all', 'student', 'education', 'manager', 'professor', 'services', 'system', 'admin'],
          labels: const ['همه', 'دانشجو', 'آموزش', 'مدیران', 'استاد', 'خدمات', 'سیستم', 'ادمین'],
          onChanged: (v) => setState(() => unitFilter = v),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: sections.map((section) {
            final key = section['key'] as String;
            final locked = lockedSections.contains(key);
            return SizedBox(
              width: 320,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: locked ? Colors.red.withValues(alpha: 0.12) : Colors.blue.withValues(alpha: 0.12),
                            child: Icon(section['icon'] as IconData, color: locked ? Colors.red : Colors.blue),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(section['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                          Chip(label: Text(locked ? 'قفل' : 'فعال')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('کلید: $key', style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showComponentEditDialog(context, section),
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('ویرایش'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => setState(() {
                              locked ? lockedSections.remove(key) : lockedSections.add(key);
                            }),
                            icon: Icon(locked ? Icons.lock_open_outlined : Icons.lock_outline),
                            label: Text(locked ? 'بازکردن' : 'قفل'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoleAccess(BuildContext context, AppState appState) {
    final roles = [
      ['admin', 'مدیر اصلی', 'مدیریت کل سیستم، قفل‌ها، نقش‌ها، گزارش‌ها، بک‌گراند، پیام شناور و تمام دسترسی‌ها'],
      ['manager', 'مدیر واحد', 'مدیریت واحد، پاسخگویی، گزارش‌گیری و ارتباط با نقش‌های مرتبط'],
      ['education_manager', 'مدیر آموزش', 'کلاس‌ها، برنامه هفتگی، پرونده دانشجو و مدیریت کارشناسان آموزش'],
      ['education_officer', 'کارشناس آموزش', 'دسترسی‌های تفویض‌شده توسط مدیر آموزش یا مدیر اصلی'],
      ['professor', 'استاد', 'کلاس‌ها، برنامه هفتگی، تعامل با دانشجو و گفتگو با مدیران'],
      ['student', 'دانشجو', 'خانه، کلاس‌ها، برنامه هفتگی، خدمات و اعلان‌ها'],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header('نقش‌ها، وظایف و دسترسی‌ها', 'مدیر اصلی می‌تواند نقش، وظیفه و سطح دسترسی هر شخص یا گروه را کنترل کند.', Icons.rule_folder_outlined, Colors.orange),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: roles.map((r) {
            return SizedBox(
              width: 360,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const CircleAvatar(child: Icon(Icons.verified_user_outlined)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(r[1], style: const TextStyle(fontWeight: FontWeight.bold))),
                        Chip(label: Text(r[0])),
                      ]),
                      const SizedBox(height: 10),
                      Text(r[2], style: const TextStyle(height: 1.5)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton.icon(onPressed: () => _showRoleEditDialog(context, r[1], r[2]), icon: const Icon(Icons.edit_note_outlined), label: const Text('وظایف')),
                          OutlinedButton.icon(onPressed: () => _showRolePermissionDialog(context, r[1]), icon: const Icon(Icons.key_outlined), label: const Text('دسترسی‌ها')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _educationOfficerAccessBox(context, appState),
      ],
    );
  }

  Widget _buildPeopleCenter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header('مدیریت اشخاص و کاربران', 'جستجو، فیلتر، قفل، گزارش، تغییر نقش و بررسی هر شخص از این قسمت انجام می‌شود.', Icons.people_alt_outlined, Colors.green),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 330,
              child: TextField(
                controller: searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'جستجو', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              ),
            ),
            _dropdownFilter(
              label: 'فیلتر نقش',
              value: roleFilter,
              values: const ['all', 'admin', 'manager', 'professor', 'student'],
              labels: const ['همه', 'ادمین', 'مدیر/کارشناس', 'استاد', 'دانشجو'],
              onChanged: (v) => setState(() => roleFilter = v),
            ),
            ElevatedButton.icon(onPressed: () => _showCreateUserDialog(context), icon: const Icon(Icons.person_add_alt_1_outlined), label: const Text('کاربر جدید')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('نام کاربری')),
                DataColumn(label: Text('نام')),
                DataColumn(label: Text('نقش')),
                DataColumn(label: Text('بخش')),
                DataColumn(label: Text('وضعیت')),
                DataColumn(label: Text('عملیات')),
              ],
              rows: filteredUsers.map((user) {
                final bool locked = lockedUsers.contains(user.username);
                return DataRow(cells: [
                  DataCell(Text(user.username)),
                  DataCell(Text(user.name)),
                  DataCell(Text(user.role)),
                  DataCell(Text(user.section)),
                  DataCell(Chip(label: Text(locked ? 'قفل' : 'فعال'))),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () => _showUserAccessDialog(context, user), icon: const Icon(Icons.edit_outlined), tooltip: 'ویرایش'),
                      IconButton(
                        onPressed: () => setState(() => locked ? lockedUsers.remove(user.username) : lockedUsers.add(user.username)),
                        icon: Icon(locked ? Icons.lock_open_outlined : Icons.lock_outline),
                        tooltip: locked ? 'بازکردن' : 'قفل',
                      ),
                      IconButton(onPressed: () => _showPersonReportDialog(context, user), icon: const Icon(Icons.assignment_ind_outlined), tooltip: 'گزارش'),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReports(BuildContext context, AppState appState) {
    final reports = [
      {'type': 'system', 'title': 'گزارش سلامت سیستم', 'unit': 'کل برنامه', 'status': maintenanceMode ? 'تعمیرات فعال' : 'فعال'},
      {'type': 'education', 'title': 'گزارش کلاس‌های آموزش', 'unit': 'آموزش', 'status': '${appState.educationClasses.length} کلاس'},
      {'type': 'education', 'title': 'گزارش کلاس‌های گذشته', 'unit': 'آموزش', 'status': '${appState.pastEducationClasses.length} کلاس گذشته'},
      {'type': 'access', 'title': 'گزارش دسترسی‌ها', 'unit': 'امنیت', 'status': '${lockedUsers.length} کاربر قفل‌شده'},
      {'type': 'notification', 'title': 'گزارش اعلان‌ها', 'unit': 'پیام‌ها', 'status': '${appState.adminNotifications.length} اعلان'},
      {'type': 'service', 'title': 'گزارش سایر خدمات', 'unit': 'خدمات', 'status': lockedSections.contains('services_panel') ? 'قفل' : 'فعال'},
    ].where((r) => reportFilter == 'all' || r['type'] == reportFilter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header('گزارش‌گیری و فیلتر پیشرفته', 'گزارش کاربران، کلاس‌ها، اعلان‌ها، دسترسی‌ها، بخش‌ها و سیستم با فیلتر قابل مشاهده است.', Icons.analytics_outlined, Colors.deepPurple),
        const SizedBox(height: 12),
        _dropdownFilter(
          label: 'نوع گزارش',
          value: reportFilter,
          values: const ['all', 'system', 'education', 'access', 'notification', 'service'],
          labels: const ['همه', 'سیستم', 'آموزش', 'دسترسی', 'اعلان', 'خدمات'],
          onChanged: (v) => setState(() => reportFilter = v),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: reports.map((item) {
            return SizedBox(
              width: 330,
              child: Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.insert_chart_outlined)),
                  title: Text(item['title']!),
                  subtitle: Text('بخش: ${item['unit']}\nوضعیت: ${item['status']}'),
                  isThreeLine: true,
                  trailing: IconButton(icon: const Icon(Icons.visibility_outlined), onPressed: () => _showReportDetailDialog(context, item, appState)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _classReportsPreview(appState),
      ],
    );
  }

  Widget _buildSystemControl(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header('کنترل سیستم، پیام شناور و بک‌گراند', 'مدیر اصلی می‌تواند پیام شناور، بک‌گراند، قفل عمومی، ثبت‌نام و قفل مالی را کنترل کند.', Icons.settings_applications_outlined, Colors.red),
        const SizedBox(height: 12),
        _sectionCard(
          title: 'پیام شناور روی برنامه',
          icon: Icons.campaign_outlined,
          color: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                TextField(
                  controller: floatingMessageCtrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(labelText: 'متن پیام شناور', border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: floatingDurationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: floatingDurationMode == 'hours' ? 'مدت نمایش / ساعت' : 'مدت نمایش / روز', border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: floatingDurationMode,
                      items: const [
                        DropdownMenuItem(value: 'hours', child: Text('ساعت')),
                        DropdownMenuItem(value: 'days', child: Text('روز')),
                        DropdownMenuItem(value: 'unlimited', child: Text('بدون محدودیت')),
                      ],
                      onChanged: (v) => setState(() => floatingDurationMode = v ?? 'hours'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: floatingTargetRole,
                  decoration: InputDecoration(
                    labelText: 'گروه هدف نمایش پیام',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('همه کاربران')),
                    DropdownMenuItem(value: 'student', child: Text('فقط دانشجویان')),
                    DropdownMenuItem(value: 'manager', child: Text('همه مدیران واحدها')),
                    DropdownMenuItem(value: 'education', child: Text('مدیر و کارشناسان آموزش')),
                    DropdownMenuItem(value: 'professor', child: Text('فقط اساتید')),
                    DropdownMenuItem(value: 'admin', child: Text('فقط مدیر اصلی')),
                  ],
                  onChanged: (v) => setState(() => floatingTargetRole = v ?? 'all'),
                ),
                SwitchListTile(value: showFloatingMessage, title: const Text('نمایش پیام شناور'), onChanged: (v) => setState(() => showFloatingMessage = v)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final int amount = int.tryParse(floatingDurationCtrl.text.trim()) ?? 0;
                      Duration? duration;
                      if (floatingDurationMode == 'hours') duration = Duration(hours: amount <= 0 ? 1 : amount);
                      if (floatingDurationMode == 'days') duration = Duration(days: amount <= 0 ? 1 : amount);
                      appState.setGlobalFloatingMessage(message: floatingMessageCtrl.text, duration: floatingDurationMode == 'unlimited' ? null : duration, enabled: showFloatingMessage, targetRole: floatingTargetRole);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پیام شناور برای همه کاربران اعمال شد.')));
                    },
                    icon: const Icon(Icons.publish_outlined),
                    label: const Text('اعمال پیام شناور برای همه کاربران'),
                  ),
                ),
                if (appState.isGlobalFloatingMessageActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('وضعیت فعلی: ${appState.globalFloatingMessageRemainingText} | گروه هدف: ${appState.globalFloatingMessageTargetText}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _sectionCard(
          title: 'ظاهر، بک‌گراند و قفل سیستم',
          icon: Icons.wallpaper_outlined,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: backgroundMode,
                  decoration: InputDecoration(labelText: 'بک‌گراند سیستم', border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                  items: const [
                    DropdownMenuItem(value: 'spring', child: Text('بهاری')),
                    DropdownMenuItem(value: 'classic', child: Text('کلاسیک دانشگاهی')),
                    DropdownMenuItem(value: 'dark_glow', child: Text('تیره با نقاط نورانی')),
                    DropdownMenuItem(value: 'minimal', child: Text('مینیمال')),
                    DropdownMenuItem(value: 'ceremony', child: Text('مناسبتی / جشن دانشگاه')),
                  ],
                  onChanged: (v) => setState(() => backgroundMode = v ?? 'spring'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: logoMode,
                  decoration: InputDecoration(labelText: 'آرم برنامه / دانشگاه', border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                  items: const [
                    DropdownMenuItem(value: 'arak_default', child: Text('آرم پیش‌فرض دانشگاه')),
                    DropdownMenuItem(value: 'international', child: Text('آرم بین‌الملل')),
                    DropdownMenuItem(value: 'science', child: Text('آرم علمی/آموزشی')),
                    DropdownMenuItem(value: 'ceremony', child: Text('آرم مناسبتی')),
                  ],
                  onChanged: (v) => setState(() => logoMode = v ?? 'arak_default'),
                ),
                SwitchListTile(value: maintenanceMode, title: const Text('حالت تعمیرات / قفل موقت سیستم'), onChanged: (v) => setState(() => maintenanceMode = v)),
                SwitchListTile(value: allowRegistration, title: const Text('اجازه ثبت‌نام از صفحه ورود'), onChanged: (v) => setState(() => allowRegistration = v)),
                SwitchListTile(value: financeEditLocked, title: const Text('قفل ویرایش بخش مالی برای همه به‌جز مدیر اصلی'), onChanged: (v) => setState(() => financeEditLocked = v)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      appState.setSystemVisualSettings(
                        backgroundMode: backgroundMode,
                        logoMode: logoMode,
                        maintenanceMode: maintenanceMode,
                        allowRegistration: allowRegistration,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تنظیمات ظاهر، آرم و بک‌گراند برای همه کاربران اعمال شد.')));
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('اعمال تنظیمات سراسری برنامه'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _sectionCard(
          title: 'پیام بین مدیران واحدها و مدیر اصلی',
          icon: Icons.forum_outlined,
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: units.where((unit) => unit.keyName != 'other_services').map((unit) {
                final int unread = mockManagerMessages.where((m) => !m.isRead && m.receiverUnit == 'admin_main' && m.senderUnit == unit.keyName).length;
                return SizedBox(
                  width: 260,
                  child: _ManagerChatCard(
                    managerName: appText(appState.selectedLang, unit.keyName),
                    icon: unit.icon,
                    unreadCount: unread,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => InterManagerChatScreen(
                            targetUnit: unit.keyName,
                            targetUnitName: appText(appState.selectedLang, unit.keyName),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _sectionCard(
          title: 'خلاصه قفل‌ها',
          icon: Icons.lock_outline,
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Text('بخش‌های قفل‌شده: ${lockedSections.isEmpty ? 'هیچ' : lockedSections.join('، ')}\nکاربران قفل‌شده: ${lockedUsers.isEmpty ? 'هیچ' : lockedUsers.join('، ')}'),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationGateway(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header('آموزش، کلاس‌ها و پرونده دانشجو', 'ادمین اصلی به مدیریت کلاس، برنامه هفتگی، پرونده دانشجو و کارشناسان آموزش دسترسی کامل دارد.', Icons.school_outlined, Colors.teal),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _actionCard('مدیریت کلاس‌ها', 'ایجاد، ویرایش، دانشجویان، استاد و گزارش کلاس‌ها', Icons.video_call_outlined, Colors.green, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationClassManagementScreen()));
            }),
            _actionCard('پرونده دانشجو', 'پروفایل، دروس، برنامه هفتگی، گزارش آموزشی/انضباطی و مالی', Icons.badge_outlined, Colors.deepPurple, () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const StudentEducationLookupScreen(
                    canEdit: true,
                    canManageSchedule: true,
                    title: 'پرونده آموزشی دانشجو - مدیر اصلی',
                  ),
                ),
              );
            }),
            _actionCard('کارشناسان آموزش', 'انتخاب، جستجو، چت و تغییر دسترسی کارشناس', Icons.manage_accounts_outlined, Colors.orange, () {
              _showOfficerPermissionSheet(context, appState);
            }),
            _actionCard('چت خصوصی آموزش', 'گفتگوی مدیر آموزش و کارشناس با ذخیره تاریخچه', Icons.lock_outline, Colors.blue, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationPrivateChatScreen()));
            }),
          ],
        ),
        const SizedBox(height: 16),
        _classReportsPreview(appState),
      ],
    );
  }

  Widget _educationOfficerAccessBox(BuildContext context, AppState appState) {
    return _sectionCard(
      title: 'دسترسی کارشناسان آموزش',
      icon: Icons.manage_accounts_outlined,
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            ...appState.educationOfficers.map((officer) {
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.badge_outlined)),
                  title: Text(officer.name),
                  subtitle: Text('نام کاربری: ${officer.username} | دسترسی‌ها: ${officer.permissions.length}'),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(onPressed: () => _showOfficerPermissionSheet(context, appState, officerId: officer.id), icon: const Icon(Icons.edit_outlined), tooltip: 'ویرایش دسترسی'),
                      IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationPrivateChatScreen())), icon: const Icon(Icons.chat_outlined), tooltip: 'چت'),
                    ],
                  ),
                ),
              );
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(onPressed: () => _showCreateOfficerDialog(context), icon: const Icon(Icons.person_add_alt_1_outlined), label: const Text('کارشناس جدید')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _classReportsPreview(AppState appState) {
    return _sectionCard(
      title: 'خلاصه گزارش کلاس‌های فعال و گذشته',
      icon: Icons.assignment_outlined,
      color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _smallBox('فعال/زمان‌بندی', appState.activeEducationClasses.length.toString(), Colors.green)),
                const SizedBox(width: 8),
                Expanded(child: _smallBox('گذشته', appState.pastEducationClasses.length.toString(), Colors.blueGrey)),
                const SizedBox(width: 8),
                Expanded(child: _smallBox('گزارش', appState.educationClassReports.length.toString(), Colors.deepPurple)),
              ],
            ),
            const SizedBox(height: 12),
            ...appState.educationClasses.take(6).map((c) {
              return ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(c.title),
                subtitle: Text('استاد: ${c.professorName} | ${c.weekDay} | ${c.studentNames.length} دانشجو'),
                trailing: Chip(label: Text(_statusLabel(c.status))),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _auditLog(AppState appState) {
    final List<String> logs = [
      'ورود مدیر اصلی sina',
      'بررسی ${managedSections.length} صفحه و جزء برنامه',
      'بررسی ${allUsers.length} کاربر و نقش',
      'بررسی ${appState.educationClasses.length} کلاس آموزشی',
      'بررسی ${lockedUsers.length + lockedSections.length} قفل فعال',
    ];
    return _sectionCard(
      title: 'لاگ و ردگیری مدیریتی',
      icon: Icons.history_outlined,
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: logs.map((log) => ListTile(
            leading: const Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text(log),
            subtitle: Text('زمان: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}'),
          )).toList(),
        ),
      ),
    );
  }

  Widget _heroCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.16), Colors.green.withValues(alpha: 0.08)]),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundColor: color, child: Icon(icon, color: Colors.white, size: 30)),
            const SizedBox(width: 12),
            Expanded(child: Text('$title\n$subtitle', style: const TextStyle(height: 1.6, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }

  Widget _header(String title, String subtitle, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.5)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            ),
            child: Row(children: [Icon(icon, color: color), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)))]),
          ),
          child,
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(children: [
        CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ])),
      ]),
    );
  }

  Widget _miniChip(String title, String value, IconData icon, Color color) {
    return Chip(avatar: Icon(icon, size: 16, color: color), label: Text('$title: $value'), backgroundColor: color.withValues(alpha: 0.08));
  }

  Widget _actionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 300,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withValues(alpha: 0.18))),
          child: Row(children: [
            CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.4)),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _smallBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.18))),
      child: Column(children: [Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color)), Text(title, style: const TextStyle(fontSize: 12))]),
    );
  }

  Widget _dropdownFilter({required String label, required String value, required List<String> values, required List<String> labels, required ValueChanged<String> onChanged}) {
    return SizedBox(
      width: 260,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
        items: List.generate(values.length, (i) => DropdownMenuItem(value: values[i], child: Text(labels[i]))),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }

  String _statusLabel(LiveClassStatus status) {
    switch (status) {
      case LiveClassStatus.scheduled: return 'زمان‌بندی';
      case LiveClassStatus.waitingForProfessor: return 'انتظار استاد';
      case LiveClassStatus.active: return 'فعال';
      case LiveClassStatus.finished: return 'پایان';
      case LiveClassStatus.cancelled: return 'لغو';
    }
  }

  String _permissionLabel(EducationPermission p) {
    switch (p) {
      case EducationPermission.manageClasses: return 'مدیریت کلاس‌ها';
      case EducationPermission.viewReports: return 'مشاهده گزارش‌ها';
      case EducationPermission.createClass: return 'ایجاد کلاس';
      case EducationPermission.editClass: return 'ویرایش کلاس';
      case EducationPermission.deleteClass: return 'حذف کلاس';
      case EducationPermission.manageStudents: return 'مدیریت دانشجویان';
      case EducationPermission.manageProfessors: return 'مدیریت استادان';
      case EducationPermission.privateChat: return 'چت خصوصی';
      case EducationPermission.viewClassHistory: return 'مشاهده تاریخچه کلاس';
    }
  }

  void _showAdminNotifications(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        final notifications = appState.adminNotifications;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: 420,
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(12), child: Text('اعلان‌های مدیر اصلی', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              Expanded(
                child: notifications.isEmpty
                    ? const Center(child: Text('اعلانی ثبت نشده است.'))
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (_, index) {
                          final n = notifications[index];
                          return ListTile(leading: Icon(n.unread ? Icons.mark_email_unread_outlined : Icons.drafts_outlined), title: Text(n.title), subtitle: Text(n.subtitle), trailing: Text(n.unitKey));
                        },
                      ),
              ),
            ]),
          ),
        );
      },
    );
  }

  void _showComponentEditDialog(BuildContext context, Map<String, dynamic> section) {
    final titleCtrl = TextEditingController(text: section['title'] as String);
    final descCtrl = TextEditingController(text: 'ویرایش نمایشی اجزای ${section['title']}');
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('ویرایش صفحه یا جزء'),
          content: SizedBox(
            width: 460,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'عنوان', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: descCtrl, minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'توضیح یا متن جزء', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              const Text('در نسخه دمو تغییرات نمایشی است؛ در نسخه دیتابیسی ذخیره دائمی انجام می‌شود.'),
            ]),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن')), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ثبت'))],
        ),
      ),
    );
  }

  void _showRoleEditDialog(BuildContext context, String roleTitle, String tasks) {
    final taskCtrl = TextEditingController(text: tasks);
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('ویرایش وظایف $roleTitle'),
          content: SizedBox(width: 480, child: TextField(controller: taskCtrl, minLines: 5, maxLines: 8, decoration: const InputDecoration(labelText: 'وظایف نقش', border: OutlineInputBorder()))),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ثبت'))],
        ),
      ),
    );
  }

  void _showRolePermissionDialog(BuildContext context, String roleTitle) {
    final permissions = <String, bool>{
      'مشاهده صفحه': true,
      'ویرایش اطلاعات': roleTitle.contains('مدیر') || roleTitle.contains('اصلی'),
      'حذف یا قفل': roleTitle.contains('اصلی'),
      'گزارش‌گیری': true,
      'ارسال اعلان': roleTitle.contains('مدیر') || roleTitle.contains('اصلی'),
      'مدیریت مالی': roleTitle.contains('اصلی'),
      'مدیریت انضباطی': roleTitle.contains('اصلی'),
    };
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('دسترسی‌های $roleTitle'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: permissions.keys.map((key) => CheckboxListTile(value: permissions[key], title: Text(key), onChanged: (v) => setDialogState(() => permissions[key] = v ?? false))).toList(),
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن')), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ثبت'))],
          );
        }),
      ),
    );
  }

  void _showOfficerPermissionSheet(BuildContext context, AppState appState, {String? officerId}) {
    EducationOfficerModel? selectedOfficer;
    if (officerId != null) {
      try { selectedOfficer = appState.educationOfficers.firstWhere((o) => o.id == officerId); } catch (_) {}
    }
    final selectedPermissions = <EducationPermission>{...(selectedOfficer?.permissions ?? <EducationPermission>[])};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
            child: SizedBox(
              height: 560,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('مدیریت دسترسی کارشناس آموزش', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedOfficer?.id,
                  decoration: const InputDecoration(labelText: 'انتخاب کارشناس', border: OutlineInputBorder()),
                  items: appState.educationOfficers.map((o) => DropdownMenuItem(value: o.id, child: Text('${o.name} - ${o.username}'))).toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    final officer = appState.educationOfficers.firstWhere((o) => o.id == v);
                    setSheetState(() {
                      selectedOfficer = officer;
                      selectedPermissions..clear()..addAll(officer.permissions);
                    });
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: EducationPermission.values.map((p) => CheckboxListTile(
                      value: selectedPermissions.contains(p),
                      title: Text(_permissionLabel(p)),
                      onChanged: selectedOfficer == null
                          ? null
                          : (v) {
                              setSheetState(() {
                                if (v == true) {
                                  selectedPermissions.add(p);
                                } else {
                                  selectedPermissions.remove(p);
                                }
                              });
                            },
                    )).toList(),
                  ),
                ),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () => _showCreateOfficerDialog(context), icon: const Icon(Icons.person_add_alt_1_outlined), label: const Text('کارشناس جدید'))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: selectedOfficer == null ? null : () {
                        appState.updateEducationOfficerPermissions(officerId: selectedOfficer!.id, permissions: selectedPermissions.toList());
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('ثبت'),
                    ),
                  ),
                ]),
              ]),
            ),
          );
        }),
      ),
    );
  }

  void _showCreateOfficerDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final usernameCtrl = TextEditingController(text: 'admin6');
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تعریف کارشناس آموزش جدید'),
          content: SizedBox(
            width: 420,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'نام کارشناس', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'نام کاربری پیشنهادی', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              const Text('این فرم در نسخه فعلی نمایشی است و برای ذخیره واقعی باید به دیتابیس متصل شود.'),
            ]),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن')), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ثبت'))],
        ),
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    final usernameCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    String role = 'student';
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('ایجاد کاربر جدید'),
            content: SizedBox(
              width: 420,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'نام', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'نام کاربری', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(labelText: 'نقش', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'student', child: Text('دانشجو')),
                    DropdownMenuItem(value: 'professor', child: Text('استاد')),
                    DropdownMenuItem(value: 'manager', child: Text('مدیر/کارشناس')),
                    DropdownMenuItem(value: 'admin', child: Text('مدیر اصلی')),
                  ],
                  onChanged: (v) => setDialogState(() => role = v ?? 'student'),
                ),
              ]),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ثبت'))],
          );
        }),
      ),
    );
  }

  void _showUserAccessDialog(BuildContext context, _AdminUserAccessItem user) {
    String selectedRole = user.role;
    bool active = !lockedUsers.contains(user.username);
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('ویرایش ${user.name}'),
            content: SizedBox(
              width: 440,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('نام کاربری: ${user.username}'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'نقش', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'admin', child: Text('مدیر اصلی')),
                    DropdownMenuItem(value: 'manager', child: Text('مدیر/کارشناس')),
                    DropdownMenuItem(value: 'professor', child: Text('استاد')),
                    DropdownMenuItem(value: 'student', child: Text('دانشجو')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedRole = v ?? user.role),
                ),
                SwitchListTile(value: active, title: const Text('حساب فعال باشد'), onChanged: (v) => setDialogState(() => active = v)),
              ]),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => active ? lockedUsers.remove(user.username) : lockedUsers.add(user.username));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('ثبت'),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showPersonReportDialog(BuildContext context, _AdminUserAccessItem user) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('گزارش شخص: ${user.name}'),
          content: Text('نام کاربری: ${user.username}\nنقش: ${user.role}\nبخش: ${user.section}\nوضعیت: ${lockedUsers.contains(user.username) ? 'قفل شده' : 'فعال'}\n\nگزارش‌های قابل توسعه: ورود و خروج، پیام‌ها، کلاس‌ها، فعالیت‌ها، دسترسی‌ها و سوابق تغییر.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن'))],
        ),
      ),
    );
  }

  void _showReportDetailDialog(BuildContext context, Map<String, String> item, AppState appState) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(item['title']!),
          content: Text('بخش: ${item['unit']}\nوضعیت: ${item['status']}\n\nکلاس‌ها: ${appState.educationClasses.length}\nاعلان‌ها: ${appState.adminNotifications.length}\nکاربران قفل‌شده: ${lockedUsers.length}\nبخش‌های قفل‌شده: ${lockedSections.length}\n\nدر نسخه عملیاتی، خروجی PDF/Excel و فیلتر تاریخ اضافه می‌شود.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن')), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.download_outlined), label: const Text('خروجی'))],
        ),
      ),
    );
  }
}

class _AdminUserAccessItem {
  final String username;
  final String name;
  final String role;
  final String section;
  final bool active;

  _AdminUserAccessItem({
    required this.username,
    required this.name,
    required this.role,
    required this.section,
    required this.active,
  });
}


String uiLabel(AppLang lang, String key) {
  final bool ar = lang == AppLang.ar;
  final bool en = lang == AppLang.en;
  switch (key) {
    case 'home': return ar ? 'الرئيسية' : (en ? 'Home' : 'خانه');
    case 'classes': return ar ? 'الصفوف' : (en ? 'Classes' : 'کلاس‌ها');
    case 'classSchedule': return ar ? 'جدول الصفوف' : (en ? 'Class Schedule' : 'برنامه درسی و کلاس‌ها');
    case 'managers': return ar ? 'التواصل مع المديرين' : (en ? 'Managers' : 'ارتباط با مدیران');
    case 'more': return ar ? 'المزيد' : (en ? 'More' : 'بیشتر');
    case 'settings': return ar ? 'الإعدادات' : (en ? 'Settings' : 'تنظیمات');
    case 'notifications': return ar ? 'الإشعارات' : (en ? 'Notifications' : 'اعلان‌ها');
    case 'notificationsDesc': return ar ? 'استلام الإشعارات الجديدة' : (en ? 'Receive new notifications' : 'دریافت نوتیفیکیشن‌های جدید');
    case 'darkMode': return ar ? 'الوضع الليلي' : (en ? 'Dark mode' : 'حالت شب');
    case 'darkModeDesc': return ar ? 'تغيير واجهة التطبيق إلى الوضع الداكن' : (en ? 'Switch to dark mode' : 'تغییر تم برنامه به حالت تاریک');
    case 'fontSize': return ar ? 'حجم الخط' : (en ? 'Font size' : 'اندازه فونت');
    case 'reminders': return ar ? 'التذكيرات' : (en ? 'Reminders' : 'یادآوری‌ها');
    case 'remindersDesc': return ar ? 'ضبط تذكيرات الأحداث' : (en ? 'Set reminders for events' : 'تنظیم یادآوری برای رویدادها');
    case 'languageApp': return ar ? 'لغة التطبيق' : (en ? 'App language' : 'زبان برنامه');
    case 'languageDesc': return ar ? 'تغيير لغة واجهة المستخدم' : (en ? 'Change UI language' : 'تغییر زبان رابط کاربری');
    case 'privacy': return ar ? 'الخصوصية' : (en ? 'Privacy' : 'حریم خصوصی');
    case 'privacyDesc': return ar ? 'عرض القوانين والسياسات' : (en ? 'Privacy policy' : 'مشاهده قوانین و مقررات');
    case 'logout': return ar ? 'تسجيل الخروج' : (en ? 'Logout' : 'خروج');
    case 'dashboard': return ar ? 'لوحة التحكم' : (en ? 'Dashboard' : 'داشبورد');
    case 'educationOfficers': return ar ? 'خبراء التعليم' : (en ? 'Education Officers' : 'کارشناسان آموزش');
    case 'newOfficer': return ar ? 'خبير جديد' : (en ? 'New Officer' : 'کارشناس جدید');
    case 'privateChat': return ar ? 'محادثة خاصة' : (en ? 'Private chat' : 'چت خصوصی');
    case 'permissions': return ar ? 'الصلاحيات' : (en ? 'Permissions' : 'دسترسی‌ها');
    case 'services': return ar ? 'الخدمات' : (en ? 'Services' : 'خدمات');
    case 'meetings': return ar ? 'الاجتماعات' : (en ? 'Meetings' : 'جلسات');
    case 'professorDashboard': return ar ? 'لوحة الأستاذ' : (en ? 'Professor Dashboard' : 'داشبورد استاد');
    case 'myClasses': return ar ? 'صفوفي' : (en ? 'My Classes' : 'کلاس‌های من');
    default: return key;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// نسخه کامل و اصلاح شده _HomeScreenState
class _HomeScreenState extends State<HomeScreen> {
  String? activeTopPanel;
  int _selectedBottomNavIndex = 0;

  void togglePanel(String key) {
    setState(() {
      activeTopPanel = key;
    });
  }

  void openUnit(BuildContext context, UnitModel unit) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext _) => UnitScreen(unit: unit),
      ),
    );
  }

  void openSupportChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext _) => const SupportChatScreen(),
      ),
    );
  }

  // ==================== صفحه اصلی (واحدها) ====================

  Widget _buildUnitsPage() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Column(
      children: <Widget>[
        Align(
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            appText(selectedLang, 'units'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: _buildUnitCard(context, units[0])),
                  const SizedBox(width: 12),
                  Expanded(child: _buildUnitCard(context, units[2])),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(child: _buildUnitCard(context, units[1])),
                  const SizedBox(width: 12),
                  Expanded(child: _buildUnitCard(context, units[3])),
                ],
              ),
              const SizedBox(height: 12),
              _buildUnitCard(context, units[4], fullWidth: true),
            ],
          ),
        ),
      ],
    );
  }

  // کارت واحد
  Widget _buildUnitCard(BuildContext context, UnitModel unit, {bool fullWidth = false}) {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String userRole = Provider.of<AppState>(context).userRole;

    final String title = appText(selectedLang, unit.keyName);
    final int unreadCount = getUnreadCountForUnit(unit.keyName);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => openUnit(context, unit),
      child: Container(
        height: fullWidth ? 80 : 90,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green.withOpacity(0.10),
                  child: Icon(unit.icon, size: 20, color: Colors.green),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userRole == 'manager'
                            ? (isRtl ? 'مدیریت این واحد' : 'Manage this unit')
                            : '${appText(selectedLang, 'enter_section')} $title',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
              ],
            ),
            if (unreadCount > 0 && unit.keyName != 'other_services')
              Positioned(
                right: isRtl ? null : 8,
                left: isRtl ? 8 : null,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentClassSchedulePage() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String studentId = appState.userIdentifier == 'admin' ? 's001' : appState.userIdentifier;
    final List<EducationManagedClassModel> classes = appState.getStudentClasses(studentId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          uiLabel(selectedLang, 'classSchedule'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 8),
        Text(
          isRtl
              ? 'برنامه درسی، زمان کلاس‌ها و وضعیت ورود به کلاس‌های شما'
              : 'Your class schedule, class time, and live class access status',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(height: 12),
        if (classes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(isRtl ? 'کلاسی برای شما ثبت نشده است.' : 'No classes have been assigned to you.'),
            ),
          )
        else
          ...classes.map((classItem) {
            final bool canEnter = classItem.status == LiveClassStatus.active;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: canEnter ? Colors.green.withOpacity(0.12) : Colors.blueGrey.withOpacity(0.12),
                  child: Icon(canEnter ? Icons.play_circle_outline : Icons.schedule, color: canEnter ? Colors.green : Colors.blueGrey),
                ),
                title: Text(classItem.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${isRtl ? 'استاد' : 'Professor'}: ${classItem.professorName}\n'
                  '${isRtl ? 'روز' : 'Day'}: ${classItem.weekDay} | '
                  '${classItem.startTime.hour.toString().padLeft(2, '0')}:${classItem.startTime.minute.toString().padLeft(2, '0')} - '
                  '${classItem.endTime.hour.toString().padLeft(2, '0')}:${classItem.endTime.minute.toString().padLeft(2, '0')}\n'
                  '${isRtl ? 'ترم' : 'Semester'}: ${classItem.semester}',
                ),
                isThreeLine: true,
                trailing: ElevatedButton.icon(
                  onPressed: canEnter
                      ? () {
                          appState.setStudentOnlineInClass(
                            classId: classItem.id,
                            studentId: studentId,
                            isOnline: true,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => StudentLiveClassScreen(
                                classId: classItem.id,
                                studentId: studentId,
                              ),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.login, size: 18),
                  label: Text(canEnter ? (isRtl ? 'ورود' : 'Enter') : (isRtl ? 'منتظر شروع' : 'Waiting')),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildStudentClassShortcutSection() {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.withOpacity(0.25)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.school_outlined, color: Colors.white),
        ),
        title: Text(uiLabel(selectedLang, 'classSchedule'), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(isRtl ? 'مشاهده برنامه درسی و زمان کلاس‌ها' : 'View schedule and class times'),
        trailing: Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
        onTap: () => setState(() => _selectedBottomNavIndex = 1),
      ),
    );
  }

  // ==================== صفحه ارتباط با مدیران ====================

  Widget _buildManagersCommunicationPage() {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    final List<Map<String, dynamic>> allManagers = units
        .where((unit) => unit.keyName != 'other_services')
        .map((unit) => ({
              'unitKey': unit.keyName,
              'unitName': appText(selectedLang, unit.keyName),
              'icon': unit.icon,
            }))
        .toList();

    allManagers.insert(0, {
      'unitKey': 'admin_main',
      'unitName': isRtl ? 'مدیر اصلی سیستم' : 'System Admin',
      'icon': Icons.admin_panel_settings_outlined,
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isRtl ? 'ارتباط مستقیم با مدیران واحدها' : 'Direct Communication with Unit Managers',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 8),
        Text(
          isRtl
              ? 'برای ارتباط مستقیم و پیگیری درخواست‌ها با مدیر هر واحد در ارتباط باشید'
              : 'Contact managers directly to follow up your requests',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: allManagers.map((manager) {
              return _ManagerChatCard(
                managerName: manager['unitName'],
                icon: manager['icon'],
                unreadCount: 0,
                onTap: () {
                  _showManagerChatDialog(manager['unitKey'], manager['unitName']);
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildRequestTrackingSection(),
      ],
    );
  }

  // دیالوگ ارسال پیام به مدیر
  void _showManagerChatDialog(String unitKey, String unitName) {
    final TextEditingController messageController = TextEditingController();
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [
          Icon(Icons.chat, color: Colors.green),
          const SizedBox(width: 8),
          Text('${isRtl ? 'ارسال پیام به' : 'Send message to'} $unitName')
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(isRtl
              ? 'پیام شما مستقیماً به مدیر واحد ارسال خواهد شد.'
              : 'Your message will be sent directly to the manager.'),
          const SizedBox(height: 12),
          TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: isRtl ? 'پیام خود را بنویسید...' : 'Write your message...')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isRtl ? 'انصراف' : 'Cancel')),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                final appState = Provider.of<AppState>(context, listen: false);
                appState.addNotificationForRole('manager', AppNotification(
                  title: 'پیام از دانشجو',
                  subtitle: messageController.text.length > 50
                      ? '${messageController.text.substring(0, 50)}...'
                      : messageController.text,
                  unitKey: unitKey,
                  unread: true,
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(isRtl ? 'پیام شما ارسال شد' : 'Message sent'),
                    backgroundColor: Colors.green));
              }
            },
            child: Text(isRtl ? 'ارسال' : 'Send'),
          ),
        ],
      ),
    );
  }

  // بخش پیگیری درخواست
  Widget _buildRequestTrackingSection() {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final TextEditingController trackingController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isRtl ? 'پیگیری درخواست' : 'Track Your Request',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.orange.withOpacity(0.3))),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: trackingController,
                decoration: InputDecoration(
                    hintText: isRtl ? 'شماره پیگیری را وارد کنید...' : 'Enter tracking number...',
                    prefixIcon: const Icon(Icons.search, color: Colors.orange)),
              )),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (trackingController.text.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(isRtl ? 'نتیجه پیگیری' : 'Tracking Result'),
                        content: Column(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.receipt_long, size: 50, color: Colors.green),
                          const SizedBox(height: 12),
                          Text(isRtl
                              ? 'شماره پیگیری: ${trackingController.text}'
                              : 'Tracking Number: ${trackingController.text}'),
                          const SizedBox(height: 8),
                          Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1)),
                              child: Text(isRtl
                                  ? 'درخواست شما در حال بررسی است.'
                                  : 'Your request is being reviewed.')),
                        ]),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(isRtl ? 'بستن' : 'Close'))
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(isRtl ? 'پیگیری' : 'Track'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== صفحه بیشتر (تنظیمات، پروفایل، سایر خدمات) ====================

  Widget _buildMorePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentClassShortcutSection(),
          const SizedBox(height: 16),
          _buildProfileSection(),
          const SizedBox(height: 16),
          _buildSettingsSection(),
          const SizedBox(height: 16),
          _buildOtherServicesSection(),
          const SizedBox(height: 16),
          _buildLogoutSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('پروفایل کاربری', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('سینا سالاری'),
            subtitle: const Text('دانشجوی بین‌الملل'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return StatefulBuilder(
      builder: (context, setState) {
        bool notificationsEnabled = true;
        bool darkModeEnabled = appState.isDarkMode;
        double fontSize = 14.0;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(uiLabel(selectedLang, 'settings'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(uiLabel(selectedLang, 'notifications')),
                subtitle: Text(uiLabel(selectedLang, 'notificationsDesc')),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(isRtl ? 'تنظیمات اعلان ذخیره شد' : 'Notification settings saved')),
                  );
                },
                activeColor: Colors.green,
              ),
              SwitchListTile(
                title: Text(uiLabel(selectedLang, 'darkMode')),
                subtitle: Text(uiLabel(selectedLang, 'darkModeDesc')),
                value: darkModeEnabled,
                onChanged: (value) {
                  setState(() => darkModeEnabled = value);
                  appState.toggleTheme();
                },
                activeColor: Colors.green,
              ),
              ListTile(
                leading: const Icon(Icons.text_fields, color: Colors.blue),
                title: Text(uiLabel(selectedLang, 'fontSize')),
                subtitle: Slider(
                  value: fontSize,
                  min: 12,
                  max: 24,
                  divisions: 6,
                  label: '${fontSize.round()}px',
                  activeColor: Colors.green,
                  onChanged: (value) => setState(() => fontSize = value),
                ),
                trailing: Text('${fontSize.round()}px', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.orange),
                title: Text(uiLabel(selectedLang, 'reminders')),
                subtitle: Text(uiLabel(selectedLang, 'remindersDesc')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showReminderSettingsDialog(),
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.purple),
                title: Text(uiLabel(selectedLang, 'languageApp')),
                subtitle: Text(uiLabel(selectedLang, 'languageDesc')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.teal),
                title: Text(uiLabel(selectedLang, 'privacy')),
                subtitle: Text(uiLabel(selectedLang, 'privacyDesc')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPrivacyDialog(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReminderSettingsDialog() {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isRtl ? 'تنظیمات یادآوری' : 'Reminder Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(title: const Text('یادآوری جلسات'), value: true, onChanged: (v) {}, activeColor: Colors.green),
            SwitchListTile(title: const Text('یادآوری تکالیف'), value: true, onChanged: (v) {}, activeColor: Colors.green),
            SwitchListTile(title: const Text('یادآوری رویدادها'), value: false, onChanged: (v) {}, activeColor: Colors.green),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isRtl ? 'ذخیره' : 'Save'))
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب زبان / Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLang.values.map((lang) => ListTile(
            title: Text(langCode(lang)),
            trailing: appState.selectedLang == lang ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              appState.setLanguage(lang);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showPrivacyDialog() {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isRtl ? 'حریم خصوصی' : 'Privacy Policy'),
        content: Text(isRtl
            ? 'اطلاعات شخصی شما نزد ما محفوظ است و تنها برای مقاصد آموزشی و ارتباطی استفاده می‌شود.'
            : 'Your personal information is safe and is only used for educational purposes.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isRtl ? 'متوجه شدم' : 'Got it'))
        ],
      ),
    );
  }

  Widget _buildOtherServicesSection() {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(appText(selectedLang, 'other_services'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          const Divider(height: 1),
          ...studentOtherServices.take(4).map((service) => ListTile(
            leading: Icon(service.icon, color: service.color),
            title: Text(appText(selectedLang, service.key)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openOtherService(service.key),
          )),
          if (studentOtherServices.length > 4)
            ListTile(
              leading: const Icon(Icons.more_horiz),
              title: Text(isRtl ? 'خدمات بیشتر' : 'More Services'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openOtherService('all'),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: Text(isRtl ? 'خروج از حساب کاربری' : 'Logout', style: const TextStyle(color: Colors.red)),
        trailing: const Icon(Icons.chevron_right, color: Colors.red),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(isRtl ? 'خروج از برنامه' : 'Logout'),
              content: Text(isRtl ? 'آیا از خروج خود اطمینان دارید؟' : 'Are you sure you want to logout?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(isRtl ? 'انصراف' : 'Cancel')),
                ElevatedButton(
                  onPressed: () {
                    appState.logout();
                    Navigator.pop(context);
                  },
                  child: Text(isRtl ? 'خروج' : 'Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openOtherService(String serviceKey) {
    if (serviceKey == 'support') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext _) => const SupportChatScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext _) => OtherServiceScreen(serviceKey: serviceKey),
        ),
      );
    }
  }

  void _showMeetingDialog(BuildContext context) {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final TextEditingController titleCtrl = TextEditingController();
    final TextEditingController dateCtrl = TextEditingController();
    final TextEditingController timeCtrl = TextEditingController();
    String selectedUnit = units.first.keyName;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isRtl ? 'برگزاری جلسه جدید' : 'Schedule New Meeting'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'عنوان جلسه' : 'Meeting Title',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'تاریخ' : 'Date',
                    hintText: isRtl ? '1403/02/15' : '2024/05/15',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeCtrl,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'ساعت' : 'Time',
                    hintText: isRtl ? '14:30' : '14:30',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'واحد مربوطه' : 'Related Unit',
                    border: const OutlineInputBorder(),
                  ),
                  items: units.where((u) => u.keyName != 'other_services').map((UnitModel unit) {
                    return DropdownMenuItem<String>(
                      value: unit.keyName,
                      child: Text(appText(selectedLang, unit.keyName)),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) selectedUnit = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(isRtl ? 'انصراف' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  addNewMeeting(
                    title: titleCtrl.text,
                    date: dateCtrl.text,
                    time: timeCtrl.text,
                    unitKey: selectedUnit,
                  );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRtl ? 'جلسه با موفقیت ثبت شد' : 'Meeting scheduled successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(() {});
                }
              },
              child: Text(isRtl ? 'ثبت جلسه' : 'Schedule'),
            ),
          ],
        );
      },
    );
  }

  // ==================== build اصلی ====================

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String userRole = appState.userRole;

    // تعیین صفحه بر اساس تب انتخاب شده
    Widget body;
    switch (_selectedBottomNavIndex) {
      case 0:
        body = _buildUnitsPage();
        break;
      case 1:
        body = _buildStudentClassSchedulePage();
        break;
      case 2:
        body = _buildManagersCommunicationPage();
        break;
      default:
        body = _buildMorePage();
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: <Widget>[
            HeaderWithInteractiveSidePanel(
              activePanel: activeTopPanel,
              onPanelToggle: togglePanel,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: activeTopPanel == null ? null : () => setState(() => activeTopPanel = null),
              child: body,
            ),
            const SizedBox(height: 70),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (int index) {
            setState(() {
              activeTopPanel = null;
              _selectedBottomNavIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: uiLabel(selectedLang, 'home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.school_outlined),
              activeIcon: const Icon(Icons.school),
              label: uiLabel(selectedLang, 'classes'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.forum_outlined),
              activeIcon: const Icon(Icons.forum),
              label: uiLabel(selectedLang, 'managers'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: uiLabel(selectedLang, 'more'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => openSupportChat(context),
          icon: const Icon(Icons.support_agent_outlined),
          label: Text(appText(selectedLang, 'support')),
        ),
      ),
    );
  }
}
// --- کارت ارتباط با مدیران ---
class _ManagerChatCard extends StatelessWidget {
  final String managerName;
  final IconData icon;
  final int unreadCount;
  final VoidCallback onTap;

  const _ManagerChatCard({
    required this.managerName,
    required this.icon,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                managerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chat_outlined, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

// --- کارت جلسات ---
class _MeetingCard extends StatelessWidget {
  final Meeting meeting;

  const _MeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.event, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  meeting.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (!meeting.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                meeting.date,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                meeting.time,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${isRtl ? 'واحد' : 'Unit'}: ${meeting.unitName}',
            style: TextStyle(fontSize: 11, color: Colors.green.shade600),
          ),
        ],
      ),
    );
  }
}

// --- مدل جلسه ---
class Meeting {
  final String id;
  final String title;
  final String date;
  final String time;
  final String unitKey;
  final String unitName;
  final bool isRead;
  final String createdBy;

  Meeting({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.unitKey,
    required this.unitName,
    this.isRead = false,
    this.createdBy = '',
  });
}

// --- داده‌های موک برای جلسات ---
final List<Meeting> mockMeetings = <Meeting>[
  Meeting(
    id: 'm1',
    title: 'جلسه هماهنگی امور آموزش',
    date: '1403/02/20',
    time: '10:00',
    unitKey: 'education',
    unitName: 'آموزش',
    isRead: false,
    createdBy: 'admin2',
  ),
  Meeting(
    id: 'm2',
    title: 'بررسی وضعیت دانشجویان بین‌الملل',
    date: '1403/02/22',
    time: '14:00',
    unitKey: 'international',
    unitName: 'امور بین‌الملل',
    isRead: false,
    createdBy: 'admin1',
  ),
];

// --- تابع دریافت جلسات برای مدیر ---
List<Meeting> getMeetingsForManager(String managerId) {
  // در حالت واقعی، بر اساس نقش و واحد مدیر فیلتر می‌شود
  return mockMeetings;
}

// --- پیام بین مدیران ---
class InterManagerMessage {
  final String id;
  final String senderUnit;
  final String receiverUnit;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  InterManagerMessage({
    required this.id,
    required this.senderUnit,
    required this.receiverUnit,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

// --- دیتاهای موک برای پیام مدیران ---
final List<InterManagerMessage> mockManagerMessages = <InterManagerMessage>[
  InterManagerMessage(
    id: 'msg1',
    senderUnit: 'education',
    receiverUnit: 'international',
    message: 'سلام. لطفاً مدارک دانشجویان جدید را ارسال کنید.',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
  ),
  InterManagerMessage(
    id: 'msg2',
    senderUnit: 'international',
    receiverUnit: 'education',
    message: 'مدارک دانشجویان ارسال شد. لطفاً بررسی کنید.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
];

// --- صفحه چت بین مدیران ---
class InterManagerChatScreen extends StatefulWidget {
  final String targetUnit;
  final String targetUnitName;

  const InterManagerChatScreen({
    super.key,
    required this.targetUnit,
    required this.targetUnitName,
  });

  @override
  State<InterManagerChatScreen> createState() => _InterManagerChatScreenState();
}

class _InterManagerChatScreenState extends State<InterManagerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<InterManagerMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    final currentUnit = appState.userRole == 'admin' ? 'admin_main' : appState.userIdentifier;

    _messages.addAll(
      mockManagerMessages.where((msg) =>
          (msg.senderUnit == currentUnit && msg.receiverUnit == widget.targetUnit) ||
          (msg.senderUnit == widget.targetUnit && msg.receiverUnit == currentUnit)),
    );
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void _sendMessage() {
    final String text = _messageController.text.trim();
    if (text.isEmpty) return;

    final AppState appState = Provider.of<AppState>(context, listen: false);

    final newMessage = InterManagerMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderUnit: appState.userRole == 'admin' ? 'admin_main' : appState.userIdentifier,
      receiverUnit: widget.targetUnit,
      message: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
      mockManagerMessages.add(newMessage);
      _messageController.clear();
    });

    appState.addNotificationForRole(
      widget.targetUnit == 'admin_main' ? 'admin' : 'manager',
      AppNotification(
        title: widget.targetUnit == 'admin_main' ? 'پیام جدید برای مدیر اصلی' : 'پیام جدید مدیر اصلی یا واحد',
        subtitle: text.length > 60 ? '${text.substring(0, 60)}...' : text,
        unitKey: widget.targetUnit,
        unread: true,
      ),
    );

    // در حالت واقعی، اینجا پیام به سرور ارسال می‌شود
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String currentUnit = appState.userIdentifier;
    final String currentUnitName = appText(selectedLang, currentUnit);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.targetUnitName} - ${isRtl ? 'گفتگو' : 'Chat'}'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            // هدر چت
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.blue.withOpacity(0.1),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.business, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.targetUnitName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isRtl ? 'مدیر واحد' : 'Unit Manager',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // لیست پیام‌ها
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final bool isMe = msg.senderUnit == currentUnit;

                  return Align(
                    alignment: isMe
                        ? (isRtl ? Alignment.centerRight : Alignment.centerLeft)
                        : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.green.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            msg.message,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(msg.timestamp),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // ورودی پیام
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: isRtl ? 'پیام خود را بنویسید...' : 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inHours < 24) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(time).inDays < 7) {
      return '${now.difference(time).inDays} روز پیش';
    } else {
      return '${time.month}/${time.day}';
    }
  }
}

// --- کارت خدمات دیگر ---
class _OtherServiceCard extends StatelessWidget {
  final OtherService service;
  final VoidCallback onTap;

  const _OtherServiceCard({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface
              .withOpacity(dark ? 0.88 : 0.96),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.22 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: service.color.withOpacity(dark ? 0.22 : 0.12),
              ),
              child: Icon(service.icon, size: 23, color: service.color),
            ),
            const SizedBox(height: 8),
            Text(
              appText(Provider.of<AppState>(context, listen: false).selectedLang, service.key),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- توابع کمکی برای اعلان‌های مدیران ---
int getManagerUnreadCount(String unitKey) {
  // در حالت واقعی، شمارش پیام‌های نخوانده از دیتابیس
  return mockManagerMessages
      .where((msg) => msg.receiverUnit == unitKey && !msg.isRead)
      .length;
}

void addNewMeeting({
  required String title,
  required String date,
  required String time,
  required String unitKey,
}) {
   if (globalContext == null) return;
  final AppState appState = Provider.of<AppState>(globalContext!, listen: false);
  final String currentUnit = appState.userIdentifier;
  final String currentUnitName = appText(AppLang.fa, currentUnit);

  mockMeetings.add(
    Meeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: date,
      time: time,
      unitKey: unitKey,
      unitName: appText(AppLang.fa, unitKey),
      isRead: false,
      createdBy: currentUnit,
    ),
  );

  // ارسال اعلان به مدیر واحد مربوطه
  _sendNotificationToManager(unitKey, title, date, time);
}

void _sendNotificationToManager(String unitKey, String title, String date, String time) {
  if (globalContext == null) return;
  
  
  final appState = Provider.of<AppState>(globalContext!, listen: false);
  final notification = AppNotification(
    title: 'جلسه جدید: $title',
    subtitle: 'تاریخ: $date - ساعت: $time',
    unitKey: unitKey,
    unread: true,
  );
  appState.addNotificationForRole('manager', notification);
  debugPrint('Notification sent to $unitKey: Meeting "$title" on $date at $time');
}
// --- Other Services Data ---

class OtherService {
  final String key;
  final IconData icon;
  final Color color;

  OtherService({
    required this.key,
    required this.icon,
    this.color = Colors.blue,
  });
}

final List<OtherService> studentOtherServices = <OtherService>[
  OtherService(key: 'money_exchange', icon: Icons.currency_exchange, color: Colors.green),
  OtherService(key: 'hotel', icon: Icons.hotel, color: Colors.indigo),
  OtherService(key: 'taxi', icon: Icons.local_taxi, color: Colors.orange),
  OtherService(key: 'translation', icon: Icons.translate, color: Colors.purple),
  OtherService(key: 'flight_ticket', icon: Icons.flight_takeoff, color: Colors.blue),
  OtherService(key: 'training_courses', icon: Icons.menu_book, color: Colors.teal),
  OtherService(key: 'printing', icon: Icons.print, color: Colors.grey),
  OtherService(key: 'welfare', icon: Icons.volunteer_activism, color: Colors.pink),
];

final List<OtherService> staffOtherServices = <OtherService>[
  OtherService(key: 'translation', icon: Icons.translate, color: Colors.purple),
  OtherService(key: 'printing', icon: Icons.print, color: Colors.grey),
  OtherService(key: 'welfare', icon: Icons.volunteer_activism, color: Colors.pink),
];

final List<OtherService> otherServices = studentOtherServices;

// --- Header (Modified to handle panel height) ---
class HeaderWithInteractiveSidePanel extends StatelessWidget {
  final String? activePanel;
  final void Function(String key) onPanelToggle;

  const HeaderWithInteractiveSidePanel({
    super.key,
    required this.activePanel,
    required this.onPanelToggle,
  });

  static const double _iconSize = 42;
  static const double _gap = 10;
  static const double _topStart = 8;
  static const double _firstTop = _topStart;
  static const double _secondTop = _firstTop + _iconSize + _gap;
  static const double _thirdTop = _secondTop + _iconSize + _gap;
  static const double _fourthTop = _thirdTop + _iconSize + _gap;
  static const double _headerBaseHeight = 210;
  static const double _panelMaxHeightFactor = 0.55;

  Widget _buildGradientBackground(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? <Color>[const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : <Color>[Colors.green.shade700, Colors.green.shade500],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final bool isDarkMode = appState.isDarkMode;

    double panelTopOffset = 0;

    if (activePanel == 'profile') {
      panelTopOffset = _firstTop;
    } else if (activePanel == 'language') {
      panelTopOffset = _secondTop;
    } else if (activePanel == 'notifications') {
      panelTopOffset = _fourthTop;
    }

    double expandedHeight = _headerBaseHeight;

    final int currentNotificationCount = appState.getCurrentRoleNotifications().length;
    if (activePanel == 'notifications' && currentNotificationCount > 3) {
      final double screenHeight = MediaQuery.of(context).size.height;
      final double panelMaxVisualHeight = screenHeight * _panelMaxHeightFactor;
      final double requiredTotalHeight = panelTopOffset + panelMaxVisualHeight + _gap;

      if (requiredTotalHeight > _headerBaseHeight) {
        expandedHeight = requiredTotalHeight;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: expandedHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _headerBaseHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.green.withOpacity(0.20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(
                        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return _buildGradientBackground(isDarkMode);
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.5)
                            : Colors.black.withOpacity(0.3),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: _HeaderCenterTexts(),
                    ),
                    Positioned(
                      top: _topStart,
                      right: isRtl ? 16 : null,
                      left: isRtl ? null : 16,
                      child: Column(
                        children: <Widget>[
                          _HeaderActionIcon(
                            icon: Icons.person_outline,
                            isActive: activePanel == 'profile',
                            onTap: () => onPanelToggle('profile'),
                          ),
                          const SizedBox(height: _gap),
                          _HeaderActionIcon(
                            icon: Icons.language,
                            isActive: activePanel == 'language',
                            onTap: () => onPanelToggle('language'),
                          ),
                          const SizedBox(height: _gap),
                          _HeaderActionIcon(
                            icon: isDarkMode
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            isActive: false,
                            onTap: appState.toggleTheme,
                          ),
                          const SizedBox(height: _gap),
                          _HeaderActionIcon(
                            icon: Icons.notifications_none,
                            isActive: activePanel == 'notifications',
                            showBlinkDot: appNotifications.any(
                              (AppNotification item) => item.unread,
                            ),
                            onTap: () => onPanelToggle('notifications'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (activePanel != null)
            Positioned(
              top: panelTopOffset,
              right: isRtl ? 66 : null,
              left: isRtl ? null : 66,
              child: _FloatingHeaderPanel(
                panelType: activePanel!,
                onOpenUnit: (String unitKey) {
                  final UnitModel unit = units.firstWhere(
                    (UnitModel item) => item.keyName == unitKey,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext _) => UnitScreen(unit: unit),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderActionIcon extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool showBlinkDot;

  const _HeaderActionIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.showBlinkDot = false,
  });

  @override
  State<_HeaderActionIcon> createState() => _HeaderActionIconState();
}

class _HeaderActionIconState extends State<_HeaderActionIcon>
    with SingleTickerProviderStateMixin {
  bool hovering = false;
  late AnimationController blinkController;

  @override
  void initState() {
    super.initState();

    blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent _) => setState(() => hovering = true),
      onExit: (PointerEvent _) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: widget.isActive || hovering
                    ? Colors.green.withOpacity(0.12)
                    : Theme.of(context).colorScheme.surface.withOpacity(0.85),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(widget.icon, color: Colors.black87, size: 20),
            ),
            if (widget.showBlinkDot)
              Positioned(
                top: 2,
                right: 2,
                child: FadeTransition(
                  opacity: blinkController,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FloatingHeaderPanel extends StatelessWidget {
  final void Function(String unitKey) onOpenUnit;
  final String panelType;

  const _FloatingHeaderPanel({
    required this.panelType,
    required this.onOpenUnit,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String userRole = appState.userRole;
    final String userUnitKey = appState.userIdentifier;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double width = panelType == 'language'
        ? screenWidth.clamp(220, 260).toDouble()
        : (screenWidth - 96).clamp(260, 340).toDouble();

    Widget content;

    if (panelType == 'profile') {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'سینا سالاری',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            userRole == 'manager'
                ? '${isRtl ? 'مدیر بخش' : 'Manager'} ${appText(selectedLang, userUnitKey)}'
                : (userRole == 'professor'
                    ? tr(selectedLang, 'professor')
                    : (isRtl ? 'دانشجو' : 'Student')),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text('P987654321', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          const Text('40254142', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext _) => const ProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(isRtl ? 'پروفایل' : 'Profile'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: appState.logout,
              icon: const Icon(Icons.logout, size: 18),
              label: Text(isRtl ? 'خروج' : 'Logout'),
            ),
          ),
        ],
      );
    } else if (panelType == 'language') {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tr(selectedLang, 'language'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppLang.values.map<Widget>((AppLang lang) {
              return ChoiceChip(
                label: Text(langCode(lang)),
                selected: selectedLang == lang,
                onSelected: (bool _) => appState.setLanguage(lang),
              );
            }).toList(),
          ),
        ],
      );
    } else {
      // Notifications Panel - نسخه اصلاح شده
      final notifications = appState.getCurrentRoleNotifications();
      final unreadCount = notifications.where((n) => n.unread).length;
      
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            appText(selectedLang, 'notifications'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            '$unreadCount ${appText(selectedLang, 'unread')}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          if (notifications.length <= 3)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: notifications.map<Widget>((AppNotification item) {
                return _HeaderNotificationTile(
                  item: item,
                  isRtl: isRtl,
                  onTap: () => onOpenUnit(item.unitKey),
                );
              }).toList(),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.55,
                minWidth: 240,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: notifications.map<Widget>((AppNotification item) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onOpenUnit(item.unitKey),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.unread
                            ? Colors.red.withOpacity(0.06)
                            : Theme.of(context).colorScheme.surface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: item.unread
                              ? Colors.red.withOpacity(0.25)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          if (item.unread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (item.unread) const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.title,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.subtitle,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isRtl ? Icons.chevron_left : Icons.chevron_right,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    }
    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.94 : 0.97,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}


class _HeaderNotificationTile extends StatelessWidget {
  final AppNotification item;
  final bool isRtl;
  final VoidCallback onTap;

  const _HeaderNotificationTile({
    required this.item,
    required this.isRtl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.unread
              ? Colors.red.withOpacity(0.06)
              : Theme.of(context).colorScheme.surface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.unread ? Colors.red.withOpacity(0.25) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: <Widget>[
            if (item.unread)
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
            if (item.unread) const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.title, textAlign: TextAlign.start, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 3),
                  Text(item.subtitle, textAlign: TextAlign.start, style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(isRtl ? Icons.chevron_left : Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }
}

class _HeaderCenterTexts extends StatelessWidget {
  const _HeaderCenterTexts();

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const Icon(
                    Icons.account_balance_outlined,
                    size: 40,
                    color: Colors.green,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            appText(selectedLang, 'university_app'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            appText(selectedLang, 'university_subtitle'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Unit Screen ---

const double kTabletBreakpoint = 800.0;

class MessageModel {
  final String text;
  final bool isUser;

  MessageModel(this.text, this.isUser);
}

class ConversationMock {
  final String titleKey;
  final String trackingCode;
  final String timeFa;
  final String timeEn;
  final String timeAr;
  final IconData icon;
  final int unread;

  ConversationMock({
    required this.titleKey,
    required this.trackingCode,
    required this.timeFa,
    required this.timeEn,
    required this.timeAr,
    required this.icon,
    this.unread = 0,
  });
}

class QuickTopicMock {
  final String titleKey;
  final String subtitleKey;
  final IconData icon;

  QuickTopicMock({
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
  });
}

final List<ConversationMock> mockConversations = <ConversationMock>[
  ConversationMock(
    titleKey: 'conv_certificate',
    trackingCode: 'ED-1403-000145',
    timeFa: '10:30',
    timeEn: '10:30',
    timeAr: '10:30',
    icon: Icons.school,
    unread: 2,
  ),
  ConversationMock(
    titleKey: 'conv_lms',
    trackingCode: 'ED-1403-000142',
    timeFa: 'دیروز',
    timeEn: 'Yesterday',
    timeAr: 'أمس',
    icon: Icons.laptop_mac,
    unread: 1,
  ),
  ConversationMock(
    titleKey: 'conv_transcript',
    trackingCode: 'ED-1403-000139',
    timeFa: '3 روز پیش',
    timeEn: '3 days ago',
    timeAr: 'قبل 3 أيام',
    icon: Icons.receipt_long,
  ),
  ConversationMock(
    titleKey: 'conv_extension',
    trackingCode: 'ED-1403-000136',
    timeFa: '5 روز پیش',
    timeEn: '5 days ago',
    timeAr: 'قبل 5 أيام',
    icon: Icons.description,
  ),
];

final List<QuickTopicMock> quickTopics = <QuickTopicMock>[
  QuickTopicMock(
    titleKey: 'topic_certificate',
    subtitleKey: 'topic_certificate_sub',
    icon: Icons.school,
  ),
  QuickTopicMock(
    titleKey: 'topic_transcript',
    subtitleKey: 'topic_transcript_sub',
    icon: Icons.receipt_long,
  ),
  QuickTopicMock(
    titleKey: 'topic_lms',
    subtitleKey: 'topic_lms_sub',
    icon: Icons.laptop_mac,
  ),
  QuickTopicMock(
    titleKey: 'topic_new_request',
    subtitleKey: 'topic_new_request_sub',
    icon: Icons.add_task,
  ),
];

class UnitScreen extends StatefulWidget {
  final UnitModel unit;

  const UnitScreen({super.key, required this.unit});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen>
    with SingleTickerProviderStateMixin {
  int selectedConversation = 0;
  final TextEditingController inputController = TextEditingController();
  late TabController _tabController;
  late List<MessageModel> messages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;

    messages = <MessageModel>[
      MessageModel(appText(selectedLang, 'welcome_message'), false),
      MessageModel(appText(selectedLang, 'sample_user_message'), true),
      MessageModel(appText(selectedLang, 'sample_staff_message'), false),
    ];
  }

  @override
  void dispose() {
    inputController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void addQuickTopic(QuickTopicMock topic) {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final String title = appText(selectedLang, topic.titleKey);

    setState(() {
      messages.add(
        MessageModel(
          '${appText(selectedLang, 'request_about')}: $title',
          true,
        ),
      );
      messages.add(
        MessageModel(appText(selectedLang, 'request_registered'), false),
      );
    });
  }

  void sendMessage() {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final String text = inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(MessageModel(text, true));
      messages.add(
        MessageModel(appText(selectedLang, 'message_received'), false),
      );
    });

    inputController.clear();
  }

  void openOtherService(String serviceKey) {
    if (serviceKey == 'support') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext _) => const SupportChatScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext _) => OtherServiceScreen(
            serviceKey: serviceKey,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    final String title = appText(selectedLang, widget.unit.keyName);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth >= kTabletBreakpoint;

    if (widget.unit.keyName == 'other_services') {
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(title: Text(title), centerTitle: true),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.16),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.green.withOpacity(0.12),
                      child: const Icon(Icons.apps, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appText(selectedLang, 'other_services'),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.14),
                  ),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherServices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLargeScreen ? 5 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: isLargeScreen ? 1.15 : 0.92,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final OtherService service = otherServices[index];
                    return otherServiceCard(service);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext _) => const SupportChatScreen(),
                ),
              );
            },
            icon: const Icon(Icons.support_agent_outlined),
            label: Text(appText(selectedLang, 'support')),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          bottom: !isLargeScreen
              ? TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: <Tab>[
                    Tab(text: appText(selectedLang, 'my_conversations')),
                    Tab(text: appText(selectedLang, 'support')),
                    Tab(text: appText(selectedLang, 'quick_access')),
                  ],
                )
              : null,
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: isLargeScreen
              ? Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: isRtl
                            ? const EdgeInsets.fromLTRB(0, 12, 12, 12)
                            : const EdgeInsets.fromLTRB(12, 12, 0, 12),
                        child: _ConversationSidebar(
                          conversations: mockConversations,
                          selectedIndex: selectedConversation,
                          onSelect: (int index) {
                            setState(() {
                              selectedConversation = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: _ChatCenterPanel(
                          unit: widget.unit,
                          conversation: mockConversations[selectedConversation],
                          messages: messages,
                          controller: inputController,
                          onSend: sendMessage,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: isRtl
                            ? const EdgeInsets.fromLTRB(12, 12, 0, 12)
                            : const EdgeInsets.fromLTRB(0, 12, 12, 12),
                        child: _QuickAccessPanel(
                          unit: widget.unit,
                          topics: quickTopics,
                          onTopicTap: addQuickTopic,
                        ),
                      ),
                    ),
                  ],
                )
              : TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    _ConversationSidebar(
                      conversations: mockConversations,
                      selectedIndex: selectedConversation,
                      onSelect: (int index) {
                        setState(() {
                          selectedConversation = index;
                        });
                      },
                    ),
                    const SupportChatScreen(),
                    _QuickAccessPanel(
                      unit: widget.unit,
                      topics: quickTopics,
                      onTopicTap: addQuickTopic,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget otherServiceCard(OtherService service) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => openOtherService(service.key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface
              .withOpacity(dark ? 0.88 : 0.96),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.22 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: service.color.withOpacity(dark ? 0.22 : 0.12),
              ),
              child: Icon(service.icon, size: 23, color: service.color),
            ),
            const SizedBox(height: 8),
            Text(
              appText(selectedLang, service.key),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationSidebar extends StatelessWidget {
  final List<ConversationMock> conversations;
  final int selectedIndex;
  final void Function(int index) onSelect;

  const _ConversationSidebar({
    required this.conversations,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    String timeText(ConversationMock item) {
      switch (selectedLang) {
        case AppLang.fa:
          return item.timeFa;
        case AppLang.en:
          return item.timeEn;
        case AppLang.ar:
          return item.timeAr;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: <Widget>[
          Text(
            appText(selectedLang, 'my_conversations'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 14),
          TextField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: appText(selectedLang, 'search_conversations'),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.filter_list),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: Text(appText(selectedLang, 'new_conversation')),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (BuildContext context, int index) {
                final ConversationMock item = conversations[index];
                final bool selected = selectedIndex == index;

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onSelect(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.green.withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? Colors.green : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.green.withOpacity(0.12),
                          child: Icon(item.icon, color: Colors.green),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                appText(selectedLang, item.titleKey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${appText(selectedLang, 'tracking')}: ${item.trackingCode}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: <Widget>[
                            Text(
                              timeText(item),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (item.unread > 0) ...<Widget>[
                              const SizedBox(height: 8),
                              CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.green.shade300,
                                child: Text(
                                  '${item.unread}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatCenterPanel extends StatelessWidget {
  final UnitModel unit;
  final ConversationMock conversation;
  final List<MessageModel> messages;
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatCenterPanel({
    required this.unit,
    required this.conversation,
    required this.messages,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appText(selectedLang, conversation.titleKey),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${appText(selectedLang, 'tracking')}: ${conversation.trackingCode}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final MessageModel msg = messages[index];

                return Align(
                  alignment: msg.isUser
                      ? (isRtl ? Alignment.centerRight : Alignment.centerLeft)
                      : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (!msg.isUser)
                        CircleAvatar(
                          backgroundColor: Colors.green.withOpacity(0.12),
                          child: Icon(unit.icon, color: Colors.green),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 520),
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: msg.isUser
                              ? Theme.of(context).colorScheme.surface
                              : Colors.green.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          msg.text,
                          textAlign: TextAlign.start,
                          style: const TextStyle(height: 1.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (msg.isUser)
                        CircleAvatar(
                          backgroundColor: Colors.green.withOpacity(0.12),
                          child: const Icon(Icons.person_outline),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: appText(selectedLang, 'write_message'),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.55),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file),
                ),
                const SizedBox(width: 10),
                FilledButton(onPressed: onSend, child: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessPanel extends StatelessWidget {
  final UnitModel unit;
  final List<QuickTopicMock> topics;
  final void Function(QuickTopicMock topic) onTopicTap;

  const _QuickAccessPanel({
    required this.unit,
    required this.topics,
    required this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.settings_outlined),
              const SizedBox(width: 8),
              Text(
                appText(selectedLang, 'quick_access'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              appText(selectedLang, 'common_items'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ...topics.map<Widget>((QuickTopicMock topic) {
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onTopicTap(topic),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.10),
                      child: Icon(topic.icon, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            appText(selectedLang, topic.titleKey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appText(selectedLang, topic.subtitleKey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
                  ],
                ),
              ),
            );
          }).toList(),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.12),
                      child: Icon(unit.icon, color: Colors.green),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        appText(selectedLang, 'unit_info'),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  appText(selectedLang, unit.keyName),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 6),
                Text(
                  appText(selectedLang, 'response_hours'),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(appText(selectedLang, 'contact_unit')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Support Chat Screen ---

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> chatMessages = [];  // ← تغییر از messages به chatMessages
  bool isTyping = false;
  late AnimationController typingController;

  @override
  void initState() {
    super.initState();

    typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;

    chatMessages.add(  // ← تغییر از messages به chatMessages
      ChatMessage(
        text: appText(selectedLang, 'support_chat_welcome'),
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    typingController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final String text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      chatMessages.add(ChatMessage(text: text, isUser: true));  // ← تغییر
      controller.clear();
      isTyping = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final String aiResponse = generateAIResponse(text, selectedLang);

    setState(() {
      isTyping = false;
      chatMessages.add(ChatMessage(text: aiResponse, isUser: false));  // ← تغییر
    });
  }

  String generateAIResponse(String userMessage, AppLang selectedLang) {
    final String lowerMsg = userMessage.toLowerCase();

    if (lowerMsg.contains('گواهی') ||
        lowerMsg.contains('certificate') ||
        lowerMsg.contains('شهادة')) {
      return appText(selectedLang, 'support_chat_certificate_response');
    }

    if (lowerMsg.contains('خوابگاه') ||
        lowerMsg.contains('dormitory') ||
        lowerMsg.contains('سكن')) {
      return appText(selectedLang, 'support_chat_dormitory_response');
    }

    if (lowerMsg.contains('ویزا') ||
        lowerMsg.contains('visa') ||
        lowerMsg.contains('تأشيرة')) {
      return appText(selectedLang, 'support_chat_visa_response');
    }

    if (lowerMsg.contains('نمره') ||
        lowerMsg.contains('grade') ||
        lowerMsg.contains('درجة')) {
      return appText(selectedLang, 'support_chat_grade_response');
    }

    if (lowerMsg.contains('سلام') ||
        lowerMsg.contains('hello') ||
        lowerMsg.contains('مرحبا')) {
      return appText(selectedLang, 'support_chat_greeting_response');
    }

    if (lowerMsg.contains('ممنون') ||
        lowerMsg.contains('thank') ||
        lowerMsg.contains('شكرا')) {
      return appText(selectedLang, 'support_chat_thanks_response');
    }

    return appText(selectedLang, 'support_chat_unclear_response');
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.support_agent_outlined, color: Colors.green),
              const SizedBox(width: 8),
              Text(appText(selectedLang, 'support')),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chatMessages.length + (isTyping ? 1 : 0),  // ← تغییر
                  itemBuilder: (BuildContext context, int index) {
                    if (isTyping && index == chatMessages.length) {  // ← تغییر
                      return _TypingIndicator(controller: typingController);
                    }

                    final ChatMessage msg = chatMessages[index];  // ← تغییر

                    return Align(
                      alignment: msg.isUser
                          ? (isRtl ? Alignment.centerRight : Alignment.centerLeft)
                          : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (!msg.isUser)
                            CircleAvatar(
                              backgroundColor: Colors.green.withOpacity(0.15),
                              child: const Icon(
                                Icons.support_agent_outlined,
                                color: Colors.green,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? Theme.of(context).colorScheme.surface.withOpacity(0.9)
                                  : Colors.green.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              msg.text,
                              textAlign: TextAlign.start,
                              style: const TextStyle(height: 1.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (msg.isUser)
                            CircleAvatar(
                              backgroundColor: Colors.green.withOpacity(0.12),
                              child: const Icon(Icons.person_outline),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          hintText: isRtl
                              ? 'پیام خود را بنویسید...'
                              : 'Write your message...',
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.55),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (String _) => sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: sendMessage,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final AnimationController controller;

  const _TypingIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.15),
            child: const Icon(
              Icons.support_agent_outlined,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: List<Widget>.generate(3, (int index) {
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.3, end: 1.0).animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: Interval(
                        index * 0.2,
                        0.6 + index * 0.2,
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Other Service Screen ---

class OtherServiceScreen extends StatelessWidget {
  final String serviceKey;

  const OtherServiceScreen({
    super.key,
    required this.serviceKey,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    final String title = appText(selectedLang, serviceKey);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.12),
                      ),
                      child: Icon(
                        _getServiceIcon(serviceKey),
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isRtl
                          ? 'این بخش به زودی فعال خواهد شد'
                          : 'This section will be available soon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: Text(isRtl ? 'بازگشت' : 'Back'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon(String key) {
    switch (key) {
      case 'money_exchange':
        return Icons.currency_exchange;
      case 'hotel':
        return Icons.hotel;
      case 'flight_ticket':
        return Icons.flight_takeoff;
      case 'training_courses':
        return Icons.menu_book;
      case 'welfare':
        return Icons.volunteer_activism;
      case 'taxi':
        return Icons.local_taxi;
      case 'translation':
        return Icons.translate;
      case 'insurance':
        return Icons.health_and_safety;
      case 'bank':
        return Icons.account_balance;
      case 'restaurant':
        return Icons.restaurant;
      case 'gym':
        return Icons.fitness_center;
      case 'library':
        return Icons.library_books;
      case 'printing':
        return Icons.print;
      default:
        return Icons.apps;
    }
  }
}

// --- Profile Screen ---

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController nationalityCtrl;
  late TextEditingController majorCtrl;
  late TextEditingController entryYearCtrl;
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    nameCtrl = TextEditingController(text: 'سینا سالاری');
    emailCtrl = TextEditingController(text: 'sina.salari@stu.araku.ac.ir');
    phoneCtrl = TextEditingController(text: '+98 912 345 6789');
    nationalityCtrl = TextEditingController(text: isRtl ? 'ایرانی' : 'Iranian');
    majorCtrl = TextEditingController(
      text: isRtl ? 'مهندسی کامپیوتر' : 'Computer Engineering',
    );
    entryYearCtrl = TextEditingController(text: '1401');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    nationalityCtrl.dispose();
    majorCtrl.dispose();
    entryYearCtrl.dispose();
    super.dispose();
  }

  Widget _buildField({
    required String label,
    required TextEditingController ctrl,
    required IconData icon,
    bool readOnly = false,
    String? note,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (note != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                note,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 11, color: Colors.orange.shade700),
              ),
            ),
          TextField(
            controller: ctrl,
            enabled: editMode && !readOnly,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(
                icon,
                color: readOnly ? Colors.grey : Colors.green,
              ),
              filled: true,
              fillColor: readOnly
                  ? Colors.grey.shade50
                  : (editMode ? Theme.of(context).colorScheme.surface : Colors.grey.shade100),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              suffixIcon: readOnly
                  ? Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.grey.shade400,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String userRole = appState.userRole;
    final String userIdentifier = appState.userIdentifier;

    final String readOnlyNote = isRtl
        ? '🔒 فقط توسط مدیر سیستم قابل تغییر است'
        : '🔒 Editable by system admin only';

    String displayRole = '';
    if (userRole == 'manager') {
      displayRole = '${isRtl ? 'مدیر' : 'Manager'} — ${appText(selectedLang, userIdentifier)}';
    } else if (userRole == 'professor') {
      final ProfessorModel? professor = mockProfessors.firstWhereOrNull((ProfessorModel p) => p.id == userIdentifier);
      displayRole = professor?.name ?? tr(selectedLang, 'professor');
    } else {
      displayRole = (isRtl ? 'دانشجوی بین‌الملل' : 'International Student');
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isRtl ? 'پروفایل کاربر' : 'User Profile'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  editMode = !editMode;
                });
              },
              icon: Icon(editMode ? Icons.close : Icons.edit_outlined),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 560),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.green.withOpacity(0.12),
                      child: const Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      nameCtrl.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayRole,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildField(
                      label: isRtl ? 'نام و نام خانوادگی' : 'Full Name',
                      ctrl: nameCtrl,
                      icon: Icons.person_outline,
                    ),
                    _buildField(
                      label: isRtl ? 'ایمیل دانشگاهی' : 'University Email',
                      ctrl: emailCtrl,
                      icon: Icons.email_outlined,
                    ),
                    _buildField(
                      label: isRtl ? 'شماره تماس' : 'Phone Number',
                      ctrl: phoneCtrl,
                      icon: Icons.phone_outlined,
                    ),
                    _buildField(
                      label: isRtl ? 'ملیت' : 'Nationality',
                      ctrl: nationalityCtrl,
                      icon: Icons.flag_outlined,
                    ),
                    _buildField(
                      label: isRtl ? 'رشته تحصیلی' : 'Major',
                      ctrl: majorCtrl,
                      icon: Icons.school_outlined,
                    ),
                    _buildField(
                      label: isRtl ? 'سال ورود' : 'Entry Year',
                      ctrl: entryYearCtrl,
                      icon: Icons.calendar_today_outlined,
                    ),
                    _buildField(
                      label: isRtl ? 'شماره دانشجویی' : 'Student ID',
                      ctrl: TextEditingController(text: '40254142'),
                      icon: Icons.badge_outlined,
                      readOnly: true,
                      note: readOnlyNote,
                    ),
                    _buildField(
                      label: isRtl ? 'شماره پاسپورت' : 'Passport Number',
                      ctrl: TextEditingController(text: 'P987654321'),
                      icon: Icons.account_box_outlined,
                      readOnly: true,
                      note: readOnlyNote,
                    ),
                    if (editMode) ...<Widget>[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() => editMode = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isRtl
                                      ? 'اطلاعات با موفقیت ذخیره شد'
                                      : 'Profile saved successfully',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.save_outlined),
                          label: Text(isRtl ? 'ذخیره تغییرات' : 'Save Changes'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension _ListWhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final E element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

// --- Professor Screens ---
// --- صفحه اصلی استادان ---
class ProfessorHomeScreen extends StatefulWidget {
  final String professorId;

  const ProfessorHomeScreen({
    super.key,
    required this.professorId,
  });

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  String? activeTopPanel;
  int _selectedBottomNavIndex = 0;

  void togglePanel(String key) {
    setState(() {
      activeTopPanel = key;
    });
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String statusText(LiveClassStatus status, AppLang lang) {
    final bool ar = lang == AppLang.ar;
    final bool en = lang == AppLang.en;
    switch (status) {
      case LiveClassStatus.scheduled:
        return ar ? 'مجدول' : (en ? 'Scheduled' : 'زمان‌بندی شده');
      case LiveClassStatus.waitingForProfessor:
        return ar ? 'بانتظار الأستاذ' : (en ? 'Waiting for professor' : 'در انتظار استاد');
      case LiveClassStatus.active:
        return ar ? 'نشط' : (en ? 'Active' : 'در حال برگزاری');
      case LiveClassStatus.finished:
        return ar ? 'منتهٍ' : (en ? 'Finished' : 'پایان‌یافته');
      case LiveClassStatus.cancelled:
        return ar ? 'ملغى' : (en ? 'Cancelled' : 'لغو شده');
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

  ProfessorModel? findProfessor() {
    try {
      return mockProfessors.firstWhere((p) => p.id == widget.professorId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang lang = appState.selectedLang;
    final bool isRtl = isRtlLang(lang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: <Widget>[
            HeaderWithInteractiveSidePanel(
              activePanel: activeTopPanel,
              onPanelToggle: togglePanel,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: activeTopPanel == null ? null : () => setState(() => activeTopPanel = null),
              child: _buildBody(appState, lang),
            ),
            const SizedBox(height: 70),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (int index) {
            setState(() {
              activeTopPanel = null;
              _selectedBottomNavIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: const Icon(Icons.dashboard_outlined), activeIcon: const Icon(Icons.dashboard), label: uiLabel(lang, 'dashboard')),
            BottomNavigationBarItem(icon: const Icon(Icons.school_outlined), activeIcon: const Icon(Icons.school), label: uiLabel(lang, 'classes')),
            BottomNavigationBarItem(icon: const Icon(Icons.forum_outlined), activeIcon: const Icon(Icons.forum), label: uiLabel(lang, 'managers')),
            BottomNavigationBarItem(icon: const Icon(Icons.notifications_outlined), activeIcon: const Icon(Icons.notifications), label: uiLabel(lang, 'notifications')),
            BottomNavigationBarItem(icon: const Icon(Icons.more_horiz), activeIcon: const Icon(Icons.more), label: uiLabel(lang, 'more')),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppState appState, AppLang lang) {
    switch (_selectedBottomNavIndex) {
      case 0:
        return _buildDashboard(appState, lang);
      case 1:
        return _buildClassesPage(appState, lang);
      case 2:
        return _buildManagersChatPage(appState, lang);
      case 3:
        return _buildNotificationsPage(appState, lang);
      default:
        return _buildMorePage(appState, lang);
    }
  }

  Widget _buildDashboard(AppState appState, AppLang lang) {
    final ProfessorModel? professor = findProfessor();
    final List<EducationManagedClassModel> professorClasses = appState.getProfessorClasses(widget.professorId);
    final int activeCount = professorClasses.where((c) => c.status == LiveClassStatus.active || c.status == LiveClassStatus.scheduled || c.status == LiveClassStatus.waitingForProfessor).length;
    final int finishedCount = professorClasses.where((c) => c.status == LiveClassStatus.finished || c.status == LiveClassStatus.cancelled).length;
    final int unreadCount = appState.professorNotifications.where((n) => n.unread).length;
    final bool isRtl = isRtlLang(lang);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade500]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.green.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: <Widget>[
              const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.green, size: 34)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(uiLabel(lang, 'professorDashboard'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21)),
                    const SizedBox(height: 6),
                    Text(professor?.name ?? widget.professorId, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            _buildProfessorStatCard(title: uiLabel(lang, 'myClasses'), value: professorClasses.length.toString(), icon: Icons.school, color: Colors.green),
            _buildProfessorStatCard(title: isRtl ? 'کلاس‌های فعال' : 'Active Classes', value: activeCount.toString(), icon: Icons.play_circle, color: Colors.orange),
            _buildProfessorStatCard(title: isRtl ? 'کلاس‌های گذشته' : 'Past Classes', value: finishedCount.toString(), icon: Icons.history, color: Colors.blueGrey),
            _buildProfessorStatCard(title: uiLabel(lang, 'notifications'), value: unreadCount.toString(), icon: Icons.notifications, color: Colors.purple),
          ],
        ),
        const SizedBox(height: 16),
        _buildProfessorDashboardShortcut(
          title: uiLabel(lang, 'classes'),
          subtitle: isRtl ? 'مشاهده کلاس‌ها و شروع کلاس زنده' : 'View classes and start live class',
          icon: Icons.video_call,
          onTap: () => setState(() => _selectedBottomNavIndex = 1),
        ),
        const SizedBox(height: 10),
        _buildProfessorDashboardShortcut(
          title: isRtl ? 'گفتگو با مدیران' : 'Chat with managers',
          subtitle: isRtl ? 'ارتباط با مدیر آموزش، خدمات، کنسولی و بین‌الملل' : 'Contact education, services, consular and international managers',
          icon: Icons.forum_outlined,
          onTap: () => setState(() => _selectedBottomNavIndex = 2),
        ),
        const SizedBox(height: 10),
        _buildProfessorDashboardShortcut(
          title: isRtl ? 'دانشجویان و برنامه هفتگی' : 'Students and weekly schedule',
          subtitle: isRtl ? 'مشاهده اطلاعات دانشجو و برنامه هفتگی او' : 'View student details and weekly schedule',
          icon: Icons.people_alt_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const StudentEducationLookupScreen(
                  canEdit: false,
                  canManageSchedule: false,
                  title: 'دانشجویان و برنامه هفتگی',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfessorStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withOpacity(0.25))),
      child: Row(children: <Widget>[
        CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ])),
      ]),
    );
  }

  Widget _buildProfessorDashboardShortcut({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.green.withOpacity(0.12), child: Icon(icon, color: Colors.green)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildClassesPage(AppState appState, AppLang lang) {
    final List<EducationManagedClassModel> classes = appState.getProfessorClasses(widget.professorId);
    final bool isRtl = isRtlLang(lang);
    if (classes.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(isRtl ? 'کلاسی برای شما ثبت نشده است.' : 'No classes assigned.')));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(uiLabel(lang, 'myClasses'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 12),
      ...classes.map((EducationManagedClassModel c) => _buildProfessorClassTile(c, lang)),
    ]);
  }

  Widget _buildProfessorClassTile(EducationManagedClassModel classItem, AppLang lang) {
    final bool isActive = classItem.status == LiveClassStatus.active;
    final bool canOpen = classItem.status == LiveClassStatus.active || classItem.status == LiveClassStatus.scheduled || classItem.status == LiveClassStatus.waitingForProfessor;
    final bool isRtl = isRtlLang(lang);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Row(children: <Widget>[
            CircleAvatar(backgroundColor: statusColor(classItem.status).withOpacity(0.15), child: Icon(Icons.school, color: statusColor(classItem.status))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text(classItem.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text('${classItem.weekDay} | ${formatTime(classItem.startTime)} - ${formatTime(classItem.endTime)}'),
            ])),
            Chip(label: Text(statusText(classItem.status, lang), style: const TextStyle(fontSize: 11)), backgroundColor: statusColor(classItem.status).withOpacity(0.12)),
          ]),
          const SizedBox(height: 10),
          Text('${isRtl ? 'دانشجویان' : 'Students'}: ${classItem.studentNames.length}'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: canOpen ? () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => ProfessorLiveClassScreen(classId: classItem.id))) : null,
            icon: Icon(isActive ? Icons.meeting_room : Icons.play_circle_outline),
            label: Text(isActive ? (isRtl ? 'ورود به کلاس' : 'Enter Class') : (isRtl ? 'شروع/مدیریت کلاس' : 'Start/Manage Class')),
          ),
        ]),
      ),
    );
  }

  Widget _buildManagersChatPage(AppState appState, AppLang lang) {
    final bool isRtl = isRtlLang(lang);
    final List<UnitModel> targetUnits = units.where((unit) => unit.keyName != 'other_services').toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(isRtl ? 'گفتگو با مدیران واحدها' : 'Chat with unit managers', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 8),
        Text(
          isRtl ? 'استاد می‌تواند مانند مدیران با واحدهای آموزش، خدمات دانشجویی، کنسولی و بین‌الملل گفتگو کند.' : 'Professors can contact education, student services, consular and international managers.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withOpacity(0.9), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade300)),
          child: Column(
            children: targetUnits.map((unit) {
              return _ManagerChatCard(
                managerName: appText(lang, unit.keyName),
                icon: unit.icon,
                unreadCount: 0,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => InterManagerChatScreen(targetUnit: unit.keyName, targetUnitName: appText(lang, unit.keyName))));
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsPage(AppState appState, AppLang lang) {
    final bool isRtl = isRtlLang(lang);
    final List<AppNotification> notifications = appState.professorNotifications;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(uiLabel(lang, 'notifications'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 12),
      if (notifications.isEmpty)
        Padding(padding: const EdgeInsets.all(16), child: Text(isRtl ? 'اعلانی وجود ندارد.' : 'No notifications.'))
      else
        ...notifications.map((n) => Card(child: ListTile(leading: Icon(n.unread ? Icons.notifications_active : Icons.notifications_none, color: n.unread ? Colors.orange : Colors.grey), title: Text(n.title), subtitle: Text(n.subtitle)))),
    ]);
  }

  Widget _buildMorePage(AppState appState, AppLang lang) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      _buildProfessorSettingsSection(appState, lang),
      const SizedBox(height: 16),
      _buildProfessorServicesSection(lang),
      const SizedBox(height: 16),
      _buildProfessorDashboardShortcut(title: uiLabel(lang, 'logout'), subtitle: isRtlLang(lang) ? 'خروج از حساب کاربری' : 'Sign out of your account', icon: Icons.logout, onTap: appState.logout),
    ]);
  }

  Widget _buildProfessorSettingsSection(AppState appState, AppLang lang) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withOpacity(0.9), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade300)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(padding: const EdgeInsets.all(16), child: Text(uiLabel(lang, 'settings'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        const Divider(height: 1),
        SwitchListTile(title: Text(uiLabel(lang, 'darkMode')), subtitle: Text(uiLabel(lang, 'darkModeDesc')), value: appState.isDarkMode, activeColor: Colors.green, onChanged: (_) => appState.toggleTheme()),
        ListTile(leading: const Icon(Icons.language, color: Colors.purple), title: Text(uiLabel(lang, 'languageApp')), subtitle: Text(uiLabel(lang, 'languageDesc')), trailing: const Icon(Icons.chevron_right), onTap: _showProfessorLanguageDialog),
      ]),
    );
  }

  void _showProfessorLanguageDialog() {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    showDialog<void>(context: context, builder: (BuildContext context) => AlertDialog(
      title: Text(uiLabel(appState.selectedLang, 'languageApp')),
      content: Column(mainAxisSize: MainAxisSize.min, children: AppLang.values.map((AppLang lang) => ListTile(title: Text(langCode(lang)), trailing: appState.selectedLang == lang ? const Icon(Icons.check, color: Colors.green) : null, onTap: () { appState.setLanguage(lang); Navigator.pop(context); })).toList()),
    ));
  }

  Widget _buildProfessorServicesSection(AppLang lang) {
    final bool isLargeScreen = MediaQuery.of(context).size.width >= kTabletBreakpoint;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(uiLabel(lang, 'services'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withOpacity(0.8), borderRadius: BorderRadius.circular(24), border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.14))),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: staffOtherServices.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isLargeScreen ? 3 : 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: isLargeScreen ? 1.25 : 1.05),
          itemBuilder: (BuildContext context, int index) {
            final OtherService service = staffOtherServices[index];
            return _OtherServiceCard(service: service, onTap: () => _openOtherService(service.key));
          },
        ),
      ),
    ]);
  }

  void _openOtherService(String serviceKey) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => OtherServiceScreen(serviceKey: serviceKey)));
  }
}

class EducationOfficerChatScreen extends StatefulWidget {
  final EducationOfficerModel officer;
  const EducationOfficerChatScreen({super.key, required this.officer});

  @override
  State<EducationOfficerChatScreen> createState() => _EducationOfficerChatScreenState();
}

class _EducationOfficerChatScreenState extends State<EducationOfficerChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final meId = appState.isEducationManager ? 'education_manager' : appState.userIdentifier;
    final otherId = widget.officer.id;
    final messages = appState.getEducationPrivateChatBetween(firstUserId: meId, secondUserId: otherId);
    return Scaffold(
      appBar: AppBar(title: Text('چت خصوصی با ${widget.officer.name}')),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
              ? const Center(child: Text('هنوز پیامی ثبت نشده است.'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: messages.map((m) => Align(
                    alignment: m.senderId == meId ? Alignment.centerRight : Alignment.centerLeft,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.senderName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(m.message),
                          ],
                        ),
                      ),
                    ),
                  )).toList(),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'پیام خود را بنویسید...'))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) return;
                    appState.sendEducationPrivateMessage(
                      senderId: meId,
                      senderName: appState.isEducationManager ? 'مدیر آموزش' : appState.userIdentifier,
                      receiverId: otherId,
                      receiverName: widget.officer.name,
                      message: text,
                    );
                    controller.clear();
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- صفحه اصلی مدیران ---
class ManagerHomeScreen extends StatefulWidget {
  final String managerUnitKey;

  const ManagerHomeScreen({super.key, required this.managerUnitKey});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  String? activeTopPanel;
  int _selectedBottomNavIndex = 0;
  final List<Meeting> _meetings = [];
  final List<InterManagerMessage> _messages = [];
  
  // ==================== داده‌های مدیریت کلاس‌ها ====================
  final List<ManagedClassModel> _managedClasses = [];
  final List<ProfessorModel> _allProfessors = mockProfessors;
  final List<StudentInClassModel> _allStudents = mockStudents;

  // ==================== متدهای اصلی生命周期 ====================
  
  @override
  void initState() {
    super.initState();
    _loadMeetings();
    _loadMessages();
    _loadSampleClasses();
  }

  void _loadMeetings() {
    _meetings.addAll(mockMeetings.where((m) => m.unitKey == widget.managerUnitKey || m.createdBy == widget.managerUnitKey));
  }

  void _loadMessages() {
    _messages.addAll(mockManagerMessages.where((msg) =>
        msg.receiverUnit == widget.managerUnitKey || msg.senderUnit == widget.managerUnitKey));
  }
  
  void _loadSampleClasses() {
    _managedClasses.addAll([
      ManagedClassModel(
        id: 'c1',
        name: 'برنامه نویسی پیشرفته',
        professorId: 'p001',
        professorName: 'دکتر محمدی',
        studentIds: ['s001', 's002'],
        studentNames: ['رضا حسینی', 'علی احمدی'],
        semester: '1403-1',
        capacity: 30,
        status: 'active',
        createdAt: DateTime.now(),
      ),
      ManagedClassModel(
        id: 'c2',
        name: 'پایگاه داده',
        professorId: 'p001',
        professorName: 'دکتر محمدی',
        studentIds: ['s001', 's003', 's004'],
        studentNames: ['رضا حسینی', 'فاطمه رضایی', 'Sara Smith'],
        semester: '1403-1',
        capacity: 25,
        status: 'active',
        createdAt: DateTime.now(),
      ),
      ManagedClassModel(
        id: 'c3',
        name: 'Data Structures',
        professorId: 'p002',
        professorName: 'Dr. Johnson',
        studentIds: ['s002', 's004'],
        studentNames: ['علی احمدی', 'Sara Smith'],
        semester: '1403-1',
        capacity: 20,
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        completedAt: DateTime.now(),
      ),
    ]);
  }

  void togglePanel(String key) {
    setState(() {
      activeTopPanel = key;
    });
  }

  // ==================== متد Build اصلی ====================
  
  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: <Widget>[
            HeaderWithInteractiveSidePanel(
              activePanel: activeTopPanel,
              onPanelToggle: togglePanel,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: activeTopPanel == null ? null : () => setState(() => activeTopPanel = null),
              child: _buildBody(),
            ),
            const SizedBox(height: 70),
          ],
        ),
        bottomNavigationBar: _buildManagerBottomNavigationBar(selectedLang),
        floatingActionButton: _currentManagerPageKey() == 'meetings'
            ? FloatingActionButton.extended(
                onPressed: () => _showNewMeetingDialog(context),
                icon: const Icon(Icons.add),
                label: Text(isRtl ? 'جلسه جدید' : 'New Meeting'),
              )
            : null,
      ),
    );
  }

  bool get _managerCanSeeClasses {
    return widget.managerUnitKey == 'education' || widget.managerUnitKey == 'education_officer';
  }

  List<String> get _managerPageKeys {
    return <String>[
      'dashboard',
      'managers',
      'meetings',
      if (_managerCanSeeClasses) 'classes',
      'services',
    ];
  }

  String _currentManagerPageKey() {
    final List<String> keys = _managerPageKeys;
    if (_selectedBottomNavIndex >= keys.length) {
      _selectedBottomNavIndex = 0;
    }
    return keys[_selectedBottomNavIndex];
  }

  BottomNavigationBar _buildManagerBottomNavigationBar(AppLang selectedLang) {
    final List<String> keys = _managerPageKeys;
    return BottomNavigationBar(
      currentIndex: _selectedBottomNavIndex >= keys.length ? 0 : _selectedBottomNavIndex,
      onTap: (int index) { setState(() { activeTopPanel = null; _selectedBottomNavIndex = index; }); },
      type: BottomNavigationBarType.fixed,
      items: keys.map((key) {
        switch (key) {
          case 'dashboard':
            return BottomNavigationBarItem(icon: const Icon(Icons.dashboard_outlined), activeIcon: const Icon(Icons.dashboard), label: uiLabel(selectedLang, 'dashboard'));
          case 'managers':
            return BottomNavigationBarItem(icon: const Icon(Icons.forum_outlined), activeIcon: const Icon(Icons.forum), label: uiLabel(selectedLang, 'managers'));
          case 'meetings':
            return BottomNavigationBarItem(icon: const Icon(Icons.event_outlined), activeIcon: const Icon(Icons.event), label: uiLabel(selectedLang, 'meetings'));
          case 'classes':
            return BottomNavigationBarItem(icon: const Icon(Icons.school_outlined), activeIcon: const Icon(Icons.school), label: uiLabel(selectedLang, 'classes'));
          default:
            return BottomNavigationBarItem(icon: const Icon(Icons.apps_outlined), activeIcon: const Icon(Icons.apps), label: uiLabel(selectedLang, 'services'));
        }
      }).toList(),
    );
  }

  Widget _buildBody() {
    switch (_currentManagerPageKey()) {
      case 'dashboard':
        return _buildDashboard();
      case 'managers':
        return _buildManagersChat();
      case 'meetings':
        return _buildMeetings();
      case 'classes':
        return _buildClassManagement();
      default:
        return _buildOtherServices();
    }
  }

  // ==================== داشبورد مدیر ====================

  Widget _buildDashboard() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final int unreadMessages = _messages.where((m) => !m.isRead && m.receiverUnit == widget.managerUnitKey).length;
    final int upcomingMeetings = _meetings.where((m) => !m.isRead).length;
    final int activeClasses = _managedClasses.where((c) => c.status == 'active').length;
    final int totalProfessors = _allProfessors.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isRtl ? 'خوش آمدید' : 'Welcome',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appText(selectedLang, widget.managerUnitKey),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings, size: 35, color: Colors.green),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: <Widget>[
            Expanded(
              child: _StatCard(
                title: isRtl ? 'پیام‌های نخوانده' : 'Unread Messages',
                value: '$unreadMessages',
                icon: Icons.message,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: isRtl ? 'جلسات پیش رو' : 'Upcoming Meetings',
                value: '$upcomingMeetings',
                icon: Icons.event,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _StatCard(
                title: isRtl ? 'کلاس‌های فعال' : 'Active Classes',
                value: '$activeClasses',
                icon: Icons.class_,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: isRtl ? 'اساتید' : 'Professors',
                value: '$totalProfessors',
                icon: Icons.person,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildManagerQuickAccess(appState, selectedLang),
        const SizedBox(height: 20),

        Text(
          isRtl ? 'واحدهای تحت مدیریت' : 'Managed Units',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: units.where((u) => u.keyName == widget.managerUnitKey).map((unit) {
              return _ManagerUnitCard(
                unit: unit,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnitScreen(unit: unit)),
                  );
                },
              );
            }).toList(),
          ),
        ),
        if (widget.managerUnitKey == 'education' || widget.managerUnitKey == 'education_officer') ...[
          const SizedBox(height: 20),
          _buildEducationFastAccess(context, appState),
        ],
      ],
    );
  }

  Widget _buildManagerQuickAccess(AppState appState, AppLang lang) {
    final bool isRtl = isRtlLang(lang);
    final List<Widget> cards = <Widget>[
      _buildEducationActionCard(title: isRtl ? 'گفتگو با مدیران' : 'Managers chat', subtitle: isRtl ? 'ارتباط سریع با واحدهای دیگر' : 'Quick access to other units', icon: Icons.forum_outlined, color: Colors.blue, onTap: () => setState(() => _selectedBottomNavIndex = _managerPageKeys.indexOf('managers'))),
      _buildEducationActionCard(title: isRtl ? 'جلسات' : 'Meetings', subtitle: isRtl ? 'برنامه‌ریزی و مشاهده جلسات' : 'Schedule and view meetings', icon: Icons.event_available_outlined, color: Colors.orange, onTap: () => setState(() => _selectedBottomNavIndex = _managerPageKeys.indexOf('meetings'))),
      _buildEducationActionCard(title: appText(lang, 'other_services'), subtitle: isRtl ? 'خدمات ترجمه، پرینت و رفاهی' : 'Translation, print and welfare services', icon: Icons.apps_outlined, color: Colors.teal, onTap: () => setState(() => _selectedBottomNavIndex = _managerPageKeys.indexOf('services'))),
    ];
    if (_managerCanSeeClasses) {
      cards.insert(0, _buildEducationActionCard(title: isRtl ? 'مدیریت کلاس‌ها' : 'Class management', subtitle: isRtl ? 'برنامه هفتگی، دانشجویان و گزارش کلاس‌ها' : 'Weekly schedule, students and class reports', icon: Icons.school_outlined, color: Colors.green, onTap: () => setState(() => _selectedBottomNavIndex = _managerPageKeys.indexOf('classes'))));
      cards.add(_buildEducationActionCard(title: isRtl ? 'پرونده دانشجو' : 'Student file', subtitle: isRtl ? 'پروفایل، دروس، برنامه هفتگی، گزارش آموزشی و وضعیت مالی' : 'Profile, courses, schedule, academic reports and financial status', icon: Icons.badge_outlined, color: Colors.deepPurple, onTap: () { Navigator.push(context, MaterialPageRoute<void>(builder: (_) => StudentEducationLookupScreen(canEdit: appState.canEditEducationStudentProfile, canManageSchedule: appState.canAccessEducationClassManagement, title: isRtl ? 'پرونده آموزشی دانشجو' : 'Student education file'))); }));
    } else {
      cards.add(_buildEducationActionCard(title: isRtl ? 'مشاهده دانشجویان' : 'Students view', subtitle: isRtl ? 'مشاهده اطلاعات و برنامه هفتگی دانشجویان بدون ویرایش' : 'View student information and weekly schedules', icon: Icons.people_outline, color: Colors.deepPurple, onTap: () { Navigator.push(context, MaterialPageRoute<void>(builder: (_) => StudentEducationLookupScreen(canEdit: false, canManageSchedule: false, title: isRtl ? 'مشاهده اطلاعات دانشجویان' : 'Students information'))); }));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(isRtl ? 'دسترسی سریع' : 'Quick access', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(height: 12),
      Wrap(spacing: 12, runSpacing: 12, children: cards),
    ]);
  }

  // ==================== ارتباط با مدیران دیگر ====================

  Widget _buildManagersChat() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    final List<Map<String, dynamic>> otherManagers = units
        .where((unit) => unit.keyName != widget.managerUnitKey && unit.keyName != 'other_services')
        .map((unit) => {
              'unitKey': unit.keyName,
              'unitName': appText(selectedLang, unit.keyName),
              'icon': unit.icon,
              'unread': _messages.where((m) => !m.isRead && m.senderUnit == unit.keyName).length,
            })
        .toList();

    otherManagers.insert(0, {
      'unitKey': 'admin_main',
      'unitName': isRtl ? 'مدیر اصلی سیستم' : 'System Admin',
      'icon': Icons.admin_panel_settings_outlined,
      'unread': _messages.where((m) => !m.isRead && m.senderUnit == 'admin_main').length,
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isRtl ? 'ارتباط با مدیران واحدها' : 'Communicate with Unit Managers',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: otherManagers.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      isRtl ? 'مدیر دیگری برای ارتباط وجود ندارد.' : 'No other managers to connect with.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                )
              : Column(
                  children: otherManagers.map((manager) {
                    return _ManagerChatCard(
                      managerName: manager['unitName'],
                      icon: manager['icon'],
                      unreadCount: manager['unread'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InterManagerChatScreen(
                              targetUnit: manager['unitKey'],
                              targetUnitName: manager['unitName'],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  // ==================== جلسات ====================

  Widget _buildMeetings() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              isRtl ? 'جلسات برنامه ریزی شده' : 'Scheduled Meetings',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showNewMeetingDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(isRtl ? 'جدید' : 'New'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: _meetings.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      isRtl ? 'هیچ جلسه‌ای برنامه ریزی نشده است.' : 'No meetings scheduled.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                )
              : Column(
                  children: _meetings.map((meeting) {
                    return _MeetingCard(meeting: meeting);
                  }).toList(),
                ),
        ),
      ],
    );
  }

  void _showNewMeetingDialog(BuildContext context) {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final TextEditingController titleCtrl = TextEditingController();
    final TextEditingController dateCtrl = TextEditingController();
    final TextEditingController timeCtrl = TextEditingController();
    String selectedUnit = units.firstWhere((u) => u.keyName != widget.managerUnitKey).keyName;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isRtl ? 'برگزاری جلسه جدید' : 'Schedule New Meeting'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'عنوان جلسه' : 'Meeting Title',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'تاریخ' : 'Date',
                    hintText: isRtl ? '1403/02/15' : '2024/05/15',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeCtrl,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'ساعت' : 'Time',
                    hintText: isRtl ? '14:30' : '14:30',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'واحد مربوطه' : 'Related Unit',
                    border: const OutlineInputBorder(),
                  ),
                  items: units.where((u) => u.keyName != 'other_services').map((UnitModel unit) {
                    return DropdownMenuItem<String>(
                      value: unit.keyName,
                      child: Text(appText(selectedLang, unit.keyName)),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) selectedUnit = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(isRtl ? 'انصراف' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  final newMeeting = Meeting(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleCtrl.text,
                    date: dateCtrl.text,
                    time: timeCtrl.text,
                    unitKey: selectedUnit,
                    unitName: appText(selectedLang, selectedUnit),
                    isRead: false,
                    createdBy: widget.managerUnitKey,
                  );
                  setState(() {
                    _meetings.add(newMeeting);
                    mockMeetings.add(newMeeting);
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRtl ? 'جلسه با موفقیت ثبت شد' : 'Meeting scheduled successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text(isRtl ? 'ثبت جلسه' : 'Schedule'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildEducationOfficersPanel() {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.admin_panel_settings_outlined, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(uiLabel(selectedLang, 'educationOfficers'), style: const TextStyle(fontWeight: FontWeight.bold))),
                ElevatedButton.icon(
                  onPressed: () => _showCreateEducationOfficerDialog(appState),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(uiLabel(selectedLang, 'newOfficer')),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...appState.educationOfficers.map((officer) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(officer.name),
                subtitle: Text('نام کاربری: ${officer.username} | دسترسی‌ها: ${officer.permissions.length}'),
                trailing: Wrap(
                  spacing: 6,
                  children: [
                    IconButton(
                      tooltip: uiLabel(selectedLang, 'privateChat'),
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.green),
                      onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => EducationOfficerChatScreen(officer: officer))),
                    ),
                    IconButton(
                      tooltip: uiLabel(selectedLang, 'permissions'),
                      icon: const Icon(Icons.security_outlined, color: Colors.deepPurple),
                      onPressed: () => _showOfficerPermissionsDialog(appState, officer),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showCreateEducationOfficerDialog(AppState appState) {
    final nameCtrl = TextEditingController();
    final usernameCtrl = TextEditingController();
    final List<EducationPermission> selected = [EducationPermission.viewReports, EducationPermission.privateChat];
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعریف کارشناس آموزش جدید'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'نام کارشناس', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'نام کاربری', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty || usernameCtrl.text.trim().isEmpty) return;
              appState.addEducationOfficer(name: nameCtrl.text.trim(), username: usernameCtrl.text.trim(), permissions: selected);
              Navigator.pop(dialogContext);
              setState(() {});
            },
            child: const Text('ثبت'),
          ),
        ],
      ),
    );
  }

  void _showOfficerPermissionsDialog(AppState appState, EducationOfficerModel officer) {
    final Set<EducationPermission> selected = Set<EducationPermission>.from(officer.permissions);
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('دسترسی‌های ${officer.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: EducationPermission.values.map((permission) => CheckboxListTile(
                value: selected.contains(permission),
                title: Text(permission.name),
                onChanged: (value) {
                  setDialogState(() {
                    if (value == true) { selected.add(permission); } else { selected.remove(permission); }
                  });
                },
              )).toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('انصراف')),
            ElevatedButton(
              onPressed: () {
                appState.updateEducationOfficerPermissions(officerId: officer.id, permissions: selected.toList());
                Navigator.pop(dialogContext);
                setState(() {});
              },
              child: const Text('ذخیره'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== سایر خدمات ====================

  Widget _buildOtherServices() {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth >= kTabletBreakpoint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          appText(selectedLang, 'other_services'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.14),
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: staffOtherServices.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isLargeScreen ? 5 : 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: isLargeScreen ? 1.15 : 0.92,
            ),
            itemBuilder: (BuildContext context, int index) {
              final OtherService service = staffOtherServices[index];
              return _OtherServiceCard(
                service: service,
                onTap: () => _openOtherService(service.key),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openOtherService(String serviceKey) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext _) => OtherServiceScreen(serviceKey: serviceKey),
      ),
    );
  }

  // ==================== مدیریت کلاس‌ها ====================
  
  Widget _buildClassManagement() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isRtl ? 'مدیریت کلاس‌ها' : 'Class Management',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            FloatingActionButton.small(
              onPressed: () => _showAddClassDialog(),
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.managerUnitKey == 'education') ...[
          _buildEducationOfficersPanel(),
          const SizedBox(height: 12),
        ],
        
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: isRtl ? 'کلاس‌های فعال' : 'Active Classes'),
                  Tab(text: isRtl ? 'کلاس‌های گذشته' : 'Past Classes'),
                  Tab(text: isRtl ? 'گزارش‌ها' : 'Reports'),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: TabBarView(
                  children: [
                    _buildActiveClassesTab(),
                    _buildPastClassesTab(),
                    _buildReportsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveClassesTab() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final activeClasses = _managedClasses.where((c) => c.status == 'active').toList();
    
    if (activeClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.class_, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'هیچ کلاس فعالی وجود ندارد' : 'No active classes',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddClassDialog(),
              child: Text(isRtl ? 'ایجاد کلاس جدید' : 'Create New Class'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: activeClasses.length,
      itemBuilder: (context, index) {
        final classItem = activeClasses[index];
        return _buildClassCard(classItem);
      },
    );
  }

  Widget _buildPastClassesTab() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final pastClasses = _managedClasses.where((c) => c.status == 'completed').toList();
    
    if (pastClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'هیچ کلاس گذشته‌ای وجود ندارد' : 'No past classes',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: pastClasses.length,
      itemBuilder: (context, index) {
        final classItem = pastClasses[index];
        return _buildPastClassCard(classItem);
      },
    );
  }

  Widget _buildReportsTab() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final reports = _generateClassReports();
    
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assessment, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'هیچ گزارشی موجود نیست' : 'No reports available',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildClassCard(ManagedClassModel classItem) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final attendanceRateValue = classItem.studentIds.isNotEmpty 
        ? (classItem.studentIds.length / classItem.capacity) * 100 
        : 0.0;
    final attendanceRate = attendanceRateValue.toDouble();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: const Icon(Icons.class_, color: Colors.green),
        ),
        title: Text(
          classItem.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${isRtl ? 'استاد' : 'Professor'}: ${classItem.professorName}'),
            Text('${isRtl ? 'ترم' : 'Semester'}: ${classItem.semester}'),
            Row(
              children: [
                Text('${isRtl ? 'تعداد دانشجویان' : 'Students'}: ${classItem.studentIds.length}/${classItem.capacity}'),
                const SizedBox(width: 12),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: attendanceRate / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: attendanceRate > 70 ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.people, color: Colors.blue),
              onPressed: () => _showManageStudentsDialog(classItem),
              tooltip: isRtl ? 'مدیریت دانشجویان' : 'Manage Students',
            ),
            IconButton(
              icon: const Icon(Icons.assessment, color: Colors.green),
              onPressed: () => _showClassReportDialog(classItem),
              tooltip: isRtl ? 'مشاهده گزارش' : 'View Report',
            ),
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.orange),
              onPressed: () => _showCompleteClassDialog(classItem),
              tooltip: isRtl ? 'پایان کلاس' : 'Complete Class',
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📚 لیست دانشجویان:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...classItem.studentNames.map((name) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(name)),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.red),
                        onPressed: () => _removeStudentFromClass(classItem, name),
                        tooltip: isRtl ? 'حذف دانشجو' : 'Remove Student',
                      ),
                    ],
                  ),
                )),
                if (classItem.studentNames.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      isRtl ? 'هیچ دانشجویی در این کلاس ثبت نشده است' : 'No students enrolled',
                      style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showAddStudentDialog(classItem),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: Text(isRtl ? 'افزودن دانشجو' : 'Add Student'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _showClassReportDialog(classItem),
                        icon: const Icon(Icons.assessment, size: 18),
                        label: Text(isRtl ? 'مشاهده گزارش' : 'View Report'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPastClassCard(ManagedClassModel classItem) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.1),
          child: const Icon(Icons.class_, color: Colors.grey),
        ),
        title: Text(classItem.name),
        subtitle: Text('${isRtl ? 'استاد' : 'Professor'}: ${classItem.professorName} | ${isRtl ? 'ترم' : 'Semester'}: ${classItem.semester}'),
        trailing: IconButton(
          icon: const Icon(Icons.assessment, color: Colors.blue),
          onPressed: () => _showClassReportDialog(classItem),
          tooltip: isRtl ? 'مشاهده گزارش' : 'View Report',
        ),
        onTap: () => _showClassReportDialog(classItem),
      ),
    );
  }

  Widget _buildReportCard(ClassReportModel report) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: const Icon(Icons.assessment, color: Colors.blue),
        title: Text(
          report.className,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${report.date.year}/${report.date.month}/${report.date.day}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildReportRow(
                  icon: Icons.person,
                  label: isRtl ? 'استاد' : 'Professor',
                  value: report.professorName,
                ),
                const SizedBox(height: 8),
                _buildReportRow(
                  icon: Icons.people,
                  label: isRtl ? 'تعداد دانشجویان' : 'Total Students',
                  value: '${report.totalStudents}',
                ),
                const SizedBox(height: 8),
                _buildReportRow(
                  icon: Icons.person_add,
                  label: isRtl ? 'دانشجویان فعال' : 'Active Students',
                  value: '${report.activeStudents}',
                ),
                const SizedBox(height: 8),
                _buildReportRow(
                  icon: Icons.message,
                  label: isRtl ? 'تعداد پیام‌ها' : 'Total Messages',
                  value: '${report.totalMessages}',
                ),
                const SizedBox(height: 8),
                _buildReportRow(
                  icon: Icons.trending_up,
                  label: isRtl ? 'نرخ حضور' : 'Attendance Rate',
                  value: '${report.attendanceRate.toStringAsFixed(1)}%',
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: report.attendanceRate / 100,
                  backgroundColor: Colors.grey.shade200,
                  color: report.attendanceRate > 70 ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _showAddClassDialog() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController semesterCtrl = TextEditingController();
    final TextEditingController capacityCtrl = TextEditingController();
    String selectedProfessorId = _allProfessors.first.id;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isRtl ? '➕ ایجاد کلاس جدید' : '➕ Create New Class'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: isRtl ? 'نام کلاس' : 'Class Name',
                  prefixIcon: const Icon(Icons.class_),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedProfessorId,
                decoration: InputDecoration(
                  labelText: isRtl ? 'استاد' : 'Professor',
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                items: _allProfessors.map((prof) {
                  return DropdownMenuItem(
                    value: prof.id,
                    child: Text(prof.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedProfessorId = value;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: semesterCtrl,
                decoration: InputDecoration(
                  labelText: isRtl ? 'ترم تحصیلی' : 'Semester',
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: isRtl ? 'مثال: 1403-1' : 'Example: 2024-1',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: capacityCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isRtl ? 'ظرفیت کلاس' : 'Class Capacity',
                  prefixIcon: const Icon(Icons.people),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isRtl ? 'انصراف' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && semesterCtrl.text.isNotEmpty) {
                final professor = _allProfessors.firstWhere((p) => p.id == selectedProfessorId);
                final newClass = ManagedClassModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text,
                  professorId: selectedProfessorId,
                  professorName: professor.name,
                  studentIds: [],
                  studentNames: [],
                  semester: semesterCtrl.text,
                  capacity: int.tryParse(capacityCtrl.text) ?? 30,
                  status: 'active',
                  createdAt: DateTime.now(),
                );
                setState(() {
                  _managedClasses.add(newClass);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isRtl ? '✅ کلاس با موفقیت ایجاد شد' : '✅ Class created successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(isRtl ? 'ایجاد' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _showAddStudentDialog(ManagedClassModel classItem) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final List<StudentInClassModel> availableStudents = _allStudents
        .where((s) => !classItem.studentIds.contains(s.id))
        .toList();
    
    if (availableStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isRtl ? '⚠️ هیچ دانشجوی دیگری برای اضافه کردن وجود ندارد' : '⚠️ No more students available'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    StudentInClassModel? selectedStudent = availableStudents.first;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('${isRtl ? '👨‍🎓 افزودن دانشجو به' : '👨‍🎓 Add Student to'} ${classItem.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<StudentInClassModel>(
                  value: selectedStudent,
                  decoration: InputDecoration(
                    labelText: isRtl ? 'انتخاب دانشجو' : 'Select Student',
                    border: const OutlineInputBorder(),
                  ),
                  items: availableStudents.map((student) {
                    return DropdownMenuItem(
                      value: student,
                      child: Text('${student.name} (${student.studentId})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() {
                        selectedStudent = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (classItem.studentIds.length >= classItem.capacity)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isRtl ? '⚠️ ظرفیت کلاس تکمیل شده است' : '⚠️ Class capacity is full',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isRtl ? 'انصراف' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final student = selectedStudent; // ذخیره در متغیر محلی
                  if (student != null && classItem.studentIds.length < classItem.capacity) {
                    setState(() {
                      final index = _managedClasses.indexOf(classItem);
                      _managedClasses[index].studentIds.add(student.id);
                      _managedClasses[index].studentNames.add(student.name);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ ${student.name} ${isRtl ? 'به کلاس اضافه شد' : 'added to class'}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (classItem.studentIds.length >= classItem.capacity) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isRtl ? '⚠️ ظرفیت کلاس تکمیل شده است' : '⚠️ Class capacity is full'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: Text(isRtl ? 'افزودن' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _removeStudentFromClass(ManagedClassModel classItem, String studentName) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final studentId = _allStudents.firstWhere((s) => s.name == studentName).id;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isRtl ? '⚠️ حذف دانشجو' : '⚠️ Remove Student'),
        content: Text(
          isRtl 
            ? 'آیا از حذف "$studentName" از کلاس "${classItem.name}" اطمینان دارید؟'
            : 'Are you sure you want to remove "$studentName" from "${classItem.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isRtl ? 'انصراف' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _managedClasses.indexOf(classItem);
                _managedClasses[index].studentIds.remove(studentId);
                _managedClasses[index].studentNames.remove(studentName);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ $studentName ${isRtl ? 'از کلاس حذف شد' : 'removed from class'}'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(isRtl ? 'حذف' : 'Remove'),
          ),
        ],
      ),
    );
  }

  void _showCompleteClassDialog(ManagedClassModel classItem) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isRtl ? '✅ پایان کلاس' : '✅ Complete Class'),
        content: Text(
          isRtl 
            ? 'آیا از پایان کلاس "${classItem.name}" اطمینان دارید؟ پس از پایان، نمی‌توانید تغییری ایجاد کنید.'
            : 'Are you sure you want to complete "${classItem.name}"? You cannot modify it after completion.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isRtl ? 'انصراف' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _managedClasses.indexOf(classItem);
                // استفاده از روش جایگزین برای تغییر status
                final updatedClass = ManagedClassModel(
                  id: _managedClasses[index].id,
                  name: _managedClasses[index].name,
                  professorId: _managedClasses[index].professorId,
                  professorName: _managedClasses[index].professorName,
                  studentIds: _managedClasses[index].studentIds,
                  studentNames: _managedClasses[index].studentNames,
                  semester: _managedClasses[index].semester,
                  capacity: _managedClasses[index].capacity,
                  status: 'completed',
                  createdAt: _managedClasses[index].createdAt,
                  completedAt: DateTime.now(),
                );
                _managedClasses[index] = updatedClass;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isRtl ? '✅ کلاس با موفقیت به پایان رسید' : '✅ Class completed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(isRtl ? 'پایان کلاس' : 'Complete'),
          ),
        ],
      ),
    );
  }

  void _showClassReportDialog(ManagedClassModel classItem) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    final attendanceRateValue = classItem.studentIds.isNotEmpty 
        ? (classItem.studentIds.length / classItem.capacity) * 100 
        : 0.0;
    final attendanceRate = attendanceRateValue.toDouble();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📊 ${isRtl ? 'گزارش کلاس' : 'Class Report'} - ${classItem.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportRow(
                icon: Icons.person,
                label: isRtl ? 'استاد' : 'Professor',
                value: classItem.professorName,
              ),
              const SizedBox(height: 8),
              _buildReportRow(
                icon: Icons.calendar_today,
                label: isRtl ? 'ترم' : 'Semester',
                value: classItem.semester,
              ),
              const SizedBox(height: 8),
              _buildReportRow(
                icon: Icons.people,
                label: isRtl ? 'تعداد دانشجویان' : 'Total Students',
                value: '${classItem.studentIds.length}/${classItem.capacity}',
              ),
              const SizedBox(height: 8),
              _buildReportRow(
                icon: Icons.trending_up,
                label: isRtl ? 'نرخ حضور' : 'Attendance Rate',
                value: '${attendanceRate.toStringAsFixed(1)}%',
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: attendanceRate / 100,
                backgroundColor: Colors.grey.shade200,
                color: attendanceRate > 70 ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              if (classItem.completedAt != null) ...[
                const SizedBox(height: 8),
                _buildReportRow(
                  icon: Icons.check_circle,
                  label: isRtl ? 'تاریخ پایان' : 'Completion Date',
                  value: '${classItem.completedAt!.year}/${classItem.completedAt!.month}/${classItem.completedAt!.day}',
                ),
              ],
              const Divider(height: 24),
              Text(
                isRtl ? '📋 لیست دانشجویان:' : '📋 Students List:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...classItem.studentNames.map((name) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(name),
                  ],
                ),
              )),
              if (classItem.studentNames.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    isRtl ? 'هیچ دانشجویی در این کلاس ثبت نشده است' : 'No students enrolled',
                    style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isRtl ? 'بستن' : 'Close'),
          ),
        ],
      ),
    );
  }

  void _showManageStudentsDialog(ManagedClassModel classItem) {
    _showAddStudentDialog(classItem);
  }

  List<ClassReportModel> _generateClassReports() {
    final reports = <ClassReportModel>[];
    for (var classItem in _managedClasses.where((c) => c.status == 'completed')) {
      final attendanceRateValue = classItem.studentIds.isNotEmpty 
          ? (classItem.studentIds.length / classItem.capacity) * 100 
          : 0.0;
      reports.add(ClassReportModel(
        classId: classItem.id,
        className: classItem.name,
        professorName: classItem.professorName,
        totalStudents: classItem.studentIds.length,
        activeStudents: classItem.studentIds.length,
        totalMessages: 0,
        date: classItem.completedAt ?? classItem.createdAt,
        attendanceRate: attendanceRateValue.toDouble(),
        status: classItem.status,
        scheduleDay: classItem.scheduleDay,
        scheduleTime: classItem.scheduleTime,
      ));
    }
    return reports;
  }

  // ==================== دسترسی سریع آموزش: درخواست‌های جدید ====================

  Widget _buildEducationFastAccess(BuildContext context, AppState appState) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.flash_on_outlined, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'دسترسی سریع آموزش',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildEducationActionCard(
                  title: 'مدیریت کلاس‌ها',
                  subtitle: 'افزودن کلاس، انتخاب استاد و دانشجویان، گزارش فعال و گذشته',
                  icon: Icons.video_call_outlined,
                  color: Colors.green,
                  onTap: appState.canAccessEducationClassManagement
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EducationClassManagementScreen(),
                            ),
                          );
                        }
                      : null,
                ),
                _buildEducationActionCard(
                  title: 'چت خصوصی آموزش',
                  subtitle: 'گفتگوی مدیر آموزش و کارشناس آموزش با ذخیره تاریخچه',
                  icon: Icons.lock_outline,
                  color: Colors.deepPurple,
                  onTap: appState.hasEducationPermission(
                            EducationPermission.privateChat,
                          ) ||
                          appState.userRole == 'admin'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EducationPrivateChatScreen(),
                            ),
                          );
                        }
                      : null,
                ),
                _buildEducationActionCard(
                  title: 'پرونده دانشجو',
                  subtitle: 'پروفایل، دروس، برنامه هفتگی، گزارش آموزشی، انضباطی و وضعیت تسویه/بدهی',
                  icon: Icons.badge_outlined,
                  color: Colors.indigo,
                  onTap: appState.hasEducationPermission(EducationPermission.manageStudents) || appState.userRole == 'admin'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => StudentEducationLookupScreen(
                                canEdit: appState.canEditEducationStudentProfile,
                                canManageSchedule: appState.canAccessEducationClassManagement,
                                title: 'پرونده آموزشی دانشجو',
                              ),
                            ),
                          );
                        }
                      : null,
                ),
                if (appState.isEducationManager || appState.userRole == 'admin')
                  _buildEducationActionCard(
                    title: 'کارشناسان آموزش',
                    subtitle: 'جستجو/انتخاب کارشناس، چت خصوصی و مدیریت دسترسی‌ها',
                    icon: Icons.manage_accounts_outlined,
                    color: Colors.orange,
                    onTap: () {
                      _showOfficerPermissionSheet(context, appState);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 260,
      child: Card(
        elevation: 0,
        color: color.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: color.withValues(alpha: 0.22)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.16),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    onTap == null
                        ? Icons.lock_outline
                        : Icons.arrow_back_ios_new,
                    size: 16,
                    color: onTap == null ? Colors.grey : color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOfficerPermissionSheet(
    BuildContext context,
    AppState appState,
  ) {
    if (appState.educationOfficers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کارشناس آموزش تعریف نشده است.')));
      return;
    }
    EducationOfficerModel selectedOfficer = appState.educationOfficers.first;
    final TextEditingController searchCtrl = TextEditingController();
    Set<EducationPermission> tempPermissions = Set<EducationPermission>.from(selectedOfficer.permissions);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final List<EducationOfficerModel> filtered = appState.educationOfficers.where((officer) {
              final String q = searchCtrl.text.trim().toLowerCase();
              if (q.isEmpty) return true;
              return officer.name.toLowerCase().contains(q) || officer.username.toLowerCase().contains(q);
            }).toList();
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: MediaQuery.of(context).viewInsets.bottom + 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('مدیریت کارشناسان آموزش', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    TextField(controller: searchCtrl, decoration: const InputDecoration(labelText: 'جستجوی کارشناس با نام یا نام کاربری', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()), onChanged: (_) => setSheetState(() {})),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedOfficer.id,
                      decoration: const InputDecoration(labelText: 'انتخاب کارشناس', border: OutlineInputBorder()),
                      items: filtered.map((officer) => DropdownMenuItem<String>(value: officer.id, child: Text('${officer.name} (${officer.username})'))).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        final EducationOfficerModel officer = appState.educationOfficers.firstWhere((o) => o.id == value);
                        setSheetState(() { selectedOfficer = officer; tempPermissions = Set<EducationPermission>.from(officer.permissions); });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: OutlinedButton.icon(onPressed: () { Navigator.push(context, MaterialPageRoute<void>(builder: (_) => EducationOfficerChatScreen(officer: selectedOfficer))); }, icon: const Icon(Icons.chat_outlined), label: const Text('چت با کارشناس'))),
                      const SizedBox(width: 8),
                      Expanded(child: OutlinedButton.icon(onPressed: () => _showCreateEducationOfficerDialog(appState), icon: const Icon(Icons.person_add_alt), label: const Text('کارشناس جدید'))),
                    ]),
                    const SizedBox(height: 12),
                    Flexible(child: ListView(shrinkWrap: true, children: EducationPermission.values.map((permission) {
                      return CheckboxListTile(value: tempPermissions.contains(permission), title: Text(_permissionTitle(permission)), subtitle: Text(_permissionSubtitle(permission)), onChanged: (value) { setSheetState(() { if (value == true) { tempPermissions.add(permission); } else { tempPermissions.remove(permission); } }); });
                    }).toList())),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, height: 48, child: ElevatedButton.icon(onPressed: () { appState.updateEducationOfficerPermissions(officerId: selectedOfficer.id, permissions: tempPermissions.toList()); Navigator.pop(sheetContext); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('دسترسی‌های ${selectedOfficer.name} ذخیره شد.'))); }, icon: const Icon(Icons.save), label: const Text('ذخیره دسترسی‌ها'))),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _permissionTitle(EducationPermission permission) {
    switch (permission) {
      case EducationPermission.manageClasses:
        return 'مدیریت کلاس‌ها';
      case EducationPermission.createClass:
        return 'ایجاد کلاس';
      case EducationPermission.editClass:
        return 'ویرایش یا لغو کلاس';
      case EducationPermission.deleteClass:
        return 'حذف کلاس';
      case EducationPermission.manageProfessors:
        return 'مدیریت استادان';
      case EducationPermission.viewReports:
        return 'مشاهده گزارش‌ها';
      case EducationPermission.manageStudents:
        return 'مدیریت دانشجویان';
      case EducationPermission.privateChat:
        return 'چت خصوصی با مدیر آموزش';
      case EducationPermission.viewClassHistory:
        return 'مشاهده تاریخچه کلاس‌ها';
    }
  }

  String _permissionSubtitle(EducationPermission permission) {
    switch (permission) {
      case EducationPermission.manageClasses:
        return 'دسترسی به صفحه مدیریت کلاس‌های آموزش';
      case EducationPermission.createClass:
        return 'امکان ثبت کلاس جدید با استاد و دانشجویان';
      case EducationPermission.editClass:
        return 'امکان لغو یا اصلاح کلاس‌ها';
      case EducationPermission.deleteClass:
        return 'امکان حذف کلاس‌های ثبت‌شده';
      case EducationPermission.manageProfessors:
        return 'امکان مدیریت استادان و اتصال آن‌ها به کلاس‌ها';
      case EducationPermission.viewReports:
        return 'مشاهده گزارش دقیق کلاس‌های فعال و گذشته';
      case EducationPermission.manageStudents:
        return 'مدیریت فهرست دانشجویان کلاس';
      case EducationPermission.privateChat:
        return 'امکان گفتگوی داخلی با مدیر آموزش';
      case EducationPermission.viewClassHistory:
        return 'مشاهده سوابق کلاس‌ها و گزارش‌های گذشته';
    }
  }

}

class StudentEducationLookupScreen extends StatefulWidget {
  final bool canEdit;
  final bool canManageSchedule;
  final String title;
  const StudentEducationLookupScreen({super.key, required this.canEdit, required this.canManageSchedule, required this.title});
  @override
  State<StudentEducationLookupScreen> createState() => _StudentEducationLookupScreenState();
}

class _StudentEducationLookupScreenState extends State<StudentEducationLookupScreen> {
  String selectedStudentId = mockStudents.first.id;
  final TextEditingController searchCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  @override
  void dispose() { searchCtrl.dispose(); noteCtrl.dispose(); super.dispose(); }
  String _formatTime(TimeOfDay time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  StudentInClassModel get selectedStudent => mockStudents.firstWhere((s) => s.id == selectedStudentId, orElse: () => mockStudents.first);

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang lang = appState.selectedLang;
    final bool isRtl = isRtlLang(lang);
    final List<StudentInClassModel> filteredStudents = mockStudents.where((student) {
      final String q = searchCtrl.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return student.name.toLowerCase().contains(q) || student.studentId.toLowerCase().contains(q);
    }).toList();
    if (!filteredStudents.any((s) => s.id == selectedStudentId) && filteredStudents.isNotEmpty) { selectedStudentId = filteredStudents.first.id; }
    final StudentInClassModel student = selectedStudent;
    final List<EducationManagedClassModel> classes = appState.getStudentClasses(student.id);
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), centerTitle: true),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isRtl ? 'انتخاب دانشجو' : 'Select student', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: searchCtrl, decoration: InputDecoration(labelText: isRtl ? 'جستجو با نام یا شماره دانشجویی' : 'Search by name or student number', prefixIcon: const Icon(Icons.search), border: const OutlineInputBorder()), onChanged: (_) => setState(() {})),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: filteredStudents.any((s) => s.id == selectedStudentId) ? selectedStudentId : null, decoration: InputDecoration(labelText: isRtl ? 'دانشجو' : 'Student', border: const OutlineInputBorder()), items: filteredStudents.map((student) => DropdownMenuItem<String>(value: student.id, child: Text('${student.name} - ${student.studentId}'))).toList(), onChanged: (value) { if (value != null) setState(() => selectedStudentId = value); }),
          ]))),
          const SizedBox(height: 12),
          _buildProfileCard(student, isRtl),
          const SizedBox(height: 12),
          _buildWeeklySchedule(classes, isRtl),
          const SizedBox(height: 12),
          _buildAcademicReports(classes, isRtl),
          const SizedBox(height: 12),
          _buildFinanceAndDiscipline(student, isRtl),
        ]),
        floatingActionButton: widget.canManageSchedule ? FloatingActionButton.extended(onPressed: () { Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const EducationClassManagementScreen())); }, icon: const Icon(Icons.edit_calendar_outlined), label: Text(isRtl ? 'مدیریت برنامه' : 'Manage schedule')) : null,
      ),
    );
  }

  Widget _buildProfileCard(StudentInClassModel student, bool isRtl) {
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const CircleAvatar(radius: 28, child: Icon(Icons.person_outline)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)), Text('${isRtl ? 'شماره دانشجویی' : 'Student ID'}: ${student.studentId}'), Text('${isRtl ? 'پاسپورت' : 'Passport'}: P-${student.studentId}') ])),
        if (widget.canEdit) IconButton(tooltip: isRtl ? 'ویرایش اطلاعات آموزشی' : 'Edit education information', icon: const Icon(Icons.edit_outlined), onPressed: () => _showEditStudentDialog(student, isRtl)),
      ]),
      const Divider(height: 24),
      Wrap(spacing: 8, runSpacing: 8, children: [Chip(label: Text(isRtl ? 'وضعیت آموزشی: فعال' : 'Academic status: Active')), Chip(label: Text(isRtl ? 'مقطع: کارشناسی' : 'Level: Bachelor')), Chip(label: Text(isRtl ? 'رشته: مهندسی کامپیوتر' : 'Major: Computer Engineering'))]),
    ])));
  }

  Widget _buildWeeklySchedule(List<EducationManagedClassModel> classes, bool isRtl) {
    final List<String> days = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه'];
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isRtl ? 'برنامه هفتگی کلاس‌ها' : 'Weekly class schedule', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 12),
      if (classes.isEmpty) Text(isRtl ? 'برای این دانشجو کلاسی ثبت نشده است.' : 'No classes registered for this student.') else ...days.map((day) {
        final List<EducationManagedClassModel> dayClasses = classes.where((c) => c.weekDay == day).toList();
        return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: dayClasses.isEmpty ? Colors.grey.withValues(alpha: 0.06) : Colors.green.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withValues(alpha: 0.18))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          if (dayClasses.isEmpty) Text(isRtl ? 'کلاسی ثبت نشده' : 'No class', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)) else ...dayClasses.map((c) => ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: const Icon(Icons.school_outlined), title: Text(c.title), subtitle: Text('${c.professorName} | ${_formatTime(c.startTime)} - ${_formatTime(c.endTime)} | ${c.semester}'))),
        ]));
      }),
    ])));
  }

  Widget _buildAcademicReports(List<EducationManagedClassModel> classes, bool isRtl) {
    final int finished = classes.where((c) => c.status == LiveClassStatus.finished).length;
    final int active = classes.where((c) => c.status == LiveClassStatus.active || c.status == LiveClassStatus.scheduled || c.status == LiveClassStatus.waitingForProfessor).length;
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isRtl ? 'گزارش آموزشی' : 'Academic report', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 10),
      _reportRow(isRtl ? 'تعداد کل دروس' : 'Total courses', classes.length.toString()),
      _reportRow(isRtl ? 'کلاس‌های فعال/زمان‌بندی‌شده' : 'Active/scheduled classes', active.toString()),
      _reportRow(isRtl ? 'کلاس‌های گذشته' : 'Past classes', finished.toString()),
      _reportRow(isRtl ? 'میانگین وضعیت حضور' : 'Attendance overview', isRtl ? 'قابل بررسی از گزارش کلاس‌ها' : 'Available in class reports'),
    ])));
  }

  Widget _buildFinanceAndDiscipline(StudentInClassModel student, bool isRtl) {
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isRtl ? 'مالی، انضباطی و تسویه حساب' : 'Finance, discipline and clearance', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 10),
      _reportRow(isRtl ? 'وضعیت مالی' : 'Financial status', student.id == 's001' ? (isRtl ? 'تسویه شده' : 'Cleared') : (isRtl ? 'دارای بدهی شهریه' : 'Tuition debt')),
      _reportRow(isRtl ? 'ارسال‌شده از واحد مالی' : 'Sent by finance unit', isRtl ? 'بله' : 'Yes'),
      _reportRow(isRtl ? 'گزارش انضباطی' : 'Discipline report', isRtl ? 'بدون مورد فعال' : 'No active issue'),
      const SizedBox(height: 8),
      Text(isRtl ? 'نکته: اطلاعات مالی و انضباطی فقط قابل مشاهده است و در پنل آموزش قابل ویرایش نیست.' : 'Note: finance and discipline data are view-only in the education panel.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
    ])));
  }

  Widget _reportRow(String title, String value) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Expanded(child: Text(title)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]));

  void _showEditStudentDialog(StudentInClassModel student, bool isRtl) {
    noteCtrl.text = isRtl ? 'ویرایش اطلاعات آموزشی، دروس و برنامه هفتگی مجاز است.' : 'Education information, courses and weekly schedule can be edited.';
    showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: Text(isRtl ? 'ویرایش اطلاعات آموزشی' : 'Edit academic information'), content: TextField(controller: noteCtrl, maxLines: 4, decoration: InputDecoration(labelText: isRtl ? 'یادداشت آموزشی' : 'Academic note', border: const OutlineInputBorder())), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(isRtl ? 'انصراف' : 'Cancel')), ElevatedButton(onPressed: () { Navigator.pop(dialogContext); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isRtl ? 'اطلاعات آموزشی ذخیره شد.' : 'Academic information saved.'))); }, child: Text(isRtl ? 'ذخیره' : 'Save'))]));
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// کارت واحد مدیر
class _ManagerUnitCard extends StatelessWidget {
  final UnitModel unit;
  final VoidCallback onTap;

  const _ManagerUnitCard({
    required this.unit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.1),
              child: Icon(unit.icon, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    appText(selectedLang, unit.keyName),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRtl ? 'مدیریت این واحد' : 'Manage this unit',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
// --- مدل پیام کلاسی ---
class ClassMessage {
  final String id;
  final String studentId;
  final String studentName;
  final String message;
  final DateTime timestamp;
  final bool isFromProfessor;
  final String? fileUrl;
  final String? fileType;

  ClassMessage({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.message,
    required this.timestamp,
    this.isFromProfessor = false,
    this.fileUrl,
    this.fileType,
  });
}

// --- مدل فایل کلاس ---
class ClassFile {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final String uploadedBy;
  final DateTime uploadedAt;

  ClassFile({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}

// --- مدل گزارش کلاس ---
class ClassReport {
  final String classId;
  final String className;
  final DateTime date;
  final int totalMessages;
  final int totalStudents;
  final int activeStudents;
  final String professorName;
  final List<String> activeStudentsList;

  ClassReport({
    required this.classId,
    required this.className,
    required this.date,
    required this.totalMessages,
    required this.totalStudents,
    required this.activeStudents,
    required this.professorName,
    required this.activeStudentsList,
  });
}

// --- صفحه کلاس درس استاد (نسخه جدید) ---
class ProfessorClassScreen extends StatefulWidget {
  final ClassModel classModel;

  const ProfessorClassScreen({super.key, required this.classModel});

  @override
  State<ProfessorClassScreen> createState() => _ProfessorClassScreenState();
}

class _ProfessorClassScreenState extends State<ProfessorClassScreen>
    with SingleTickerProviderStateMixin {
  late List<ClassMessage> messages;
  late List<StudentInClassModel> students;
  final TextEditingController inputController = TextEditingController();
  late TabController _tabController;
  int selectedStudentIndex = -1; // -1 means class chat (all students)
  bool isClassChat = true;
  bool isClassActive = true;

  // مدیریت فایل
  final List<ClassFile> classFiles = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStudents();
    _loadMessages();
    _sendClassStartNotification();
  }

  void _loadStudents() {
    students = mockStudents
        .where((s) => widget.classModel.studentIds.contains(s.id))
        .toList();
  }

  void _loadMessages() {
    messages = [
      ClassMessage(
        id: '1',
        studentId: 'system',
        studentName: 'سیستم',
        message: 'کلاس آغاز شد. به جمع دانشجویان خوش آمدید.',
        timestamp: DateTime.now(),
        isFromProfessor: false,
      ),
    ];
  }

  void _sendClassStartNotification() {
    final appState = Provider.of<AppState>(context, listen: false);
    final notification = AppNotification(
      title: 'شروع کلاس ${widget.classModel.name}',
      subtitle: 'کلاس توسط استاد آغاز شد.',
      unitKey: 'education',
      unread: true,
    );
    appState.addNotificationForRole('education', notification);
  }

  void sendMessageToAll(String message, {String? fileUrl, String? fileType}) {
    if (message.trim().isEmpty && fileUrl == null) return;

    final appState = Provider.of<AppState>(context, listen: false);
    final professor = mockProfessors.firstWhere((p) => p.id == appState.userIdentifier);

    setState(() {
      messages.add(ClassMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: appState.userIdentifier,
        studentName: professor.name,
        message: message,
        timestamp: DateTime.now(),
        isFromProfessor: true,
        fileUrl: fileUrl,
        fileType: fileType,
      ));
      inputController.clear();
    });

    _sendReportToEducation();
  }

  void sendMessageToStudent(String studentId, String message) {
    if (message.trim().isEmpty) return;

    final student = students.firstWhere((s) => s.id == studentId);

    setState(() {
      messages.add(ClassMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: studentId,
        studentName: student.name,
        message: message,
        timestamp: DateTime.now(),
        isFromProfessor: true,
      ));
      inputController.clear();
    });
  }

  void removeStudent(String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف دانشجو'),
        content: Text('آیا از حذف این دانشجو از کلاس اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                students.removeWhere((s) => s.id == studentId);
                if (selectedStudentIndex >= students.length) {
                  selectedStudentIndex = -1;
                  isClassChat = true;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('دانشجو از کلاس حذف شد')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void uploadFile() {
    // شبیه‌سازی آپلود فایل
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('آپلود فایل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('جزوه درس 1'),
              onTap: () {
                sendMessageToAll('', fileUrl: 'https://example.com/file1.pdf', fileType: 'pdf');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('ویدیو آموزشی جلسه 1'),
              onTap: () {
                sendMessageToAll('', fileUrl: 'https://example.com/video1.mp4', fileType: 'video');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('تمرین سری 1'),
              onTap: () {
                sendMessageToAll('', fileUrl: 'https://example.com/homework1.docx', fileType: 'doc');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendReportToEducation() {
    final appState = Provider.of<AppState>(context, listen: false);
    final report = ClassReport(
      classId: widget.classModel.id,
      className: widget.classModel.name,
      date: DateTime.now(),
      totalMessages: messages.length,
      totalStudents: students.length,
      activeStudents: messages.map((m) => m.studentId).toSet().length,
      professorName: mockProfessors.firstWhere((p) => p.id == appState.userIdentifier).name,
      activeStudentsList: messages.map((m) => m.studentId).toSet().toList(),
    );
    
    // ارسال گزارش به واحد آموزش
    final notification = AppNotification(
      title: 'گزارش کلاس ${widget.classModel.name}',
      subtitle: 'تعداد پیام‌ها: ${report.totalMessages} - دانشجویان فعال: ${report.activeStudents}',
      unitKey: 'education',
      unread: true,
    );
    appState.addNotificationForRole('manager', notification);
  }

  void endClass() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('پایان کلاس'),
        content: const Text('آیا از پایان کلاس اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isClassActive = false;
              });
              _sendReportToEducation();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('کلاس پایان یافت. گزارش به آموزش ارسال شد.')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('پایان کلاس'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedLang = appState.selectedLang;
    final isRtl = isRtlLang(selectedLang);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= kTabletBreakpoint;

    if (!isClassActive) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.classModel.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                isRtl ? 'این کلاس پایان یافته است.' : 'This class has ended.',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isRtl ? 'بازگشت' : 'Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.classModel.name} - ${isRtl ? 'مدیریت کلاس' : 'Class Management'}'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: endClass,
            icon: const Icon(Icons.power_settings_new),
            tooltip: isRtl ? 'پایان کلاس' : 'End Class',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: isRtl ? 'گفتگوی کلاس' : 'Class Chat'),
            Tab(text: isRtl ? 'دانشجویان' : 'Students'),
            Tab(text: isRtl ? 'فایل‌ها' : 'Files'),
            Tab(text: isRtl ? 'اطلاعات کلاس' : 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClassChatTab(),
          _buildStudentsTab(),
          _buildFilesTab(),
          _buildClassInfoTab(),
        ],
      ),
    );
  }

  // تب گفتگوی کلاس
  Widget _buildClassChatTab() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);

    return Column(
      children: [
        // انتخاب مخاطب
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ChatTargetChip(
                  label: isRtl ? 'گفتگوی کلاس' : 'Class Chat',
                  isSelected: isClassChat,
                  onTap: () {
                    setState(() {
                      isClassChat = true;
                      selectedStudentIndex = -1;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...students.asMap().entries.map((entry) {
                  return _ChatTargetChip(
                    label: entry.value.name,
                    isSelected: !isClassChat && selectedStudentIndex == entry.key,
                    onTap: () {
                      setState(() {
                        isClassChat = false;
                        selectedStudentIndex = entry.key;
                      });
                    },
                  );
                }),
              ],
            ),
          ),
        ),
        // لیست پیام‌ها
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMyMessage = msg.isFromProfessor;
              
              return _ClassMessageBubble(
                message: msg,
                isMyMessage: isMyMessage,
                isRtl: isRtl,
              );
            },
          ),
        ),
        // ورودی پیام
        _buildMessageInput(),
      ],
    );
  }

  // تب دانشجویان
  Widget _buildStudentsTab() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(student.name.substring(0, 1)),
            ),
            title: Text(student.name),
            subtitle: Text('${isRtl ? 'شماره دانشجویی' : 'Student ID'}: ${student.studentId}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => removeStudent(student.id),
              tooltip: isRtl ? 'حذف دانشجو' : 'Remove Student',
            ),
            onTap: () {
              setState(() {
                isClassChat = false;
                selectedStudentIndex = index;
                _tabController.animateTo(0);
              });
            },
          ),
        );
      },
    );
  }

  // تب فایل‌ها
  Widget _buildFilesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: uploadFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('آپلود فایل جدید'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.where((m) => m.fileUrl != null).length,
            itemBuilder: (context, index) {
              final fileMessages = messages.where((m) => m.fileUrl != null).toList();
              final msg = fileMessages[index];
              return ListTile(
                leading: _getFileIcon(msg.fileType), 
                title: Text(msg.message.isEmpty ? 'فایل پیوست شده' : msg.message),
                subtitle: Text('${msg.studentName} - ${_formatDate(msg.timestamp)}'),
                trailing: const Icon(Icons.download),
                onTap: () {
                  // دانلود فایل
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('در حال دانلود فایل...')),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // تب اطلاعات کلاس
  Widget _buildClassInfoTab() {
    final appState = Provider.of<AppState>(context);
    final selectedLang = appState.selectedLang;
    final isRtl = isRtlLang(selectedLang);
    final professor = mockProfessors.firstWhere((p) => p.id == appState.userIdentifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.school,
            label: isRtl ? 'نام کلاس' : 'Class Name',
            value: widget.classModel.name,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.person,
            label: isRtl ? 'استاد' : 'Professor',
            value: professor.name,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.people,
            label: isRtl ? 'تعداد دانشجویان' : 'Students Count',
            value: '${students.length}',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.message,
            label: isRtl ? 'تعداد پیام‌ها' : 'Messages Count',
            value: '${messages.length}',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.attach_file,
            label: isRtl ? 'فایل‌های ارسال شده' : 'Shared Files',
            value: '${messages.where((m) => m.fileUrl != null).length}',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isRtl 
                      ? 'تمامی فعالیت‌های این کلاس به واحد آموزش گزارش می‌شود.'
                      : 'All activities in this class are reported to the Education department.',
                    style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: uploadFile,
            icon: const Icon(Icons.attach_file),
            tooltip: isRtl ? 'ارسال فایل' : 'Attach File',
          ),
          Expanded(
            child: TextField(
              controller: inputController,
              decoration: InputDecoration(
                hintText: isRtl ? 'پیام خود را بنویسید...' : 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onSubmitted: (_) {
                if (isClassChat) {
                  sendMessageToAll(inputController.text);
                } else if (selectedStudentIndex >= 0) {
                  sendMessageToStudent(students[selectedStudentIndex].id, inputController.text);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.green,
            child: IconButton(
              onPressed: () {
                if (isClassChat) {
                  sendMessageToAll(inputController.text);
                } else if (selectedStudentIndex >= 0) {
                  sendMessageToStudent(students[selectedStudentIndex].id, inputController.text);
                }
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFileIcon(String? fileType) {
    switch (fileType) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case 'video':
        return const Icon(Icons.video_library, color: Colors.blue);
      case 'doc':
        return const Icon(Icons.description, color: Colors.green);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
  }
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inHours < 24) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

// --- کامپوننت حباب پیام ---
class _ClassMessageBubble extends StatelessWidget {
  final ClassMessage message;
  final bool isMyMessage;
  final bool isRtl;

  const _ClassMessageBubble({
    required this.message,
    required this.isMyMessage,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMyMessage
          ? (isRtl ? Alignment.centerLeft : Alignment.centerRight)
          : (isRtl ? Alignment.centerRight : Alignment.centerLeft),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyMessage)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  message.studentName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMyMessage ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.message.isNotEmpty)
                    Text(message.message, style: const TextStyle(fontSize: 14)),
                  if (message.fileUrl != null)
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('در حال دانلود فایل...')),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getFileIcon(message.fileType), 
                            const SizedBox(width: 8),
                            Text(
                              message.fileType == 'pdf' ? 'جزوه.pdf' :
                              message.fileType == 'video' ? 'ویدیو.mp4' : 'فایل.docx',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFileIcon(String? fileType) {
    switch (fileType) {
      case 'pdf': 
        return const Icon(Icons.picture_as_pdf, size: 20, color: Colors.red);
      case 'video': 
        return const Icon(Icons.video_library, size: 20, color: Colors.blue);
      case 'doc': 
        return const Icon(Icons.description, size: 20, color: Colors.green);
      default: 
        return const Icon(Icons.insert_drive_file, size: 20, color: Colors.grey);
    }
  }
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// --- کامپوننت انتخاب مخاطب چت ---
class _ChatTargetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChatTargetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.green.shade100,
    );
  }
}

// --- کامپوننت ردیف اطلاعات ---
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
// --- صفحه نظارت بر کلاس‌ها برای مدیر آموزش ---
class EducationMonitoringScreen extends StatefulWidget {
  const EducationMonitoringScreen({super.key});

  @override
  State<EducationMonitoringScreen> createState() => _EducationMonitoringScreenState();
}

class _EducationMonitoringScreenState extends State<EducationMonitoringScreen> {
  final List<ClassReport> reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    // بارگذاری گزارش‌ها از AppState
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);

    return Scaffold(
      appBar: AppBar(
        title: Text(isRtl ? 'نظارت بر کلاس‌ها' : 'Class Monitoring'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockClasses.length,
        itemBuilder: (context, index) {
          final classModel = mockClasses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: const Icon(Icons.class_, color: Colors.blue),
              title: Text(classModel.name),
              subtitle: Text('${isRtl ? 'تعداد دانشجویان' : 'Students'}: ${classModel.studentIds.length}'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        icon: Icons.person,
                        label: isRtl ? 'استاد' : 'Professor',
                        value: mockProfessors.firstWhere((p) => p.id == classModel.professorId).name,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.group,
                        label: isRtl ? 'لیست دانشجویان' : 'Students List',
                        value: '',
                      ),
                      const SizedBox(height: 8),
                      ...classModel.studentIds.map((studentId) {
                        final student = mockStudents.firstWhere((s) => s.id == studentId);
                        return Padding(
                          padding: const EdgeInsets.only(left: 24, top: 4),
                          child: Text('• ${student.name} (${student.studentId})'),
                        );
                      }),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // مشاهده گزارش کلاس
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('در حال نمایش گزارش کلاس...')),
                                );
                              },
                              icon: const Icon(Icons.assessment),
                              label: Text(isRtl ? 'مشاهده گزارش' : 'View Report'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                // ورود به کلاس برای نظارت
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('ورود به کلاس به عنوان ناظر...')),
                                );
                              },
                              icon: const Icon(Icons.visibility),
                              label: Text(isRtl ? 'نظارت بر کلاس' : 'Monitor Class'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
// ==================== کلاس‌های پیام ====================

// برای SupportChatScreen (چت داخل اپلیکیشن)
// خط ~ آخر فایل - کلاس ChatMessage (برای SupportChatScreen)
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

