import 'package:flutter/animation.dart';

import '../drivers/explicit_driver.dart';
import '../drivers/motion_driver.dart';
import '../effects/motion_effect.dart';
import '../effects/motion_render.dart';
import '../triggers/motion_trigger.dart';
import 'motion_engine.dart';

/// Default engine: binds controllers for explicit effects, coordinates lifecycle.
class DefaultMotionEngine implements MotionEngine {
  DefaultMotionEngine();

  List<MotionEffect> _effects = const [];
  bool _animationsDisabled = false;
  VoidCallback? _onRequestRebuild;
  final List<AnimationController> _controllers = [];
  final List<ExplicitDriverBinding> _bindings = [];
  final Map<MotionEffect, AnimationController> _effectControllers = {};

  /// Called before [bind] so the engine knows accessibility and rebuild hooks.
  void configure({
    required bool animationsDisabled,
    VoidCallback? onRequestRebuild,
  }) {
    _animationsDisabled = animationsDisabled;
    _onRequestRebuild = onRequestRebuild;
  }

  @override
  void bind(List<MotionEffect> effects, TickerProvider vsync) {
    _disposeBindings();

    _effects = List<MotionEffect>.from(effects);

    for (final effect in _effects) {
      AnimationController? controller;

      if (!_animationsDisabled &&
          effect.preferredDriver == MotionDriver.explicit) {
        controller = AnimationController(
          vsync: vsync,
          duration: effect.duration,
        );
        _controllers.add(controller);
        _effectControllers[effect] = controller;

        _bindings.add(
          ExplicitDriverBinding(
            controller: controller,
            effect: effect,
            onTick: () => _onRequestRebuild?.call(),
          ),
        );
      }

      effect.attach(
        MotionContext(
          vsync: vsync,
          animationsDisabled: _animationsDisabled,
          onRequestRebuild: _onRequestRebuild,
          controller: controller,
        ),
      );
    }
  }

  @override
  void start(MotionTrigger trigger) {
    if (_animationsDisabled) {
      return;
    }

    for (final effect in _effects) {
      effect.play(trigger: trigger);
    }
  }

  @override
  void stop() {
    for (final controller in _controllers) {
      controller.stop();
    }
  }

  @override
  void reset() {
    for (final controller in _controllers) {
      controller.stop();
      controller.value = 0;
    }

    for (final effect in _effects) {
      if (!_effectControllers.containsKey(effect)) {
        effect.tick(Duration.zero);
      }
    }

    _onRequestRebuild?.call();
  }

  @override
  void dispose() {
    for (final effect in _effects) {
      effect.dispose();
    }
    _disposeBindings();
    _effects = const [];
  }

  void _disposeBindings() {
    for (final binding in _bindings) {
      binding.dispose();
    }
    _bindings.clear();

    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _effectControllers.clear();
  }

  @override
  List<MotionRender> buildPipeline() {
    if (_animationsDisabled) {
      return List<MotionRender>.filled(
        _effects.length,
        const PassthroughMotionRender(),
      );
    }

    return _effects.map((effect) => effect.toRender()).toList(growable: false);
  }
}
