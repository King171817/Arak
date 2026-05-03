import 'package:flutter/material.dart';

class Student {
  final String id;
  final String name;
  final String studentId;
  final String passportNumber;
  final String major;

  const Student({
    required this.id,
    required this.name,
    required this.studentId,
    required this.passportNumber,
    required this.major,
  });
}

class Professor {
  final String id;
  final String name;
  final String department;

  const Professor({required this.id, required this.name, required this.department});
}

class UnitModel {
  final String keyName;
  final IconData icon;

  const UnitModel({required this.keyName, required this.icon});
}

class UniversityClass {
  final String id;
  String name;
  String professorId;
  String professorName;
  String day;
  String startTime;
  String endTime;
  String semester;
  final List<String> studentIds;
  bool isActive;
  final Set<String> presentStudentIds;

  UniversityClass({
    required this.id,
    required this.name,
    required this.professorId,
    required this.professorName,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.semester,
    required List<String> studentIds,
    this.isActive = false,
    Set<String>? presentStudentIds,
  })  : studentIds = List<String>.from(studentIds),
        presentStudentIds = presentStudentIds ?? <String>{};

  String get schedule => '$day $startTime-$endTime';
}

class AppNotification {
  final String title;
  final String subtitle;
  final String unitKey;
  final bool unread;

  const AppNotification({required this.title, required this.subtitle, required this.unitKey, this.unread = true});
}
