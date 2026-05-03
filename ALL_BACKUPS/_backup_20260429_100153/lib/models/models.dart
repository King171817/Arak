import 'package:flutter/material.dart';

enum UserRole { guest, student, manager, professor, superAdmin }

enum ServiceAudience { studentOnly, staffOnly, all }

class UnitModel {
  final String key;
  final IconData icon;
  const UnitModel({required this.key, required this.icon});
}

class AppUser {
  final String id;
  final String username;
  final String password;
  final String name;
  final UserRole role;
  final String? unitKey;
  final String? studentNumber;
  final String? passportNumber;

  const AppUser({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.role,
    this.unitKey,
    this.studentNumber,
    this.passportNumber,
  });
}

class StudentModel {
  final String id;
  final String name;
  final String studentNumber;
  const StudentModel({required this.id, required this.name, required this.studentNumber});
}

class ProfessorModel {
  final String id;
  final String name;
  const ProfessorModel({required this.id, required this.name});
}

class ManagedClassModel {
  final String id;
  String name;
  String professorId;
  String day;
  String time;
  String semester;
  final List<String> studentIds;
  bool isActive;

  ManagedClassModel({
    required this.id,
    required this.name,
    required this.professorId,
    required this.day,
    required this.time,
    required this.semester,
    required List<String> studentIds,
    this.isActive = true,
  }) : studentIds = List<String>.from(studentIds);
}

class AppNotification {
  final String id;
  final String title;
  final String subtitle;
  bool unread;

  AppNotification({required this.id, required this.title, required this.subtitle, this.unread = true});
}

class OtherService {
  final String key;
  final IconData icon;
  final Color color;
  final ServiceAudience audience;
  const OtherService({required this.key, required this.icon, required this.color, required this.audience});
}

class LiveClassSession {
  final String classId;
  bool isStarted;
  bool chatEnabled;
  bool studentMicAllowed;
  bool cameraAllowed;
  bool recordingEnabled;
  final Set<String> joinedStudentIds;
  final Set<String> mutedStudentIds;
  final Set<String> restrictedStudentIds;
  final Set<String> handRaisedStudentIds;
  final List<String> announcements;
  final List<String> messages;

  LiveClassSession({
    required this.classId,
    this.isStarted = false,
    this.chatEnabled = false,
    this.studentMicAllowed = false,
    this.cameraAllowed = false,
    this.recordingEnabled = false,
  })  : joinedStudentIds = <String>{},
        mutedStudentIds = <String>{},
        restrictedStudentIds = <String>{},
        handRaisedStudentIds = <String>{},
        announcements = <String>[],
        messages = <String>[];
}
