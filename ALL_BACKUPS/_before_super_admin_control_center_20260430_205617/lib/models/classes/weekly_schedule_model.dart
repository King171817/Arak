import 'package:flutter/material.dart';

class WeeklyScheduleModel {
  final String id;
  final String studentId;
  final String classId;
  final String title;
  final String professorName;
  final String weekDay;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String semester;

  const WeeklyScheduleModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.title,
    required this.professorName,
    required this.weekDay,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.semester,
  });
}
