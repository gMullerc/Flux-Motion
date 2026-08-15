// The trigger is intentionally local because it also configures the generated
// BlurEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'blur_effect.dart';
import 'blur_spec.dart';

/// Ergonomic widget for applying a [BlurEffect] to any child.
class FluxBlur extends FluxMotion {
  FluxBlur({
    super.key,
    required super.child,
    BlurSpec? spec,
    List<BlurEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.controller,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <BlurEffect>[
                BlurEffect(
                  spec ?? const BlurSpec(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
