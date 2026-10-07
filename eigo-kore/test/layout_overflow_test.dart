import 'package:eigo_kore/data/stage_data.dart';
import 'package:eigo_kore/screens/stage_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('StageSelectScreen has no overflow (textScale $scale)', (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.dark(),
            builder: (c, child) => MediaQuery(
              data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const StageSelectScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(allStages, isNotEmpty);
      final e = tester.takeException();
      if (e != null) { debugPrint('EXC: $e'); }
      expect(e, isNull);
    });
  }
}
