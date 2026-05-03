import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../models/ui_section_setting_model.dart';
import '../../../state/app_state.dart';

class AdminUiSettingsScreen extends StatelessWidget {
  const AdminUiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final List<UiSectionSettingModel> settings = appState.uiSectionSettings;

    return Container(
      decoration: AppDecorations.pageBackground,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.design_services_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت ظاهر، آیکون‌ها، فونت و پیام‌های شناور',
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
          const _AppearanceControlPanel(),
          const SizedBox(height: 12),
          const Text(
            'تنظیم ظاهر بخش‌ها و نقش‌ها',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...settings.map((UiSectionSettingModel setting) {
            return _UiSettingCard(setting: setting);
          }),
        ],
      ),
    );
  }
}

class _AppearanceControlPanel extends StatelessWidget {
  const _AppearanceControlPanel();

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return Container(
      decoration: AppDecorations.cardDecoration,
      child: Column(
        children: <Widget>[
          const ListTile(
            dense: true,
            leading: Icon(Icons.wallpaper_outlined, size: 22),
            title: Text(
              'کنترل فایل‌های ظاهری سامانه',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              'لوگو، اسپلش، بک‌گراند هدر، آرم دانشگاه و پس‌زمینه برنامه',
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Divider(height: 1),
          _AppearanceAction(
            icon: Icons.image_outlined,
            title: 'تغییر لوگوی صفحه ورود',
            subtitle: 'در نسخه دیتابیس، فایل از Storage انتخاب می‌شود.',
            onTap: () => _showTodo(context),
          ),
          _AppearanceAction(
            icon: Icons.movie_filter_outlined,
            title: 'تغییر فایل اسپلش',
            subtitle: 'GIF / تصویر / ویدئو برای شروع برنامه',
            onTap: () => _showTodo(context),
          ),
          _AppearanceAction(
            icon: Icons.account_balance_outlined,
            title: 'تغییر آرم هدر',
            subtitle: 'آرم دانشگاه یا آرم واحد در هدر برنامه',
            onTap: () => _showTodo(context),
          ),
          _AppearanceAction(
            icon: Icons.landscape_outlined,
            title: 'تغییر بک‌گراند هدر',
            subtitle: 'جایگزینی بک‌گراند هدر با فایل جدید',
            onTap: () => _showTodo(context),
          ),
          SwitchListTile(
            dense: true,
            title: const Text('حالت تیره'),
            subtitle: const Text('تغییر تم روز و شب'),
            value: appState.isDarkMode,
            onChanged: appState.setDarkMode,
          ),
        ],
      ),
    );
  }

  static void _showTodo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('اتصال انتخاب فایل به Supabase Storage در گام دیتابیس انجام می‌شود.'),
      ),
    );
  }
}

class _AppearanceAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AppearanceAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -3),
      leading: Icon(icon, size: 21),
      title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
      trailing: const Icon(Icons.chevron_right, size: 17),
      onTap: onTap,
    );
  }
}

class _UiSettingCard extends StatelessWidget {
  final UiSectionSettingModel setting;

  const _UiSettingCard({
    required this.setting,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.read<AppState>();

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: AppDecorations.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    _safeIcon(setting.targetKey),
                    size: setting.iconSize.clamp(18, 30),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        setting.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: setting.fontSize.clamp(11, 17),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${setting.targetType} / ${setting.targetKey}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('نمایش داده شود', style: TextStyle(fontSize: 12)),
              value: setting.visible,
              onChanged: (bool value) {
                appState.toggleUiSectionVisibility(setting.id, value);
              },
            ),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('فعال باشد', style: TextStyle(fontSize: 12)),
              value: setting.enabled,
              onChanged: (bool value) {
                appState.toggleUiSectionEnabled(setting.id, value);
              },
            ),
            _SliderRow(
              title: 'سایز آیکون',
              value: setting.iconSize,
              min: 18,
              max: 32,
              onChanged: (double value) {
                appState.changeUiSectionIconSize(setting.id, value);
              },
            ),
            _SliderRow(
              title: 'سایز فونت',
              value: setting.fontSize,
              min: 11,
              max: 18,
              onChanged: (double value) {
                appState.changeUiSectionFontSize(setting.id, value);
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('انتخاب آیکون از لیست آیکون‌ها در گام بعد متصل می‌شود.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.emoji_symbols_outlined, size: 17),
                    label: const Text('تغییر آیکون'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('پیام شناور این بخش در گام دیتابیس ذخیره می‌شود.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.campaign_outlined, size: 17),
                    label: const Text('پیام شناور'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _safeIcon(String key) {
    switch (key) {
      case 'dashboard':
        return Icons.dashboard_outlined;
      case 'classes':
        return Icons.school_outlined;
      case 'students':
        return Icons.people_outline;
      case 'professors':
        return Icons.person_pin_outlined;
      case 'tickets':
        return Icons.confirmation_number_outlined;
      case 'services':
        return Icons.apps_outlined;
      case 'educationManager':
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.widgets_outlined;
    }
  }
}

class _SliderRow extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 82,
          child: Text(title, style: const TextStyle(fontSize: 11)),
        ),
        Expanded(
          child: Slider(
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            value: value.clamp(min, max),
            label: value.toStringAsFixed(0),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
