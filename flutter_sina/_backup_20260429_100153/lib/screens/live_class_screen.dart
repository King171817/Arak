import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import 'services_screen.dart';

class ProfessorLiveClassRoomScreen extends StatefulWidget {
  final ManagedClassModel classModel;
  const ProfessorLiveClassRoomScreen({super.key, required this.classModel});
  @override
  State<ProfessorLiveClassRoomScreen> createState() => _ProfessorLiveClassRoomScreenState();
}

class _ProfessorLiveClassRoomScreenState extends State<ProfessorLiveClassRoomScreen> {
  int tab = 0;
  final announce = TextEditingController();
  final chat = TextEditingController();
  @override
  void dispose() { announce.dispose(); chat.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    final session = app.sessionFor(widget.classModel.id);
    final students = app.students.where((s) => widget.classModel.studentIds.contains(s.id)).toList();
    final pages = [_control(app, lang, session, students), _students(app, lang, session, students), _chat(app, lang, session), const ServicesScreen(), _contact(lang)];
    return AppScaffold(
      title: widget.classModel.name,
      actions: [
        FilledButton.icon(
          onPressed: () => session.isStarted ? app.endClass(widget.classModel.id) : app.startClass(widget.classModel.id),
          icon: Icon(session.isStarted ? Icons.stop_circle : Icons.play_circle),
          label: Text(session.isStarted ? tr(lang, 'end_class') : tr(lang, 'start_class')),
        ),
        const SizedBox(width: 8),
      ],
      body: pages[tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => tab = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.cast_for_education), label: tr(lang, 'control')),
          BottomNavigationBarItem(icon: const Icon(Icons.groups), label: tr(lang, 'students')),
          BottomNavigationBarItem(icon: const Icon(Icons.chat), label: tr(lang, 'chat')),
          BottomNavigationBarItem(icon: const Icon(Icons.apps), label: tr(lang, 'services')),
          BottomNavigationBarItem(icon: const Icon(Icons.support_agent), label: tr(lang, 'contact')),
        ],
      ),
    );
  }

  Widget _control(AppState app, AppLang lang, LiveClassSession s, List<StudentModel> students) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      InfoCard(title: tr(lang, 'classes'), value: s.isStarted ? tr(lang, 'class_live') : tr(lang, 'class_not_started'), icon: s.isStarted ? Icons.live_tv : Icons.lock_clock),
      Card(child: Column(children: [
        SwitchListTile(value: s.chatEnabled, onChanged: s.isStarted ? (v) => app.updateSession(() => s.chatEnabled = v) : null, title: Text(tr(lang, 'chat'))),
        SwitchListTile(value: s.studentMicAllowed, onChanged: s.isStarted ? (v) => app.updateSession(() => s.studentMicAllowed = v) : null, title: Text(tr(lang, 'allow_speak'))),
        SwitchListTile(value: s.cameraAllowed, onChanged: s.isStarted ? (v) => app.updateSession(() => s.cameraAllowed = v) : null, title: Text(tr(lang, 'camera'))),
        SwitchListTile(value: s.recordingEnabled, onChanged: s.isStarted ? (v) => app.updateSession(() => s.recordingEnabled = v) : null, title: Text(tr(lang, 'record'))),
      ])),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: announce, decoration: InputDecoration(labelText: tr(lang, 'announcement'), border: const OutlineInputBorder())),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: s.isStarted ? () {
          final t = announce.text.trim();
          if (t.isNotEmpty) app.updateSession(() { s.announcements.add(t); announce.clear(); });
        } : null, icon: const Icon(Icons.campaign), label: Text(tr(lang, 'send')))),
        ...s.announcements.reversed.map((a) => ListTile(leading: const Icon(Icons.campaign), title: Text(a))),
      ]))),
    ]);
  }

  Widget _students(AppState app, AppLang lang, LiveClassSession s, List<StudentModel> students) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (_, i) {
        final st = students[i];
        final joined = s.joinedStudentIds.contains(st.id);
        final muted = s.mutedStudentIds.contains(st.id);
        final restricted = s.restrictedStudentIds.contains(st.id);
        final hand = s.handRaisedStudentIds.contains(st.id);
        return Card(child: ListTile(
          leading: Icon(joined ? Icons.check_circle : Icons.person_off, color: joined ? Colors.green : Colors.grey),
          title: Text(st.name),
          subtitle: Text('${st.studentNumber} | ${joined ? tr(lang, 'present') : tr(lang, 'not_joined')}${hand ? ' | ✋' : ''}${muted ? ' | ${tr(lang, 'mute')}' : ''}${restricted ? ' | ${tr(lang, 'restrict')}' : ''}'),
          trailing: PopupMenuButton<String>(
            onSelected: (v) => app.updateSession(() {
              if (v == 'mute') { muted ? s.mutedStudentIds.remove(st.id) : s.mutedStudentIds.add(st.id); }
              if (v == 'restrict') { restricted ? s.restrictedStudentIds.remove(st.id) : s.restrictedStudentIds.add(st.id); }
              if (v == 'allow') { s.handRaisedStudentIds.remove(st.id); s.mutedStudentIds.remove(st.id); }
            }),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'mute', child: Text(muted ? tr(lang, 'unmute') : tr(lang, 'mute'))),
              PopupMenuItem(value: 'restrict', child: Text(restricted ? tr(lang, 'remove_restrict') : tr(lang, 'restrict'))),
              PopupMenuItem(value: 'allow', child: Text(tr(lang, 'allow_speak'))),
            ],
          ),
        ));
      },
    );
  }

  Widget _chat(AppState app, AppLang lang, LiveClassSession s) {
    return Column(children: [
      if (!s.isStarted) Container(width: double.infinity, color: Colors.orange.shade100, padding: const EdgeInsets.all(12), child: Text(tr(lang, 'class_not_started'), textAlign: TextAlign.center)),
      Expanded(child: ListView(padding: const EdgeInsets.all(16), children: s.messages.map((m) => Card(child: ListTile(leading: const Icon(Icons.message), title: Text(m)))).toList())),
      Padding(padding: const EdgeInsets.all(12), child: Row(children: [
        Expanded(child: TextField(enabled: s.isStarted && s.chatEnabled, controller: chat, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Message...'))),
        const SizedBox(width: 8),
        FilledButton(onPressed: s.isStarted && s.chatEnabled ? () { final t = chat.text.trim(); if (t.isNotEmpty) app.updateSession(() { s.messages.add('استاد: $t'); chat.clear(); }); } : null, child: const Icon(Icons.send)),
      ])),
    ]);
  }

  Widget _contact(AppLang lang) => ListView(padding: const EdgeInsets.all(16), children: [
    InfoCard(title: tr(lang, 'education'), value: appText(lang, 'ارسال پیام به واحد آموزش', 'Send message to Education', 'إرسال رسالة إلى التعليم'), icon: Icons.school),
    InfoCard(title: tr(lang, 'notifications'), value: appText(lang, 'پشتیبانی کلاس و گزارش مشکل', 'Class support and issue report', 'دعم الفصل والإبلاغ'), icon: Icons.support_agent),
  ]);
}

class StudentLiveClassRoomScreen extends StatefulWidget {
  final ManagedClassModel classModel;
  const StudentLiveClassRoomScreen({super.key, required this.classModel});
  @override
  State<StudentLiveClassRoomScreen> createState() => _StudentLiveClassRoomScreenState();
}

class _StudentLiveClassRoomScreenState extends State<StudentLiveClassRoomScreen> {
  final chat = TextEditingController();
  @override
  void dispose() { chat.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    final id = app.currentUser?.id ?? '';
    final s = app.sessionFor(widget.classModel.id);
    final joined = s.joinedStudentIds.contains(id);
    final muted = s.mutedStudentIds.contains(id);
    final restricted = s.restrictedStudentIds.contains(id);

    if (!s.isStarted) {
      return AppScaffold(title: widget.classModel.name, body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(tr(lang, 'class_not_started'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))));
    }

    return AppScaffold(title: widget.classModel.name, body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: ListTile(
        leading: Icon(joined ? Icons.check_circle : Icons.login, color: joined ? Colors.green : Colors.orange),
        title: Text(joined ? tr(lang, 'present') : tr(lang, 'join_class')),
        trailing: FilledButton(onPressed: restricted ? null : () => app.updateSession(() { joined ? s.joinedStudentIds.remove(id) : s.joinedStudentIds.add(id); }), child: Text(joined ? tr(lang, 'leave_class') : tr(lang, 'join_class'))),
      )),
      Card(child: ListTile(
        leading: Icon(muted ? Icons.mic_off : Icons.mic),
        title: Text(tr(lang, 'mic')),
        subtitle: Text(muted ? tr(lang, 'mute') : (s.studentMicAllowed ? tr(lang, 'allow_speak') : appText(lang, 'برای صحبت اجازه بگیرید', 'Ask permission to speak', 'اطلب الإذن بالكلام'))),
        trailing: IconButton(icon: const Icon(Icons.pan_tool), onPressed: joined ? () => app.updateSession(() => s.handRaisedStudentIds.add(id)) : null),
      )),
      Card(child: SwitchListTile(value: s.cameraAllowed, onChanged: null, title: Text(tr(lang, 'camera')))),
      const SizedBox(height: 12),
      TextField(enabled: joined && s.chatEnabled && !restricted, controller: chat, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Message...')),
      const SizedBox(height: 8),
      FilledButton.icon(onPressed: joined && s.chatEnabled && !restricted ? () { final t = chat.text.trim(); if (t.isNotEmpty) app.updateSession(() { s.messages.add('دانشجو: $t'); chat.clear(); }); } : null, icon: const Icon(Icons.send), label: Text(tr(lang, 'send'))),
      const Divider(),
      ...s.announcements.reversed.map((a) => ListTile(leading: const Icon(Icons.campaign), title: Text(a))),
      ...s.messages.map((m) => ListTile(leading: const Icon(Icons.message), title: Text(m))),
    ]));
  }
}
