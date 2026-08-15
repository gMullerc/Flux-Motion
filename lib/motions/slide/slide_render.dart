import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a slide at one point in its animation.
class SlideRender extends MotionRender {
  const SlideRender({required this.offset});

  final Offset offset;

  @override
  Widget build(Widget child) {
    return Transform.translate(
      offset: offset,
      child: child,
    );
  }
}
