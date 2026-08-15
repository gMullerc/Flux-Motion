import 'package:flutter/animation.dart';

/// Axis along which a shake moves its child.
enum ShakeAxis {
  /// Moves the child from side to side.
  horizontal,

  /// Moves the child up and down.
  vertical,
}

/// Immutable configuration for a [ShakeEffect].
final class ShakeSpec {
  /// Creates a shake configuration.
  const ShakeSpec({
    this.distance = 12,
    this.oscillations = 3,
    this.axis = ShakeAxis.horizontal,
    this.duration = const Duration(milliseconds: 520),
    this.curve = Curves.easeOutCubic,
    this.repeat = false,
  })  : assert(distance >= 0),
        assert(oscillations > 0);

  /// Maximum translation distance in logical pixels.
  final double distance;

  /// Number of complete side-to-side oscillations.
  final int oscillations;

  /// Axis along which the translation is applied.
  final ShakeAxis axis;

  /// Duration of one shake sequence.
  final Duration duration;

  /// Timing curve applied to the shake progress.
  final Curve curve;

  /// Whether the shake sequence keeps playing.
  final bool repeat;
}
