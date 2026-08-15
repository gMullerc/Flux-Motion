import 'package:flutter/animation.dart';

import 'shake_spec.dart';

/// Ready-to-use shake configurations for common feedback scenarios.
final class ShakePreset {
  const ShakePreset._();

  /// A clear horizontal shake for invalid input and error feedback.
  static ShakeSpec error() {
    return const ShakeSpec();
  }

  /// A restrained shake that draws attention without suggesting failure.
  static ShakeSpec attention() {
    return const ShakeSpec(
      distance: 8,
      oscillations: 2,
      duration: Duration(milliseconds: 420),
      curve: Curves.easeOut,
    );
  }

  /// A vertical shake suited to directional hints and compact controls.
  static ShakeSpec vertical() {
    return const ShakeSpec(
      distance: 10,
      oscillations: 2,
      axis: ShakeAxis.vertical,
      duration: Duration(milliseconds: 500),
    );
  }
}
