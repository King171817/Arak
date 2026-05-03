import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../classes/classes_repository.dart';

class SupabaseClassesRepository implements ClassesRepository {
  @override
  Future<List<EducationManagedClassModel>> fetchClasses() async {
    final client = SupabaseBootstrap.client;

    if (client == null) {
      throw Exception('supabase_not_initialized');
    }

    final data = await client
        .from('education_classes')
        .select()
        .order('created_at', ascending: false);

    return data.map<EducationManagedClassModel>((item) {
      return EducationManagedClassModel(
        id: item['id'].toString(),
        title: item['title'].toString(),
        professorId: item['professor_id'].toString(),
        professorName: item['professor_name'].toString(),
        studentIds: List<String>.from(item['student_ids'] as List<dynamic>),
        studentNames: List<String>.from(item['student_names'] as List<dynamic>),
        weekDay: item['week_day'].toString(),
        startTime: _timeFromString(item['start_time'].toString()),
        endTime: _timeFromString(item['end_time'].toString()),
        semester: item['semester'].toString(),
        createdAt: DateTime.parse(item['created_at'].toString()),
        startedAt: item['started_at'] == null
            ? null
            : DateTime.parse(item['started_at'].toString()),
        finishedAt: item['finished_at'] == null
            ? null
            : DateTime.parse(item['finished_at'].toString()),
        status: LiveClassStatus.values.firstWhere(
          (LiveClassStatus status) => status.name == item['status'].toString(),
          orElse: () => LiveClassStatus.scheduled,
        ),
      );
    }).toList();
  }

  @override
  Future<EducationManagedClassModel> createClass(
    EducationManagedClassModel classItem,
  ) async {
    final client = SupabaseBootstrap.client;

    if (client == null) {
      throw Exception('supabase_not_initialized');
    }

    final item = await client
        .from('education_classes')
        .insert(_toMap(classItem))
        .select()
        .single();

    return _fromMap(item);
  }

  @override
  Future<EducationManagedClassModel> updateClass(
    EducationManagedClassModel classItem,
  ) async {
    final client = SupabaseBootstrap.client;

    if (client == null) {
      throw Exception('supabase_not_initialized');
    }

    final item = await client
        .from('education_classes')
        .update(_toMap(classItem))
        .eq('id', classItem.id)
        .select()
        .single();

    return _fromMap(item);
  }

  Map<String, dynamic> _toMap(EducationManagedClassModel item) {
    return <String, dynamic>{
      'id': item.id,
      'title': item.title,
      'professor_id': item.professorId,
      'professor_name': item.professorName,
      'student_ids': item.studentIds,
      'student_names': item.studentNames,
      'week_day': item.weekDay,
      'start_time': _timeToString(item.startTime),
      'end_time': _timeToString(item.endTime),
      'semester': item.semester,
      'created_at': item.createdAt.toIso8601String(),
      'started_at': item.startedAt?.toIso8601String(),
      'finished_at': item.finishedAt?.toIso8601String(),
      'status': item.status.name,
    };
  }

  EducationManagedClassModel _fromMap(Map<String, dynamic> item) {
    return EducationManagedClassModel(
      id: item['id'].toString(),
      title: item['title'].toString(),
      professorId: item['professor_id'].toString(),
      professorName: item['professor_name'].toString(),
      studentIds: List<String>.from(item['student_ids'] as List<dynamic>),
      studentNames: List<String>.from(item['student_names'] as List<dynamic>),
      weekDay: item['week_day'].toString(),
      startTime: _timeFromString(item['start_time'].toString()),
      endTime: _timeFromString(item['end_time'].toString()),
      semester: item['semester'].toString(),
      createdAt: DateTime.parse(item['created_at'].toString()),
      startedAt: item['started_at'] == null
          ? null
          : DateTime.parse(item['started_at'].toString()),
      finishedAt: item['finished_at'] == null
          ? null
          : DateTime.parse(item['finished_at'].toString()),
      status: LiveClassStatus.values.firstWhere(
        (LiveClassStatus status) => status.name == item['status'].toString(),
        orElse: () => LiveClassStatus.scheduled,
      ),
    );
  }

  String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay _timeFromString(String value) {
    final parts = value.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
  }
}
