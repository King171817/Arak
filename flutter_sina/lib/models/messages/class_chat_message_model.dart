class ClassChatMessageModel {
  final String id;
  final String classId;
  final String senderId;
  final String senderName;
  final String body;
  final DateTime createdAt;

  const ClassChatMessageModel({
    required this.id,
    required this.classId,
    required this.senderId,
    required this.senderName,
    required this.body,
    required this.createdAt,
  });
}
