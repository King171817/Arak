import '../auth/app_role.dart';
import '../permissions/permission_model.dart';

class AppUserModel {
  final String id;
  final String username;
  final String displayName;
  final AppRole role;
  final String unitKey;
  final List<AppPermission> permissions;
  final bool isLocked;

  const AppUserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.unitKey,
    required this.permissions,
    this.isLocked = false,
  });

  bool hasPermission(AppPermission permission) {
    if (role == AppRole.superAdmin) return true;
    return permissions.contains(permission);
  }

  AppUserModel copyWith({
    String? id,
    String? username,
    String? displayName,
    AppRole? role,
    String? unitKey,
    List<AppPermission>? permissions,
    bool? isLocked,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      unitKey: unitKey ?? this.unitKey,
      permissions: permissions ?? this.permissions,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
