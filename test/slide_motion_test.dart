import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/slide/slide_effect.dart';
import 'package:flutter_flux_motion/motions/slide/slide_render.dart';
import 'package:flutter_flux_motion/motions/slide/slide_spec.dart';
import 'package:flutter_flux_motion/motions/slide/flux_slide.dart';

void main() {
  group('SlideSpec', () {
    test('provides the mobile defaults', () {
      const spec = SlideSpec();

      expect(spec.begin, const Offset(0, 24));
      expect(spec.end, Offset.zero);
      expect(spec.duration, const Duration(milliseconds: 500));
      expect(spec.curve, Curves.easeOutCubic);
      expect(spec.repeat, isFalse);
      expect(spec.reverse, isTrue);
    });
  });

  group('SlideEffect', () {
    test('maps elapsed time to an interpolated offset', () {
      final effect = SlideEffect(
        const SlideSpec(
          begin: Offset(-20, 40),
          end: Offset(20, -40),
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 500));

      final render = effect.toRender() as SlideRender;
      expect(render.offset, const Offset(0, 0));
      expect(effect.duration, const Duration(milliseconds: 1000));
      expect(effect.curve, Curves.linear);
      expect(effect.trigger, MotionTrigger.onMount);
    });

    test('uses the end offset when elapsed time exceeds duration', () {
      final effect = SlideEffect(
        const SlideSpec(
          begin: Offset(0, 24),
          end: Offset(10, -10),
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 200));

      expect((effect.toRender() as SlideRender).offset, const Offset(10, -10));
    });
  });

  group('SlideRender', () {
    testWidgets('builds Transform.translate without changing the child type',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SlideRender(offset: Offset(12, 24))
              .build(const Text('slide')),
        ),
      );

      final transform = tester.widget<Transform>(find.byType(Transform));
      expect(transform.transform.storage[12], 12);
      expect(transform.transform.storage[13], 24);
      expect(find.text('slide'), findsOneWidget);
    });
  });

  group('FluxSlide', () {
    testWidgets('starts on mount and reaches the configured end offset',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxSlide(
            spec: const SlideSpec(
              begin: Offset(0, 24),
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
            child: const Text('slide'),
          ),
        ),
      );

      expect(
          tester
              .widget<Transform>(find.byType(Transform))
              .transform
              .storage[13],
          24);

      await tester.pump(const Duration(milliseconds: 100));

      final transform = tester.widget<Transform>(find.byType(Transform));
      expect(transform.transform.storage[12], 0);
      expect(transform.transform.storage[13], 0);
    });

    testWidgets('starts from the widget trigger', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxSlide(
            trigger: MotionTrigger.onTap,
            spec: const SlideSpec(
              begin: Offset(0, 0.01),
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
            child: const Text('tap slide'),
          ),
        ),
      );

      expect(
          tester
              .widget<Transform>(find.byType(Transform))
              .transform
              .storage[13],
          0.01);

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
          tester
              .widget<Transform>(find.byType(Transform))
              .transform
              .storage[13],
          0);
    });
  });
}
