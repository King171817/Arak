enum AppLang { fa, en, ar }

String langCode(AppLang lang) {
  switch (lang) {
    case AppLang.fa:
      return 'فارسی';
    case AppLang.en:
      return 'English';
    case AppLang.ar:
      return 'العربية';
  }
}

bool isRtlLang(AppLang lang) {
  return lang == AppLang.fa || lang == AppLang.ar;
}

String langKey(AppLang lang) {
  switch (lang) {
    case AppLang.fa:
      return 'FA';
    case AppLang.en:
      return 'EN';
    case AppLang.ar:
      return 'AR';
  }
}

extension AppLangTextDirection on AppLang {
  bool get isRtl => isRtlLang(this);
}
