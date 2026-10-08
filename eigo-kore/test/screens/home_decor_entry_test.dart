import 'package:eigo_kore/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ホームに「きせかえショップ」ボタンがあり、押すと /decor-shop へ遷移する', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    String? pushed;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const HomeScreen(),
          onGenerateRoute: (settings) {
            pushed = settings.name;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('dest')),
            );
          },
        ),
      ),
    );
    await tester.pump();
    // テスト用フォントでヘッダーが数px溢れる既存の描画警告は本テストの対象外。
    tester.takeException();

    final btn = find.text('👕 きせかえショップ');
    await tester.scrollUntilVisible(btn, 200,
        scrollable: find.byType(Scrollable).first);
    expect(btn, findsOneWidget);
    await tester.tap(btn);
    await tester.pump();
    expect(pushed, '/decor-shop');
  });
}
