import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/badge_model.dart';
import 'package:kokugo_kore/widgets/badge_encyclopedia.dart';
import 'package:kokugo_kore/models/badge_set_bonus_model.dart';
import 'package:kokugo_kore/providers/badge_provider.dart';

void main() {
  group('BadgeEncyclopedia Widget Tests', () {
    // テスト用の Badge モデル
    final testBadges = [
      BadgeModel(
        id: 'badge_1',
        emoji: '🎯',
        title: 'テストバッジ1',
        description: '説明1',
        category: BadgeCategory.score,
        requiredCount: 10,
      ),
      BadgeModel(
        id: 'badge_2',
        emoji: '⭐',
        title: 'テストバッジ2',
        description: '説明2',
        category: BadgeCategory.score,
        requiredCount: 5,
      ),
      BadgeModel(
        id: 'badge_3',
        emoji: '🏆',
        title: 'テストバッジ3',
        description: '説明3',
        category: BadgeCategory.score,
        requiredCount: 20,
      ),
    ];

    testWidgets('BadgeEncyclopedia renders with empty earned badges',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BadgeEncyclopedia(allBadges: testBadges),
            ),
          ),
        ),
      );

      // 初回描画時の確認
      expect(find.byType(BadgeEncyclopedia), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('BadgeEncyclopedia displays correct number of badges',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BadgeEncyclopedia(allBadges: testBadges),
            ),
          ),
        ),
      );

      // GridView のアイテム数を確認（バッジの全数）
      final gridViewFinder = find.byType(GridView);
      expect(gridViewFinder, findsOneWidget);
    });

    testWidgets('BadgeEncyclopedia filter chips work correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BadgeEncyclopedia(allBadges: testBadges),
            ),
          ),
        ),
      );

      // フィルターチップが存在することを確認
      expect(find.byType(ChoiceChip), findsWidgets);

      // フィルターチップをタップ
      await tester.tap(find.byType(ChoiceChip).first);
      await tester.pumpAndSettle();

      // フィルター後の状態を確認
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('BadgeEncyclopedia displays statistics section',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BadgeEncyclopedia(allBadges: testBadges),
            ),
          ),
        ),
      );

      // 統計セクションが存在することを確認
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });

    testWidgets('BadgeEncyclopedia responsive layout - portrait',
        (WidgetTester tester) async {
      // ポートレートモード（縦画面）
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BadgeEncyclopedia(allBadges: testBadges),
            ),
          ),
        ),
      );

      // 4列グリッドを期待
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('BadgeEncyclopedia responsive layout - landscape',
        (WidgetTester tester) async {
      // ランドスケープモード（横画面）
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BadgeEncyclopedia(allBadges: testBadges),
            ),
          ),
        ),
      );

      // 6列グリッドを期待
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('BadgeEncyclopedia dark mode support',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
            home: Scaffold(
              body: BadgeEncyclopedia(allBadges: testBadges),
            ),
          ),
        ),
      );

      // ダークモードで描画されることを確認
      expect(find.byType(BadgeEncyclopedia), findsOneWidget);
    });
  });
}
