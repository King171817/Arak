import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';

class UnitsCommunicationScreen extends StatefulWidget {
  final String unitKey;

  const UnitsCommunicationScreen({
    super.key,
    this.unitKey = UnitKeys.education,
  });

  @override
  State<UnitsCommunicationScreen> createState() =>
      _UnitsCommunicationScreenState();
}

class _UnitsCommunicationScreenState extends State<UnitsCommunicationScreen> {
  final TextEditingController messageCtrl = TextEditingController();

  int selectedConversationIndex = 0;

  late final List<_UnitConversation> conversations = <_UnitConversation>[
    _UnitConversation(
      title: 'درخواست راهنمایی',
      trackingCode: '${widget.unitKey.toUpperCase()}-1404-1001',
      messages: <_UnitMessage>[
        _UnitMessage(
          sender: 'student',
          text: 'سلام، برای این درخواست نیاز به راهنمایی دارم.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        _UnitMessage(
          sender: 'unit',
          text: 'سلام، لطفاً جزئیات درخواست خود را ارسال کنید.',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
    _UnitConversation(
      title: 'پیگیری پرونده',
      trackingCode: '${widget.unitKey.toUpperCase()}-1404-1002',
      messages: <_UnitMessage>[
        _UnitMessage(
          sender: 'student',
          text: 'وضعیت پرونده من در چه مرحله‌ای است؟',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    messageCtrl.dispose();
    super.dispose();
  }

  void sendMessage() {
    final String text = messageCtrl.text.trim();

    if (text.isEmpty) return;

    setState(() {
      conversations[selectedConversationIndex].messages.add(
            _UnitMessage(
              sender: 'student',
              text: text,
              createdAt: DateTime.now(),
            ),
          );
    });

    messageCtrl.clear();
  }

  void addQuickMessage(String text) {
    messageCtrl.text = text;
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final bool wide = MediaQuery.of(context).size.width >= 900;
    final _UnitConversation selected = conversations[selectedConversationIndex];

    return Directionality(
      textDirection: textDirectionOf(lang),
      child: Container(
        decoration: AppDecorations.pageBackground(context),
        child: wide
            ? Row(
                children: <Widget>[
                  SizedBox(
                    width: 280,
                    child: _ConversationHistory(
                      unitTitle: appText(lang, widget.unitKey),
                      conversations: conversations,
                      selectedIndex: selectedConversationIndex,
                      onSelect: (int index) {
                        setState(() {
                          selectedConversationIndex = index;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _ChatPanel(
                      unitKey: widget.unitKey,
                      conversation: selected,
                      messageCtrl: messageCtrl,
                      onSend: sendMessage,
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: _QuickUnitActions(
                      unitKey: widget.unitKey,
                      onPick: addQuickMessage,
                    ),
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: _ConversationHistory(
                      unitTitle: appText(lang, widget.unitKey),
                      conversations: conversations,
                      selectedIndex: selectedConversationIndex,
                      horizontal: true,
                      onSelect: (int index) {
                        setState(() {
                          selectedConversationIndex = index;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _ChatPanel(
                      unitKey: widget.unitKey,
                      conversation: selected,
                      messageCtrl: messageCtrl,
                      onSend: sendMessage,
                    ),
                  ),
                  SizedBox(
                    height: 142,
                    child: _QuickUnitActions(
                      unitKey: widget.unitKey,
                      horizontal: true,
                      onPick: addQuickMessage,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ConversationHistory extends StatelessWidget {
  final String unitTitle;
  final List<_UnitConversation> conversations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool horizontal;

  const _ConversationHistory({
    required this.unitTitle,
    required this.conversations,
    required this.selectedIndex,
    required this.onSelect,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget header = Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        unitTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );

    final Widget list = horizontal
        ? ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 210,
                child: _ConversationTile(
                  conversation: conversations[index],
                  selected: selectedIndex == index,
                  onTap: () => onSelect(index),
                ),
              );
            },
          )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: conversations.length,
            itemBuilder: (BuildContext context, int index) {
              return _ConversationTile(
                conversation: conversations[index],
                selected: selectedIndex == index,
                onTap: () => onSelect(index),
              );
            },
          );

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          header,
          Expanded(child: list),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final _UnitConversation conversation;
  final bool selected;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.10)
          : null,
      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: const Icon(Icons.forum_outlined),
        title: Text(
          conversation.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          conversation.trackingCode,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _ChatPanel extends StatelessWidget {
  final String unitKey;
  final _UnitConversation conversation;
  final TextEditingController messageCtrl;
  final VoidCallback onSend;

  const _ChatPanel({
    required this.unitKey,
    required this.conversation,
    required this.messageCtrl,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.account_balance_outlined),
            ),
            title: Text(appText(lang, unitKey)),
            subtitle: Text('Tracking: ${conversation.trackingCode}'),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: conversation.messages.length,
              itemBuilder: (BuildContext context, int index) {
                final _UnitMessage message = conversation.messages[index];
                final bool mine = message.sender == 'student';

                return Align(
                  alignment:
                      mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 520),
                    decoration: BoxDecoration(
                      color: mine
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                          : Colors.grey.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageCtrl,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'پیام خود را بنویسید...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: onSend,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickUnitActions extends StatelessWidget {
  final String unitKey;
  final ValueChanged<String> onPick;
  final bool horizontal;

  const _QuickUnitActions({
    required this.unitKey,
    required this.onPick,
    this.horizontal = false,
  });

  List<String> actions() {
    switch (unitKey) {
      case UnitKeys.education:
        return <String>[
          'درخواست گواهی اشتغال به تحصیل',
          'پیگیری انتخاب واحد',
          'مشاهده برنامه هفتگی',
          'درخواست بررسی پرونده آموزشی',
        ];
      case UnitKeys.international:
        return <String>[
          'پیگیری مدارک پذیرش',
          'سوال درباره اقامت',
          'درخواست راهنمایی برای ویزا',
          'ارسال مدارک تکمیلی',
        ];
      case UnitKeys.studentServices:
        return <String>[
          'پیگیری خوابگاه',
          'درخواست خدمات رفاهی',
          'مشکل کارت دانشجویی',
          'درخواست پشتیبانی',
        ];
      case UnitKeys.consular:
        return <String>[
          'پیگیری امور کنسولی',
          'سوال درباره پاسپورت',
          'درخواست تایید مدارک',
          'مشاوره تمدید اقامت',
        ];
      default:
        return <String>[
          'درخواست راهنمایی',
          'پیگیری درخواست',
          'ارسال مدارک',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = actions();

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: horizontal
            ? ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  return ActionChip(
                    label: Text(items[index]),
                    onPressed: () => onPick(items[index]),
                  );
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'دسترسی سریع',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        return OutlinedButton(
                          onPressed: () => onPick(items[index]),
                          child: Text(items[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _UnitConversation {
  final String title;
  final String trackingCode;
  final List<_UnitMessage> messages;

  _UnitConversation({
    required this.title,
    required this.trackingCode,
    required this.messages,
  });
}

class _UnitMessage {
  final String sender;
  final String text;
  final DateTime createdAt;

  _UnitMessage({
    required this.sender,
    required this.text,
    required this.createdAt,
  });
}




