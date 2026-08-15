import 'motion_sequence_step.dart';

/// Timeline configuration for a sequence of motion effects.
final class SequenceSpec {
  /// Creates a sequence from a non-empty list of [steps].
  SequenceSpec({
    required List<MotionSequenceStep> steps,
    this.repeat = false,
    this.reverse = false,
  })  : assert(steps.isNotEmpty, 'SequenceSpec requires at least one step.'),
        steps = List<MotionSequenceStep>.unmodifiable(steps);

  /// Ordered steps in this timeline.
  final List<MotionSequenceStep> steps;

  /// Whether the complete timeline repeats indefinitely.
  final bool repeat;

  /// Whether a repeated timeline alternates playback direction.
  final bool reverse;

  /// Total time occupied by all delays and effects.
  Duration get totalDuration => steps.fold<Duration>(
        Duration.zero,
        (total, step) => total + step.delay + step.effect.duration,
      );
}
