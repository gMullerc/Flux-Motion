import 'dart:math' as math;

import 'package:flutter/animation.dart';

import '../../core/drivers/explicit_driver.dart';
import '../../core/effects/motion_render.dart';
import '../../core/triggers/motion_trigger.dart';
import 'pulse_render.dart';
import 'pulse_spec.dart';

/// Explicitly driven scale pulse effect.
final class PulseEffect extends ExplicitMotionEffect {
  /// Creates a pulse effect from [spec] that responds to [activation].
  PulseEffect(
    this.spec, {
    this.activation = MotionTrigger.onMount,
  });

  /// Configuration used by this effect.
  final PulseSpec spec;

  /// Trigger that starts this effect.
  final MotionTrigger activation;

  double _progress = 0;

  /// Current curved progress from zero to one.
  double get progress => _progress;

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
      controller?.repeat();
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

  double get _scale {
    if (_progress <= 0 || _progress >= 1) {
      return spec.beginScale;
    }

    return spec.beginScale +
        (spec.peakScale - spec.beginScale) * math.sin(math.pi * _progress);
  }

  @override
  MotionRender toRender() {
    return PulseRender(
      scale: _scale,
      alignment: spec.alignment,
    );
  }
}
