import 'package:sansu_kore/widgets/branded_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('起動画面: 3画像が出て背景は白・小画面でも溢れない', (tester) async {
    tester.view.physicalSize = const Size(360, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: BrandedSplashBody())),
    );
    final paths = tester
        .widgetList<Image>(find.byType(Image))
        .map((i) => (i.image as AssetImage).assetName)
        .toList();
    expect(paths, contains('assets/branding/app_icon.png'));
    expect(paths, contains('assets/branding/series_logo.png'));
    expect(paths, contains('assets/branding/yourwish_logo.png'));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final box = tester.widget<ColoredBox>(find
        .descendant(
            of: find.byType(BrandedSplashBody),
            matching: find.byType(ColoredBox))
        .first);
    expect(box.color, const Color(0xFFFFFFFF));
    expect(tester.takeException(), isNull);
  });
}
