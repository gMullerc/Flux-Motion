// The trigger is intentionally local because it also configures the generated
// ShakeEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'shake_effect.dart';
import 'shake_preset.dart';
import 'shake_spec.dart';

/// Ergonomic widget for applying a [ShakeEffect] to any child.
final class FluxShake extends FluxMotion {
  /// Creates a shake from one [spec] or a custom list of [effects].
  FluxShake({
    super.key,
    required super.child,
    ShakeSpec? spec,
    List<ShakeEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <ShakeEffect>[
                ShakeEffect(
                  spec ?? ShakePreset.error(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
