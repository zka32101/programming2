import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/widgets/daily_bonus_dialog.dart';

void main() {
  for (final w in [320.0, 360.0, 411.0]) {
    for (final scale in [1.0, 1.3]) {
      for (final streak in [1, 7, 30]) {
        testWidgets('今日のプレゼントが溢れない width=$w scale=$scale streak=$streak', (tester) async {
          tester.view.physicalSize = Size(w * 2, 1600 * 2);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(MaterialApp(
            builder: (c, child) => MediaQuery(
              data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: Scaffold(
              body: Builder(
                builder: (ctx) => TextButton(
                  onPressed: () => showDialog(
                    context: ctx,
                    builder: (_) => DailyBonusDialog(streak: streak, bonusCoins: 200, onClaim: () {}),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ));
          await tester.tap(find.text('open'));
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.textContaining('うけとる'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
