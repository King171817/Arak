class DailyActivityReportModel {
  final String id;
  final String userId;
  final String userName;
  final String role;
  final String unit;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyActivityReportModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.role,
    required this.unit,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  bool canEdit({required bool isMainAdmin}) {
    if (isMainAdmin) return true;
    final limit = createdAt.add(const Duration(hours: 48));
    return DateTime.now().isBefore(limit);
  }

  DailyActivityReportModel copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
  }) {
    return DailyActivityReportModel(
      id: id,
      userId: userId,
      userName: userName,
      role: role,
      unit: unit,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
