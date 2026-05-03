class SupportRequestModel {
  final String id;
  final String userId;
  final String userName;
  final String question;
  final String answer;
  final String targetUnitKey;
  final DateTime createdAt;
  final bool answeredAutomatically;

  const SupportRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.question,
    required this.answer,
    required this.targetUnitKey,
    required this.createdAt,
    required this.answeredAutomatically,
  });
}
