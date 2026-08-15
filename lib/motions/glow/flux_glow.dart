// The trigger is intentionally local because it also configures the generated
// GlowEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/widgets/flux_motion.dart';
import '../../core/triggers/motion_trigger.dart';
import 'glow_effect.dart';
import 'glow_preset.dart';
import 'glow_spec.dart';

/// Ergonomic widget for applying a [GlowEffect] to any child.
class FluxGlow extends FluxMotion {
  FluxGlow({
    super.key,
    required super.child,
    GlowSpec? spec,
    List<GlowEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <GlowEffect>[
                GlowEffect(
                  spec ?? GlowPreset.soft(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
