import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  static BoxDecoration pageBackground(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).primaryColor.withValues(alpha: 0.05),
          Colors.white,
        ],
      ),
    );
  }

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 15,
        offset: Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration headerDecoration = const BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.primary, AppColors.primaryDark],
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    ),
  );
}
