import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a rotation at one point in its animation.
class RotateRender extends MotionRender {
  const RotateRender({required this.degrees});

  /// Current rotation angle in degrees, exposed for inspection and tests.
  final double degrees;

  @override
  Widget build(Widget child) {
    return Transform.rotate(
      angle: degrees * math.pi / 180,
      alignment: Alignment.center,
      child: child,
    );
  }
}
