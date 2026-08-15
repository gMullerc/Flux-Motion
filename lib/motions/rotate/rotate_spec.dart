import 'package:flutter/animation.dart';

/// Immutable configuration for a [RotateEffect].
final class RotateSpec {
  const RotateSpec({
    this.beginDegrees = 0,
    this.degrees = 360,
    this.duration = const Duration(milliseconds: 650),
    this.curve = Curves.easeOutCubic,
    this.repeat = false,
    this.reverse = true,
  });

  /// Starting angle in degrees.
  final double beginDegrees;

  /// Total angle delta in degrees. Negative values rotate in reverse.
  final double degrees;

  /// Duration of one forward pass.
  final Duration duration;

  /// Curve applied to the rotation progress.
  final Curve curve;

  /// Whether the rotation keeps playing after the first pass.
  final bool repeat;

  /// When repeating, play the next pass in the opposite direction.
  final bool reverse;
}
