import 'package:flutter/animation.dart';

import '../../core/drivers/explicit_driver.dart';
import '../../core/effects/motion_render.dart';
import '../../core/triggers/motion_trigger.dart';
import 'shimmer_render.dart';
import 'shimmer_spec.dart';

/// Explicitly driven shimmer effect.
class ShimmerEffect extends ExplicitMotionEffect {
  ShimmerEffect(
    this.spec, {
    this.activation = MotionTrigger.onMount,
  });

  final ShimmerSpec spec;
  final MotionTrigger activation;
  double _progress = 0;

  @override
  Duration get duration => spec.duration;

  @override
  Curve get curve => spec.curve;

  @override
  MotionTrigger get trigger => activation;

  double get progress => _progress;

  @override
  void play({required MotionTrigger trigger}) {
    if (trigger != this.trigger) {
      return;
    }

    if (spec.repeat) {
      controller?.repeat(reverse: spec.reverse);
    } else {
      super.play(trigger: trigger);
    }
  }

  @override
  void tick(Duration elapsed) {
    if (duration == Duration.zero) {
      _progress = 1;
      return;
    }

    final rawProgress =
        (elapsed.inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);
    _progress = curve.transform(rawProgress);
  }

  @override
  MotionRender toRender() {
    return ShimmerRender(
      progress: _progress,
      baseColor: spec.baseColor,
      highlightColor: spec.highlightColor,
      intensity: spec.intensity,
      bandWidth: spec.bandWidth,
      direction: spec.direction,
    );
  }
}
