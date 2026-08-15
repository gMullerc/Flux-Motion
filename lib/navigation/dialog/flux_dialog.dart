import 'package:flutter/material.dart';

import 'flux_dialog_spec.dart';

/// Shows a modal dialog using a [FluxDialogSpec] transition.
///
/// The returned future completes with the value passed to [Navigator.pop].
Future<T?> showFluxDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  FluxDialogSpec spec = const FluxDialogSpec.fadeScale(),
  bool barrierDismissible = true,
  String? barrierLabel,
  Color barrierColor = const Color(0x99000000),
  bool useRootNavigator = true,
  bool useSafeArea = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  final animationsDisabled = MediaQuery.disableAnimationsOf(context);
  final effectiveBarrierLabel = barrierLabel ??
      (barrierDismissible
          ? MaterialLocalizations.of(context).modalBarrierDismissLabel
          : null);
  final routeDuration = animationsDisabled ? Duration.zero : spec.duration;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: effectiveBarrierLabel,
    barrierColor: barrierColor,
    transitionDuration: routeDuration,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      Widget child = builder(dialogContext);
      if (useSafeArea) {
        child = SafeArea(child: child);
      }
      return child;
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      if (animationsDisabled) {
        return child;
      }

      final progress = _transitionProgress(animation, spec, routeDuration);
      final fadedChild = Opacity(
        opacity: progress.clamp(0.0, 1.0),
        child: child,
      );

      return switch (spec.transition) {
        FluxDialogTransition.fadeScale => Transform.scale(
            scale: spec.scaleFrom + (1 - spec.scaleFrom) * progress,
            alignment: spec.alignment,
            child: fadedChild,
          ),
        FluxDialogTransition.fade => fadedChild,
        FluxDialogTransition.slideUp => FractionalTranslation(
            translation: Offset.lerp(spec.slideFrom, Offset.zero, progress)!,
            child: fadedChild,
          ),
      };
    },
  );
}

double _transitionProgress(
  Animation<double> animation,
  FluxDialogSpec spec,
  Duration routeDuration,
) {
  final reversing = animation.status == AnimationStatus.reverse;
  final motionDuration = reversing && spec.reverseDuration < routeDuration
      ? spec.reverseDuration
      : routeDuration;
  if (motionDuration == Duration.zero) {
    return reversing ? 0 : 1;
  }

  final durationRatio =
      routeDuration.inMicroseconds / motionDuration.inMicroseconds;
  final rawProgress = reversing
      ? 1 - ((1 - animation.value) * durationRatio).clamp(0.0, 1.0)
      : (animation.value * durationRatio).clamp(0.0, 1.0);
  final curve = reversing ? spec.reverseCurve : spec.curve;
  return curve.transform(rawProgress);
}
