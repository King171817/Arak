import 'auth/app_lang.dart';

class FloatingMessage {
  final String id;
  final Map<AppLang, String> texts;
  final DateTime start;
  final DateTime end;
  final List<String> roles;
  final List<String> users;
  final List<String> units;

  FloatingMessage({
    required this.id,
    required this.texts,
    required this.start,
    required this.end,
    required this.roles,
    required this.users,
    required this.units,
  });

  bool isActive() {
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }

  String getText(AppLang lang) {
    return texts[lang] ?? texts.values.first;
  }
}
