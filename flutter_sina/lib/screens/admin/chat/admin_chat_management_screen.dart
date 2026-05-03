import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/unit_keys.dart';
import '../../../core/theme/theme.dart';
import '../../../models/notifications/chat_message_models.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class AdminChatManagementScreen extends StatefulWidget {
  const AdminChatManagementScreen({super.key});

  @override
  State<AdminChatManagementScreen> createState() => _AdminChatManagementScreenState();
}

class _AdminChatManagementScreenState extends State<AdminChatManagementScreen> {
  final TextEditingController messageCtrl = TextEditingController();
  String selectedReceiverUnit = UnitKeys.adminMain;
  String filterUnit = 'all';

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

    final String senderUnit = appState.currentUnitKey.isEmpty ? UnitKeys.education : appState.currentUnitKey;

    appState.addManagerMessage(
      InterManagerMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderUnit: senderUnit,
        receiverUnit: selectedReceiverUnit,
        senderName: appState.currentUser?.displayName ?? 'مدیر',
        message: text,
        sentAt: DateTime.now(),
        isRead: true,
      ),
    );

    messageCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('پیام مدیریتی ثبت شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final List<InterManagerMessage> messages = appState.managerMessages;
    final List<InterManagerMessage> filteredMessages = filterUnit == 'all'
        ? messages
        : messages.where((InterManagerMessage message) {
            return message.senderUnit == filterUnit || message.receiverUnit == filterUnit;
          }).toList();

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.chat_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت چت و بررسی پیام‌های واحدها',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: AppDecorations.cardDecoration,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  initialValue: selectedReceiverUnit,
                  decoration: const InputDecoration(labelText: 'ارسال به واحد'),
                  items: targets.map((String unitKey) {
                    return DropdownMenuItem<String>(
                      value: unitKey,
                      child: Text(unitKey),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() => selectedReceiverUnit = value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: messageCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'متن پیام مدیریتی',
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
          const SizedBox(height: 12),
          Container(
            decoration: AppDecorations.cardDecoration,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('فیلتر واحد / نقش', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <String>['all', ...targets].map((String unitKey) {
                    final bool selected = filterUnit == unitKey;
                    return ChoiceChip(
                      label: Text(unitKey == 'all' ? 'همه' : unitKey),
                      selected: selected,
                      onSelected: (_) => setState(() => filterUnit = unitKey),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'پیام‌های نمایش داده شده: ${filteredMessages.length} / ${messages.length}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (filteredMessages.isEmpty)
            const EmptyState(message: 'هنوز پیامی ثبت نشده است.')
          else
            ...filteredMessages.reversed.map((InterManagerMessage message) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: AppDecorations.cardDecoration,
                child: ListTile(
                  leading: const Icon(Icons.message_outlined),
                  title: Text('${message.senderUnit} → ${message.receiverUnit}'),
                  subtitle: Text(message.message),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(message.senderName, style: const TextStyle(fontSize: 10)),
                      const SizedBox(height: 4),
                      Text(
                        message.sentAt.toString().substring(0, 19),
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
