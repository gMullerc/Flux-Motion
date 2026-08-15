import 'package:flutter/animation.dart';

import '../../core/drivers/explicit_driver.dart';
import '../../core/effects/motion_render.dart';
import '../../core/triggers/motion_trigger.dart';
import 'scale_render.dart';
import 'scale_spec.dart';

/// Explicitly driven scale effect.
class ScaleEffect extends ExplicitMotionEffect {
  ScaleEffect(
    this.spec, {
    this.activation = MotionTrigger.onMount,
  }) : _scale = spec.begin;

  final ScaleSpec spec;
  final MotionTrigger activation;
  double _scale;

  /// Current scale value produced by the effect.
  double get scale => _scale;

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
      _scale = spec.end;
      return;
    }

    final rawProgress =
        (elapsed.inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);
    final progress = curve.transform(rawProgress);
    _scale = spec.begin + ((spec.end - spec.begin) * progress);
  }

  @override
  MotionRender toRender() => ScaleRender(scale: _scale);
}
