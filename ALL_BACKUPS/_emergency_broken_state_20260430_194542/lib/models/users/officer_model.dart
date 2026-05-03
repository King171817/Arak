import '../permissions/permission_model.dart';

class OfficerModel {
  final String id;
  final String unitKey;
  final String name;
  final String username;
  final String password;
  final List<AppPermission> permissions;
  final bool isActive;

  const OfficerModel({
    required this.id,
    required this.unitKey,
    required this.name,
    required this.username,
    required this.password,
    required this.permissions,
    this.isActive = true,
  });

  bool hasPermission(AppPermission permission) {
    return permissions.contains(permission);
  }

  OfficerModel copyWith({
    String? id,
    String? unitKey,
    String? name,
    String? username,
    String? password,
    List<AppPermission>? permissions,
    bool? isActive,
  }) {
    return OfficerModel(
      id: id ?? this.id,
      unitKey: unitKey ?? this.unitKey,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
    );
  }
}
