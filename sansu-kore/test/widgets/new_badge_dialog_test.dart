import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/widgets/badge_display_widget.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  testWidgets('NewBadgeDialog: 達成演出3画像・おめでとう・バッジ名・小画面でも溢れない', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final b = allBadges.first;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NewBadgeDialog(badges: [b], onClose: () {}),
      ),
    ));
    await tester.pump(const Duration(seconds: 1));
    final paths = tester
        .widgetList<Image>(find.byType(Image))
        .map((i) => (i.image as AssetImage).assetName)
        .toList();
    expect(paths, contains('assets/celebrate/celebrate_starburst.webp'));
    expect(paths, contains('assets/celebrate/celebrate_medal.webp'));
    expect(paths, contains('assets/celebrate/celebrate_ribbon_banner.webp'));
    expect(find.text('おめでとう！'), findsOneWidget);
    expect(find.text('${b.emoji} ${b.title} を獲得'), findsOneWidget);
    expect(find.text('了解'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
