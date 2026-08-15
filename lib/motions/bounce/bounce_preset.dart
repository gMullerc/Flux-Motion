import 'package:flutter/animation.dart';

import 'bounce_spec.dart';

/// Ready-to-use bounce configurations for common feedback scenarios.
final class BouncePreset {
  const BouncePreset._();

  /// A concise upward bounce for success confirmation.
  static BounceSpec success() {
    return const BounceSpec(
      distance: 16,
      duration: Duration(milliseconds: 600),
    );
  }

  /// A repeating, restrained bounce for unread notifications.
  static BounceSpec notification() {
    return const BounceSpec(
      distance: 12,
      duration: Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      repeat: true,
    );
  }

  /// A larger multi-arc bounce for expressive, playful feedback.
  static BounceSpec playful() {
    return const BounceSpec(
      distance: 28,
      bounces: 3,
      duration: Duration(milliseconds: 850),
    );
  }
}
