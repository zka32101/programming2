import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/widgets/streak_badge.dart';
import 'package:eigo_kore/widgets/streak_card.dart';

void main() {
  for (final d in [6, 7, 14, 30]) {
    testWidgets('streak widgets no overflow at 320px (days=$d)', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: [
            Row(children: [StreakBadge(days: d)]),
            StreakCard(days: d),
          ]),
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
      final crowns = find.byWidgetPredicate((w) =>
          w is Image && w.image is AssetImage &&
          (w.image as AssetImage).assetName.contains('_crown'));
      expect(crowns, d == 6 ? findsNothing : findsNWidgets(2));
    });
  }
}
