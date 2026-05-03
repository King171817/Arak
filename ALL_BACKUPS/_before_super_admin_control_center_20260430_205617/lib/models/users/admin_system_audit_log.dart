class AdminSystemAuditLog {
  final String id;
  final String actor;
  final String action;
  final String description;
  final DateTime createdAt;

  const AdminSystemAuditLog({
    required this.id,
    required this.actor,
    required this.action,
    required this.description,
    required this.createdAt,
  });
}
