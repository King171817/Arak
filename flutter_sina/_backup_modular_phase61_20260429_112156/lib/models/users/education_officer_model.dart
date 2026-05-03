import '../permissions/education_permission.dart';

class EducationOfficerModel {
  final String id;
  final String name;
  final String username;
  final String password;
  final List<EducationPermission> permissions;
  final bool isActive;

  const EducationOfficerModel({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.permissions,
    this.isActive = true,
  });

  bool hasPermission(EducationPermission permission) {
    return permissions.contains(permission);
  }

  EducationOfficerModel copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    List<EducationPermission>? permissions,
    bool? isActive,
  }) {
    return EducationOfficerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
    );
  }
}
