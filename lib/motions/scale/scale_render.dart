import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a scale at one point in its animation.
class ScaleRender extends MotionRender {
  const ScaleRender({required this.scale});

  final double scale;

  @override
  Widget build(Widget child) {
    return Transform.scale(
      scale: scale,
      child: child,
    );
  }
}
