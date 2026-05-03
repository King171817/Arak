import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double fontSize = 14;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lang = app.selectedLang;
    return AppScaffold(
      title: tr(lang, 'settings'),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Column(children: [
          SwitchListTile(title: Text(tr(lang, 'dark_mode')), value: app.isDarkMode, onChanged: (_) => app.toggleTheme()),
          SwitchListTile(title: Text(tr(lang, 'notifications')), value: notifications, onChanged: (v) => setState(() => notifications = v)),
          ListTile(title: Text(tr(lang, 'font_size')), subtitle: Slider(value: fontSize, min: 12, max: 24, divisions: 6, label: '${fontSize.round()}', onChanged: (v) => setState(() => fontSize = v))),
          ListTile(title: Text(tr(lang, 'language')), subtitle: Wrap(spacing: 8, children: AppLang.values.map((l) => ChoiceChip(label: Text(langCode(l)), selected: app.selectedLang == l, onSelected: (_) => app.setLanguage(l))).toList())),
          ListTile(leading: const Icon(Icons.alarm), title: Text(tr(lang, 'reminders'))),
          ListTile(leading: const Icon(Icons.privacy_tip), title: Text(tr(lang, 'privacy'))),
        ])),
      ]),
    );
  }
}
