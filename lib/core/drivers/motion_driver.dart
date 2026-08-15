/// How an effect prefers to drive its animation.
enum MotionDriver {
  /// [AnimationController] managed by the engine.
  explicit,

  /// Implicit widgets (e.g. [TweenAnimationBuilder]) inside [MotionRender].
  intrinsic,
}
