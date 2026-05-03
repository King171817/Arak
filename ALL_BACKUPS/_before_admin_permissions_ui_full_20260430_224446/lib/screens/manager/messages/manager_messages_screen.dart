import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/notifications/chat_message_models.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ManagerMessagesScreen extends StatefulWidget {
  const ManagerMessagesScreen({super.key});

  @override
  State<ManagerMessagesScreen> createState() => _ManagerMessagesScreenState();
}

class _ManagerMessagesScreenState extends State<ManagerMessagesScreen> {
  final TextEditingController messageCtrl = TextEditingController();

  String selectedTargetUnit = UnitKeys.adminMain;

  final List<String> targets = <String>[
    UnitKeys.adminMain,
    UnitKeys.international,
    UnitKeys.education,
    UnitKeys.studentServices,
    UnitKeys.consular,
  ];

  @override
  void dispose() {
    messageCtrl.dispose();
    super.dispose();
  }

  void sendMessage(AppState appState) {
    final String text = messageCtrl.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('متن پیام را وارد کنید.')),
      );
      return;
    }

    final String senderUnit = appState.currentUnitKey.isEmpty
        ? UnitKeys.education
        : appState.currentUnitKey;

    appState.addManagerMessage(
      InterManagerMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderUnit: senderUnit,
        receiverUnit: selectedTargetUnit,
        senderName: appState.currentUser?.displayName ?? 'کاربر',
        message: text,
        sentAt: DateTime.now(),
        isRead: false,
      ),
    );

    messageCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('پیام ارسال شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final messages = appState.getMessagesForCurrentUnit();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: 'ارسال پیام',
          icon: Icons.send_outlined,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  initialValue: selectedTargetUnit,
                  decoration: const InputDecoration(
                    labelText: 'گیرنده',
                    border: OutlineInputBorder(),
                  ),
                  items: targets.map((String unitKey) {
                    return DropdownMenuItem<String>(
                      value: unitKey,
                      child: Text(appText(lang, unitKey)),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      selectedTargetUnit = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: messageCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'متن پیام',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => sendMessage(appState),
                    icon: const Icon(Icons.send),
                    label: const Text('ارسال پیام'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: appText(lang, 'managers_chat'),
          icon: Icons.chat_outlined,
          child: messages.isEmpty
              ? const EmptyState(message: 'هنوز پیامی ثبت نشده است.')
              : Column(
                  children: messages.reversed.map((message) {
                    return ListTile(
                      leading: const Icon(Icons.message_outlined),
                      title: Text('${appText(lang, message.senderUnit)} → ${appText(lang, message.receiverUnit)}'),
                      subtitle: Text(message.message),
                      trailing: Text(formatDateTimeShort(message.sentAt)),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

