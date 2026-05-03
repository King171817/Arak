import 'auth/app_lang.dart';

class FloatingMessage {
  final String id;
  final Map<AppLang, String> texts;
  final DateTime startAt;
  final DateTime endAt;
  final List<String> targetRoles;
  final List<String> targetUnits;
  final List<String> targetUserIds;
  final bool allRoles;
  final bool isActive;

  const FloatingMessage({
    required this.id,
    required this.texts,
    required this.startAt,
    required this.endAt,
    required this.targetRoles,
    required this.targetUnits,
    required this.targetUserIds,
    this.allRoles = false,
    this.isActive = true,
  });

  bool get isInTimeWindow {
    final now = DateTime.now();
    return now.isAfter(startAt) && now.isBefore(endAt);
  }

  bool canShowFor({
    required String userId,
    required String role,
    required String unit,
  }) {
    if (!isActive || !isInTimeWindow) return false;
    if (allRoles) return true;
    if (targetUserIds.contains(userId)) return true;
    if (targetRoles.contains(role)) return true;
    if (targetUnits.contains(unit)) return true;
    return false;
  }

  String textFor(AppLang lang) {
    return texts[lang] ?? texts[AppLang.fa] ?? texts.values.firstOrNull ?? '';
  }
}
