import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../auth/auth_repository.dart';
import '../../core/constants/unit_keys.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<AppUserModel?> login({
    required String username,
    required String password,
  }) async {
    if (password != '1234') return null;

    switch (username) {
      case 'admin':
        return const AppUserModel(
          id: 'student_admin',
          username: 'admin',
          displayName: 'دانشجو نمونه',
          role: AppRole.student,
          unitKey: 'student',
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewClasses,
          ],
        );

      case 'prof1':
        return const AppUserModel(
          id: 'p001',
          username: 'prof1',
          displayName: 'دکتر محمدی',
          role: AppRole.professor,
          unitKey: UnitKeys.education,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewClasses,
            AppPermission.chatWithManagers,
          ],
        );

      case 'prof2':
        return const AppUserModel(
          id: 'p002',
          username: 'prof2',
          displayName: 'Dr. Johnson',
          role: AppRole.professor,
          unitKey: UnitKeys.education,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewClasses,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin1':
        return const AppUserModel(
          id: 'manager_international',
          username: 'admin1',
          displayName: 'مدیر امور بین‌الملل',
          role: AppRole.unitManager,
          unitKey: UnitKeys.international,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin2':
        return const AppUserModel(
          id: 'manager_education',
          username: 'admin2',
          displayName: 'مدیر آموزش',
          role: AppRole.educationManager,
          unitKey: UnitKeys.education,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.editStudents,
            AppPermission.viewClasses,
            AppPermission.manageClasses,
            AppPermission.createClass,
            AppPermission.editClass,
            AppPermission.deleteClass,
            AppPermission.viewReports,
            AppPermission.manageOfficers,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin3':
        return const AppUserModel(
          id: 'manager_student_services',
          username: 'admin3',
          displayName: 'مدیر خدمات دانشجویی',
          role: AppRole.unitManager,
          unitKey: UnitKeys.studentServices,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin4':
        return const AppUserModel(
          id: 'manager_consular',
          username: 'admin4',
          displayName: 'مدیر کنسولی',
          role: AppRole.unitManager,
          unitKey: UnitKeys.consular,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.chatWithManagers,
          ],
        );

      case 'sina':
        return const AppUserModel(
          id: 'super_admin_sina',
          username: 'sina',
          displayName: 'sina',
          role: AppRole.superAdmin,
          unitKey: UnitKeys.adminMain,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.manageGlobalSettings,
            AppPermission.manageFloatingAnnouncements,
            AppPermission.manageBackground,
            AppPermission.manageLogo,
            AppPermission.lockUsers,
            AppPermission.lockSections,
            AppPermission.manageRoles,
            AppPermission.managePermissions,
            AppPermission.viewReports,
            AppPermission.manageReports,
            AppPermission.chatWithManagers,
          ],
        );

      default:
        try {
          final EducationOfficerModel officer = mockEducationOfficers.firstWhere(
            (EducationOfficerModel item) => item.username == username,
          );

          if (!officer.isActive) return null;

          return AppUserModel(
            id: officer.id,
            username: officer.username,
            displayName: officer.name,
            role: AppRole.educationOfficer,
            unitKey: UnitKeys.education,
            permissions: const <AppPermission>[
              AppPermission.viewDashboard,
              AppPermission.viewUnits,
              AppPermission.viewClasses,
              AppPermission.manageClasses,
              AppPermission.viewReports,
              AppPermission.chatWithManagers,
            ],
          );
        } catch (_) {
          return null;
        }
    }
  }
}
