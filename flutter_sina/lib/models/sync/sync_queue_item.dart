class SyncQueueItem {
  final String id;
  final String tableName;
  final String action;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final String status;

  const SyncQueueItem({
    required this.id,
    required this.tableName,
    required this.action,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'tableName': tableName,
      'action': action,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'status': status,
    };
  }

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) {
    return SyncQueueItem(
      id: json['id']?.toString() ?? '',
      tableName: json['tableName']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      payload: Map<String, dynamic>.from(json['payload'] as Map? ?? <String, dynamic>{}),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      retryCount: int.tryParse(json['retryCount']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? 'pending',
    );
  }

  SyncQueueItem copyWith({
    String? id,
    String? tableName,
    String? action,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
    String? status,
  }) {
    return SyncQueueItem(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
    );
  }
}

