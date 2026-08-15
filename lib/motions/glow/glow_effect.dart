import 'package:flutter/animation.dart';

import '../../core/drivers/explicit_driver.dart';
import '../../core/effects/motion_render.dart';
import '../../core/triggers/motion_trigger.dart';
import 'glow_render.dart';
import 'glow_spec.dart';

/// Explicitly driven glow effect.
class GlowEffect extends ExplicitMotionEffect {
  GlowEffect(
    this.spec, {
    this.activation = MotionTrigger.onMount,
  });

  final GlowSpec spec;
  final MotionTrigger activation;
  double _progress = 0;

  @override
  Duration get duration => spec.duration;

  @override
  Curve get curve => spec.curve;

  @override
  MotionTrigger get trigger => activation;

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
    return GlowRender(
      radius: spec.radius,
      spreadRadius: spec.spreadRadius,
      color: spec.color,
      intensity: spec.intensity * _progress,
      offset: spec.offset,
      shape: spec.shape,
      borderRadius: spec.borderRadius,
    );
  }
}
