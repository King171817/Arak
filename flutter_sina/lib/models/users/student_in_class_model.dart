class StudentInClassModel {
  final String id;
  final String name;
  final String studentId;
  final String? profileImageUrl;

  const StudentInClassModel({
    required this.id,
    required this.name,
    required this.studentId,
    this.profileImageUrl,
  });

  StudentInClassModel copyWith({
    String? id,
    String? name,
    String? studentId,
    String? profileImageUrl,
  }) {
    return StudentInClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
