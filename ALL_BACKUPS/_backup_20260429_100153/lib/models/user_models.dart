class Student {
  final String id;
  final String name;
  final String studentId;
  final List<String> classIds;
  
  Student({
    required this.id,
    required this.name,
    required this.studentId,
    required this.classIds,
  });
}

class Professor {
  final String id;
  final String name;
  final String professorId;
  final List<String> classIds;
  
  Professor({
    required this.id,
    required this.name,
    required this.professorId,
    required this.classIds,
  });
}

class ClassModel {
  final String id;
  final String name;
  final String professorId;
  final String professorName;
  final List<String> studentIds;
  final List<String> studentNames;
  final String semester;
  final String schedule;
  bool isActive;
  
  ClassModel({
    required this.id,
    required this.name,
    required this.professorId,
    required this.professorName,
    required this.studentIds,
    required this.studentNames,
    required this.semester,
    required this.schedule,
    this.isActive = false,
  });
}
