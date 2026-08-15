import 'package:flutter/material.dart';

import 'shimmer_spec.dart';

/// Ready-to-use shimmer configurations.
class ShimmerPreset {
  const ShimmerPreset._();

  /// Preserves the child colors and adds a restrained highlight pass.
  static ShimmerSpec subtle({
    Color highlightColor = Colors.white,
  }) {
    return ShimmerSpec(
      highlightColor: highlightColor,
      intensity: .42,
      bandWidth: .24,
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// Replaces the child colors with a skeleton loading palette.
  static ShimmerSpec skeleton({
    Color baseColor = const Color(0xFF252C33),
    Color highlightColor = const Color(0xFF4C5661),
  }) {
    return ShimmerSpec(
      baseColor: baseColor,
      highlightColor: highlightColor,
      intensity: .9,
      bandWidth: .32,
      duration: const Duration(milliseconds: 1250),
    );
  }

  /// A brighter pass for buttons, cards, and primary actions.
  static ShimmerSpec accent({
    Color highlightColor = Colors.white,
    ShimmerDirection direction = ShimmerDirection.leftToRight,
  }) {
    return ShimmerSpec(
      highlightColor: highlightColor,
      intensity: .78,
      bandWidth: .2,
      direction: direction,
      duration: const Duration(milliseconds: 1000),
    );
  }
}
