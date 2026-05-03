import 'package:flutter/foundation.dart';

import '../../models/admin/access_rule_model.dart';
import '../../repositories/admin_advanced_repository.dart';

class PermissionState extends ChangeNotifier {
  final AdminAdvancedRepository repository;

  PermissionState({
    AdminAdvancedRepository? repository,
  }) : repository = repository ?? AdminAdvancedRepository();

  AccessRuleModel? currentRule;
  bool loading = false;
  String? error;

  Future<void> loadForUser(String userId) async {
    if (userId.isEmpty) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      currentRule = await repository.fetchAccessRuleByUser(userId);
      loading = false;
      error = null;
      notifyListeners();
    } catch (e) {
      currentRule = null;
      loading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  bool get isLocked => currentRule?.isLocked == true;

  String? get roleOverride => currentRule?.role;

  bool has(String permission) {
    final rule = currentRule;
    if (rule == null) return true;
    if (rule.isLocked) return false;
    return rule.permissions.contains(permission);
  }

  bool hasAny(List<String> permissions) {
    return permissions.any(has);
  }

  void clear() {
    currentRule = null;
    loading = false;
    error = null;
    notifyListeners();
  }
}
