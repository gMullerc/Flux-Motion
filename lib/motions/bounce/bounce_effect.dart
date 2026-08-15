import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

import '../../core/drivers/explicit_driver.dart';
import '../../core/effects/motion_render.dart';
import '../../core/triggers/motion_trigger.dart';
import 'bounce_render.dart';
import 'bounce_spec.dart';

/// Explicitly driven, damped directional bounce effect.
final class BounceEffect extends ExplicitMotionEffect {
  /// Creates a bounce effect from [spec] that responds to [activation].
  BounceEffect(
    this.spec, {
    this.activation = MotionTrigger.onMount,
  });

  /// Configuration used by this effect.
  final BounceSpec spec;

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

  Offset get _offset {
    if (_progress <= 0 || _progress >= 1 || spec.distance == 0) {
      return Offset.zero;
    }

    final displacement = math.sin(math.pi * spec.bounces * _progress).abs() *
        spec.distance *
        (1 - _progress);

    return switch (spec.direction) {
      BounceDirection.up => Offset(0, -displacement),
      BounceDirection.down => Offset(0, displacement),
      BounceDirection.left => Offset(-displacement, 0),
      BounceDirection.right => Offset(displacement, 0),
    };
  }

  @override
  MotionRender toRender() => BounceRender(offset: _offset);
}
