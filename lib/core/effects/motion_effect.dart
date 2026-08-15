import 'package:flutter/animation.dart';

import '../drivers/motion_driver.dart';
import '../triggers/motion_trigger.dart';
import 'motion_render.dart';

/// Runtime context passed to effects during [MotionEffect.attach].
class MotionContext {
  const MotionContext({
    required this.vsync,
    required this.animationsDisabled,
    this.onRequestRebuild,
    this.controller,
  });

  final TickerProvider vsync;
  final bool animationsDisabled;
  final VoidCallback? onRequestRebuild;

  /// Set by the engine for effects with [MotionDriver.explicit].
  final AnimationController? controller;
}

/// Configurable animation unit owned by the engine domain.
abstract class MotionEffect {
  Duration get duration;
  Curve get curve;
  MotionDriver get preferredDriver;

  /// Which trigger starts this effect. Defaults to [MotionTrigger.onMount].
  MotionTrigger get trigger => MotionTrigger.onMount;

  void attach(MotionContext context) {}

  void play({required MotionTrigger trigger}) {}

  void tick(Duration elapsed) {}

  void dispose() {}

  MotionRender toRender();
}
