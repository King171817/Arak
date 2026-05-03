import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class GlobalAppBackground extends StatelessWidget {
  final Widget child;

  const GlobalAppBackground({
    super.key,
    required this.child,
  });

  List<Color> colorsFor(String key, bool dark) {
    switch (key) {
      case 'classic':
        return dark
            ? <Color>[
                const Color(0xFF111827),
                const Color(0xFF1F2937),
              ]
            : <Color>[
                const Color(0xFFE8F5E9),
                const Color(0xFFFFFFFF),
              ];

      case 'dark_glow':
        return <Color>[
          const Color(0xFF020617),
          const Color(0xFF0F172A),
          const Color(0xFF064E3B),
        ];

      case 'minimal':
        return dark
            ? <Color>[
                const Color(0xFF0F172A),
                const Color(0xFF111827),
              ]
            : <Color>[
                const Color(0xFFF8FAFC),
                const Color(0xFFE5E7EB),
              ];

      case 'event':
        return dark
            ? <Color>[
                const Color(0xFF312E81),
                const Color(0xFF701A75),
                const Color(0xFF111827),
              ]
            : <Color>[
                const Color(0xFFFFF7ED),
                const Color(0xFFFFEDD5),
                const Color(0xFFFDE68A),
              ];

      case 'spring':
      default:
        return dark
            ? <Color>[
                const Color(0xFF0F172A),
                const Color(0xFF064E3B),
                const Color(0xFF111827),
              ]
            : <Color>[
                const Color(0xFFE8F5E9),
                const Color(0xFFC8E6C9),
                const Color(0xFFA5D6A7),
              ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> colors = colorsFor(appState.selectedBackgroundKey, dark);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
