import 'package:flutter/widgets.dart';

import '../../core/effects/motion_render.dart';

/// Render layer that applies every sequence effect in timeline order.
final class SequenceRender extends MotionRender {
  /// Creates a render layer from the current child-effect [pipeline].
  SequenceRender({required List<MotionRender> pipeline})
      : pipeline = List<MotionRender>.unmodifiable(pipeline);

  /// Ordered child-effect renders for the current timeline frame.
  final List<MotionRender> pipeline;

  @override
  Widget build(Widget child) {
    return pipeline.fold<Widget>(
      child,
      (current, render) => render.build(current),
    );
  }
}
