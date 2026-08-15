import 'package:flutter/widgets.dart';

/// Immutable configuration for a [SlideEffect].
class SlideSpec {
  const SlideSpec({
    this.begin = const Offset(0, 24),
    this.end = Offset.zero,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
    this.repeat = false,
    this.reverse = true,
  });

  /// Translation offset at the beginning of the animation.
  final Offset begin;

  /// Translation offset at the end of the animation.
  final Offset end;

  /// Duration of one forward pass.
  final Duration duration;

  /// Curve applied to the animation progress.
  final Curve curve;

  /// Whether the slide keeps playing after the first pass.
  final bool repeat;

  /// When repeating, play the next pass in the opposite direction.
  final bool reverse;
}
