class UnitMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String targetUnit;
  final String subject;
  final String body;
  final DateTime createdAt;

  const UnitMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.targetUnit,
    required this.subject,
    required this.body,
    required this.createdAt,
  });
}
