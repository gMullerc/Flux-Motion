import 'package:flutter/animation.dart';

/// Direction in which a bounce displaces its child.
enum BounceDirection {
  /// Moves the child upward.
  up,

  /// Moves the child downward.
  down,

  /// Moves the child to the left.
  left,

  /// Moves the child to the right.
  right,
}

/// Immutable configuration for a [BounceEffect].
final class BounceSpec {
  /// Creates a bounce configuration.
  const BounceSpec({
    this.distance = 20,
    this.bounces = 2,
    this.direction = BounceDirection.up,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutCubic,
    this.repeat = false,
  })  : assert(distance >= 0),
        assert(bounces > 0);

  /// Maximum displacement in logical pixels.
  final double distance;

  /// Number of directional arcs in one sequence.
  final int bounces;

  /// Direction in which the child is displaced.
  final BounceDirection direction;

  /// Duration of one bounce sequence.
  final Duration duration;

  /// Timing curve applied to the bounce progress.
  final Curve curve;

  /// Whether the bounce sequence keeps playing.
  final bool repeat;
}
