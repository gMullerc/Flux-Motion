import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a shake at one point in its animation.
final class ShakeRender extends MotionRender {
  /// Creates a render value with the current translation [offset].
  const ShakeRender({required this.offset});

  /// Current translation, exposed for inspection and tests.
  final Offset offset;

  @override
  Widget build(Widget child) {
    return Transform.translate(
      offset: offset,
      child: child,
    );
  }
}
