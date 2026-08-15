import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import '../drivers/motion_driver.dart';
import '../effects/motion_effect.dart';
import '../triggers/motion_trigger.dart';

/// Binds an [AnimationController] to an explicit [MotionEffect].
class ExplicitDriverBinding {
  ExplicitDriverBinding({
    required this.controller,
    required this.effect,
    required this.onTick,
  }) {
    _listener = () {
      final elapsed = Duration(
        microseconds:
            (controller.value * effect.duration.inMicroseconds).round(),
      );
      effect.tick(elapsed);
      onTick();
    };
    controller.addListener(_listener!);
  }

  final AnimationController controller;
  final MotionEffect effect;
  final VoidCallback onTick;

  VoidCallback? _listener;

  void dispose() {
    if (_listener != null) {
      controller.removeListener(_listener!);
      _listener = null;
    }
  }
}

/// Base for effects driven by an engine-owned [AnimationController].
abstract class ExplicitMotionEffect extends MotionEffect {
  @override
  MotionDriver get preferredDriver => MotionDriver.explicit;

  AnimationController? _controller;

  /// The engine-owned controller available to concrete explicit effects.
  ///
  /// Effects should use this only to customize playback (for example, to
  /// repeat or reverse an animation). The engine still owns its lifecycle.
  @protected
  AnimationController? get controller => _controller;

  @override
  void attach(MotionContext context) {
    _controller = context.controller;
  }

  @override
  void play({required MotionTrigger trigger}) {
    if (trigger != this.trigger) {
      return;
    }
    _controller?.forward(from: 0);
  }

  @override
  void dispose() {
    _controller = null;
  }
}
