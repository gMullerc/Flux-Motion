import 'package:flutter/scheduler.dart';

import '../effects/motion_effect.dart';
import '../effects/motion_render.dart';
import '../triggers/motion_trigger.dart';

/// Orchestrates motion effects — never renders widgets directly.
abstract class MotionEngine {
  /// Attaches [effects] to the engine using [vsync] for explicit animations.
  void bind(List<MotionEffect> effects, TickerProvider vsync);

  /// Starts effects configured for [trigger].
  void start(MotionTrigger trigger);

  /// Stops active effects at their current frame.
  void stop();

  /// Stops active effects and returns them to their initial frame.
  void reset();

  /// Releases every effect, listener, and animation controller.
  void dispose();

  /// Builds the ordered render pipeline for the current animation frame.
  List<MotionRender> buildPipeline();
}
