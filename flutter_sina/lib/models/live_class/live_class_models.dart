class LiveSessionModel {
  final String id;
  final String classId;
  final String title;
  final String professorId;
  final String professorName;
  final String status;
  final DateTime? startedAt;
  final DateTime? endedAt;

  const LiveSessionModel({
    required this.id,
    required this.classId,
    required this.title,
    required this.professorId,
    required this.professorName,
    required this.status,
    this.startedAt,
    this.endedAt,
  });

  bool get isActive => status == 'active';
  bool get isEnded => status == 'ended';

  LiveSessionModel copyWith({
    String? id,
    String? classId,
    String? title,
    String? professorId,
    String? professorName,
    String? status,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return LiveSessionModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }
}

class LiveSessionParticipantModel {
  final String id;
  final String sessionId;
  final String classId;
  final String userId;
  final String userName;
  final String userRole;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final bool isOnline;
  final bool isMuted;
  final bool raisedHand;
  /// ثبت‌شده توسط استاد به‌عنوان حاضر در جلسه (حضور و غیاب).
  final bool present;

  const LiveSessionParticipantModel({
    required this.id,
    required this.sessionId,
    required this.classId,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.joinedAt,
    this.leftAt,
    required this.isOnline,
    this.isMuted = false,
    this.raisedHand = false,
    this.present = false,
  });

  LiveSessionParticipantModel copyWith({
    String? id,
    String? sessionId,
    String? classId,
    String? userId,
    String? userName,
    String? userRole,
    DateTime? joinedAt,
    DateTime? leftAt,
    bool? isOnline,
    bool? isMuted,
    bool? raisedHand,
    bool? present,
  }) {
    return LiveSessionParticipantModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      classId: classId ?? this.classId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      isOnline: isOnline ?? this.isOnline,
      isMuted: isMuted ?? this.isMuted,
      raisedHand: raisedHand ?? this.raisedHand,
      present: present ?? this.present,
    );
  }
}

class LiveSessionMessageModel {
  final String id;
  final String sessionId;
  final String classId;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String text;
  final DateTime sentAt;

  const LiveSessionMessageModel({
    required this.id,
    required this.sessionId,
    required this.classId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.text,
    required this.sentAt,
  });
}

