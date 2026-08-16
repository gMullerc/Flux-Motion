import 'package:flutter/material.dart';

/// Visual language used while a page is pushed or popped.
enum FluxPageTransition {
  slide,
  fade,
  scale,
  fadeThrough,
  sharedAxis,
}

/// Direction from which a sliding page enters.
enum FluxPageDirection {
  left,
  right,
  up,
  down,
}

/// Immutable configuration for [FluxPageRoute].
///
/// Prefer the named presets so navigation keeps a consistent rhythm across an
/// application. Durations and curves remain customizable when product needs
/// call for a different pace.
@immutable
final class FluxPageRouteSpec {
  const FluxPageRouteSpec.slide({
    this.direction = FluxPageDirection.left,
    this.duration = const Duration(milliseconds: 340),
    this.reverseDuration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
    this.distance = 1,
  })  : transition = FluxPageTransition.slide,
        axis = Axis.horizontal,
        reverse = false,
        scaleFrom = .94,
        assert(distance >= 0);

  const FluxPageRouteSpec.fade({
    this.duration = const Duration(milliseconds: 240),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
  })  : transition = FluxPageTransition.fade,
        direction = FluxPageDirection.left,
        axis = Axis.horizontal,
        reverse = false,
        distance = 0,
        scaleFrom = 1;

  const FluxPageRouteSpec.scale({
    this.duration = const Duration(milliseconds: 280),
    this.reverseDuration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutBack,
    this.reverseCurve = Curves.easeInCubic,
    this.scaleFrom = .92,
  })  : transition = FluxPageTransition.scale,
        direction = FluxPageDirection.left,
        axis = Axis.horizontal,
        reverse = false,
        distance = 0,
        assert(scaleFrom > 0);

  const FluxPageRouteSpec.fadeThrough({
    this.duration = const Duration(milliseconds: 320),
    this.reverseDuration = const Duration(milliseconds: 260),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
    this.scaleFrom = .96,
  })  : transition = FluxPageTransition.fadeThrough,
        direction = FluxPageDirection.left,
        axis = Axis.horizontal,
        reverse = false,
        distance = 0,
        assert(scaleFrom > 0);

  const FluxPageRouteSpec.sharedAxis({
    this.axis = Axis.horizontal,
    this.reverse = false,
    this.duration = const Duration(milliseconds: 360),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
    this.distance = .12,
  })  : transition = FluxPageTransition.sharedAxis,
        direction = FluxPageDirection.left,
        scaleFrom = 1,
        assert(distance >= 0);

  final FluxPageTransition transition;
  final FluxPageDirection direction;

  /// Axis used by the coordinated shared-axis preset.
  final Axis axis;

  /// Flips the travel direction of a shared-axis transition.
  final bool reverse;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Curve reverseCurve;

  /// Distance measured as a fraction of the route size.
  final double distance;

  /// Initial scale for scale and fade-through transitions.
  final double scaleFrom;
}
