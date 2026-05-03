import 'package:flutter/material.dart';

class SmoothFadeSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;

  const SmoothFadeSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 420),
    this.beginOffset = const Offset(0, 0.04),
  });

  @override
  State<SmoothFadeSlide> createState() => _SmoothFadeSlideState();
}

class _SmoothFadeSlideState extends State<SmoothFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> opacity;
  late final Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    opacity = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    offset = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: widget.child,
      ),
    );
  }
}

