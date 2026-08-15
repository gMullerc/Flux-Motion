import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/blur/blur_effect.dart';
import 'package:flutter_flux_motion/motions/blur/blur_render.dart';
import 'package:flutter_flux_motion/motions/blur/blur_spec.dart';
import 'package:flutter_flux_motion/motions/blur/flux_blur.dart';

void main() {
  group('BlurSpec', () {
    test('uses the planned defaults', () {
      const spec = BlurSpec();

      expect(spec.sigmaXBegin, 12);
      expect(spec.sigmaYBegin, 12);
      expect(spec.sigmaXEnd, 0);
      expect(spec.sigmaYEnd, 0);
      expect(spec.duration, const Duration(milliseconds: 550));
      expect(spec.curve, Curves.easeOutCubic);
      expect(spec.repeat, isFalse);
      expect(spec.reverse, isTrue);
    });

    test('rejects negative sigma values', () {
      expect(() => BlurSpec(sigmaXBegin: -1), throwsA(isA<AssertionError>()));
      expect(() => BlurSpec(sigmaYBegin: -1), throwsA(isA<AssertionError>()));
      expect(() => BlurSpec(sigmaXEnd: -1), throwsA(isA<AssertionError>()));
      expect(() => BlurSpec(sigmaYEnd: -1), throwsA(isA<AssertionError>()));
    });
  });

  group('BlurEffect', () {
    test('interpolates both blur axes from begin to end', () {
      final effect = BlurEffect(
        const BlurSpec(
          sigmaXBegin: 12,
          sigmaYBegin: 8,
          sigmaXEnd: 2,
          sigmaYEnd: 0,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 500));

      final render = effect.toRender() as BlurRender;
      expect(render.sigmaX, closeTo(7, 0.0001));
      expect(render.sigmaY, closeTo(4, 0.0001));
    });

    test('clamps elapsed time and reaches the configured end values', () {
      final effect = BlurEffect(
        const BlurSpec(
          sigmaXBegin: 12,
          sigmaYBegin: 12,
          sigmaXEnd: 0,
          sigmaYEnd: 4,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 1500));

      final render = effect.toRender() as BlurRender;
      expect(render.sigmaX, 0);
      expect(render.sigmaY, 4);
    });
  });

  group('FluxBlur', () {
    testWidgets('renders ImageFiltered without changing child layout',
        (tester) async {
      final childKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: FluxBlur(
              spec: const BlurSpec(
                duration: Duration(milliseconds: 100),
              ),
              child: SizedBox(
                key: childKey,
                width: 80,
                height: 40,
                child: const ColoredBox(color: Colors.blue),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ImageFiltered), findsOneWidget);
      final filtered = tester.widget<ImageFiltered>(find.byType(ImageFiltered));
      expect(filtered.imageFilter, isA<ui.ImageFilter>());
      expect(tester.getSize(find.byKey(childKey)), const Size(80, 40));
    });

    test('requires either a spec or explicit effects', () {
      expect(
        () => FluxBlur(
          spec: const BlurSpec(),
          effects: const <BlurEffect>[],
          child: const SizedBox.shrink(),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('stores the requested activation trigger', () {
      final effect = BlurEffect(
        const BlurSpec(),
        activation: MotionTrigger.onTap,
      );

      expect(effect.trigger, MotionTrigger.onTap);
    });
  });
}
