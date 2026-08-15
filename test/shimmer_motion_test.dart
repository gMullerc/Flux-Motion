import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/shimmer/flux_shimmer.dart';
import 'package:flutter_flux_motion/motions/shimmer/shimmer_effect.dart';
import 'package:flutter_flux_motion/motions/shimmer/shimmer_render.dart';
import 'package:flutter_flux_motion/motions/shimmer/shimmer_spec.dart';

void main() {
  const childKey = ValueKey('shimmer-child');

  Widget tappableChild() {
    return const Listener(
      key: childKey,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 120, height: 40),
    );
  }

  group('ShimmerSpec', () {
    test('uses mobile-friendly defaults', () {
      const spec = ShimmerSpec();

      expect(spec.baseColor, const Color(0x00000000));
      expect(spec.highlightColor, const Color(0xFFFFFFFF));
      expect(spec.intensity, .7);
      expect(spec.bandWidth, .28);
      expect(spec.direction, ShimmerDirection.leftToRight);
      expect(spec.duration, const Duration(milliseconds: 1300));
      expect(spec.curve, Curves.linear);
      expect(spec.repeat, isTrue);
      expect(spec.reverse, isFalse);
    });

    test('rejects invalid intensity and band width', () {
      expect(() => ShimmerSpec(intensity: -1), throwsAssertionError);
      expect(() => ShimmerSpec(intensity: 1.1), throwsAssertionError);
      expect(() => ShimmerSpec(bandWidth: 0), throwsAssertionError);
      expect(() => ShimmerSpec(bandWidth: 1.1), throwsAssertionError);
    });
  });

  test('ShimmerEffect maps elapsed time to shader progress', () {
    final effect = ShimmerEffect(
      const ShimmerSpec(
        duration: Duration(milliseconds: 1000),
        repeat: false,
      ),
    );

    effect.tick(const Duration(milliseconds: 500));

    expect(effect.progress, .5);
    final render = effect.toRender() as ShimmerRender;
    expect(render.progress, .5);
    expect(render.direction, ShimmerDirection.leftToRight);
  });

  test('ShimmerRender exposes directional gradient geometry', () {
    const render = ShimmerRender(
      progress: .5,
      baseColor: Colors.transparent,
      highlightColor: Colors.white,
      intensity: .8,
      bandWidth: .2,
      direction: ShimmerDirection.topToBottom,
    );

    expect(render.begin, Alignment.topCenter);
    expect(render.end, Alignment.bottomCenter);
    expect(render.stops[0], moreOrLessEquals(.3));
    expect(render.stops[1], moreOrLessEquals(.4));
    expect(render.stops[2], moreOrLessEquals(.5));
    expect(render.stops[3], moreOrLessEquals(.6));
    expect(render.stops[4], moreOrLessEquals(.7));
  });

  testWidgets('onTap moves the highlight only after the child is tapped',
      (tester) async {
    final effect = ShimmerEffect(
      const ShimmerSpec(
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
        repeat: false,
      ),
      activation: MotionTrigger.onTap,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FluxShimmer(
              trigger: MotionTrigger.onTap,
              effects: <ShimmerEffect>[effect],
              child: tappableChild(),
            ),
          ),
        ),
      ),
    );

    expect(effect.progress, 0);
    expect(find.byType(ShaderMask), findsOneWidget);
    expect(find.byKey(childKey), findsOneWidget);
    expect(
      tester.widget<ShaderMask>(find.byType(ShaderMask)).blendMode,
      BlendMode.srcATop,
    );

    await tester.pump(const Duration(milliseconds: 300));
    expect(effect.progress, 0,
        reason: 'elapsed time alone must not activate it');

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(effect.progress, closeTo(.5, .01));
    final activeMask = tester.widget<ShaderMask>(find.byType(ShaderMask));
    final activeShader =
        activeMask.shaderCallback(const Rect.fromLTWH(0, 0, 120, 40));
    expect(activeShader, isNotNull);

    await tester.pump(const Duration(milliseconds: 300));
    expect(effect.progress, 1);

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(effect.progress, closeTo(.25, .01),
        reason: 'a second tap must restart the shimmer pass');
  });

  testWidgets('default shimmer repeats past one cycle and disposes its ticker',
      (tester) async {
    final motion = FluxShimmer(
      child: const SizedBox(key: childKey, width: 120, height: 40),
    );
    final effect = motion.effects.single as ShimmerEffect;
    final quarterCycle = Duration(
      microseconds: effect.duration.inMicroseconds ~/ 4,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: motion)),
      ),
    );

    await tester.pump(effect.duration + quarterCycle);

    expect(find.byType(ShaderMask), findsOneWidget);
    expect(effect.progress, closeTo(.25, .01),
        reason: 'the standard shimmer must restart after its first pass');

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(effect.duration * 2);

    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('disableAnimations keeps the complete onTap widget static',
      (tester) async {
    final effect = ShimmerEffect(
      const ShimmerSpec(
        duration: Duration(milliseconds: 600),
        repeat: false,
      ),
      activation: MotionTrigger.onTap,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: FluxShimmer(
              trigger: MotionTrigger.onTap,
              effects: <ShimmerEffect>[effect],
              child: tappableChild(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(childKey));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ShaderMask), findsNothing);
    expect(find.byKey(childKey), findsOneWidget);
    expect(effect.progress, 0);
  });
}
