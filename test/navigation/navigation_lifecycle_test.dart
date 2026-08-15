import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('disposing the app during a page transition leaves no ticker',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            key: const ValueKey<String>('open-route'),
            onPressed: () {
              Navigator.of(context).push<void>(
                FluxPageRoute<void>(
                  spec: const FluxPageRouteSpec.fadeThrough(),
                  builder: (_) => const Scaffold(body: Text('Destination')),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('open-route')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(tester.binding.transientCallbackCount, greaterThan(0));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('disposing overlays during their transitions leaves no ticker',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Row(
            children: [
              TextButton(
                key: const ValueKey<String>('open-dialog'),
                onPressed: () {
                  showFluxDialog<void>(
                    context: context,
                    spec: const FluxDialogSpec.fadeScale(),
                    builder: (_) => const AlertDialog(title: Text('Dialog')),
                  );
                },
                child: const Text('Dialog'),
              ),
              TextButton(
                key: const ValueKey<String>('open-sheet'),
                onPressed: () {
                  showFluxBottomSheet<void>(
                    context: context,
                    spec: const FluxBottomSheetSpec.standard(),
                    builder: (_) => const SizedBox(height: 200),
                  );
                },
                child: const Text('Sheet'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('open-dialog')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(tester.binding.transientCallbackCount, greaterThan(0));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            key: const ValueKey<String>('open-sheet-again'),
            onPressed: () {
              showFluxBottomSheet<void>(
                context: context,
                spec: const FluxBottomSheetSpec.standard(),
                builder: (_) => const SizedBox(height: 200),
              );
            },
            child: const Text('Sheet'),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('open-sheet-again')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(tester.binding.transientCallbackCount, greaterThan(0));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });
}
