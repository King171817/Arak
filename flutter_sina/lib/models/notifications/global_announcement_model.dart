enum AnnouncementType {
  calendar,
  disciplinary,
  celebration,
  classCancellation,
  general,
}

enum AnnouncementTarget {
  all,
  students,
  professors,
  managers,
  unitSpecific,
}

class GlobalAnnouncementModel {
  final String id;
  final String title;
  final String content;
  final AnnouncementType type;
  final AnnouncementTarget target;
  final String? unitKey;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String creatorId;
  final String creatorName;
  final bool isActive;

  const GlobalAnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.target,
    this.unitKey,
    required this.createdAt,
    this.expiresAt,
    required this.creatorId,
    required this.creatorName,
    this.isActive = true,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  GlobalAnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    AnnouncementType? type,
    AnnouncementTarget? target,
    String? unitKey,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? creatorId,
    String? creatorName,
    bool? isActive,
  }) {
    return GlobalAnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      target: target ?? this.target,
      unitKey: unitKey ?? this.unitKey,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      isActive: isActive ?? this.isActive,
    );
  }
}