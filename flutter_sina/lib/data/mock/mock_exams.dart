import 'package:flutter/material.dart';

import '../../models/classes/exam_model.dart';

final List<ExamModel> mockExams = <ExamModel>[
  ExamModel(
    id: 'e001',
    classId: 'c001',
    classTitle: 'برنامه نویسی پیشرفته',
    professorId: 'p001',
    professorName: 'دکتر محمدی',
    studentIds: <String>['s001', 's002'],
    examDate: DateTime(2026, 4, 26),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 30),
    description: 'امتحان میان‌ترم برای درس برنامه نویسی پیشرفته.',
    status: ExamStatus.scheduled,
    createdAt: DateTime(2026, 4, 20),
    approvedBy: 'm001',
    approvedAt: DateTime(2026, 4, 21),
  ),
  ExamModel(
    id: 'e002',
    classId: 'c002',
    classTitle: 'پایگاه داده',
    professorId: 'p001',
    professorName: 'دکتر محمدی',
    studentIds: <String>['s001', 's003', 's004'],
    examDate: DateTime(2026, 4, 27),
    startTime: const TimeOfDay(hour: 14, minute: 0),
    endTime: const TimeOfDay(hour: 15, minute: 30),
    description: 'امتحان نهایی درس پایگاه داده.',
    status: ExamStatus.scheduled,
    createdAt: DateTime(2026, 4, 20),
    approvedBy: 'm001',
    approvedAt: DateTime(2026, 4, 21),
  ),
];