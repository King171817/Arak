import 'package:flutter/material.dart';

enum LiveClassStatus {
  scheduled,
  waitingForProfessor,
  active,
  finished,
  cancelled,
}

class EducationManagedClassModel {
  final String id;
  final String title;
  final String professorId;
  final String professorName;
  final List<String> studentIds;
  final List<String> studentNames;
  final String weekDay;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String semester;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final LiveClassStatus status;

  const EducationManagedClassModel({
    required this.id,
    required this.title,
    required this.professorId,
    required this.professorName,
    required this.studentIds,
    required this.studentNames,
    required this.weekDay,
    required this.startTime,
    required this.endTime,
    required this.semester,
    required this.createdAt,
    this.startedAt,
    this.finishedAt,
    this.status = LiveClassStatus.scheduled,
  });

  EducationManagedClassModel copyWith({
    String? id,
    String? title,
    String? professorId,
    String? professorName,
    List<String>? studentIds,
    List<String>? studentNames,
    String? weekDay,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? semester,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    LiveClassStatus? status,
  }) {
    return EducationManagedClassModel(
      id: id ?? this.id,
      title: title ?? this.title,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      studentIds: studentIds ?? this.studentIds,
      studentNames: studentNames ?? this.studentNames,
      weekDay: weekDay ?? this.weekDay,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      semester: semester ?? this.semester,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
    );
  }
}

class LiveClassParticipantModel {
  final String studentId;
  final String studentName;
  final bool isOnline;
  final bool isMuted;
  final bool canSpeak;
  final bool raisedHand;

  const LiveClassParticipantModel({
    required this.studentId,
    required this.studentName,
    required this.isOnline,
    required this.isMuted,
    required this.canSpeak,
    required this.raisedHand,
  });

  LiveClassParticipantModel copyWith({
    String? studentId,
    String? studentName,
    bool? isOnline,
    bool? isMuted,
    bool? canSpeak,
    bool? raisedHand,
  }) {
    return LiveClassParticipantModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      isOnline: isOnline ?? this.isOnline,
      isMuted: isMuted ?? this.isMuted,
      canSpeak: canSpeak ?? this.canSpeak,
      raisedHand: raisedHand ?? this.raisedHand,
    );
  }
}

class LiveClassMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime sentAt;
  final bool hasFile;
  final String? fileName;

  const LiveClassMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.sentAt,
    this.hasFile = false,
    this.fileName,
  });
}

class EducationClassReportModel {
  final String id;
  final String classId;
  final String classTitle;
  final String professorName;
  final DateTime reportDate;
  final int totalStudents;
  final int presentStudents;
  final int absentStudents;
  final int totalMessages;
  final int uploadedFiles;
  final Duration classDuration;
  final LiveClassStatus finalStatus;
  final List<String> presentStudentNames;
  final List<String> absentStudentNames;

  const EducationClassReportModel({
    required this.id,
    required this.classId,
    required this.classTitle,
    required this.professorName,
    required this.reportDate,
    required this.totalStudents,
    required this.presentStudents,
    required this.absentStudents,
    required this.totalMessages,
    required this.uploadedFiles,
    required this.classDuration,
    required this.finalStatus,
    required this.presentStudentNames,
    required this.absentStudentNames,
  });
}
