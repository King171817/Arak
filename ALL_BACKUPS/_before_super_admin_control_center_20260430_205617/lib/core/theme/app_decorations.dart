import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration pageBackground = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xFFF8FAFF),
        Color(0xFFEFF4FF),
      ],
    ),
  );

  static BoxDecoration headerDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFF1565C0),
        Color(0xFF1E88E5),
        Color(0xFF26A69A),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.10),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(20),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
