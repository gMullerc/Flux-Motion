import 'package:flutter/widgets.dart';

/// Direction followed by the shimmer highlight band.
enum ShimmerDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

/// Immutable configuration for a [ShimmerEffect].
class ShimmerSpec {
  const ShimmerSpec({
    this.baseColor = const Color(0x00000000),
    this.highlightColor = const Color(0xFFFFFFFF),
    this.intensity = 0.7,
    this.bandWidth = 0.28,
    this.direction = ShimmerDirection.leftToRight,
    this.duration = const Duration(milliseconds: 1300),
    this.curve = Curves.linear,
    this.repeat = true,
    this.reverse = false,
  })  : assert(intensity >= 0 && intensity <= 1),
        assert(bandWidth > 0 && bandWidth <= 1);

  /// Color applied outside the moving highlight band.
  ///
  /// Keep it transparent to preserve the original child colors.
  final Color baseColor;

  /// Color used at the center of the moving highlight band.
  final Color highlightColor;

  /// Opacity multiplier applied to [highlightColor], from zero to one.
  final double intensity;

  /// Relative width of the highlight band, from zero to one.
  final double bandWidth;

  /// Axis and direction followed by the highlight.
  final ShimmerDirection direction;

  /// Duration of one complete pass.
  final Duration duration;

  /// Timing curve applied to the highlight progress.
  final Curve curve;

  /// Whether the shimmer keeps playing after the first pass.
  final bool repeat;

  /// When repeating, alternate the pass direction.
  final bool reverse;
}
