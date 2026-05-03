import '../../models/users/student_in_class_model.dart';
import '../../models/users/professor_model.dart';
import '../../models/users/education_officer_model.dart';
import '../../models/permissions/education_permission.dart';

final List<StudentInClassModel> mockStudents = <StudentInClassModel>[
  StudentInClassModel(id: 's001', name: 'رضا حسینی', studentId: '40210001'),
  StudentInClassModel(id: 's002', name: 'علی احمدی', studentId: '40210002'),
  StudentInClassModel(id: 's003', name: 'فاطمه رضایی', studentId: '40210003'),
  StudentInClassModel(id: 's004', name: 'Sara Smith', studentId: '40210004'),
];

final List<ProfessorModel> mockProfessors = <ProfessorModel>[
  ProfessorModel(id: 'p001', name: 'دکتر محمدی', classIds: <String>['c001', 'c002']),
  ProfessorModel(id: 'p002', name: 'Dr. Johnson', classIds: <String>['c003']),
];

final List<EducationOfficerModel> mockEducationOfficers = <EducationOfficerModel>[
  EducationOfficerModel(
    id: 'eo001',
    name: 'کارشناس آموزش ۱',
    username: 'edu_officer1',
    password: '1234',
    permissions: <EducationPermission>[
      EducationPermission.viewReports,
      EducationPermission.manageClasses,
      EducationPermission.createClass,
      EducationPermission.editClass,
      EducationPermission.manageStudents,
      EducationPermission.privateChat,
      EducationPermission.viewClassHistory,
    ],
  ),
];
