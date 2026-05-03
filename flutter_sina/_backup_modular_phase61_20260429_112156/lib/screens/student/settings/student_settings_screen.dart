import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';

class StudentSettingsScreen extends StatelessWidget {
  const StudentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  isRtlLang(lang) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  appText(lang, 'settings'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  appText(lang, 'language'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppLang.values.map((AppLang item) {
                    return ChoiceChip(
                      label: Text(langCode(item)),
                      selected: appState.selectedLang == item,
                      onSelected: (_) => appState.setLanguage(item),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 22),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    isRtlLang(lang) ? 'حالت تیره' : 'Dark mode',
                  ),
                  value: appState.isDarkMode,
                  onChanged: (_) => appState.toggleTheme(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
