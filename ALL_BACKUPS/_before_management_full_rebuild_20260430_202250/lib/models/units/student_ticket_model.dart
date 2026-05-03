enum TicketStatus {
  submitted,
  reviewing,
  needDocuments,
  referred,
  completed,
  rejected,
}

class StudentTicketModel {
  final String id;
  final String trackingCode;
  final String studentId;
  final String studentName;
  final String unitKey;
  final String title;
  final String description;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String assignedTo;

  const StudentTicketModel({
    required this.id,
    required this.trackingCode,
    required this.studentId,
    required this.studentName,
    required this.unitKey,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedTo,
  });

  StudentTicketModel copyWith({
    String? id,
    String? trackingCode,
    String? studentId,
    String? studentName,
    String? unitKey,
    String? title,
    String? description,
    TicketStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
  }) {
    return StudentTicketModel(
      id: id ?? this.id,
      trackingCode: trackingCode ?? this.trackingCode,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      unitKey: unitKey ?? this.unitKey,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}
