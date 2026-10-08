import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/screens/splash_screen.dart';

void main() {
  testWidgets('スプラッシュにアプリ画像・アプリ名・組織名が出る', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SplashScreen())),
    );
    await tester.pump(const Duration(milliseconds: 1300));

    final paths = tester
        .widgetList<Image>(find.byType(Image))
        .map((i) => (i.image as AssetImage).assetName)
        .toList();
    expect(paths, contains('assets/logos/app_icon_512.jpg'));
    expect(paths, contains('assets/logos/company_app_icon.jpg'));
    expect(find.text('小学コレ！算数'), findsOneWidget);
    expect(find.text('Your Wish'), findsOneWidget);
  });
}
