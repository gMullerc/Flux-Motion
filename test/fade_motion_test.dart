import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/fade/fade_effect.dart';
import 'package:flutter_flux_motion/motions/fade/fade_render.dart';
import 'package:flutter_flux_motion/motions/fade/fade_spec.dart';
import 'package:flutter_flux_motion/motions/fade/flux_fade.dart';

void main() {
  group('FadeSpec', () {
    test('provides the phase one defaults', () {
      const spec = FadeSpec();

      expect(spec.begin, 0);
      expect(spec.end, 1);
      expect(spec.duration, const Duration(milliseconds: 500));
      expect(spec.curve, Curves.easeOut);
      expect(spec.repeat, isFalse);
      expect(spec.reverse, isTrue);
    });
  });

  group('FadeEffect', () {
    test('maps elapsed time to opacity using the configured curve', () {
      final effect = FadeEffect(
        const FadeSpec(
          begin: 0.2,
          end: 0.8,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 500));

      final render = effect.toRender() as FadeRender;
      expect(render.opacity, closeTo(0.5, 0.0001));
      expect(effect.duration, const Duration(milliseconds: 1000));
      expect(effect.curve, Curves.linear);
      expect(effect.trigger, MotionTrigger.onMount);
    });

    test('uses the end value when elapsed time exceeds duration', () {
      final effect = FadeEffect(
        const FadeSpec(
          begin: -1,
          end: 2,
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 200));

      expect((effect.toRender() as FadeRender).opacity, 2);
    });
  });

  group('FadeRender', () {
    testWidgets('builds Opacity with a clamped alpha', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const FadeRender(opacity: 2).build(const Text('fade')),
        ),
      );

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 1);
    });
  });

  group('FluxFade', () {
    testWidgets('starts on mount and reaches the configured end opacity',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxFade(
            spec: const FadeSpec(
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
            child: const Text('fade'),
          ),
        ),
      );

      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0);

      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
    });

    testWidgets('starts from the widget trigger', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxFade(
            trigger: MotionTrigger.onTap,
            spec: const FadeSpec(
              begin: 0.01,
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
            child: const Text('tap fade'),
          ),
        ),
      );

      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.01);

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
    });
  });
}
