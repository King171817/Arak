class ClassModel {
  final String id;
  final String name;
  final String professorId;
  final List<String> studentIds;
  final String descriptionKey;

  const ClassModel({
    required this.id,
    required this.name,
    required this.professorId,
    required this.studentIds,
    required this.descriptionKey,
  });

  ClassModel copyWith({
    String? id,
    String? name,
    String? professorId,
    List<String>? studentIds,
    String? descriptionKey,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      professorId: professorId ?? this.professorId,
      studentIds: studentIds ?? this.studentIds,
      descriptionKey: descriptionKey ?? this.descriptionKey,
    );
  }
}
