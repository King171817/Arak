import 'package:flutter/material.dart';
import '../../models/classes/class_model.dart';
import '../../models/classes/education_class_model.dart';

final List<ClassModel> mockClasses = <ClassModel>[
  ClassModel(
    id: 'c001',
    name: 'برنامه نویسی پیشرفته',
    professorId: 'p001',
    studentIds: <String>['s001', 's002'],
    descriptionKey: 'class_programming_desc',
  ),
  ClassModel(
    id: 'c002',
    name: 'پایگاه داده',
    professorId: 'p001',
    studentIds: <String>['s001', 's003', 's004'],
    descriptionKey: 'class_database_desc',
  ),
  ClassModel(
    id: 'c003',
    name: 'Data Structures',
    professorId: 'p002',
    studentIds: <String>['s002', 's004'],
    descriptionKey: 'class_datastructure_desc',
  ),
];

final List<EducationManagedClassModel> mockEducationClasses = <EducationManagedClassModel>[
  EducationManagedClassModel(
    id: 'ec001',
    title: 'برنامه‌نویسی پیشرفته',
    professorId: 'p001',
    professorName: 'دکتر محمدی',
    studentIds: <String>['s001', 's002'],
    studentNames: <String>['رضا حسینی', 'علی احمدی'],
    weekDay: 'شنبه',
    startTime: TimeOfDay(hour: 10, minute: 0),
    endTime: TimeOfDay(hour: 11, minute: 30),
    semester: 'نیمسال اول ۱۴۰۴',
    createdAt: DateTime(2026, 4, 1),
    status: LiveClassStatus.scheduled,
  ),
  EducationManagedClassModel(
    id: 'ec002',
    title: 'پایگاه داده',
    professorId: 'p001',
    professorName: 'دکتر محمدی',
    studentIds: <String>['s001', 's003', 's004'],
    studentNames: <String>['رضا حسینی', 'فاطمه رضایی', 'Sara Smith'],
    weekDay: 'دوشنبه',
    startTime: TimeOfDay(hour: 14, minute: 0),
    endTime: TimeOfDay(hour: 15, minute: 30),
    semester: 'نیمسال اول ۱۴۰۴',
    createdAt: DateTime(2026, 4, 2),
    status: LiveClassStatus.finished,
    startedAt: DateTime(2026, 4, 20, 14, 0),
    finishedAt: DateTime(2026, 4, 20, 15, 28),
  ),
];
