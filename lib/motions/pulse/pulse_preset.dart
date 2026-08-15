import 'package:flutter/animation.dart';

import 'pulse_spec.dart';

/// Ready-to-use pulse configurations for common feedback scenarios.
final class PulsePreset {
  const PulsePreset._();

  /// A balanced pulse for emphasizing a control or a piece of content.
  static PulseSpec emphasis() {
    return const PulseSpec();
  }

  /// A short inward pulse that mimics tactile press feedback.
  static PulseSpec tap() {
    return const PulseSpec(
      peakScale: 0.94,
      duration: Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }

  /// A repeating, restrained pulse for live status indicators.
  static PulseSpec status() {
    return const PulseSpec(
      peakScale: 1.06,
      duration: Duration(milliseconds: 900),
      repeat: true,
    );
  }
}
