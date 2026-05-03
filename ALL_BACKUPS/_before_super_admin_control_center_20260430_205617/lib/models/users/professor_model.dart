class ProfessorModel {
  final String id;
  final String name;
  final List<String> classIds;

  const ProfessorModel({
    required this.id,
    required this.name,
    required this.classIds,
  });

  ProfessorModel copyWith({
    String? id,
    String? name,
    List<String>? classIds,
  }) {
    return ProfessorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      classIds: classIds ?? this.classIds,
    );
  }
}
