import 'package:flutter/scheduler.dart';

import '../effects/motion_effect.dart';
import '../effects/motion_render.dart';
import '../triggers/motion_trigger.dart';

/// Orchestrates motion effects — never renders widgets directly.
abstract class MotionEngine {
  void bind(List<MotionEffect> effects, TickerProvider vsync);

  void start(MotionTrigger trigger);

  void stop();

  void dispose();

  List<MotionRender> buildPipeline();
}
