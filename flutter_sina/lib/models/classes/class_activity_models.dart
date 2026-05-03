class ClassMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime sentAt;

  const ClassMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.sentAt,
  });
}

class ClassFile {
  final String id;
  final String fileName;
  final String uploadedBy;
  final DateTime uploadedAt;

  const ClassFile({
    required this.id,
    required this.fileName,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}

class ClassReport {
  final String id;
  final String classId;
  final String title;
  final String summary;
  final DateTime createdAt;

  const ClassReport({
    required this.id,
    required this.classId,
    required this.title,
    required this.summary,
    required this.createdAt,
  });
}
