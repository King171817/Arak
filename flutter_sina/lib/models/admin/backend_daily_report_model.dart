class BackendDailyReportModel {
  final String id;
  final String userId;
  final String userName;
  final String role;
  final String unit;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BackendDailyReportModel({
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

  factory BackendDailyReportModel.fromJson(Map<String, dynamic> json) {
    return BackendDailyReportModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  bool canEdit({required bool isMainAdmin}) {
    if (isMainAdmin) return true;
    return DateTime.now().isBefore(createdAt.add(const Duration(hours: 48)));
  }
}
