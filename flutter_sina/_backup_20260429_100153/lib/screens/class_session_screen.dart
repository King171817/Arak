import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';

class ClassSessionScreen extends StatefulWidget {
  final String classId;
  final String className;
  final String professorName;
  final bool isActive;

  const ClassSessionScreen({
    super.key,
    required this.classId,
    required this.className,
    required this.professorName,
    required this.isActive,
  });

  @override
  State<ClassSessionScreen> createState() => _ClassSessionScreenState();
}

class _ClassSessionScreenState extends State<ClassSessionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  int _selectedBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(text: 'به کلاس ${widget.className} خوش آمدید', isUser: false, senderName: 'سیستم', timestamp: DateTime.now()));
    
    if (widget.isActive) {
      _messages.add(ChatMessage(text: 'کلاس فعال است. می‌توانید سوالات خود را مطرح کنید.', isUser: false, senderName: 'سیستم', timestamp: DateTime.now()));
    } else {
      _messages.add(ChatMessage(text: 'کلاس هنوز شروع نشده است. لطفاً منتظر بمانید تا استاد کلاس را شروع کند.', isUser: false, senderName: 'سیستم', timestamp: DateTime.now()));
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, senderName: 'من', timestamp: DateTime.now()));
      _messageController.clear();
    });
    _scrollToBottom();

    if (widget.isActive) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(ChatMessage(text: 'پیام شما دریافت شد. در اسرع وقت پاسخ داده می‌شود.', isUser: false, senderName: widget.professorName, timestamp: DateTime.now()));
          });
          _scrollToBottom();
        }
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.className),
          centerTitle: true,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: widget.isActive ? Colors.green.shade100 : Colors.orange.shade100, borderRadius: BorderRadius.circular(12)),
              child: Text(widget.isActive ? 'فعال' : 'در انتظار شروع', style: TextStyle(color: widget.isActive ? Colors.green.shade800 : Colors.orange.shade800, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade50, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text('استاد: ${widget.professorName}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text('دانشجویان: 0', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message, isRtl);
                },
              ),
            ),
            _buildMessageInput(isRtl),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (index) => setState(() => _selectedBottomNavIndex = index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'گفتگو'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'شرکت‌کنندگان'),
            BottomNavigationBarItem(icon: Icon(Icons.description), label: 'فایل‌ها'),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(bool isRtl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: widget.isActive,
              decoration: InputDecoration(
                hintText: widget.isActive ? 'پیام خود را بنویسید...' : 'کلاس شروع نشده است',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: widget.isActive ? Colors.green : Colors.grey,
            child: IconButton(onPressed: widget.isActive ? _sendMessage : null, icon: const Icon(Icons.send, color: Colors.white, size: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isRtl) {
    return Align(
      alignment: message.isUser ? (isRtl ? Alignment.centerRight : Alignment.centerLeft) : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) Padding(padding: const EdgeInsets.only(left: 8, bottom: 4), child: Text(message.senderName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: message.isUser ? Colors.green.shade100 : Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
              child: Text(message.text),
            ),
            const SizedBox(height: 4),
            Text(_formatTime(message.timestamp), style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String senderName;
  final DateTime timestamp;
  ChatMessage({required this.text, required this.isUser, required this.senderName, required this.timestamp});
}
