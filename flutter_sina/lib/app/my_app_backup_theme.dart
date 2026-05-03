import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/helpers/language_helper.dart';
import '../models/auth/app_lang.dart';
import '../state/app_state.dart';
import '../core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({
    super.key,
    required this.home,
  });

  Locale _localeOf(AppLang lang) {
    switch (lang) {
      case AppLang.fa:
        return const Locale('fa');
      case AppLang.en:
        return const Locale('en');
      case AppLang.ar:
        return const Locale('ar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final AppLang lang = appState.selectedLang;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: _localeOf(lang),
          supportedLocales: const [
            Locale('fa'),
            Locale('en'),
            Locale('ar'),
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
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: home,
        );
      },
    );
  }
}
