import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../state/app_state.dart';

class AdminDatasetSettingsScreen extends StatefulWidget {
  const AdminDatasetSettingsScreen({super.key});

  @override
  State<AdminDatasetSettingsScreen> createState() => _AdminDatasetSettingsScreenState();
}

class _AdminDatasetSettingsScreenState extends State<AdminDatasetSettingsScreen> {
  final apiController = TextEditingController(text: 'http://localhost:3000');
  final dbController = TextEditingController(text: 'postgresql://USER:PASSWORD@localhost:5432/arak');
  bool useApi = true;
  bool useLocalMock = true;

  @override
  void dispose() {
    apiController.dispose();
    dbController.dispose();
    super.dispose();
  }

  void save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تنظیمات دیتاست ذخیره شد. اتصال واقعی در مرحله بک‌اند فعال می‌شود.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'settings'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('اتصال دیتاست و بک‌اند', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      dense: true,
                      title: const Text('استفاده از API بک‌اند'),
                      value: useApi,
                      onChanged: (v) => setState(() => useApi = v),
                    ),
                    SwitchListTile(
                      dense: true,
                      title: const Text('استفاده موقت از داده آزمایشی'),
                      subtitle: const Text('تا زمانی که دیتابیس واقعی کامل وصل شود'),
                      value: useLocalMock,
                      onChanged: (v) => setState(() => useLocalMock = v),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: apiController,
                      decoration: const InputDecoration(
                        labelText: 'آدرس API',
                        hintText: 'http://localhost:3000',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dbController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Database URL',
                        hintText: 'postgresql://...',
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: save,
                      icon: const Icon(Icons.save),
                      label: const Text('ذخیره تنظیمات دیتاست'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'برای اتصال واقعی باید همین تنظیمات در بک‌اند NestJS و فایل .env ذخیره شود. '
                  'در مرحله بعد API های /admin/settings/dataset را اضافه می‌کنیم.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
