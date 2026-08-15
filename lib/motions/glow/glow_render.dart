import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a glow at one point in its animation.
class GlowRender extends MotionRender {
  const GlowRender({
    required this.radius,
    required this.spreadRadius,
    required this.color,
    required this.intensity,
    required this.offset,
    required this.shape,
    this.borderRadius,
  });

  final double radius;
  final double spreadRadius;
  final Color color;
  final double intensity;
  final Offset offset;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(Widget child) {
    final alpha = (color.alpha * intensity).round().clamp(0, 255);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        shape: shape,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withAlpha(alpha),
            blurRadius: radius,
            spreadRadius: spreadRadius,
            offset: offset,
          ),
        ],
      ),
      child: child,
    );
  }
}
