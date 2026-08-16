import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_flux_motion_example/main.dart';

void main() {
  testWidgets('vitrine mobile percorre favorito e montagem da caixa',
      (tester) async {
    final exceptions = <Object>[];
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const ValueKey('open-mobile-showcase')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    _collectExceptions(tester, exceptions);

    expect(find.byKey(const ValueKey('mobile-showcase-page')), findsOneWidget);
    expect(find.text('Seu sábado já está\nem movimento.'), findsOneWidget);
    expect(find.byKey(const ValueKey('showcase-card-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('showcase-card-3')), findsOneWidget);
    expect(find.text('Baunilha tostada'), findsOneWidget);
    expect(find.text('Chocolate 70%'), findsOneWidget);
    expect(find.text('0 SALVOS'), findsOneWidget);

    final firstCard = find.byKey(const ValueKey('showcase-card-0'));
    final firstFavorite = find.byKey(const ValueKey('showcase-favorite-0'));
    final favoritePulse = find.ancestor(
      of: firstFavorite,
      matching: find.byType(FluxPulse),
    );

    expect(tester.getSize(firstFavorite), const Size.square(58));
    expect(favoritePulse, findsOneWidget);

    // Tocar no card, fora do ícone, não pode acionar o favorito.
    await tester.tapAt(tester.getTopLeft(firstCard) + const Offset(24, 24));
    await tester.pump(const Duration(milliseconds: 320));
    expect(find.text('0 SALVOS'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('showcase-favorite-icon-0-false')),
      findsOneWidget,
    );

    await tester.tap(firstFavorite);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));

    expect(_pulseScale(tester, 0), closeTo(1.1, .01));

    await tester.pump(const Duration(milliseconds: 160));

    expect(_pulseScale(tester, 0), closeTo(1, .01));
    expect(find.text('1 SALVOS'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('showcase-favorite-icon-0-true')),
      findsOneWidget,
    );

    await _scrollToEnd(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    _collectExceptions(tester, exceptions);

    expect(find.byKey(const ValueKey('showcase-route-sheet')), findsOneWidget);
    final glowingCta = find.byKey(const ValueKey('showcase-glowing-cta'));
    expect(glowingCta, findsOneWidget);
    expect(
      find.ancestor(of: glowingCta, matching: find.byType(FluxGlow)),
      findsOneWidget,
    );

    await tester.tap(glowingCta);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    _collectExceptions(tester, exceptions);

    expect(find.text('Pedido montado.'), findsOneWidget);
    expect(
      find.text('Um pouco de motion, bem quando importa.'),
      findsOneWidget,
    );
    expect(exceptions, isEmpty, reason: exceptions.join('\n\n'));
  });

  testWidgets('vitrine mobile permanece sem overflow em 320px', (tester) async {
    final exceptions = <Object>[];
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 720);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const ValueKey('open-mobile-showcase')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    _collectExceptions(tester, exceptions);

    await _scrollToEnd(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    _collectExceptions(tester, exceptions);

    expect(find.byKey(const ValueKey('showcase-route-sheet')), findsOneWidget);
    expect(exceptions, isEmpty, reason: exceptions.join('\n\n'));
  });
}

double _pulseScale(WidgetTester tester, int index) {
  final childKey = ValueKey('showcase-favorite-pulse-child-$index');
  final transform = find.byWidgetPredicate(
    (widget) => widget is Transform && widget.child?.key == childKey,
    description: 'transformação do pulso ao redor do favorito $index',
  );
  expect(transform, findsOneWidget);
  return tester.widget<Transform>(transform).transform.storage[0];
}

Future<void> _scrollToEnd(WidgetTester tester) async {
  final scrollable = find.byKey(
    const PageStorageKey<String>('mobile-showcase-scroll'),
  );
  expect(scrollable, findsOneWidget);
  final state = tester.state<ScrollableState>(
    find.descendant(of: scrollable, matching: find.byType(Scrollable)).first,
  );

  var steps = 0;
  while (state.position.extentAfter > 1) {
    await tester.drag(scrollable, const Offset(0, -420));
    await tester.pump(const Duration(milliseconds: 60));
    steps++;
    expect(steps, lessThan(30));
  }
}

void _collectExceptions(WidgetTester tester, List<Object> exceptions) {
  while (true) {
    final exception = tester.takeException();
    if (exception == null) {
      return;
    }
    exceptions.add(exception);
  }
}
