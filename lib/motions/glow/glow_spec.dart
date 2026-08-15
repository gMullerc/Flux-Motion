import 'package:flutter/widgets.dart';

/// Immutable configuration for a [GlowEffect].
class GlowSpec {
  const GlowSpec({
    this.radius = 16,
    this.spreadRadius = 0,
    this.color = const Color(0xFFFFFFFF),
    this.intensity = 0.65,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOut,
    this.repeat = false,
    this.reverse = true,
    this.offset = Offset.zero,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  })  : assert(radius >= 0),
        assert(spreadRadius >= 0),
        assert(intensity >= 0 && intensity <= 1),
        assert(shape == BoxShape.rectangle || borderRadius == null);

  /// Blur radius of the shadow used to create the glow.
  final double radius;

  /// Additional expansion around the child's bounds.
  final double spreadRadius;

  /// Base color of the glow.
  final Color color;

  /// Maximum opacity multiplier, from 0 to 1.
  final double intensity;

  /// Duration of one forward pass.
  final Duration duration;

  /// Curve applied to the glow progress.
  final Curve curve;

  /// Whether the glow keeps playing after the first pass.
  final bool repeat;

  /// When repeating, play the next pass in the opposite direction.
  final bool reverse;

  /// Offset of the glow shadow.
  final Offset offset;

  /// Optional radius for rectangular children.
  final BorderRadiusGeometry? borderRadius;

  /// Shape used by the glow shadow. Use [BoxShape.circle] for circular
  /// widgets so the glow follows the same silhouette instead of a rectangle.
  final BoxShape shape;
}
