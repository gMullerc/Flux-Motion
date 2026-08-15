import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Visual representation of a blur at one point in its animation.
class BlurRender extends MotionRender {
  const BlurRender({
    required this.sigmaX,
    required this.sigmaY,
  });

  final double sigmaX;
  final double sigmaY;

  @override
  Widget build(Widget child) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
      ),
      child: child,
    );
  }
}
