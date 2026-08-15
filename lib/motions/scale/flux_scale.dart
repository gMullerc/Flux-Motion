// The trigger is intentionally local because it also configures the generated
// ScaleEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'scale_effect.dart';
import 'scale_spec.dart';

/// Ergonomic widget for applying a [ScaleEffect] to any child.
class FluxScale extends FluxMotion {
  FluxScale({
    super.key,
    required super.child,
    ScaleSpec? spec,
    List<ScaleEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.controller,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <ScaleEffect>[
                ScaleEffect(
                  spec ?? const ScaleSpec(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
