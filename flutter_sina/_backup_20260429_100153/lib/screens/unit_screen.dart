import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/unit_models.dart';
import 'support_chat_screen.dart';
import 'other_service_screen.dart';

class UnitScreen extends StatefulWidget {
  final UnitModel unit;
  const UnitScreen({super.key, required this.unit});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  int selectedConversation = 0;
  final TextEditingController inputController = TextEditingController();
  late List<MessageModel> messages;

  @override
  void initState() {
    super.initState();
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    messages = <MessageModel>[
      MessageModel(appText(selectedLang, 'welcome_message'), false),
      MessageModel(appText(selectedLang, 'sample_user_message'), true),
      MessageModel(appText(selectedLang, 'sample_staff_message'), false),
    ];
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final AppLang selectedLang = Provider.of<AppState>(context, listen: false).selectedLang;
    final String text = inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(MessageModel(text, true));
      messages.add(MessageModel(appText(selectedLang, 'message_received'), false));
      inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String title = appText(selectedLang, widget.unit.keyName);

    if (widget.unit.keyName == 'other_services') {
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(title: Text(title), centerTitle: true),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.green.withOpacity(0.12),
                      child: const Icon(Icons.apps, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appText(selectedLang, 'other_services'),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherServices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.92,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final OtherService service = otherServices[index];
                    return _otherServiceCard(service);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext _) => const SupportChatScreen(),
                ),
              );
            },
            icon: const Icon(Icons.support_agent_outlined),
            label: Text(appText(selectedLang, 'support')),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Align(
                    alignment: msg.isUser
                        ? (isRtl ? Alignment.centerRight : Alignment.centerLeft)
                        : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isUser ? Colors.green.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg.text),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        hintText: appText(selectedLang, 'write_message'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherServiceCard(OtherService service) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final AppLang selectedLang = Provider.of<AppState>(context).selectedLang;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext _) => OtherServiceScreen(serviceKey: service.key),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(dark ? 0.88 : 0.96),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.22 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: service.color.withOpacity(dark ? 0.22 : 0.12),
              ),
              child: Icon(service.icon, size: 23, color: service.color),
            ),
            const SizedBox(height: 8),
            Text(
              appText(selectedLang, service.key),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageModel {
  final String text;
  final bool isUser;
  MessageModel(this.text, this.isUser);
}
