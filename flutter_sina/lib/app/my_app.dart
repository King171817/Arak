import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/helpers/language_helper.dart';
import '../core/theme/app_theme.dart';
import '../models/auth/app_lang.dart';
import '../state/app_state.dart';
import '../widgets/announcements/floating_announcement_banner.dart';

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({
    super.key,
    required this.home,
  });

  Locale _localeOf(AppLang lang) {
    switch (lang) {
      case AppLang.fa:
        return const Locale('fa', 'IR');
      case AppLang.en:
        return const Locale('en', 'US');
      case AppLang.ar:
        return const Locale('ar', 'SA');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final lang = appState.selectedLang;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: _localeOf(lang),
          supportedLocales: const [
            Locale('fa', 'IR'),
            Locale('en', 'US'),
            Locale('ar', 'SA'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            return Directionality(
              textDirection: textDirectionOf(lang),
              child: FloatingAnnouncementBanner(child: child ?? const SizedBox.shrink()),
            );
          },
          home: home,
        );
      },
    );
  }
}

