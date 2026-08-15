import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/shimmer/flux_shimmer.dart';
import 'package:flutter_flux_motion/motions/shimmer/shimmer_effect.dart';
import 'package:flutter_flux_motion/motions/shimmer/shimmer_render.dart';
import 'package:flutter_flux_motion/motions/shimmer/shimmer_spec.dart';

void main() {
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

  testWidgets('FluxShimmer renders a ShaderMask around the child',
      (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: FluxShimmer(
          spec: const ShimmerSpec(repeat: false),
          child: const SizedBox(
            key: ValueKey('shimmer-child'),
            width: 120,
            height: 40,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ShaderMask), findsOneWidget);
    expect(find.byKey(const ValueKey('shimmer-child')), findsOneWidget);
    expect(
      tester.widget<ShaderMask>(find.byType(ShaderMask)).blendMode,
      BlendMode.srcATop,
    );
  });

  testWidgets('FluxShimmer respects disabled animations', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: FluxShimmer(
            trigger: MotionTrigger.onMount,
            child: const SizedBox(width: 120, height: 40),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ShaderMask), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
