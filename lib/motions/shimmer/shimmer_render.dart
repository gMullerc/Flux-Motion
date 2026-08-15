import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';
import 'shimmer_spec.dart';

/// Shader-based visual representation of a shimmer pass.
class ShimmerRender extends MotionRender {
  const ShimmerRender({
    required this.progress,
    required this.baseColor,
    required this.highlightColor,
    required this.intensity,
    required this.bandWidth,
    required this.direction,
  });

  final double progress;
  final Color baseColor;
  final Color highlightColor;
  final double intensity;
  final double bandWidth;
  final ShimmerDirection direction;

  Alignment get begin {
    switch (direction) {
      case ShimmerDirection.leftToRight:
        return Alignment.centerLeft;
      case ShimmerDirection.rightToLeft:
        return Alignment.centerRight;
      case ShimmerDirection.topToBottom:
        return Alignment.topCenter;
      case ShimmerDirection.bottomToTop:
        return Alignment.bottomCenter;
    }
  }

  Alignment get end {
    switch (direction) {
      case ShimmerDirection.leftToRight:
        return Alignment.centerRight;
      case ShimmerDirection.rightToLeft:
        return Alignment.centerLeft;
      case ShimmerDirection.topToBottom:
        return Alignment.bottomCenter;
      case ShimmerDirection.bottomToTop:
        return Alignment.topCenter;
    }
  }

  List<double> get stops {
    final center = -bandWidth + progress.clamp(0.0, 1.0) * (1 + bandWidth * 2);
    final halfBand = bandWidth / 2;

    return <double>[
      center - bandWidth,
      center - halfBand,
      center,
      center + halfBand,
      center + bandWidth,
    ].map((stop) => stop.clamp(0.0, 1.0)).toList(growable: false);
  }

  @override
  Widget build(Widget child) {
    final alpha = (highlightColor.alpha * intensity).round().clamp(0, 255);
    final highlight = highlightColor.withAlpha(alpha);

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: begin,
          end: end,
          colors: <Color>[
            baseColor,
            baseColor,
            highlight,
            baseColor,
            baseColor,
          ],
          stops: stops,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
