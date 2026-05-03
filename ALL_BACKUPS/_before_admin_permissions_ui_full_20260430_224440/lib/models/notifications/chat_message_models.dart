class EducationPrivateChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String message;
  final DateTime sentAt;
  final bool unread;

  const EducationPrivateChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.message,
    required this.sentAt,
    this.unread = true,
  });

  EducationPrivateChatMessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? receiverName,
    String? message,
    DateTime? sentAt,
    bool? unread,
  }) {
    return EducationPrivateChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      unread: unread ?? this.unread,
    );
  }
}

class InterManagerMessage {
  final String id;
  final String senderUnit;
  final String receiverUnit;
  final String senderName;
  final String message;
  final DateTime sentAt;
  final bool isRead;

  const InterManagerMessage({
    required this.id,
    required this.senderUnit,
    required this.receiverUnit,
    required this.senderName,
    required this.message,
    required this.sentAt,
    this.isRead = false,
  });

  InterManagerMessage copyWith({
    String? id,
    String? senderUnit,
    String? receiverUnit,
    String? senderName,
    String? message,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return InterManagerMessage(
      id: id ?? this.id,
      senderUnit: senderUnit ?? this.senderUnit,
      receiverUnit: receiverUnit ?? this.receiverUnit,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
