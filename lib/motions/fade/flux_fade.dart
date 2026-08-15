// The trigger is intentionally local because it also configures the generated
// FadeEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'fade_effect.dart';
import 'fade_spec.dart';

/// Ergonomic widget for applying a [FadeEffect] to any child.
class FluxFade extends FluxMotion {
  FluxFade({
    super.key,
    required super.child,
    FadeSpec? spec,
    List<FadeEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <FadeEffect>[
                FadeEffect(
                  spec ?? const FadeSpec(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
