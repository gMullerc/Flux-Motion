import 'package:flutter/widgets.dart';

import '../../core/controllers/flux_motion_controller.dart';
import '../../core/triggers/motion_trigger.dart';
import 'stagger_spec.dart';

/// Builds the layout that receives the animated stagger children.
typedef FluxStaggerLayoutBuilder = Widget Function(
  BuildContext context,
  List<Widget> children,
);

/// Animates a collection of children through offset entrance windows.
///
/// Each child fades and translates independently while the widget keeps a
/// single timeline controller for the complete collection.
class FluxStagger extends StatefulWidget {
  /// Creates a declarative staggered entrance.
  const FluxStagger({
    super.key,
    required this.children,
    this.spec = const StaggerSpec(),
    this.trigger = MotionTrigger.onMount,
    this.controller,
    this.layoutBuilder,
  });

  /// Widgets animated by this stagger.
  final List<Widget> children;

  /// Timing, direction, and visual configuration for the stagger.
  final StaggerSpec spec;

  /// Interaction that starts the complete stagger timeline.
  final MotionTrigger trigger;

  /// Optional imperative controller for playback commands.
  final FluxMotionController? controller;

  /// Optional builder used to lay out the animated children.
  ///
  /// When omitted, children are placed in a minimum-height [Column].
  final FluxStaggerLayoutBuilder? layoutBuilder;

  @override
  State<FluxStagger> createState() => _FluxStaggerState();
}

