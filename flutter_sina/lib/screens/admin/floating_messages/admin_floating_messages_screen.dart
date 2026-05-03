import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../models/floating_message.dart';
import '../../../state/app_state.dart';

class AdminFloatingMessagesScreen extends StatefulWidget {
  const AdminFloatingMessagesScreen({super.key});

  @override
  State<AdminFloatingMessagesScreen> createState() => _AdminFloatingMessagesScreenState();
}

class _AdminFloatingMessagesScreenState extends State<AdminFloatingMessagesScreen> {
  final faController = TextEditingController();
  final enController = TextEditingController();
  final arController = TextEditingController();
  final userIdsController = TextEditingController();

  bool allRoles = true;
  int durationHours = 24;

  final selectedRoles = <String>{};
  final selectedUnits = <String>{};

  final messages = <FloatingMessage>[];

  @override
  void dispose() {
    faController.dispose();
    enController.dispose();
    arController.dispose();
    userIdsController.dispose();
    super.dispose();
  }

  void addMessage() {
    if (faController.text.trim().isEmpty &&
        enController.text.trim().isEmpty &&
        arController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حداقل متن فارسی، انگلیسی یا عربی را وارد کنید.')),
      );
      return;
    }

    final now = DateTime.now();

    setState(() {
      messages.insert(
        0,
        FloatingMessage(
          id: now.microsecondsSinceEpoch.toString(),
          texts: {
            AppLang.fa: faController.text.trim().isEmpty ? enController.text.trim() : faController.text.trim(),
            AppLang.en: enController.text.trim().isEmpty ? faController.text.trim() : enController.text.trim(),
            AppLang.ar: arController.text.trim().isEmpty ? faController.text.trim() : arController.text.trim(),
          },
          startAt: now,
          endAt: now.add(Duration(hours: durationHours)),
          targetRoles: selectedRoles.toList(),
          targetUnits: selectedUnits.toList(),
          targetUserIds: userIdsController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          allRoles: allRoles,
        ),
      );
    });

    faController.clear();
    enController.clear();
    arController.clear();
    userIdsController.clear();
    selectedRoles.clear();
    selectedUnits.clear();
    allRoles = true;
    durationHours = 24;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('پیام شناور ثبت شد.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'floating_announcement'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: faController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'متن فارسی پیام'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: enController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'English message'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: arController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'النص العربي'),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      dense: true,
                      title: const Text('نمایش برای همه نقش‌ها و واحدها'),
                      value: allRoles,
                      onChanged: (v) => setState(() => allRoles = v),
                    ),
                    if (!allRoles) ...[
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text('انتخاب نقش‌ها', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: {
                          'student': 'دانشجو',
                          'professor': 'استاد',
                          'mainAdmin': 'مدیر اصلی',
                          'educationManager': 'مدیر آموزش',
                          'educationExpert': 'کارشناس آموزش',
                          'unitManager': 'مدیر واحد',
                        }.entries.map((entry) {
                          return FilterChip(
                            label: Text(entry.value),
                            selected: selectedRoles.contains(entry.key),
                            onSelected: (v) => setState(() {
                              if (v) {
                                selectedRoles.add(entry.key);
                              } else {
                                selectedRoles.remove(entry.key);
                              }
                            }),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text('انتخاب واحدها', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: {
                          'education': 'آموزش',
                          'international': 'امور بین‌الملل',
                          'consular': 'کنسولی',
                          'student_services': 'خدمات دانشجویی',
                          'other_services': 'سایر خدمات',
                        }.entries.map((entry) {
                          return FilterChip(
                            label: Text(entry.value),
                            selected: selectedUnits.contains(entry.key),
                            onSelected: (v) => setState(() {
                              if (v) {
                                selectedUnits.add(entry.key);
                              } else {
                                selectedUnits.remove(entry.key);
                              }
                            }),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: userIdsController,
                        decoration: const InputDecoration(
                          labelText: 'شناسه کاربران خاص',
                          hintText: 'مثال: student1, prof1, admin1',
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      initialValue: durationHours,
                      decoration: const InputDecoration(labelText: 'مدت نمایش پیام'),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('۱ ساعت')),
                        DropdownMenuItem(value: 3, child: Text('۳ ساعت')),
                        DropdownMenuItem(value: 6, child: Text('۶ ساعت')),
                        DropdownMenuItem(value: 24, child: Text('۱ روز')),
                        DropdownMenuItem(value: 72, child: Text('۳ روز')),
                        DropdownMenuItem(value: 168, child: Text('۷ روز')),
                      ],
                      onChanged: (v) => setState(() => durationHours = v ?? 24),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: addMessage,
                        icon: const Icon(Icons.campaign),
                        label: const Text('ثبت پیام شناور'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...messages.map((m) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.campaign_outlined),
                  title: Text(m.textFor(lang)),
                  subtitle: Text(
                    'تا: ${m.endAt}\n'
                    'همه: ${m.allRoles ? 'بله' : 'خیر'} | نقش‌ها: ${m.targetRoles.join(', ')} | واحدها: ${m.targetUnits.join(', ')}',
                  ),
                  trailing: Switch(
                    value: m.isActive,
                    onChanged: null,
                  ),
                ),
              );
            }),
            if (messages.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('هنوز پیام شناوری ثبت نشده است.'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
