import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/screens/daily_bonus_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final w in [320.0, 360.0, 411.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('今日のプレゼントの7日表示が溢れない width=$w scale=$scale', (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = Size(w * 2, 1600 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
            builder: (c, child) => MediaQuery(
              data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const Scaffold(body: DailyBonusScreen()),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 700));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
