import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/permissions/permission_state.dart';

class PermissionGuard extends StatelessWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final permissionState = context.watch<PermissionState>();

    if (permissionState.isLocked) {
      return fallback ?? const SizedBox.shrink();
    }

    if (!permissionState.has(permission)) {
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }
}
