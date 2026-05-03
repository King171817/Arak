class ManagedClassModel {
  final String id;
  final String name;
  final String professorId;
  final String professorName;
  final List<String> studentIds;
  final List<String> studentNames;
  final String semester;
  final int capacity;
  String status;
  final DateTime createdAt;
  DateTime? completedAt;

  ManagedClassModel({
    required this.id,
    required this.name,
    required this.professorId,
    required this.professorName,
    required this.studentIds,
    required this.studentNames,
    required this.semester,
    required this.capacity,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });
}

class ClassReportModel {
  final String classId;
  final String className;
  final String professorName;
  final int totalStudents;
  final int activeStudents;
  final int totalMessages;
  final DateTime date;
  final double attendanceRate;

  ClassReportModel({
    required this.classId,
    required this.className,
    required this.professorName,
    required this.totalStudents,
    required this.activeStudents,
    required this.totalMessages,
    required this.date,
    required this.attendanceRate,
  });
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

class ProfessorModel {
  final String id;
  final String name;
  final List<String> classIds;

  ProfessorModel({required this.id, required this.name, required this.classIds});
}

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
