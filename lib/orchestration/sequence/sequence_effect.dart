import 'package:flutter/animation.dart';

import '../../core/drivers/explicit_driver.dart';
import '../../core/effects/motion_effect.dart';
import '../../core/effects/motion_render.dart';
import '../../core/triggers/motion_trigger.dart';
import 'sequence_render.dart';
import 'sequence_spec.dart';

/// Explicit effect that drives several child effects on one timeline.
final class SequenceEffect extends ExplicitMotionEffect {
  /// Creates a timeline effect from [spec] that responds to [activation].
  SequenceEffect(
    this.spec, {
    this.activation = MotionTrigger.onMount,
  });

  /// Timeline configuration driven by this effect.
  final SequenceSpec spec;

  /// Trigger that starts this timeline.
  final MotionTrigger activation;

  bool _childrenAttached = false;

  @override
  Duration get duration => spec.totalDuration;

  @override
  Curve get curve => Curves.linear;

  @override
  MotionTrigger get trigger => activation;

  @override
  void attach(MotionContext context) {
    super.attach(context);

    if (_childrenAttached) {
      for (final step in spec.steps) {
        step.effect.dispose();
      }
    }

    final childContext = MotionContext(
      vsync: context.vsync,
      animationsDisabled: context.animationsDisabled,
      onRequestRebuild: context.onRequestRebuild,
    );

    for (final step in spec.steps) {
      step.effect.attach(childContext);
    }
    _childrenAttached = true;
    tick(Duration.zero);
  }

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
    var cursor = Duration.zero;

    for (final step in spec.steps) {
      final start = cursor + step.delay;
      final end = start + step.effect.duration;
      final localElapsed = switch (elapsed) {
        _ when elapsed < start => Duration.zero,
        _ when elapsed >= end => step.effect.duration,
        _ => elapsed - start,
      };

      step.effect.tick(localElapsed);
      cursor = end;
    }
  }

  @override
  MotionRender toRender() {
    return SequenceRender(
      pipeline: spec.steps
          .map((step) => step.effect.toRender())
          .toList(growable: false),
    );
  }

  @override
  void dispose() {
    for (final step in spec.steps) {
      step.effect.dispose();
    }
    _childrenAttached = false;
    super.dispose();
  }
}
