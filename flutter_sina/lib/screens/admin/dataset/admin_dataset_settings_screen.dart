import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../repositories/admin_advanced_repository.dart';
import '../../../state/app_state.dart';

class AdminDatasetSettingsScreen extends StatefulWidget {
  const AdminDatasetSettingsScreen({super.key});

  @override
  State<AdminDatasetSettingsScreen> createState() => _AdminDatasetSettingsScreenState();
}

class _AdminDatasetSettingsScreenState extends State<AdminDatasetSettingsScreen> {
  final repository = AdminAdvancedRepository();

  final apiController = TextEditingController();
  final dbController = TextEditingController();

  bool useApi = true;
  bool useMock = true;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadSetting();
  }

  @override
  void dispose() {
    apiController.dispose();
    dbController.dispose();
    super.dispose();
  }

  Future<void> loadSetting() async {
    try {
      final setting = await repository.fetchDatasetSetting();
      if (!mounted) return;

      setState(() {
        apiController.text = setting.apiBaseUrl;
        dbController.text = setting.databaseUrl;
        useApi = setting.useApi;
        useMock = setting.useMock;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        apiController.text = 'http://localhost:3001';
        dbController.text = '';
        loading = false;
        error = e.toString();
      });
    }
  }

  Future<void> save() async {
    try {
      await repository.saveDatasetSetting(
        apiBaseUrl: apiController.text.trim(),
        databaseUrl: dbController.text.trim(),
        useApi: useApi,
        useMock: useMock,
        updatedBy: 'sina',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تنظیمات دیتاست در بک‌اند ذخیره شد.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ذخیره دیتاست: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(
        title: Text(t(lang, 'settings')),
        actions: [
          IconButton(onPressed: loadSetting, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (error != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('هشدار اتصال: $error'),
                      ),
                    ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'تنظیم اتصال دیتاست و API',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            dense: true,
                            title: const Text('استفاده از API بک‌اند'),
                            value: useApi,
                            onChanged: (v) => setState(() => useApi = v),
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text('استفاده از Mock Data'),
                            subtitle: const Text('برای توسعه بدون وابستگی کامل به بک‌اند'),
                            value: useMock,
                            onChanged: (v) => setState(() => useMock = v),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: apiController,
                            decoration: const InputDecoration(
                              labelText: 'API Base URL',
                              hintText: 'http://localhost:3001',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: dbController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Database URL / Supabase PostgreSQL',
                              hintText: 'postgresql://postgres:...',
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: save,
                              icon: const Icon(Icons.save),
                              label: const Text('ذخیره تنظیمات دیتاست'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
