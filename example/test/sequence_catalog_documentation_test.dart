import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_flux_motion_example/catalog/catalog_component_page.dart';
import 'package:flutter_flux_motion_example/catalog/sequence_catalog.dart';

void main() {
  testWidgets('Sequence documentation stays complete at 320px', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CatalogComponentPage(entry: sequenceCatalog),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1100));

    expect(find.text('Screen entrance choreography'), findsOneWidget);
    expect(find.text('Success confirmation'), findsOneWidget);
    expect(find.text('Error to recovery'), findsOneWidget);
    expect(find.text('Controller transport'), findsOneWidget);
    expect(
      find.textContaining('420MS ERROR + 220MS GAP + 360MS RECOVERY'),
      findsOneWidget,
    );
    expect(find.text('SequenceSpec.totalDuration'), findsOneWidget);
    expect(find.text('controller.stop()'), findsOneWidget);
    expect(find.text('controller.reset()'), findsOneWidget);
    expect(find.text('controller.replay()'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final document = find.byKey(
      const PageStorageKey<String>('catalog-sequence'),
    );
    final documentScroll =
        find.descendant(of: document, matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(
      find.text('Implementation'),
      520,
      scrollable: documentScroll,
    );
    await tester.pumpAndSettle();

    expect(find.text('Implementation'), findsOneWidget);
    expect(find.textContaining('totalDuration: 680ms'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Sequence success example uses three effects and exact timing',
      (tester) async {
    final example = sequenceCatalog.examples.singleWhere(
      (item) => item.title == 'Success confirmation',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: example.builder!(
              example.trigger!,
              const SizedBox(
                key: ValueKey('confirmation-target'),
                width: 80,
                height: 64,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final sequence = tester.widget<FluxSequence>(find.byType(FluxSequence));
    final effect = sequence.effects.single as SequenceEffect;

    expect(effect.spec.totalDuration, const Duration(milliseconds: 680));
    expect(effect.spec.steps, hasLength(3));
    expect(effect.spec.steps[0].effect, isA<FadeEffect>());
    expect(effect.spec.steps[1].effect, isA<ScaleEffect>());
    expect(effect.spec.steps[2].effect, isA<PulseEffect>());
    expect(effect.spec.steps[2].delay, const Duration(milliseconds: 40));

    await tester.tapAt(
      tester.getCenter(find.byKey(const ValueKey('confirmation-target'))),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, greaterThan(.2));
    expect(opacity.opacity, lessThan(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Sequence controller preview stops, resets, and replays',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 300);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final example = sequenceCatalog.examples.singleWhere(
      (item) => item.title == 'Controller transport',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: example.builder!(
              example.trigger!,
              const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final target = find.byKey(const ValueKey('sequence-controller-target'));
    final opacityFinder = find.ancestor(
      of: target,
      matching: find.byType(Opacity),
    );

    expect(find.byType(FluxSequence), findsOneWidget);
    expect(opacityFinder, findsOneWidget);
    expect(
      find.byKey(const ValueKey('sequence-controller-stop')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('sequence-controller-reset')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('sequence-controller-replay')),
      findsOneWidget,
    );

    final stopButton = find.widgetWithIcon(IconButton, Icons.pause_rounded);
    final resetButton = find.widgetWithIcon(IconButton, Icons.stop_rounded);
    final replayButton = find.widgetWithIcon(IconButton, Icons.replay_rounded);

    await tester.tap(replayButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.tap(stopButton);
    await tester.pump();
    final stoppedOpacity = tester.widget<Opacity>(opacityFinder).opacity;

    expect(stoppedOpacity, greaterThan(0));

    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.widget<Opacity>(opacityFinder).opacity, stoppedOpacity);

    await tester.tap(resetButton);
    await tester.pump();
    expect(tester.widget<Opacity>(opacityFinder).opacity, 0);

    await tester.tap(replayButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(tester.widget<Opacity>(opacityFinder).opacity, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
