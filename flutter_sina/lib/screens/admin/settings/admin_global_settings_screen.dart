import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../state/app_state.dart';

/// پیام‌های چندزبانهٔ حالت تعمیرات سراسری و چند گزینهٔ پایه.
class AdminGlobalSettingsScreen extends StatefulWidget {
  const AdminGlobalSettingsScreen({super.key});

  @override
  State<AdminGlobalSettingsScreen> createState() =>
      _AdminGlobalSettingsScreenState();
}

class _AdminGlobalSettingsScreenState extends State<AdminGlobalSettingsScreen> {
  final TextEditingController _fa = TextEditingController();
  final TextEditingController _en = TextEditingController();
  final TextEditingController _ar = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _fa.dispose();
    _en.dispose();
    _ar.dispose();
    super.dispose();
  }

  void _seedFrom(AppState appState) {
    if (_seeded) return;
    _fa.text = appState.maintenanceMessageFaText;
    _en.text = appState.maintenanceMessageEnText;
    _ar.text = appState.maintenanceMessageArText;
    _seeded = true;
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    _seedFrom(appState);

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
                Icon(Icons.public_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'تنظیمات سراسری و پیام تعمیرات',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: AppDecorations.cardDecoration,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'متن بنر تعمیرات (سه زبان)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _fa,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'فارسی',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _en,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'English',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ar,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'العربية',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    appState.setMaintenanceMessages(
                      fa: _fa.text,
                      en: _en.text,
                      ar: _ar.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('پیام‌های تعمیرات ذخیره شد')),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('ذخیره پیام‌ها'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.cardDecoration,
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  title: const Text('حالت تعمیرات سراسری'),
                  subtitle: Text(appState.maintenanceMessageForCurrentLang()),
                  value: appState.maintenanceMode,
                  onChanged: appState.setMaintenanceMode,
                ),
                SwitchListTile(
                  title: const Text('ثبت‌نام کاربران جدید'),
                  value: appState.registrationEnabled,
                  onChanged: appState.setRegistrationEnabled,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
