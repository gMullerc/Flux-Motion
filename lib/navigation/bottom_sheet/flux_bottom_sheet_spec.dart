import 'package:flutter/widgets.dart';

/// Immutable motion configuration for a Flux modal bottom sheet.
@immutable
final class FluxBottomSheetSpec {
  /// Creates a custom bottom-sheet motion specification.
  const FluxBottomSheetSpec({
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
  });

  /// Creates the standard mobile bottom-sheet motion.
  const FluxBottomSheetSpec.standard()
      : duration = const Duration(milliseconds: 300),
        reverseDuration = const Duration(milliseconds: 220),
        curve = Curves.easeOutCubic,
        reverseCurve = Curves.easeInCubic;

  /// Creates a shorter motion for lightweight actions.
  const FluxBottomSheetSpec.quick()
      : duration = const Duration(milliseconds: 200),
        reverseDuration = const Duration(milliseconds: 160),
        curve = Curves.easeOutCubic,
        reverseCurve = Curves.easeInCubic;

  /// Creates a softer, slower motion for content-rich sheets.
  const FluxBottomSheetSpec.gentle()
      : duration = const Duration(milliseconds: 420),
        reverseDuration = const Duration(milliseconds: 320),
        curve = Curves.easeOutQuart,
        reverseCurve = Curves.easeInQuart;

  /// Duration of the entrance motion.
  final Duration duration;

  /// Duration of the exit motion.
  final Duration reverseDuration;

  /// Curve used while the sheet enters.
  final Curve curve;

  /// Curve used while the sheet exits.
  final Curve reverseCurve;
}
