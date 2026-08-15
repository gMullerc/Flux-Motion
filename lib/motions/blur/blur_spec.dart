import 'package:flutter/widgets.dart';

/// Immutable configuration for a [BlurEffect].
class BlurSpec {
  const BlurSpec({
    this.sigmaXBegin = 12,
    this.sigmaYBegin = 12,
    this.sigmaXEnd = 0,
    this.sigmaYEnd = 0,
    this.duration = const Duration(milliseconds: 550),
    this.curve = Curves.easeOutCubic,
    this.repeat = false,
    this.reverse = true,
  })  : assert(sigmaXBegin >= 0),
        assert(sigmaYBegin >= 0),
        assert(sigmaXEnd >= 0),
        assert(sigmaYEnd >= 0);

  /// Horizontal blur sigma at the beginning of the animation.
  final double sigmaXBegin;

  /// Vertical blur sigma at the beginning of the animation.
  final double sigmaYBegin;

  /// Horizontal blur sigma at the end of the animation.
  final double sigmaXEnd;

  /// Vertical blur sigma at the end of the animation.
  final double sigmaYEnd;

  /// Duration of one forward pass.
  final Duration duration;

  /// Curve applied to the interpolation between the two blur states.
  final Curve curve;

  /// Whether the blur keeps playing after the first pass.
  final bool repeat;

  /// When repeating, play the next pass in the opposite direction.
  final bool reverse;
}
