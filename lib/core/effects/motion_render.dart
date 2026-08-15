import 'package:flutter/widgets.dart';

/// Visual layer of a motion effect — no animation controller logic.
abstract class MotionRender {
  const MotionRender();

  Widget build(Widget child);
}

/// Returns [child] unchanged — used when animations are disabled.
class PassthroughMotionRender extends MotionRender {
  const PassthroughMotionRender();

  @override
  Widget build(Widget child) => child;
}
