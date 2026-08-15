// The trigger is intentionally local because it also configures the generated
// BounceEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'bounce_effect.dart';
import 'bounce_preset.dart';
import 'bounce_spec.dart';

/// Ergonomic widget for applying a [BounceEffect] to any child.
final class FluxBounce extends FluxMotion {
  /// Creates a bounce from one [spec] or a custom list of [effects].
  FluxBounce({
    super.key,
    required super.child,
    BounceSpec? spec,
    List<BounceEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.controller,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <BounceEffect>[
                BounceEffect(
                  spec ?? BouncePreset.success(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
