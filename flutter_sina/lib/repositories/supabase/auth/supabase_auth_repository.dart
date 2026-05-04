import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../auth/auth_repository.dart';
import '../../../models/users/app_user_model.dart';
import '../../../models/auth/app_role.dart';
import '../../../models/permissions/permission_model.dart';

class SupabaseAuthRepository implements AuthRepository {
  static const String baseUrl = 'http://localhost:3001';

  @override
  Future<AppUserModel?> login({
    required String username,
    required String password,
  }) async {
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    final Map<String, dynamic> user =
        data['user'] as Map<String, dynamic>;

    final AppRole role = _mapRole(user['role']?.toString());

    return AppUserModel(
      id: user['id']?.toString() ?? '',
      username: user['username']?.toString() ?? username,
      displayName: user['displayName']?.toString() ??
          user['fullName']?.toString() ??
          username,
      role: role,
      unitKey: user['unitKey']?.toString() ??
          user['unit']?.toString() ??
          '',
      permissions: _defaultPermissionsForRole(role),
    );
  }

  AppRole _mapRole(String? role) {
    switch (role) {
      case 'superAdmin':
        return AppRole.superAdmin;
      case 'educationManager':
        return AppRole.educationManager;
      case 'unitManager':
        return AppRole.unitManager;
      case 'professor':
        return AppRole.professor;
      case 'educationExpert':
      case 'educationOfficer':
        return AppRole.educationOfficer;
      case 'unitOfficer':
        return AppRole.unitOfficer;
      case 'student':
      default:
        return AppRole.student;
    }
  }

  List<AppPermission> _defaultPermissionsForRole(AppRole role) {
    switch (role) {
      case AppRole.superAdmin:
        return <AppPermission>[
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
        ];
      case AppRole.educationManager:
        return <AppPermission>[
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
        ];
      case AppRole.educationOfficer:
        return <AppPermission>[
          AppPermission.viewDashboard,
          AppPermission.viewUnits,
          AppPermission.viewStudents,
          AppPermission.viewClasses,
          AppPermission.manageClasses,
          AppPermission.viewReports,
        ];
      case AppRole.professor:
        return <AppPermission>[
          AppPermission.viewDashboard,
          AppPermission.viewClasses,
          AppPermission.chatWithManagers,
        ];
      case AppRole.unitManager:
        return <AppPermission>[
          AppPermission.viewDashboard,
          AppPermission.viewUnits,
          AppPermission.viewStudents,
          AppPermission.chatWithManagers,
        ];
      case AppRole.unitOfficer:
        return <AppPermission>[
          AppPermission.viewDashboard,
          AppPermission.viewUnits,
          AppPermission.viewStudents,
        ];
      case AppRole.student:
        return <AppPermission>[
          AppPermission.viewDashboard,
          AppPermission.viewUnits,
          AppPermission.viewClasses,
        ];
      case AppRole.guest:
        return <AppPermission>[];
    }
  }
}
