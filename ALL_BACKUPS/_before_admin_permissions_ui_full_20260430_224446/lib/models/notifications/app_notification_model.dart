class AppNotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String unitKey;
  final bool unread;
  final DateTime createdAt;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.unitKey,
    required this.createdAt,
    this.unread = true,
  });

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? unitKey,
    bool? unread,
    DateTime? createdAt,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      unitKey: unitKey ?? this.unitKey,
      unread: unread ?? this.unread,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
