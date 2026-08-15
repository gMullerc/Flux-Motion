// The trigger is intentionally local because it also configures the generated
// PulseEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'pulse_effect.dart';
import 'pulse_preset.dart';
import 'pulse_spec.dart';

/// Ergonomic widget for applying a [PulseEffect] to any child.
final class FluxPulse extends FluxMotion {
  /// Creates a pulse from one [spec] or a custom list of [effects].
  FluxPulse({
    super.key,
    required super.child,
    PulseSpec? spec,
    List<PulseEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.controller,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <PulseEffect>[
                PulseEffect(
                  spec ?? PulsePreset.emphasis(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
