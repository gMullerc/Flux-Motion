import 'package:flutter/widgets.dart';

/// Immutable configuration for a [PulseEffect].
final class PulseSpec {
  /// Creates a pulse configuration.
  const PulseSpec({
    this.beginScale = 1,
    this.peakScale = 1.08,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    this.repeat = false,
    this.alignment = Alignment.center,
  })  : assert(beginScale > 0),
        assert(peakScale > 0);

  /// Scale at the beginning and end of the pulse.
  final double beginScale;

  /// Scale reached halfway through the pulse.
  final double peakScale;

  /// Duration of one complete pulse.
  final Duration duration;

  /// Timing curve applied to the pulse progress.
  final Curve curve;

  /// Whether the pulse keeps playing.
  final bool repeat;

  /// Point around which the child scales.
  final Alignment alignment;
}
