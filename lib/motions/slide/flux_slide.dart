// The trigger is intentionally local because it also configures the generated
// SlideEffect before being forwarded to FluxMotion.
// ignore_for_file: use_super_parameters
import '../../core/triggers/motion_trigger.dart';
import '../../core/widgets/flux_motion.dart';
import 'slide_effect.dart';
import 'slide_spec.dart';

/// Ergonomic widget for applying a [SlideEffect] to any child.
class FluxSlide extends FluxMotion {
  FluxSlide({
    super.key,
    required super.child,
    SlideSpec? spec,
    List<SlideEffect>? effects,
    MotionTrigger trigger = MotionTrigger.onMount,
    super.controller,
    super.engineFactory,
  })  : assert(
          spec == null || effects == null,
          'Pass either spec or effects, not both.',
        ),
        super(
          effects: effects ??
              <SlideEffect>[
                SlideEffect(
                  spec ?? const SlideSpec(),
                  activation: trigger,
                ),
              ],
          trigger: trigger,
        );
}
