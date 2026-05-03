enum LockTargetType {
  user,
  section,
  unit,
  role,
}

class SystemLockModel {
  final String id;
  final LockTargetType targetType;
  final String targetKey;
  final String title;
  final String reason;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;

  const SystemLockModel({
    required this.id,
    required this.targetType,
    required this.targetKey,
    required this.title,
    required this.reason,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
  });

  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  bool get isEffective {
    return isActive && !isExpired;
  }

  SystemLockModel copyWith({
    String? id,
    LockTargetType? targetType,
    String? targetKey,
    String? title,
    String? reason,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
  }) {
    return SystemLockModel(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetKey: targetKey ?? this.targetKey,
      title: title ?? this.title,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
