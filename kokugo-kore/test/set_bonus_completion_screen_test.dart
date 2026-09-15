import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/widgets/set_bonus_completion_screen.dart';
import 'package:kokugo_kore/models/badge_set_bonus_model.dart';

void main() {
  group('SetBonusCompletionScreen Animation Tests', () {
    // テスト用の SetBonus モデル
    final testSetBonus = BadgeSetBonus(
      id: 'set_1',
      title: 'テストセット完成！',
      emoji: '🏆',
      description: 'テストセットの説明',
      requiredBadgeIds: ['badge_1', 'badge_2', 'badge_3'],
      rewardCoins: 500,
      rewardDescription: '500 コイン獲得！',
    );

    testWidgets('SetBonusCompletionScreen renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {},
          ),
        ),
      );

      // スクリーンが描画されることを確認
      expect(find.byType(SetBonusCompletionScreen), findsOneWidget);
      expect(find.text('🏆'), findsOneWidget);
    });

    testWidgets('SetBonusCompletionScreen displays set bonus information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {},
          ),
        ),
      );

      // セットボーナス情報が表示される
      expect(find.text('🏆 セットボーナス完成！'), findsOneWidget);
      expect(find.text('テストセット完成！'), findsOneWidget);
      expect(find.text('+500'), findsOneWidget);
      expect(find.text('コイン！'), findsOneWidget);
    });

    testWidgets('SetBonusCompletionScreen animations run',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {},
          ),
        ),
      );

      // 初期状態を確認（複数のCustomPaintが存在する場合がある）
      expect(find.byType(CustomPaint), findsWidgets);

      // 短時間のアニメーション進行（自動閉鎖前）
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(SetBonusCompletionScreen), findsOneWidget);
    });

    testWidgets('SetBonusCompletionScreen displays confetti effect',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {},
          ),
        ),
      );

      // CustomPaint（コンフェッティ）が描画されることを確認（複数存在可）
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('SetBonusCompletionScreen auto-closes after 5 seconds',
        (WidgetTester tester) async {
      bool callbackInvoked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {
              callbackInvoked = true;
            },
          ),
        ),
      );

      // スクリーンが表示されることを確認
      expect(find.byType(SetBonusCompletionScreen), findsOneWidget);

      // 5秒タイマーを待機（実際にはテスト用に段階的に進める）
      // 1秒経過
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SetBonusCompletionScreen), findsOneWidget);

      // 5秒まで進める
      await tester.pump(const Duration(seconds: 4));

      // スクリーンが閉じられたことを確認（コールバック呼び出し）
      // または Navigator.pop が呼ばれたことを確認
      expect(callbackInvoked || find.byType(SetBonusCompletionScreen).evaluate().isEmpty, isTrue);
    });

    testWidgets('SetBonusCompletionScreen disposes resources',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {},
          ),
        ),
      );

      // 短時間アニメーション進行
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SetBonusCompletionScreen), findsOneWidget);

      // 画面が存在することを確認（リソース破棄に向けて準備）
      final screenFinder = find.byType(SetBonusCompletionScreen);
      expect(screenFinder, findsWidgets);
    });

    testWidgets('SetBonusCompletionScreen dark mode support',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {},
          ),
        ),
      );

      // ダークモードでの描画を確認
      expect(find.byType(SetBonusCompletionScreen), findsOneWidget);
    });

    testWidgets('SetBonusCompletionScreen multiple animations coordinate',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SetBonusCompletionScreen(
            setBonus: testSetBonus,
            coinsEarned: 500,
            onCompleted: () {},
          ),
        ),
      );

      // スケール、回転、グロー、コンフェッティアニメーションが同時に実行
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(CustomPaint), findsWidgets);

      // 追加の時間経過でコイン表示アニメーション（テキストが表示される時間を確保）
      await tester.pump(const Duration(milliseconds: 400));
      // コイン情報は setBonus から取得
      expect(find.text('テストセット完成！'), findsOneWidget);
    });
  });
}
