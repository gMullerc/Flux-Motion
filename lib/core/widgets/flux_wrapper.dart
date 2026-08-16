import 'package:flutter/widgets.dart';

import '../effects/motion_render.dart';

/// Applies an ordered list of [MotionRender] layers over [child] by folding the
/// render pipeline in order.
class FluxWrapper extends StatelessWidget {
  const FluxWrapper({
    super.key,
    required this.child,
    required this.pipeline,
  });

  final Widget child;
  final List<MotionRender> pipeline;

  @override
  Widget build(BuildContext context) {
    if (pipeline.isEmpty) {
      return child;
    }

    return pipeline.fold<Widget>(
      child,
      (current, render) => render.build(current),
    );
  }
}
