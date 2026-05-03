import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/user_models.dart';
import '../data/mock_data.dart';
import 'login_screen.dart';

class EducationAdminScreen extends StatefulWidget {
  const EducationAdminScreen({super.key});

  @override
  State<EducationAdminScreen> createState() => _EducationAdminScreenState();
}

class _EducationAdminScreenState extends State<EducationAdminScreen> {
  List<ClassModel> _classes = [];
  List<Professor> _professors = [];
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _classes = List.from(mockClasses);
    _professors = List.from(mockProfessors);
    _students = List.from(mockStudents);
  }

  void _addNewClass() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController semesterController = TextEditingController();
    final TextEditingController scheduleController = TextEditingController();
    Professor? selectedProfessor = _professors.isNotEmpty ? _professors.first : null;
    List<String> selectedStudentIds = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('ایجاد کلاس جدید'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'نام کلاس', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: semesterController,
                      decoration: const InputDecoration(labelText: 'ترم تحصیلی', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: scheduleController,
                      decoration: const InputDecoration(labelText: 'روز و ساعت (مثال: شنبه 10:00-12:00)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Professor>(
                      value: selectedProfessor,
                      decoration: const InputDecoration(labelText: 'استاد', border: OutlineInputBorder()),
                      items: _professors.map((prof) => DropdownMenuItem(value: prof, child: Text(prof.name))).toList(),
                      onChanged: (value) => setStateDialog(() => selectedProfessor = value),
                    ),
                    const SizedBox(height: 12),
                    const Text('انتخاب دانشجویان:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: ListView.builder(
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final student = _students[index];
                          final isSelected = selectedStudentIds.contains(student.id);
                          return CheckboxListTile(
                            title: Text('${student.name} (${student.studentId})'),
                            value: isSelected,
                            onChanged: (checked) {
                              setStateDialog(() {
                                if (checked == true) {
                                  selectedStudentIds.add(student.id);
                                } else {
                                  selectedStudentIds.remove(student.id);
                                }
                              });
                            },
                            dense: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && semesterController.text.isNotEmpty && selectedProfessor != null) {
                    final selectedStudents = _students.where((s) => selectedStudentIds.contains(s.id)).toList();
                    final newClass = ClassModel(
                      id: 'c${_classes.length + 1}',
                      name: nameController.text,
                      professorId: selectedProfessor!.id,
                      professorName: selectedProfessor!.name,
                      studentIds: selectedStudentIds,
                      studentNames: selectedStudents.map((s) => s.name).toList(),
                      semester: semesterController.text,
                      schedule: scheduleController.text,
                      isActive: false,
                    );
                    setState(() {
                      _classes.add(newClass);
                      addNewClass(newClass);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کلاس با موفقیت ایجاد شد'), backgroundColor: Colors.green));
                  }
                },
                child: const Text('ایجاد کلاس'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteClass(ClassModel classItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف کلاس'),
        content: Text('آیا از حذف کلاس "${classItem.name}" اطمینان دارید؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _classes.remove(classItem);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کلاس حذف شد'), backgroundColor: Colors.red));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مدیریت آموزش'),
          centerTitle: true,
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          actions: [
            IconButton(icon: const Icon(Icons.add), onPressed: _addNewClass),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                appState.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            ),
          ],
        ),
        body: _classes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.class_, size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    const Text('هیچ کلاسی ایجاد نشده است'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(onPressed: _addNewClass, icon: const Icon(Icons.add), label: const Text('ایجاد اولین کلاس')),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _classes.length,
                itemBuilder: (context, index) {
                  final classItem = _classes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ExpansionTile(
                      leading: CircleAvatar(backgroundColor: Colors.purple.withOpacity(0.1), child: const Icon(Icons.class_, color: Colors.purple)),
                      title: Text(classItem.name),
                      subtitle: Text('استاد: ${classItem.professorName} | ${classItem.semester}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteClass(classItem)),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(Icons.calendar_today, 'زمان برگزاری', classItem.schedule),
                              const SizedBox(height: 8),
                              _infoRow(Icons.people, 'تعداد دانشجویان', '${classItem.studentIds.length}'),
                              const SizedBox(height: 8),
                              _infoRow(Icons.person, 'استاد', classItem.professorName),
                              const SizedBox(height: 16),
                              const Text('لیست دانشجویان:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ...classItem.studentNames.map((name) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(children: [const Icon(Icons.person, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(name)]),
                              )),
                              if (classItem.studentNames.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('هیچ دانشجویی ثبت نام نشده است')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewClass,
          backgroundColor: Colors.purple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(children: [Icon(icon, size: 18, color: Colors.grey), const SizedBox(width: 8), Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)), Text(value)]);
  }
}
