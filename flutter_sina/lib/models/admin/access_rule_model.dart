class AccessRuleModel {
  final String id;
  final String userId;
  final String role;
  final String unit;
  final List<String> permissions;
  final bool isLocked;
  final String updatedBy;

  const AccessRuleModel({
    required this.id,
    required this.userId,
    required this.role,
    required this.unit,
    required this.permissions,
    required this.isLocked,
    required this.updatedBy,
  });

  factory AccessRuleModel.fromJson(Map<String, dynamic> json) {
    return AccessRuleModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      permissions: _list(json['permissions']),
      isLocked: json['isLocked'] == true,
      updatedBy: json['updatedBy']?.toString() ?? '',
    );
  }

  static List<String> _list(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return <String>[];
  }
}
