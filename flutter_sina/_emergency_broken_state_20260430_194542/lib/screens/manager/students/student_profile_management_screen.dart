import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../data/mock/mock_users.dart';
import '../../../models/users/student_in_class_model.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class StudentProfileManagementScreen extends StatefulWidget {
  const StudentProfileManagementScreen({super.key});

  @override
  State<StudentProfileManagementScreen> createState() =>
      _StudentProfileManagementScreenState();
}

class _StudentProfileManagementScreenState
    extends State<StudentProfileManagementScreen> {
  String query = '';

  List<StudentInClassModel> filteredStudents() {
    final String q = query.trim().toLowerCase();

    if (q.isEmpty) return mockStudents;

    return mockStudents.where((StudentInClassModel student) {
      return student.name.toLowerCase().contains(q) ||
          student.studentId.toLowerCase().contains(q) ||
          student.id.toLowerCase().contains(q);
    }).toList();
  }

  void openStudentFile(StudentInClassModel student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _StudentFullFileScreen(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final List<StudentInClassModel> students = filteredStudents();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'students'),
          icon: Icons.people_outline,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'جستجوی دانشجو',
                hintText: 'نام، شماره دانشجویی یا شناسه',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'فهرست دانشجویان',
          icon: Icons.list_alt_outlined,
          child: students.isEmpty
              ? const EmptyState(message: 'دانشجویی پیدا نشد.')
              : Column(
                  children: students.map((student) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person_outline),
                      ),
                      title: Text(student.name),
                      subtitle: Text('شماره دانشجویی: ${student.studentId}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => openStudentFile(student),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _StudentFullFileScreen extends StatelessWidget {
  final StudentInClassModel student;

  const _StudentFullFileScreen({
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final classes = appState.getStudentClasses(student.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('پرونده ${student.name}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SectionCard(
            title: 'پروفایل دانشجو',
            icon: Icons.person_outline,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('نام'),
                  subtitle: Text(student.name),
                  trailing: IconButton(
                    tooltip: 'ویرایش',
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('شماره دانشجویی'),
                  subtitle: Text(student.studentId),
                ),
                const ListTile(
                  leading: Icon(Icons.public_outlined),
                  title: Text('ملیت'),
                  subtitle: Text('ثبت نشده'),
                  trailing: Icon(Icons.edit_outlined),
                ),
                const ListTile(
                  leading: Icon(Icons.phone_outlined),
                  title: Text('شماره تماس'),
                  subtitle: Text('ثبت نشده'),
                  trailing: Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'دروس و کلاس‌ها',
            icon: Icons.school_outlined,
            child: classes.isEmpty
                ? const EmptyState(message: 'کلاسی برای این دانشجو ثبت نشده است.')
                : Column(
                    children: classes.map((item) {
                      return ListTile(
                        leading: const Icon(Icons.class_outlined),
                        title: Text(item.title),
                        subtitle: Text(
                          '${item.weekDay} | ${formatTimeOfDay(item.startTime)} - ${formatTimeOfDay(item.endTime)}\n'
                          'استاد: ${item.professorName}',
                        ),
                        isThreeLine: true,
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'برنامه هفتگی',
            icon: Icons.calendar_month_outlined,
            child: classes.isEmpty
                ? const EmptyState(message: 'برنامه هفتگی ثبت نشده است.')
                : Column(
                    children: classes.map((item) {
                      return ListTile(
                        leading: const Icon(Icons.event_note_outlined),
                        title: Text(item.weekDay),
                        subtitle: Text(
                          '${item.title} | ${formatTimeOfDay(item.startTime)} - ${formatTimeOfDay(item.endTime)}',
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'گزارش آموزشی',
            icon: Icons.analytics_outlined,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.class_outlined),
                  title: const Text('تعداد کلاس‌ها'),
                  subtitle: Text('${classes.length} کلاس'),
                ),
                const ListTile(
                  leading: Icon(Icons.grade_outlined),
                  title: Text('میانگین وضعیت آموزشی'),
                  subtitle: Text('در حال تکمیل'),
                  trailing: Icon(Icons.edit_outlined),
                ),
                const ListTile(
                  leading: Icon(Icons.note_alt_outlined),
                  title: Text('یادداشت آموزشی'),
                  subtitle: Text('قابل ویرایش توسط مدیر/کارشناس آموزش'),
                  trailing: Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SectionCard(
            title: 'وضعیت مالی / تسویه حساب',
            icon: Icons.account_balance_wallet_outlined,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.payments_outlined),
                  title: Text('وضعیت تسویه'),
                  subtitle: Text('نمایشی - توسط واحد مالی ارسال می‌شود'),
                  trailing: Chip(label: Text('در انتظار اطلاعات مالی')),
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('امکان ویرایش'),
                  subtitle: Text('مدیر/کارشناس آموزش اجازه ویرایش این بخش را ندارد.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SectionCard(
            title: 'گزارش انضباطی',
            icon: Icons.gavel_outlined,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.verified_user_outlined),
                  title: Text('وضعیت انضباطی'),
                  subtitle: Text('نمایشی - توسط واحد مربوطه ثبت می‌شود'),
                  trailing: Chip(label: Text('بدون گزارش')),
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('امکان ویرایش'),
                  subtitle: Text('مدیر/کارشناس آموزش اجازه ویرایش این بخش را ندارد.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
