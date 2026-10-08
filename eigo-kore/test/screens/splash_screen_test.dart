import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/screens/splash_screen.dart';

void main() {
  testWidgets('スプラッシュにアプリ画像・シリーズロゴ・組織ロゴが出て背景は白', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SplashScreen())),
    );
    await tester.pump(const Duration(milliseconds: 1300));

    final paths = tester
        .widgetList<Image>(find.byType(Image))
        .map((i) => (i.image as AssetImage).assetName)
        .toList();
    expect(paths, contains('assets/branding/app_icon.png'));
    expect(paths, contains('assets/branding/series_logo.png'));
    expect(paths, contains('assets/branding/yourwish_logo.png'));
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
        const Color(0xFFFFFFFF));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
