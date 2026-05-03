class BackendAdminUserModel {
  final String id;
  final String username;
  final String fullName;
  final String role;
  final String unit;
  final String email;
  final String phone;
  final String passportNo;
  final String studentNo;
  final bool isLocked;

  const BackendAdminUserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.unit,
    required this.email,
    required this.phone,
    required this.passportNo,
    required this.studentNo,
    required this.isLocked,
  });

  factory BackendAdminUserModel.fromJson(Map<String, dynamic> json) {
    return BackendAdminUserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      passportNo: json['passportNo']?.toString() ?? '',
      studentNo: json['studentNo']?.toString() ?? '',
      isLocked: json['isLocked'] == true,
    );
  }
}
