import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/screens/splash_screen.dart';

Widget _app() => const ProviderScope(
      child: MaterialApp(
        home: SplashScreen(),
        onGenerateRoute: _route,
      ),
    );

Route<dynamic>? _route(RouteSettings s) => MaterialPageRoute(
      builder: (_) => Scaffold(body: Text('route:${s.name}')),
      settings: s,
    );

void main() {
  testWidgets('スプラッシュにアプリ画像・シリーズロゴ・組織ロゴが出て背景は白', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 1200));

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
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('プロフィール0件ならスプラッシュ後にプロフィール選択へ遷移', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('route:/profile-select'), findsOneWidget);
  });
}
