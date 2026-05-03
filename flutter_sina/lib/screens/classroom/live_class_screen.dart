import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../state/live_class_state.dart';

class LiveClassScreen extends StatefulWidget {
  final String classId;
  final String classTitle;
  final String professorId;
  final String professorName;

  const LiveClassScreen({
    super.key,
    required this.classId,
    required this.classTitle,
    required this.professorId,
    required this.professorName,
  });

  @override
  State<LiveClassScreen> createState() => _LiveClassScreenState();
}

class _LiveClassScreenState extends State<LiveClassScreen> {
  final TextEditingController messageCtrl = TextEditingController();

  @override
  void dispose() {
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final LiveClassState live = context.watch<LiveClassState>();
    final AppUserModel? user = appState.currentUser;

    final LiveSessionModel? active =
        live.activeSessionForClass(widget.classId);

    final bool isProfessor = user?.id == widget.professorId;
    final bool canJoin = active != null && active.isActive;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classTitle),
      ),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: <Widget>[
            Container(
              decoration: AppDecorations.headerDecoration,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.video_call_outlined, color: Colors.white, size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      active == null
                          ? 'کلاس هنوز شروع نشده است'
                          : active.isActive
                              ? 'کلاس زنده فعال است'
                              : 'کلاس پایان یافته است',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (isProfessor && active == null)
              ElevatedButton.icon(
                onPressed: () {
                  live.startClass(
                    classId: widget.classId,
                    title: widget.classTitle,
                    professorId: widget.professorId,
                    professorName: widget.professorName,
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('شروع کلاس'),
              ),
            if (isProfessor && active != null && active.isActive)
              ElevatedButton.icon(
                onPressed: () {
                  live.endClass(active.id);
                },
                icon: const Icon(Icons.stop),
                label: const Text('پایان کلاس'),
              ),
            if (!isProfessor && canJoin && user != null)
              ElevatedButton.icon(
                onPressed: () {
                  live.joinClass(
                    sessionId: active.id,
                    classId: widget.classId,
                    userId: user.id,
                    userName: user.displayName,
                    role: user.role.name,
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text('ورود به کلاس'),
              ),
            const SizedBox(height: 12),
            if (active != null) ...<Widget>[
              _ParticipantsPanel(session: active),
              const SizedBox(height: 12),
              _MessagesPanel(session: active, controller: messageCtrl),
            ],
          ],
        ),
      ),
    );
  }
}

class _ParticipantsPanel extends StatelessWidget {
  final LiveSessionModel session;

  const _ParticipantsPanel({
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final LiveClassState live = context.watch<LiveClassState>();
    final bool isProfessor = appState.currentUser?.id == session.professorId;
    final List<LiveSessionParticipantModel> participants =
        live.participantsOf(session.id);
    final int onlineCount =
        participants.where((LiveSessionParticipantModel item) => item.isOnline).length;
    final int presentCount =
        participants.where((LiveSessionParticipantModel item) => item.present).length;

    return Container(
      decoration: AppDecorations.cardDecoration,
      child: ExpansionTile(
        leading: const Icon(Icons.people_outline),
        title: Text('حاضرین کلاس (${participants.length})'),
        subtitle: Text('آنلاین: $onlineCount · حضور ثبت‌شده: $presentCount'),
        children: participants.map((LiveSessionParticipantModel item) {
          return ListTile(
            dense: true,
            isThreeLine: true,
            leading: Icon(
              item.userRole == 'professor'
                  ? Icons.school_outlined
                  : Icons.person_outline,
            ),
            title: Text(item.userName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${item.userRole} / ${item.joinedAt}'),
                Text(item.isOnline ? 'وضعیت: آنلاین' : 'وضعیت: آفلاین'),
                if (item.present)
                  const Text('حضور و غیاب: حاضر',
                      style: TextStyle(color: Colors.green, fontSize: 12)),
                if (item.raisedHand)
                  const Text('درخواست صحبت: دست بالا',
                      style: TextStyle(color: Colors.orange, fontSize: 12)),
              ],
            ),
            trailing: Wrap(
              spacing: 4,
              children: <Widget>[
                if (isProfessor && item.userRole != 'professor')
                  IconButton(
                    tooltip: item.present ? 'حذف حضور' : 'ثبت حضور',
                    icon: Icon(
                      item.present
                          ? Icons.how_to_reg
                          : Icons.how_to_reg_outlined,
                      color: item.present ? Colors.green : null,
                    ),
                    onPressed: () {
                      live.markParticipantAttendance(
                        sessionId: session.id,
                        userId: item.userId,
                        present: !item.present,
                      );
                    },
                  ),
                if (isProfessor && item.userRole != 'professor')
                  IconButton(
                    tooltip: item.isMuted ? 'فعال کردن میکروفون' : 'قطع صدا',
                    icon: Icon(
                      item.isMuted ? Icons.mic_off_outlined : Icons.mic_none_outlined,
                    ),
                    onPressed: () {
                      live.setParticipantMute(
                        sessionId: session.id,
                        userId: item.userId,
                        muted: !item.isMuted,
                      );
                    },
                  ),
                if (!isProfessor && appState.currentUser?.id == item.userId)
                  IconButton(
                    tooltip: item.raisedHand ? 'حذف دست بالا' : 'درخواست صحبت',
                    icon: Icon(
                      item.raisedHand ? Icons.pan_tool : Icons.pan_tool_outlined,
                    ),
                    onPressed: () {
                      live.setParticipantHandRaise(
                        sessionId: session.id,
                        userId: item.userId,
                        raisedHand: !item.raisedHand,
                      );
                    },
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MessagesPanel extends StatelessWidget {
  final LiveSessionModel session;
  final TextEditingController controller;

  const _MessagesPanel({
    required this.session,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final LiveClassState live = context.watch<LiveClassState>();
    final AppUserModel? user = appState.currentUser;
    final List<LiveSessionMessageModel> messages = live.messagesOf(session.id);

    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.chat_outlined, size: 20),
              SizedBox(width: 6),
              Text(
                'گفتگوی کلاس',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(),
          ...messages.map((LiveSessionMessageModel item) {
            return ListTile(
              dense: true,
              title: Text(item.senderName),
              subtitle: Text(item.text),
              trailing: Text(
                '${item.sentAt.hour}:${item.sentAt.minute.toString().padLeft(2, '0')}',
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'پیام کلاس...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: user == null
                    ? null
                    : () {
                        live.sendMessage(
                          sessionId: session.id,
                          classId: session.classId,
                          senderId: user.id,
                          senderName: user.displayName,
                          senderRole: user.role.name,
                          message: controller.text,
                        );
                        controller.clear();
                      },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





