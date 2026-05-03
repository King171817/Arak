import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/user_models.dart';
import '../data/mock_data.dart';
import '../screens/class_session_screen.dart';
import '../screens/login_screen.dart';
import 'professor_class_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/user_models.dart';
import '../data/mock_data.dart';
import '../screens/class_session_screen.dart';
import 'professor_class_management.dart';

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
    _myClasses = getClassesForProfessor(appState.userIdentifier);
  }

  void _startClass(String classId) {
    setState(() {
      final index = _myClasses.indexWhere((c) => c.id == classId);
      if (index != -1) {
        final classItem = _myClasses[index];
        _myClasses[index] = ClassModel(
          id: classItem.id,
          name: classItem.name,
          professorId: classItem.professorId,
          professorName: classItem.professorName,
          studentIds: classItem.studentIds,
          studentNames: classItem.studentNames,
          semester: classItem.semester,
          schedule: classItem.schedule,
          isActive: true,
        );
        // ??????????? ?? ????? ????
        final mockIndex = mockClasses.indexWhere((c) => c.id == classId);
        if (mockIndex != -1) {
          mockClasses[mockIndex] = _myClasses[index];
        }
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('? ???? ???? ??! ????????? ????????? ???? ????'), backgroundColor: Colors.green),
    );
  }

  void _endClass(String classId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('????? ????'),
        content: const Text('??? ?? ????? ???? ??????? ??????'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('??????')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _myClasses.indexWhere((c) => c.id == classId);
                if (index != -1) {
                  final classItem = _myClasses[index];
                  _myClasses[index] = ClassModel(
                    id: classItem.id,
                    name: classItem.name,
                    professorId: classItem.professorId,
                    professorName: classItem.professorName,
                    studentIds: classItem.studentIds,
                    studentNames: classItem.studentNames,
                    semester: classItem.semester,
                    schedule: classItem.schedule,
                    isActive: false,
                  );
                  final mockIndex = mockClasses.indexWhere((c) => c.id == classId);
                  if (mockIndex != -1) {
                    mockClasses[mockIndex] = _myClasses[index];
                  }
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('? ???? ????? ????'), backgroundColor: Colors.orange),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('????? ????'),
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
          title: const Text('??? ?????'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('??????? ?? ??? ?????'))),
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.class_), label: '???????'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: '?????????'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '???????'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfessorClassManagementScreen()),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
          tooltip: '??????? ???? ????',
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildClassesTab();
      case 1:
        return _buildStudentsTab();
      default:
        return _buildSettingsTab();
    }
  }

  Widget _buildClassesTab() {
    if (_myClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('??? ????? ???? ??? ??? ???? ???'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfessorClassManagementScreen()));
              },
              icon: const Icon(Icons.add),
              label: const Text('??????? ???? ????'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myClasses.length,
      itemBuilder: (context, index) {
        final classItem = _myClasses[index];
        return _buildClassCard(classItem);
      },
    );
  }

  Widget _buildClassCard(ClassModel classItem) {
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.class_, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(classItem.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('???: ${classItem.semester}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: classItem.isActive ? Colors.green : Colors.orange, borderRadius: BorderRadius.circular(12)),
                  child: Text(classItem.isActive ? '????' : '???????', style: const TextStyle(color: Colors.white, fontSize: 10)),
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
                Text('${classItem.studentIds.length} ??????', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('?????? ????'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(width: 12),
                if (!classItem.isActive)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _startClass(classItem.id),
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('???? ????'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _endClass(classItem.id),
                      icon: const Icon(Icons.stop, size: 18),
                      label: const Text('????? ????'),
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
        allStudents.add({'name': classItem.studentNames[i], 'class': classItem.name, 'studentId': classItem.studentIds[i]});
      }
    }

    if (allStudents.isEmpty) {
      return const Center(child: Text('??? ???????? ?? ???????? ??? ??? ??? ????? ???'));
    }

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
            subtitle: Text('${student['class']} | ${student['studentId']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('????? ???? ?? ${student['name']} ?? ??? ?????')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
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
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Text('?????')),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(leading: const Icon(Icons.class_), title: const Text('????? ???????'), trailing: Text('${_myClasses.length}')),
                  const Divider(),
                  ListTile(leading: const Icon(Icons.people), title: const Text('????? ?????????'), trailing: Text('${_myClasses.fold(0, (sum, c) => sum + c.studentIds.length)}')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                appState.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('???? ?? ????'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }
}

