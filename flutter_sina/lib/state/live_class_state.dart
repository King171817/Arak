import 'package:flutter/material.dart';

import '../models/live_class/live_class_models.dart';

class LiveClassState extends ChangeNotifier {
  final List<LiveSessionModel> _sessions = <LiveSessionModel>[];
  final List<LiveSessionParticipantModel> _participants =
      <LiveSessionParticipantModel>[];
  final List<LiveSessionMessageModel> _messages =
      <LiveSessionMessageModel>[];

  List<LiveSessionModel> get sessions =>
      List<LiveSessionModel>.unmodifiable(_sessions);

  List<LiveSessionParticipantModel> participantsOf(String sessionId) {
    return _participants
        .where((LiveSessionParticipantModel item) => item.sessionId == sessionId)
        .toList();
  }

  List<LiveSessionMessageModel> messagesOf(String sessionId) {
    return _messages
        .where((LiveSessionMessageModel item) => item.sessionId == sessionId)
        .toList();
  }

  LiveSessionModel? activeSessionForClass(String classId) {
    for (final LiveSessionModel session in _sessions) {
      if (session.classId == classId && session.status == 'active') {
        return session;
      }
    }
    return null;
  }

  LiveSessionModel startClass({
    required String classId,
    required String title,
    required String professorId,
    required String professorName,
  }) {
    final LiveSessionModel session = LiveSessionModel(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      classId: classId,
      title: title,
      professorId: professorId,
      professorName: professorName,
      status: 'active',
      startedAt: DateTime.now(),
    );

    _sessions.add(session);
    notifyListeners();
    return session;
  }

  void endClass(String sessionId) {
    final int index = _sessions.indexWhere(
      (LiveSessionModel item) => item.id == sessionId,
    );

    if (index == -1) return;

    _sessions[index] = _sessions[index].copyWith(
      status: 'ended',
      endedAt: DateTime.now(),
    );

    notifyListeners();
  }

  void joinClass({
    required String sessionId,
    required String classId,
    required String userId,
    required String userName,
    required String role,
  }) {
    final bool exists = _participants.any(
      (LiveSessionParticipantModel item) =>
          item.sessionId == sessionId && item.userId == userId,
    );

    if (exists) return;

    _participants.add(
      LiveSessionParticipantModel(
        id: 'participant_${DateTime.now().millisecondsSinceEpoch}',
        sessionId: sessionId,
        classId: classId,
        userId: userId,
        userName: userName,
        userRole: role,
        joinedAt: DateTime.now(),
        isOnline: true,
        isMuted: false,
        raisedHand: false,
      ),
    );

    notifyListeners();
  }

  void setParticipantMute({
    required String sessionId,
    required String userId,
    required bool muted,
  }) {
    final int index = _participants.indexWhere((LiveSessionParticipantModel item) {
      return item.sessionId == sessionId && item.userId == userId;
    });

    if (index == -1) return;

    _participants[index] = _participants[index].copyWith(isMuted: muted);
    notifyListeners();
  }

  void setParticipantHandRaise({
    required String sessionId,
    required String userId,
    required bool raisedHand,
  }) {
    final int index = _participants.indexWhere((LiveSessionParticipantModel item) {
      return item.sessionId == sessionId && item.userId == userId;
    });

    if (index == -1) return;

    _participants[index] = _participants[index].copyWith(raisedHand: raisedHand);
    notifyListeners();
  }

  void markParticipantAttendance({
    required String sessionId,
    required String userId,
    required bool present,
  }) {
    final int index = _participants.indexWhere((LiveSessionParticipantModel item) {
      return item.sessionId == sessionId && item.userId == userId;
    });

    if (index == -1) return;

    _participants[index] = _participants[index].copyWith(present: present);
    notifyListeners();
  }

  void leaveClass({
    required String sessionId,
    required String userId,
  }) {
    final int index = _participants.indexWhere((LiveSessionParticipantModel item) {
      return item.sessionId == sessionId && item.userId == userId;
    });

    if (index == -1) return;

    _participants[index] = _participants[index].copyWith(
      isOnline: false,
      leftAt: DateTime.now(),
      raisedHand: false,
    );
    notifyListeners();
  }

  void sendMessage({
    required String sessionId,
    required String classId,
    required String senderId,
    required String senderName,
    required String senderRole,
    required String message,
  }) {
    if (message.trim().isEmpty) return;

    _messages.add(
      LiveSessionMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sessionId: sessionId,
        classId: classId,
        senderId: senderId,
        senderName: senderName,
        senderRole: senderRole,
        text: message.trim(),
        sentAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}

