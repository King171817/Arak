import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../services/support_service.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> chatMessages = [];
  bool isTyping = false;
  late AnimationController typingController;

  @override
  void initState() {
    super.initState();

    typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;

    chatMessages.add(
      ChatMessage(
        text: appText(selectedLang, 'support_chat_welcome'),
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    typingController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final String text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      chatMessages.add(ChatMessage(text: text, isUser: true));
      controller.clear();
      isTyping = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final String aiResponse = SupportService.getAutoResponse(text, selectedLang);

    setState(() {
      isTyping = false;
      chatMessages.add(ChatMessage(text: aiResponse, isUser: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.support_agent_outlined, color: Colors.green),
              const SizedBox(width: 8),
              Text(appText(selectedLang, 'support')),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chatMessages.length + (isTyping ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (isTyping && index == chatMessages.length) {
                      return _TypingIndicator(controller: typingController);
                    }
                    final ChatMessage msg = chatMessages[index];
                    return Align(
                      alignment: msg.isUser
                          ? (isRtl ? Alignment.centerRight : Alignment.centerLeft)
                          : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (!msg.isUser)
                            CircleAvatar(
                              backgroundColor: Colors.green.withOpacity(0.15),
                              child: const Icon(Icons.support_agent_outlined, color: Colors.green),
                            ),
                          const SizedBox(width: 8),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? Theme.of(context).colorScheme.surface.withOpacity(0.9)
                                  : Colors.green.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(msg.text, style: const TextStyle(height: 1.6)),
                          ),
                          const SizedBox(width: 8),
                          if (msg.isUser)
                            CircleAvatar(
                              backgroundColor: Colors.green.withOpacity(0.12),
                              child: const Icon(Icons.person_outline),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: isRtl ? 'پیام خود را بنویسید...' : 'Write your message...',
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.55),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: sendMessage,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class _TypingIndicator extends StatelessWidget {
  final AnimationController controller;
  const _TypingIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.15),
            child: const Icon(Icons.support_agent_outlined, color: Colors.green),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: List<Widget>.generate(3, (int index) {
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.3, end: 1.0).animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: Interval(index * 0.2, 0.6 + index * 0.2, curve: Curves.easeInOut),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
