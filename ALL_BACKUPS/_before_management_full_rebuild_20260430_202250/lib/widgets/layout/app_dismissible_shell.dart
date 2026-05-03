import 'package:flutter/material.dart';

class AppDismissibleShell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const AppDismissibleShell({
    super.key,
    required this.child,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: child,
    );
  }
}
