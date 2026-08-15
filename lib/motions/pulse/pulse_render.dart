import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a pulse at one point in its animation.
final class PulseRender extends MotionRender {
  /// Creates a render value with the current [scale] and [alignment].
  const PulseRender({
    required this.scale,
    required this.alignment,
  });

  /// Current uniform scale, exposed for inspection and tests.
  final double scale;

  /// Point around which the scale is applied.
  final Alignment alignment;

  @override
  Widget build(Widget child) {
    return Transform.scale(
      scale: scale,
      alignment: alignment,
      child: child,
    );
  }
}
