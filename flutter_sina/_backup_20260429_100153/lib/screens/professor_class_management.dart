import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/user_models.dart';
import '../data/mock_data.dart';

class ProfessorClassManagementScreen extends StatefulWidget {
  const ProfessorClassManagementScreen({super.key});

  @override
  State<ProfessorClassManagementScreen> createState() => _ProfessorClassManagementScreenState();
}

class _ProfessorClassManagementScreenState extends State<ProfessorClassManagementScreen> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  
  List<String> _selectedStudentIds = [];
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
    // لیست دانشجویانی که در کلاس‌های دیگر این استاد نیستند
    final professorClasses = getClassesForProfessor(appState.userId);
    final existingStudentIds = professorClasses.expand((c) => c.studentIds).toSet();
    final availableStudents = mockStudents.where((s) => !existingStudentIds.contains(s.id)).toList();
    
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('درخواست کلاس جدید'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // فرم اطلاعات کلاس
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'اطلاعات کلاس',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      TextField(
                        controller: _classNameController,
                        decoration: const InputDecoration(
                          labelText: 'نام کلاس',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.class_),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      TextField(
                        controller: _semesterController,
                        decoration: const InputDecoration(
                          labelText: 'ترم تحصیلی',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      TextField(
                        controller: _scheduleController,
                        decoration: const InputDecoration(
                          labelText: 'روز و ساعت (مثال: شنبه 10:00-12:00)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // انتخاب دانشجویان
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'انتخاب دانشجویان',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_selectedStudentIds.length} دانشجو انتخاب شده',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      
                      if (availableStudents.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('هیچ دانشجوی دیگری برای اضافه کردن وجود ندارد'),
                          ),
                        )
                      else
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: availableStudents.length,
                            itemBuilder: (context, index) {
                              final student = availableStudents[index];
                              final isSelected = _selectedStudentIds.contains(student.id);
                              return CheckboxListTile(
                                title: Text('${student.name} (${student.studentId})'),
                                value: isSelected,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      _selectedStudentIds.add(student.id);
                                    } else {
                                      _selectedStudentIds.remove(student.id);
                                    }
                                  });
                                },
                                secondary: CircleAvatar(
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  child: const Icon(Icons.person, color: Colors.blue),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // دکمه ارسال درخواست
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ارسال درخواست به مدیریت آموزش',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _submitRequest() {
    if (_classNameController.text.isEmpty) {
      _showError('لطفاً نام کلاس را وارد کنید');
      return;
    }
    
    if (_semesterController.text.isEmpty) {
      _showError('لطفاً ترم تحصیلی را وارد کنید');
      return;
    }
    
    if (_scheduleController.text.isEmpty) {
      _showError('لطفاً روز و ساعت کلاس را وارد کنید');
      return;
    }
    
    final appState = Provider.of<AppState>(context, listen: false);
    final professor = mockProfessors.firstWhere((p) => p.id == appState.userId);
    final selectedStudents = mockStudents.where((s) => _selectedStudentIds.contains(s.id)).toList();
    
    // ایجاد کلاس جدید (در واقعیت اینجا به سرور ارسال می‌شود)
    final newClass = ClassModel(
      id: 'c${mockClasses.length + 1}',
      name: _classNameController.text,
      professorId: professor.id,
      professorName: professor.name,
      studentIds: _selectedStudentIds,
      studentNames: selectedStudents.map((s) => s.name).toList(),
      semester: _semesterController.text,
      schedule: _scheduleController.text,
      isActive: false,
    );
    
    // اضافه کردن به لیست (در حالت واقعی منتظر تأیید مدیر می‌ماند)
    mockClasses.add(newClass);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, size: 50, color: Colors.green),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'درخواست شما با موفقیت ثبت شد',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('پس از تأیید مدیریت آموزش، کلاس فعال خواهد شد'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('باشه'),
          ),
        ],
      ),
    );
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
