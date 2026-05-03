import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class FloatingSupportButton extends StatelessWidget {
  const FloatingSupportButton({super.key});

  void openSupport(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return const _SmartSupportSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'global_support_button',
      onPressed: () => openSupport(context),
      child: const Icon(Icons.support_agent),
    );
  }
}

class _SmartSupportSheet extends StatefulWidget {
  const _SmartSupportSheet();

  @override
  State<_SmartSupportSheet> createState() => _SmartSupportSheetState();
}

class _SmartSupportSheetState extends State<_SmartSupportSheet> {
  final TextEditingController ctrl = TextEditingController();
  final List<_SupportChatMessage> messages = <_SupportChatMessage>[
    _SupportChatMessage(
      text: 'سلام، من پشتیبان هوشمند هستم. سؤال خود را بنویسید.',
      fromUser: false,
    ),
  ];

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void send() {
    final String question = ctrl.text.trim();

    if (question.isEmpty) return;

    final AppState appState = context.read<AppState>();
    final String answer = appState.submitSupportQuestion(question);

    setState(() {
      messages.add(_SupportChatMessage(text: question, fromUser: true));
      messages.add(_SupportChatMessage(text: answer, fromUser: false));
      ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 14,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.58,
        child: Column(
          children: <Widget>[
            const ListTile(
              dense: true,
              leading: Icon(Icons.support_agent),
              title: Text('پشتیبانی هوشمند'),
              subtitle: Text('اگر پاسخ دقیق پیدا نشود، درخواست برای کارشناس ثبت می‌شود.'),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final _SupportChatMessage message = messages[index];

                  return Align(
                    alignment: message.fromUser
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxWidth: 420),
                      decoration: BoxDecoration(
                        color: message.fromUser
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.12)
                            : Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        message.text,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'سؤال یا مشکل خود را بنویسید...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: send,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportChatMessage {
  final String text;
  final bool fromUser;

  const _SupportChatMessage({
    required this.text,
    required this.fromUser,
  });
}