class _FluxStaggerState extends State<FluxStagger>
    with SingleTickerProviderStateMixin {
  AnimationController? _timeline;
  bool? _animationsDisabled;
  bool _mountStarted = false;
  bool _visibilityScheduled = false;

  Duration get _totalDuration {
    if (widget.children.isEmpty) {
      return Duration.zero;
    }

    return Duration(
      microseconds: widget.spec.itemDuration.inMicroseconds +
          widget.spec.interval.inMicroseconds * (widget.children.length - 1),
    );
  }

  bool get _canAnimate =>
      !(_animationsDisabled ?? false) && widget.children.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _debugAssertValidDurations();
    _attachMotionController(widget.controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    final accessibilityChanged = animationsDisabled != _animationsDisabled;
    _animationsDisabled = animationsDisabled;

    if (accessibilityChanged) {
      _syncTimeline();
      if (animationsDisabled) {
        _mountStarted = false;
      }
    }

    _startOnMountIfNeeded();
  }

  @override
  void didUpdateWidget(FluxStagger oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debugAssertValidDurations();

    if (oldWidget.controller != widget.controller) {
      _detachMotionController(oldWidget.controller);
      _attachMotionController(widget.controller);
    }

    final timelineChanged = oldWidget.spec != widget.spec ||
        oldWidget.children.length != widget.children.length;
    final triggerChanged = oldWidget.trigger != widget.trigger;

    if (timelineChanged || triggerChanged) {
      _mountStarted = false;
      _visibilityScheduled = false;
      _syncTimeline(reset: true);
      _startOnMountIfNeeded();
    }
  }

  void _syncTimeline({bool reset = false}) {
    if (!_canAnimate) {
      final timeline = _timeline;
      if (timeline != null) {
        timeline.stop();
        timeline.duration = Duration.zero;
        timeline.value = 0;
      }
      return;
    }

    final duration = _totalDuration;
    final timeline = _timeline;

    if (timeline == null) {
      _timeline = AnimationController(
        vsync: this,
        duration: duration,
      )..addListener(_handleTick);
      return;
    }

    timeline.stop();
    timeline.duration = duration;
    if (reset) {
      timeline.value = 0;
    }
  }

  void _debugAssertValidDurations() {
    assert(
      !widget.spec.interval.isNegative,
      'StaggerSpec.interval must not be negative.',
    );
    assert(
      !widget.spec.itemDuration.isNegative,
      'StaggerSpec.itemDuration must not be negative.',
    );
  }

  void _handleTick() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startOnMountIfNeeded() {
    if (!_mountStarted && widget.trigger == MotionTrigger.onMount) {
      _mountStarted = _replay();
    }
  }

  void _start(MotionTrigger trigger) {
    if (!mounted || widget.trigger != trigger) {
      return;
    }

    _replay();
  }

  bool _play() {
    final timeline = _timeline;
    if (!_canAnimate || timeline == null) {
      return false;
    }

    if (_totalDuration == Duration.zero) {
      timeline.value = 1;
      return true;
    }

    if (widget.spec.repeat) {
      timeline.repeat(reverse: widget.spec.reverse);
    } else {
      timeline.forward();
    }
    return true;
  }

  void _stop() {
    _timeline?.stop();
  }

  void _reset() {
    final timeline = _timeline;
    if (timeline == null) {
      return;
    }

    timeline.stop();
    timeline.value = 0;
  }

  bool _replay() {
    final timeline = _timeline;
    if (!_canAnimate || timeline == null) {
      return false;
    }

    timeline.stop();
    timeline.value = 0;
    return _play();
  }

  void _scheduleVisibilityStart() {
    if (_visibilityScheduled || _animationsDisabled == true) {
      return;
    }

    _visibilityScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.trigger == MotionTrigger.onVisibility) {
        _start(MotionTrigger.onVisibility);
      }
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
          onNotification: (_) {
            _start(MotionTrigger.onScroll);
            return false;
          },
          child: child,
        );
      case MotionTrigger.onVisibility:
        _scheduleVisibilityStart();
        return child;
    }
  }

  List<Widget> _buildAnimatedChildren() {
    final timeline = _timeline;
    if (!_canAnimate || timeline == null) {
      return widget.children;
    }

    return List<Widget>.generate(
      widget.children.length,
      (index) => _buildAnimatedChild(
        child: widget.children[index],
        index: index,
        timelineValue: timeline.value,
      ),
      growable: false,
    );
  }

  Widget _buildAnimatedChild({
    required Widget child,
    required int index,
    required double timelineValue,
  }) {
    final itemCount = widget.children.length;
    final orderedIndex = widget.spec.order == StaggerOrder.forward
        ? index
        : itemCount - index - 1;
    final start = widget.spec.interval.inMicroseconds * orderedIndex;
    final elapsed = _totalDuration.inMicroseconds * timelineValue;
    final itemDuration = widget.spec.itemDuration.inMicroseconds;

    final double rawProgress;
    if (itemDuration == 0) {
      rawProgress = elapsed >= start ? 1 : 0;
    } else {
      rawProgress = ((elapsed - start) / itemDuration).clamp(0.0, 1.0);
    }

    final progress = widget.spec.curve.transform(rawProgress);
    final opacity =
        widget.spec.fadeFrom + (1 - widget.spec.fadeFrom) * progress;
    final offset = Offset.lerp(
      widget.spec.beginOffset,
      Offset.zero,
      progress,
    )!;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: offset,
        child: child,
      ),
    );
  }

  Widget _buildLayout(BuildContext context, List<Widget> children) {
    final layoutBuilder = widget.layoutBuilder;
    if (layoutBuilder != null) {
      return layoutBuilder(context, children);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  void _attachMotionController(FluxMotionController? controller) {
    controller?.attach(
      owner: this,
      play: _play,
      stop: _stop,
      reset: _reset,
      replay: _replay,
    );
  }

  void _detachMotionController(FluxMotionController? controller) {
    controller?.detach(this);
  }

  void _disposeTimeline() {
    final timeline = _timeline;
    if (timeline == null) {
      return;
    }

    timeline.removeListener(_handleTick);
    timeline.dispose();
    _timeline = null;
  }

  @override
  void dispose() {
    _detachMotionController(widget.controller);
    _disposeTimeline();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _withTrigger(
      _buildLayout(context, _buildAnimatedChildren()),
    );
  }
}
