import 'package:flutter/material.dart';

import 'flux_bottom_sheet_spec.dart';

/// Shows a Material modal bottom sheet using a [FluxBottomSheetSpec].
///
/// The returned future completes with the value passed to [Navigator.pop].
Future<T?> showFluxBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  FluxBottomSheetSpec spec = const FluxBottomSheetSpec.standard(),
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  final animationsDisabled = MediaQuery.disableAnimationsOf(context);
  final animationStyle = animationsDisabled
      ? AnimationStyle.noAnimation
      : AnimationStyle(
          duration: spec.duration,
          reverseDuration: spec.reverseDuration,
          curve: spec.curve,
          reverseCurve: spec.reverseCurve,
        );

  return showModalBottomSheet<T>(
    context: context,
    builder: builder,
    backgroundColor: backgroundColor,
    barrierLabel: barrierLabel,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    sheetAnimationStyle: animationStyle,
  );
}
