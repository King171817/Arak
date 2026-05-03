import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ctrl = TextEditingController();
  final messages = <String>['سلام! پشتیبانی دانشگاه اراک آماده پاسخگویی است.'];
  @override
  void dispose() { ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Column(children: [
      Expanded(child: ListView(padding: const EdgeInsets.all(16), children: messages.map((m) => Card(child: ListTile(title: Text(m)))).toList())),
      Padding(padding: const EdgeInsets.all(12), child: Row(children: [
        Expanded(child: TextField(controller: ctrl, decoration: InputDecoration(hintText: t(app.selectedLang, 'پیام...', 'Message...', 'رسالة...'), border: const OutlineInputBorder()))),
        const SizedBox(width: 8),
        FilledButton(onPressed: () { final m = ctrl.text.trim(); if (m.isNotEmpty) setState(() { messages.add(m); messages.add(t(app.selectedLang, 'درخواست شما ثبت شد.', 'Your request was registered.', 'تم تسجيل طلبك.')); ctrl.clear(); }); }, child: const Icon(Icons.send)),
      ])),
    ]);
  }
}
