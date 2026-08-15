import 'package:flutter/widgets.dart';

/// Visual transition used by [showFluxDialog].
enum FluxDialogTransition {
  /// Fades and scales the dialog into place.
  fadeScale,

  /// Fades the dialog without moving it.
  fade,

  /// Fades and slides the dialog upward.
  slideUp,
}

/// Immutable motion configuration for a Flux dialog route.
@immutable
final class FluxDialogSpec {
  /// Creates a custom dialog motion specification.
  const FluxDialogSpec({
    this.transition = FluxDialogTransition.fadeScale,
    this.duration = const Duration(milliseconds: 220),
    this.reverseDuration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
    this.scaleFrom = .9,
    this.slideFrom = const Offset(0, .08),
    this.alignment = Alignment.center,
  }) : assert(
          transition != FluxDialogTransition.fadeScale || scaleFrom > 0,
          'scaleFrom must be greater than zero.',
        );

  /// Creates the standard fade-and-scale dialog motion.
  const FluxDialogSpec.fadeScale()
      : transition = FluxDialogTransition.fadeScale,
        duration = const Duration(milliseconds: 220),
        reverseDuration = const Duration(milliseconds: 180),
        curve = Curves.easeOutCubic,
        reverseCurve = Curves.easeInCubic,
        scaleFrom = .9,
        slideFrom = const Offset(0, .08),
        alignment = Alignment.center;

  /// Creates a dialog motion that only fades.
  const FluxDialogSpec.fade()
      : transition = FluxDialogTransition.fade,
        duration = const Duration(milliseconds: 220),
        reverseDuration = const Duration(milliseconds: 180),
        curve = Curves.easeOutCubic,
        reverseCurve = Curves.easeInCubic,
        scaleFrom = .9,
        slideFrom = const Offset(0, .08),
        alignment = Alignment.center;

  /// Creates a dialog motion that enters from below.
  const FluxDialogSpec.slideUp()
      : transition = FluxDialogTransition.slideUp,
        duration = const Duration(milliseconds: 220),
        reverseDuration = const Duration(milliseconds: 180),
        curve = Curves.easeOutCubic,
        reverseCurve = Curves.easeInCubic,
        scaleFrom = .9,
        slideFrom = const Offset(0, .08),
        alignment = Alignment.center;

  /// Transition rendered by the route.
  final FluxDialogTransition transition;

  /// Duration of the entrance motion.
  final Duration duration;

  /// Visual duration targeted by the exit motion.
  ///
  /// `showGeneralDialog` has one route duration, so values longer than
  /// [duration] are limited to [duration].
  final Duration reverseDuration;

  /// Curve used while the dialog enters.
  final Curve curve;

  /// Curve used while the dialog exits.
  final Curve reverseCurve;

  /// Initial scale used by [FluxDialogTransition.fadeScale].
  final double scaleFrom;

  /// Initial fractional offset used by [FluxDialogTransition.slideUp].
  final Offset slideFrom;

  /// Origin used by [FluxDialogTransition.fadeScale].
  final AlignmentGeometry alignment;
}
