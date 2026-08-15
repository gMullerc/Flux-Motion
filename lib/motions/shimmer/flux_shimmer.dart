// The trigger is intentionally local because it also configures the generated
// ShimmerEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'shimmer_effect.dart';
import 'shimmer_preset.dart';
import 'shimmer_spec.dart';

/// Ergonomic widget for applying a [ShimmerEffect] to any child.
class FluxShimmer extends FluxMotion {
  FluxShimmer({
    super.key,
    required super.child,
    ShimmerSpec? spec,
    List<ShimmerEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.controller,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <ShimmerEffect>[
                ShimmerEffect(
                  spec ?? ShimmerPreset.subtle(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
