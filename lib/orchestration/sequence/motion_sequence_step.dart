import '../../core/effects/motion_effect.dart';

/// One effect and its position within a motion sequence.
final class MotionSequenceStep {
  /// Creates a step that waits for [delay] before playing [effect].
  const MotionSequenceStep({
    required this.effect,
    this.delay = Duration.zero,
  });

  /// Effect driven during this step's timeline window.
  final MotionEffect effect;

  /// Time to wait after the previous step and before [effect].
  final Duration delay;
}
