import 'package:flutter/widgets.dart';

/// Immutable configuration for a [FadeEffect].
class FadeSpec {
  const FadeSpec({
    this.begin = 0,
    this.end = 1,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
    this.repeat = false,
    this.reverse = true,
  });

  /// Opacity at the beginning of the animation.
  final double begin;

  /// Opacity at the end of the animation.
  final double end;

  /// Duration of one forward pass.
  final Duration duration;

  /// Curve applied to the animation progress.
  final Curve curve;

  /// Whether the fade keeps playing after the first pass.
  final bool repeat;

  /// When repeating, play the next pass in the opposite direction.
  final bool reverse;
}
