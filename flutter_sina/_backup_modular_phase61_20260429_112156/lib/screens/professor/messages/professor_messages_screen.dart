import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ProfessorMessagesScreen extends StatelessWidget {
  const ProfessorMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final messages = appState.getMessagesForCurrentUnit();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'managers_chat'),
          icon: Icons.chat_outlined,
          child: messages.isEmpty
              ? EmptyState(
                  message: isRtlLang(lang)
                      ? 'هنوز پیامی ثبت نشده است.'
                      : 'No messages yet.',
                )
              : Column(
                  children: messages.map((message) {
                    return ListTile(
                      leading: const Icon(Icons.message_outlined),
                      title: Text(message.senderName),
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
