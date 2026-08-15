import 'package:flutter/widgets.dart';

/// Defines the order in which children enter a staggered motion.
enum StaggerOrder {
  /// Animates children from the first item to the last item.
  forward,

  /// Animates children from the last item to the first item.
  reverse,
}

/// Immutable timing and appearance configuration for a staggered motion.
@immutable
final class StaggerSpec {
  /// Creates a stagger configuration.
  const StaggerSpec({
    this.interval = const Duration(milliseconds: 80),
    this.itemDuration = const Duration(milliseconds: 420),
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, 16),
    this.fadeFrom = 0,
    this.order = StaggerOrder.forward,
    this.repeat = false,
    this.reverse = false,
  }) : assert(
          fadeFrom >= 0 && fadeFrom <= 1,
          'fadeFrom must be between 0 and 1.',
        );

  /// Delay between the start of two consecutive children.
  final Duration interval;

  /// Duration of each child's entrance.
  final Duration itemDuration;

  /// Curve applied independently to each child's local progress.
  final Curve curve;

  /// Translation applied to a child before its entrance begins.
  final Offset beginOffset;

  /// Initial opacity of each child, from zero to one.
  final double fadeFrom;

  /// Order in which children enter.
  final StaggerOrder order;

  /// Whether the complete stagger timeline repeats continuously.
  final bool repeat;

  /// Whether a repeating timeline alternates between forward and backward.
  final bool reverse;
}
