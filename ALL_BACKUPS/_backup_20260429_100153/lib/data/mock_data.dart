import '../models/user_models.dart';

final List<Student> mockStudents = [
  Student(id: 's001', name: 'رضا حسینی', studentId: '40210001', classIds: ['c001', 'c002']),
  Student(id: 's002', name: 'علی احمدی', studentId: '40210002', classIds: ['c001', 'c003']),
  Student(id: 's003', name: 'فاطمه رضایی', studentId: '40210003', classIds: ['c002']),
  Student(id: 's004', name: 'Sara Smith', studentId: '40210004', classIds: ['c002', 'c003']),
];

final List<Professor> mockProfessors = [
  Professor(id: 'p001', name: 'دکتر محمدی', professorId: 'p001', classIds: ['c001', 'c002']),
  Professor(id: 'p002', name: 'Dr. Johnson', professorId: 'p002', classIds: ['c003']),
];

List<ClassModel> mockClasses = [
  ClassModel(
    id: 'c001',
    name: 'برنامه نویسی پیشرفته',
    professorId: 'p001',
    professorName: 'دکتر محمدی',
    studentIds: ['s001', 's002'],
    studentNames: ['رضا حسینی', 'علی احمدی'],
    semester: '1403-1',
    schedule: 'شنبه 10:00-12:00',
    isActive: false,
  ),
  ClassModel(
    id: 'c002',
    name: 'پایگاه داده',
    professorId: 'p001',
    professorName: 'دکتر محمدی',
    studentIds: ['s001', 's003', 's004'],
    studentNames: ['رضا حسینی', 'فاطمه رضایی', 'Sara Smith'],
    semester: '1403-1',
    schedule: 'دوشنبه 14:00-16:00',
    isActive: false,
  ),
  ClassModel(
    id: 'c003',
    name: 'Data Structures',
    professorId: 'p002',
    professorName: 'Dr. Johnson',
    studentIds: ['s002', 's004'],
    studentNames: ['علی احمدی', 'Sara Smith'],
    semester: '1403-1',
    schedule: 'سه‌شنبه 08:00-10:00',
    isActive: false,
  ),
];

List<ClassModel> getClassesForStudent(String studentId) {
  final student = mockStudents.firstWhere((s) => s.id == studentId);
  return mockClasses.where((c) => student.classIds.contains(c.id)).toList();
}

List<ClassModel> getClassesForProfessor(String professorId) {
  return mockClasses.where((c) => c.professorId == professorId).toList();
}

void addNewClass(ClassModel newClass) {
  mockClasses.add(newClass);
}

void updateClassStatus(String classId, bool isActive) {
  final index = mockClasses.indexWhere((c) => c.id == classId);
  if (index != -1) {
    mockClasses[index].isActive = isActive;
  }
}
