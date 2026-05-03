import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../models/notifications/floating_announcement_model.dart';
import '../../../state/app_state.dart';

/// مدیریت ظاهر: بخش‌های UI، برندینگ (لوگو/پس‌زمینه)، پیام شناور چندزبانه.
class AdminUiSettingsScreen extends StatefulWidget {
  const AdminUiSettingsScreen({super.key});

  @override
  State<AdminUiSettingsScreen> createState() => _AdminUiSettingsScreenState();
}

class _AdminUiSettingsScreenState extends State<AdminUiSettingsScreen> {
  final TextEditingController _floatFa = TextEditingController();
  final TextEditingController _floatEn = TextEditingController();
  final TextEditingController _floatAr = TextEditingController();
  FloatingAnnouncementTarget _floatTarget = FloatingAnnouncementTarget.all;
  int? _expireHours;

  static const List<String> _logoKeys = <String>[
    'default',
    'compact',
    'wide',
  ];

  static const List<String> _bgKeys = <String>[
    'spring',
    'classic',
    'minimal',
    'event',
    'dark_glow',
  ];

  @override
  void dispose() {
    _floatFa.dispose();
    _floatEn.dispose();
    _floatAr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

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
                Icon(Icons.palette_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت ظاهر و پیام شناور',
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
          const Text(
            'تنظیمات نمایش هر بخش برای نقش‌ها در اپ. در نسخهٔ متصل به سرور، '
            'این مقادیر از دیتابیس خوانده و ذخیره می‌شوند.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ...appState.uiSectionSettings.map((setting) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: AppDecorations.cardDecoration,
              child: ExpansionTile(
                leading: Icon(setting.icon, color: AppColors.primary),
                title: Text(
                  setting.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  '${setting.targetKey} · ${setting.targetType}',
                  style: const TextStyle(fontSize: 10),
                ),
                children: <Widget>[
                  SwitchListTile(
                    dense: true,
                    title: const Text('نمایش در منو'),
                    value: setting.visible,
                    onChanged: (bool v) {
                      appState.toggleUiSectionVisibility(setting.id, v);
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: const Text('فعال (قابل کلیک)'),
                    value: setting.enabled,
                    onChanged: (bool v) {
                      appState.toggleUiSectionEnabled(setting.id, v);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('اندازه آیکون: ${setting.iconSize.round()}'),
                        Slider(
                          min: 16,
                          max: 40,
                          value: setting.iconSize,
                          onChanged: (double v) {
                            appState.changeUiSectionIconSize(setting.id, v);
                          },
                        ),
                        Text('اندازه فونت برچسب: ${setting.fontSize.round()}'),
                        Slider(
                          min: 10,
                          max: 20,
                          value: setting.fontSize,
                          onChanged: (double v) {
                            appState.changeUiSectionFontSize(setting.id, v);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.cardDecoration,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'برندینگ سراسری',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('کلید لوگوی هدر'),
                  subtitle: DropdownButton<String>(
                    isExpanded: true,
                    value: appState.selectedLogoKey,
                    items: _logoKeys
                        .map((String k) => DropdownMenuItem<String>(
                              value: k,
                              child: Text(k),
                            ))
                        .toList(),
                    onChanged: (String? v) {
                      if (v != null) appState.setLogoKey(v);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('تم پس‌زمینهٔ عمومی'),
                  subtitle: DropdownButton<String>(
                    isExpanded: true,
                    value: appState.selectedBackgroundKey,
                    items: _bgKeys
                        .map((String k) => DropdownMenuItem<String>(
                              value: k,
                              child: Text(k),
                            ))
                        .toList(),
                    onChanged: (String? v) {
                      if (v != null) appState.setBackgroundKey(v);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.cardDecoration,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'پیام شناور چندزبانه (نوار بالای صفحه بعد از ورود)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                DropdownButton<FloatingAnnouncementTarget>(
                  isExpanded: true,
                  value: _floatTarget,
                  items: FloatingAnnouncementTarget.values
                      .map((FloatingAnnouncementTarget t) =>
                          DropdownMenuItem<FloatingAnnouncementTarget>(
                            value: t,
                            child: Text(t.name),
                          ))
                      .toList(),
                  onChanged: (FloatingAnnouncementTarget? v) {
                    if (v != null) setState(() => _floatTarget = v);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _floatFa,
                  decoration: const InputDecoration(
                    labelText: 'متن فارسی',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _floatEn,
                  decoration: const InputDecoration(
                    labelText: 'English text',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _floatAr,
                  decoration: const InputDecoration(
                    labelText: 'النص العربي',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<int?>(
                  isExpanded: true,
                  value: _expireHours,
                  hint: const Text('انقضا (ساعت) — اختیاری'),
                  items: <DropdownMenuItem<int?>>[
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('بدون انقضا'),
                    ),
                    ...List<int>.generate(24, (int i) => i + 1).map(
                      (int h) => DropdownMenuItem<int?>(
                        value: h,
                        child: Text('$h ساعت'),
                      ),
                    ),
                  ],
                  onChanged: (int? v) => setState(() => _expireHours = v),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    final DateTime now = DateTime.now();
                    final DateTime? exp = _expireHours == null
                        ? null
                        : now.add(Duration(hours: _expireHours!));
                    appState.setFloatingAnnouncement(
                      FloatingAnnouncementModel(
                        id: 'ann_${now.millisecondsSinceEpoch}',
                        textFa: _floatFa.text.trim().isEmpty
                            ? 'اعلان مدیریت'
                            : _floatFa.text.trim(),
                        textEn: _floatEn.text.trim().isEmpty
                            ? 'Management notice'
                            : _floatEn.text.trim(),
                        textAr: _floatAr.text.trim().isEmpty
                            ? 'تنبيه إداري'
                            : _floatAr.text.trim(),
                        target: _floatTarget,
                        createdAt: now,
                        expiresAt: exp,
                        isActive: true,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'اعمال شد. زبان فعلی اپ: ${appState.selectedLang.name}',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text('اعمال پیام شناور'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
