import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a fade at one point in its animation.
class FadeRender extends MotionRender {
  const FadeRender({required this.opacity});

  final double opacity;

  @override
  Widget build(Widget child) {
    final clampedOpacity = opacity.clamp(0.0, 1.0).toDouble();
    return Opacity(
      opacity: clampedOpacity,
      child: child,
    );
  }
}
