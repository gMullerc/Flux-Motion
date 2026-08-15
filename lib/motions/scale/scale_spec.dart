import 'package:flutter/animation.dart';

/// Immutable configuration for a [ScaleEffect].
final class ScaleSpec {
  const ScaleSpec({
    this.begin = 0.92,
    this.end = 1,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutBack,
    this.repeat = false,
    this.reverse = true,
  });

  /// Scale applied at the start of the animation.
  final double begin;

  /// Scale applied at the end of the animation.
  final double end;

  /// Duration of one forward pass.
  final Duration duration;

  /// Curve applied to the scale progress.
  final Curve curve;

  /// Whether the scale keeps playing after the first pass.
  final bool repeat;

  /// When repeating, play the next pass in the opposite direction.
  final bool reverse;
}
