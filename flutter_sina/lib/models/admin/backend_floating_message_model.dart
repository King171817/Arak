import '../auth/app_lang.dart';

class BackendFloatingMessageModel {
  final String id;
  final String textFa;
  final String textEn;
  final String textAr;
  final DateTime startAt;
  final DateTime endAt;
  final List<String> roles;
  final List<String> units;
  final List<String> userIds;
  final bool isActive;

  const BackendFloatingMessageModel({
    required this.id,
    required this.textFa,
    required this.textEn,
    required this.textAr,
    required this.startAt,
    required this.endAt,
    required this.roles,
    required this.units,
    required this.userIds,
    required this.isActive,
  });

  factory BackendFloatingMessageModel.fromJson(Map<String, dynamic> json) {
    return BackendFloatingMessageModel(
      id: json['id']?.toString() ?? '',
      textFa: json['textFa']?.toString() ?? '',
      textEn: json['textEn']?.toString() ?? '',
      textAr: json['textAr']?.toString() ?? '',
      startAt: DateTime.tryParse(json['startAt']?.toString() ?? '') ?? DateTime.now(),
      endAt: DateTime.tryParse(json['endAt']?.toString() ?? '') ?? DateTime.now(),
      roles: _toStringList(json['roles']),
      units: _toStringList(json['units']),
      userIds: _toStringList(json['userIds']),
      isActive: json['isActive'] == true,
    );
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String && value.trim().isNotEmpty) return [value];
    return <String>[];
  }

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
    if (roles.isEmpty && units.isEmpty && userIds.isEmpty) return true;
    if (userIds.contains(userId)) return true;
    if (roles.contains(role)) return true;
    if (unit.isNotEmpty && units.contains(unit)) return true;
    return false;
  }

  String textFor(AppLang lang) {
    switch (lang) {
      case AppLang.fa:
        return textFa.isNotEmpty ? textFa : textEn;
      case AppLang.en:
        return textEn.isNotEmpty ? textEn : textFa;
      case AppLang.ar:
        return textAr.isNotEmpty ? textAr : textFa;
    }
  }
}
