import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class StudentSettingsScreen extends StatelessWidget {
  const StudentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'settings'),
          icon: Icons.settings_outlined,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: Text(isRtlLang(lang) ? 'حالت تیره' : 'Dark Mode'),
                subtitle: Text(
                  isRtlLang(lang)
                      ? 'تغییر ظاهر برنامه'
                      : 'Change application appearance',
                ),
                value: appState.isDarkMode,
                onChanged: appState.setDarkMode,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    appText(lang, 'language'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Wrap(
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
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: isRtlLang(lang) ? 'اعلان‌ها' : 'Notifications',
          icon: Icons.notifications_none,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: Text(isRtlLang(lang) ? 'دریافت اعلان‌ها' : 'Receive Notifications'),
                value: true,
                onChanged: (_) {},
              ),
              SwitchListTile(
                title: Text(isRtlLang(lang) ? 'صدای اعلان' : 'Notification Sound'),
                value: false,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: isRtlLang(lang) ? 'امنیت' : 'Security',
          icon: Icons.security_outlined,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(isRtlLang(lang) ? 'تغییر رمز عبور' : 'Change Password'),
                subtitle: Text(
                  isRtlLang(lang)
                      ? 'در نسخه بعد به دیتابیس متصل می‌شود.'
                      : 'Will be connected to database later.',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(isRtlLang(lang) ? 'حریم خصوصی' : 'Privacy'),
                subtitle: Text(
                  isRtlLang(lang)
                      ? 'مدیریت نمایش اطلاعات پروفایل'
                      : 'Manage profile visibility',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

