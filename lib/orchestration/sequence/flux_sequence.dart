// The trigger is intentionally local because it configures SequenceEffect
// before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'motion_sequence_step.dart';
import 'sequence_effect.dart';
import 'sequence_spec.dart';

/// Applies several effects sequentially using one animation timeline.
final class FluxSequence extends FluxMotion {
  /// Creates a sequence from either [spec] or a non-empty list of [steps].
  ///
  /// Exactly one of [spec] and [steps] must be provided.
  FluxSequence({
    super.key,
    required super.child,
    SequenceSpec? spec,
    List<MotionSequenceStep>? steps,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.controller,
    super.engineFactory,
  })  : assert(
          (spec == null) != (steps == null),
          'Pass either spec or steps.',
        ),
        assert(
          steps == null || steps.isNotEmpty,
          'FluxSequence requires at least one step.',
        ),
        super(
          effects: <SequenceEffect>[
            SequenceEffect(
              spec ?? SequenceSpec(steps: steps!),
              activation: trigger,
            ),
          ],
          trigger: trigger,
        );
}
