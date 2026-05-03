import 'package:flutter/material.dart';

enum RequestType {
  extraClass,
  exam,
}

enum RequestStatus {
  pending,
  approved,
  rejected,
}

class ProfessorRequestModel {
  final String id;
  final String professorId;
  final String professorName;
  final String classId;
  final String classTitle;
  final RequestType type;
  final DateTime requestedDate;
  final TimeOfDay? requestedStartTime;
  final TimeOfDay? requestedEndTime;
  final String description;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? reviewerId;
  final String? reviewerName;
  final String? reviewNote;

  const ProfessorRequestModel({
    required this.id,
    required this.professorId,
    required this.professorName,
    required this.classId,
    required this.classTitle,
    required this.type,
    required this.requestedDate,
    required this.description,
    required this.status,
    required this.createdAt,
    this.requestedStartTime,
    this.requestedEndTime,
    this.reviewedAt,
    this.reviewerId,
    this.reviewerName,
    this.reviewNote,
  });

  ProfessorRequestModel copyWith({
    String? id,
    String? professorId,
    String? professorName,
    String? classId,
    String? classTitle,
    RequestType? type,
    DateTime? requestedDate,
    TimeOfDay? requestedStartTime,
    TimeOfDay? requestedEndTime,
    String? description,
    RequestStatus? status,
    DateTime? createdAt,
    DateTime? reviewedAt,
    String? reviewerId,
    String? reviewerName,
    String? reviewNote,
  }) {
    return ProfessorRequestModel(
      id: id ?? this.id,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      classId: classId ?? this.classId,
      classTitle: classTitle ?? this.classTitle,
      type: type ?? this.type,
      requestedDate: requestedDate ?? this.requestedDate,
      requestedStartTime: requestedStartTime ?? this.requestedStartTime,
      requestedEndTime: requestedEndTime ?? this.requestedEndTime,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewNote: reviewNote ?? this.reviewNote,
    );
  }
}