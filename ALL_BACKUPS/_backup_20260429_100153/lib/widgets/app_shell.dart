import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_lang.dart';
import '../models/app_state.dart';

class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final List<BottomNavigationBarItem>? items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<Widget>? actions;

  const AppShell({
    super.key,
    required this.title,
    required this.body,
    this.items,
    this.currentIndex = 0,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isRtl = isRtlLang(app.selectedLang);
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              tooltip: tr(app.selectedLang, 'language'),
              onPressed: () => _showLanguageDialog(context, app),
              icon: const Icon(Icons.language),
            ),
            IconButton(
              tooltip: tr(app.selectedLang, 'logout'),
              onPressed: app.logout,
              icon: const Icon(Icons.logout),
            ),
            ...?actions,
          ],
        ),
        body: body,
        bottomNavigationBar: items == null
            ? null
            : BottomNavigationBar(
                currentIndex: currentIndex,
                type: BottomNavigationBarType.fixed,
                onTap: onTap,
                items: items!,
              ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppState app) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr(app.selectedLang, 'language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLang.values
              .map((lang) => RadioListTile<AppLang>(
                    value: lang,
                    groupValue: app.selectedLang,
                    onChanged: (v) {
                      if (v != null) app.setLanguage(v);
                      Navigator.pop(context);
                    },
                    title: Text(langCode(lang)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
