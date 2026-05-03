import 'package:flutter/material.dart';

enum ExamStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}

class ExamModel {
  final String id;
  final String classId;
  final String classTitle;
  final String professorId;
  final String professorName;
  final List<String> studentIds;
  final DateTime examDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String description;
  final ExamStatus status;
  final DateTime createdAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final Map<String, dynamic>? results; // studentId -> score/notes

  const ExamModel({
    required this.id,
    required this.classId,
    required this.classTitle,
    required this.professorId,
    required this.professorName,
    required this.studentIds,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.status,
    required this.createdAt,
    this.approvedBy,
    this.approvedAt,
    this.results,
  });

  ExamModel copyWith({
    String? id,
    String? classId,
    String? classTitle,
    String? professorId,
    String? professorName,
    List<String>? studentIds,
    DateTime? examDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? description,
    ExamStatus? status,
    DateTime? createdAt,
    String? approvedBy,
    DateTime? approvedAt,
    Map<String, dynamic>? results,
  }) {
    return ExamModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      classTitle: classTitle ?? this.classTitle,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      studentIds: studentIds ?? this.studentIds,
      examDate: examDate ?? this.examDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      results: results ?? this.results,
    );
  }

  bool get isApproved => approvedBy != null;
  bool get isPast => DateTime.now().isAfter(DateTime(examDate.year, examDate.month, examDate.day, endTime.hour, endTime.minute));
  bool get isToday => DateTime.now().year == examDate.year && DateTime.now().month == examDate.month && DateTime.now().day == examDate.day;
}