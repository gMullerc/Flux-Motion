import 'package:flutter/widgets.dart';

import '../controllers/flux_motion_controller.dart';
import '../effects/motion_effect.dart';
import '../engine/default_motion_engine.dart';
import '../engine/motion_engine.dart';
import '../triggers/motion_trigger.dart';
import 'flux_wrapper.dart';

/// Base widget that connects [child], the motion engine, and the render pipeline.
///
/// Concrete components such as [FluxGlow] extend this class with ergonomic
/// constructors. You can also use [FluxMotion] directly with a custom effect list.
class FluxMotion extends StatefulWidget {
  const FluxMotion({
    super.key,
    required this.child,
    required this.effects,
    this.trigger = MotionTrigger.onMount,
    this.controller,
    this.engineFactory = DefaultMotionEngine.new,
  });

  /// Widget transformed by the render pipeline.
  final Widget child;

  /// Effects bound to the motion engine in pipeline order.
  final List<MotionEffect> effects;

  /// Interaction or lifecycle event that starts the effects.
  final MotionTrigger trigger;

  /// Optional imperative controller for playback operations.
  final FluxMotionController? controller;

  /// Factory used to create the engine that owns effect playback.
  final MotionEngine Function() engineFactory;

  @override
  State<FluxMotion> createState() => _FluxMotionState();
}

class _FluxMotionState extends State<FluxMotion> with TickerProviderStateMixin {
  late MotionEngine _engine;
  bool _started = false;
  bool _scrollScheduled = false;
  bool _visibilityScheduled = false;

  @override
  void initState() {
    super.initState();
    _engine = widget.engineFactory();
    _attachController(widget.controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rebindEngine();
    if (!_started && widget.trigger == MotionTrigger.onMount) {
      _start(MotionTrigger.onMount);
    }
  }

  @override
  void didUpdateWidget(FluxMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach(this);
      _attachController(widget.controller);
    }

    if (oldWidget.effects != widget.effects ||
        oldWidget.trigger != widget.trigger ||
        oldWidget.engineFactory != widget.engineFactory) {
      _engine.dispose();
      _engine = widget.engineFactory();
      _started = false;
      _scrollScheduled = false;
      _visibilityScheduled = false;
      _rebindEngine();
      if (widget.trigger == MotionTrigger.onMount) {
        _start(MotionTrigger.onMount);
      }
    }
  }

  void _rebindEngine() {
    final engine = _engine;
    if (engine is DefaultMotionEngine) {
      engine.configure(
        animationsDisabled: MediaQuery.disableAnimationsOf(context),
        onRequestRebuild: _handleRequestRebuild,
      );
    }

    _engine.bind(widget.effects, this);
  }

  void _handleRequestRebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  void _attachController(FluxMotionController? controller) {
    controller?.attach(
      owner: this,
      play: _handleControllerPlay,
      stop: _handleControllerStop,
      reset: _handleControllerReset,
      replay: _handleControllerReplay,
    );
  }

  void _handleControllerPlay() {
    _start(widget.trigger);
  }

  void _handleControllerStop() {
    _engine.stop();
  }

  void _handleControllerReset() {
    _engine.reset();
    _started = false;
    _scrollScheduled = false;
    _visibilityScheduled = false;
  }

  void _handleControllerReplay() {
    _engine.reset();
    _started = false;
    _scrollScheduled = false;
    _visibilityScheduled = false;
    _start(widget.trigger);
  }

  void _start(MotionTrigger trigger) {
    if (!mounted || widget.trigger != trigger) {
      return;
    }

    _engine.start(trigger);
    _started = true;
  }

  void _scheduleVisibilityStart() {
    if (_visibilityScheduled || _started) {
      return;
    }

    _visibilityScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.trigger == MotionTrigger.onVisibility) {
        _start(MotionTrigger.onVisibility);
      }
    });
  }

  void _scheduleScrollStart() {
    if (_scrollScheduled) {
      return;
    }

    _scrollScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(Duration.zero, () {
        _scrollScheduled = false;
        if (mounted && widget.trigger == MotionTrigger.onScroll) {
          _start(MotionTrigger.onScroll);
        }
      });
    });
  }

  Widget _withTrigger(Widget child) {
    switch (widget.trigger) {
      case MotionTrigger.onMount:
        return child;
      case MotionTrigger.onTap:
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _start(MotionTrigger.onTap),
          child: child,
        );
      case MotionTrigger.onTapDown:
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _start(MotionTrigger.onTapDown),
          child: child,
        );
      case MotionTrigger.onTapUp:
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (_) => _start(MotionTrigger.onTapUp),
          child: child,
        );
      case MotionTrigger.onHover:
        return MouseRegion(
          onEnter: (_) => _start(MotionTrigger.onHover),
          child: child,
        );
      case MotionTrigger.onScroll:
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              _scheduleScrollStart();
            }
            return false;
          },
          child: child,
        );
      case MotionTrigger.onVisibility:
        _scheduleVisibilityStart();
        return child;
    }
  }

  @override
  void dispose() {
    widget.controller?.detach(this);
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _withTrigger(
      FluxWrapper(
        pipeline: _engine.buildPipeline(),
        child: widget.child,
      ),
    );
  }
}
