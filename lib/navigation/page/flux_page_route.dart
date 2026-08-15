import 'package:flutter/material.dart';

import 'flux_page_route_spec.dart';

/// A mobile-first [PageRoute] with coordinated push and pop motion.
///
/// The navigator owns the animation controller and its lifecycle. When the
/// platform requests reduced motion, the destination is rendered without
/// opacity, scale, or translation changes.
class FluxPageRoute<T> extends PageRouteBuilder<T> {
  FluxPageRoute({
    required WidgetBuilder builder,
    this.spec = const FluxPageRouteSpec.slide(),
    super.settings,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (MediaQuery.disableAnimationsOf(context)) {
              return child;
            }

            return _FluxPageTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              spec: spec,
              child: child,
            );
          },
          transitionDuration: spec.duration,
          reverseTransitionDuration: spec.reverseDuration,
        );

  final FluxPageRouteSpec spec;
}

class _FluxPageTransition extends StatelessWidget {
  const _FluxPageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.spec,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final FluxPageRouteSpec spec;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final incoming = _DirectionalCurveAnimation(
      parent: animation,
      forwardCurve: spec.curve,
      reverseCurve: spec.reverseCurve,
    );
    final outgoing = _DirectionalCurveAnimation(
      parent: secondaryAnimation,
      forwardCurve: spec.curve,
      reverseCurve: spec.reverseCurve,
    );

    return switch (spec.transition) {
      FluxPageTransition.slide => _buildSlide(incoming, outgoing),
      FluxPageTransition.fade => _buildFade(incoming),
      FluxPageTransition.scale => _buildScale(incoming, outgoing),
      FluxPageTransition.fadeThrough => _buildFadeThrough(incoming, outgoing),
      FluxPageTransition.sharedAxis => _buildSharedAxis(incoming, outgoing),
    };
  }

  Widget _buildSlide(
    Animation<double> incoming,
    Animation<double> outgoing,
  ) {
    final begin = _directionOffset(spec.direction) * spec.distance;

    return FadeTransition(
      opacity: _clamped(
        Tween<double>(begin: .88, end: 1).animate(incoming),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: begin * -.22,
        ).animate(outgoing),
        child: SlideTransition(
          position:
              Tween<Offset>(begin: begin, end: Offset.zero).animate(incoming),
          child: child,
        ),
      ),
    );
  }

  Widget _buildFade(Animation<double> incoming) {
    return FadeTransition(
      opacity: _clamped(incoming),
      child: child,
    );
  }

  Widget _buildScale(
    Animation<double> incoming,
    Animation<double> outgoing,
  ) {
    return FadeTransition(
      opacity: _clamped(incoming),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: .97).animate(outgoing),
        child: ScaleTransition(
          alignment: Alignment.center,
          scale: Tween<double>(begin: spec.scaleFrom, end: 1).animate(incoming),
          child: child,
        ),
      ),
    );
  }

  Widget _buildFadeThrough(
    Animation<double> incoming,
    Animation<double> outgoing,
  ) {
    final incomingOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 70),
    ]).animate(incoming);
    final outgoingOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 30),
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 70),
    ]).animate(outgoing);

    return FadeTransition(
      opacity: _clamped(outgoingOpacity),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 1.02).animate(outgoing),
        child: FadeTransition(
          opacity: _clamped(incomingOpacity),
          child: ScaleTransition(
            scale:
                Tween<double>(begin: spec.scaleFrom, end: 1).animate(incoming),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildSharedAxis(
    Animation<double> incoming,
    Animation<double> outgoing,
  ) {
    final sign = spec.reverse ? -1.0 : 1.0;
    final begin = spec.axis == Axis.horizontal
        ? Offset(spec.distance * sign, 0)
        : Offset(0, spec.distance * sign);

    return FadeTransition(
      opacity: _clamped(
        Tween<double>(begin: 1, end: 0).animate(outgoing),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: begin * -.5,
        ).animate(outgoing),
        child: FadeTransition(
          opacity: _clamped(incoming),
          child: SlideTransition(
            position:
                Tween<Offset>(begin: begin, end: Offset.zero).animate(incoming),
            child: child,
          ),
        ),
      ),
    );
  }
}

Offset _directionOffset(FluxPageDirection direction) {
  return switch (direction) {
    FluxPageDirection.left => const Offset(1, 0),
    FluxPageDirection.right => const Offset(-1, 0),
    FluxPageDirection.up => const Offset(0, 1),
    FluxPageDirection.down => const Offset(0, -1),
  };
}

Animation<double> _clamped(Animation<double> animation) {
  return _ClampedAnimation(animation);
}

class _ClampedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  const _ClampedAnimation(this.parent);

  @override
  final Animation<double> parent;

  @override
  double get value => parent.value.clamp(0.0, 1.0);
}

class _DirectionalCurveAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  const _DirectionalCurveAnimation({
    required this.parent,
    required this.forwardCurve,
    required this.reverseCurve,
  });

  @override
  final Animation<double> parent;
  final Curve forwardCurve;
  final Curve reverseCurve;

  @override
  double get value {
    final curve =
        parent.status == AnimationStatus.reverse ? reverseCurve : forwardCurve;
    return curve.transform(parent.value);
  }
}
