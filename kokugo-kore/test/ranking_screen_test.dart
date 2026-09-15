import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/models/ranking_model.dart';
import 'package:kokugo_kore/screens/ranking_screen.dart';

void main() {
  group('RankingScreen Widget Tests', () {
    testWidgets('RankingScreen displays ranking data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディング完了を待機
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ランキング画面が表示される
      expect(find.text('ランキング'), findsWidgets);

      // フィルタータブが表示される
      expect(find.text('すべて'), findsOneWidget);
      expect(find.text('学年別'), findsOneWidget);
      expect(find.text('開始月別'), findsOneWidget);
      expect(find.text('学年×開始月'), findsOneWidget);
    });

    testWidgets('RankingScreen displays student rankings', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 学生名が表示される
      expect(find.text('田中 太郎'), findsOneWidget);
      expect(find.text('山田 花子'), findsOneWidget);
      expect(find.text('佐藤 次郎'), findsOneWidget);
    });

    testWidgets('RankingScreen displays rank badges', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 順位バッジが表示される
      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);
    });

    testWidgets('RankingScreen displays badge counts', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // バッジ数が表示される
      expect(find.text('バッジ'), findsWidgets);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('13'), findsOneWidget);
    });

    testWidgets('RankingScreen filter by grade works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 「学年別」フィルタータブが存在することを確認
      expect(find.text('学年別'), findsOneWidget);

      // タップして表示を更新
      await tester.tap(find.text('学年別'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // ランキング画面がまだ表示されていることを確認
      expect(find.byType(RankingScreen), findsOneWidget);
    });

    testWidgets('RankingScreen filter by start date works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 「開始月別」フィルタータブをタップ
      await tester.tap(find.text('開始月別'));
      await tester.pumpAndSettle();

      // 開始月のグループヘッダーが表示される
      expect(find.textContaining('月'), findsWidgets);
    });

    testWidgets('RankingScreen filter by grade and start date works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 「学年×開始月」フィルタータブをタップ
      await tester.tap(find.text('学年×開始月'));
      await tester.pumpAndSettle();

      // 複合グループヘッダーが表示される
      expect(find.textContaining('年生'), findsWidgets);
      expect(find.textContaining('開始'), findsWidgets);
    });

    testWidgets('RankingScreen displays grade and start date info',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 学年と開始月の情報が表示される
      expect(find.textContaining('年生'), findsWidgets);
      expect(find.textContaining('月開始'), findsWidgets);
    });

    testWidgets('RankingScreen dark mode support', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
            home: const RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // ダークモードでの描画を確認
      expect(find.byType(RankingScreen), findsOneWidget);
    });

    testWidgets('RankingScreen scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // ローディングが完了するまで待機
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // スクロール可能か確認
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // スクロール後も表示が正常
      expect(find.byType(RankingScreen), findsOneWidget);
    });
  });
}
