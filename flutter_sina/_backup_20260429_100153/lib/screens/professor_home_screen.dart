import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/user_models.dart';
import '../data/mock_data.dart';
import 'class_session_screen.dart';
import 'login_screen.dart';

class ProfessorHomeScreen extends StatefulWidget {
  const ProfessorHomeScreen({super.key});

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  int _selectedIndex = 0;
  late List<ClassModel> _myClasses;
  
  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _myClasses = getClassesForProfessor(appState.userId);
  }

  void _toggleClassStatus(String classId, bool isActive) {
    setState(() {
      final index = _myClasses.indexWhere((c) => c.id == classId);
      if (index != -1) {
        _myClasses[index].isActive = isActive;
        updateClassStatus(classId, isActive);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isActive ? '✅ کلاس شروع شد!' : '✅ کلاس پایان یافت'),
        backgroundColor: isActive ? Colors.green : Colors.orange,
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
          title: const Text('پنل استاد'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                appState.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'کلاس‌ها'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'دانشجویان'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'پروفایل'),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return _buildClassesTab();
      case 1: return _buildStudentsTab();
      default: return _buildProfileTab();
    }
  }

  Widget _buildClassesTab() {
    if (_myClasses.isEmpty) {
      return const Center(child: Text('هیچ کلاسی برای شما ثبت نشده است'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          final appState = Provider.of<AppState>(context, listen: false);
          _myClasses = getClassesForProfessor(appState.userId);
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _myClasses.length,
        itemBuilder: (context, index) {
          final classItem = _myClasses[index];
          return _buildClassCard(classItem);
        },
      ),
    );
  }

  Widget _buildClassCard(ClassModel classItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.class_, color: Colors.blue, size: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(classItem.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('ترم: ${classItem.semester}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: classItem.isActive ? Colors.green : Colors.orange, borderRadius: BorderRadius.circular(12)),
                  child: Text(classItem.isActive ? 'فعال' : 'غیرفعال', style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(classItem.schedule, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text('${classItem.studentIds.length} دانشجو', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClassSessionScreen(
                            classId: classItem.id,
                            className: classItem.name,
                            professorName: classItem.professorName,
                            isActive: classItem.isActive,
                            isProfessor: true,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('مشاهده کلاس'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(width: 12),
                if (!classItem.isActive)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleClassStatus(classItem.id, true),
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('شروع کلاس'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleClassStatus(classItem.id, false),
                      icon: const Icon(Icons.stop, size: 18),
                      label: const Text('پایان کلاس'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsTab() {
    final allStudents = <Map<String, String>>[];
    for (var classItem in _myClasses) {
      for (int i = 0; i < classItem.studentIds.length; i++) {
        allStudents.add({'name': classItem.studentNames[i], 'class': classItem.name});
      }
    }
    if (allStudents.isEmpty) return const Center(child: Text('هیچ دانشجویی ثبت نام نکرده است'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allStudents.length,
      itemBuilder: (context, index) {
        final student = allStudents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white)),
            title: Text(student['name']!),
            subtitle: Text(student['class']!),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  Widget _buildProfileTab() {
    final appState = Provider.of<AppState>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Colors.blue, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 16),
            Text(appState.userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Text('استاد')),
            const SizedBox(height: 24),
            Card(child: Column(children: [ListTile(leading: const Icon(Icons.class_), title: const Text('تعداد کلاس‌ها'), trailing: Text('${_myClasses.length}')), const Divider(), ListTile(leading: const Icon(Icons.people), title: const Text('تعداد دانشجویان'), trailing: Text('${_myClasses.fold(0, (sum, c) => sum + c.studentIds.length)}'))])),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                appState.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('خروج از حساب'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }
}

