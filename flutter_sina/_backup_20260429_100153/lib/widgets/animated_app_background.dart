import 'package:flutter/material.dart';

class AnimatedAppBackground extends StatefulWidget {
  final Widget child;
  const AnimatedAppBackground({super.key, required this.child});

  @override
  State<AnimatedAppBackground> createState() => _AnimatedAppBackgroundState();
}

class _AnimatedAppBackgroundState extends State<AnimatedAppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: dark
                  ? <Color>[
                      const Color(0xFF0F172A),
                      const Color(0xFF1E3A5F),
                      const Color(0xFF0A1929),
                    ]
                  : <Color>[
                      const Color(0xFFE8F5E9),
                      const Color(0xFFC8E6C9),
                      const Color(0xFFA5D6A7),
                    ],
              stops: <double>[0, 0.45 + controller.value * 0.15, 1],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 80 + controller.value * 30,
                right: -60,
                child: _GlowCircle(
                  size: 190,
                  color: dark
                      ? Colors.green.withOpacity(0.15)
                      : Colors.green.withOpacity(0.12),
                ),
              ),
              Positioned(
                bottom: 120 - controller.value * 25,
                left: -70,
                child: _GlowCircle(
                  size: 220,
                  color: dark
                      ? Colors.blue.withOpacity(0.10)
                      : Colors.blue.withOpacity(0.08),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: <BoxShadow>[BoxShadow(color: color, blurRadius: 70, spreadRadius: 25)],
      ),
    );
  }
}
