import 'package:flutter/animation.dart';

import '../../core/drivers/explicit_driver.dart';
import '../../core/effects/motion_render.dart';
import '../../core/triggers/motion_trigger.dart';
import 'rotate_render.dart';
import 'rotate_spec.dart';

/// Explicitly driven rotation effect.
class RotateEffect extends ExplicitMotionEffect {
  RotateEffect(
    this.spec, {
    this.activation = MotionTrigger.onMount,
  }) : _currentDegrees = spec.beginDegrees;

  final RotateSpec spec;
  final MotionTrigger activation;
  double _currentDegrees;

  /// Current rotation value in degrees.
  double get currentDegrees => _currentDegrees;

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
      _currentDegrees = spec.beginDegrees + spec.degrees;
      return;
    }

    final rawProgress =
        (elapsed.inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);
    final progress = curve.transform(rawProgress);
    _currentDegrees = spec.beginDegrees + (spec.degrees * progress);
  }

  @override
  MotionRender toRender() => RotateRender(degrees: _currentDegrees);
}
