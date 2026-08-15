// The trigger is intentionally local because it also configures the generated
// RotateEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'rotate_effect.dart';
import 'rotate_spec.dart';

/// Ergonomic widget for applying a [RotateEffect] to any child.
class FluxRotate extends FluxMotion {
  FluxRotate({
    super.key,
    required super.child,
    RotateSpec? spec,
    List<RotateEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <RotateEffect>[
                RotateEffect(
                  spec ?? const RotateSpec(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
