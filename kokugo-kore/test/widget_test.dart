import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/main.dart';
import 'package:kokugo_kore/models/quest_model.dart';
import 'package:shared_core/shared_core.dart'
    show BadgeModel, EarnedBadge, BadgeCategory, characterStateProvider, equippedItemsProvider;
import 'package:kokugo_kore/screens/splash_screen.dart';
import 'package:kokugo_kore/screens/home_screen.dart';
import 'package:kokugo_kore/screens/stage_select_screen.dart';
import 'package:kokugo_kore/screens/badge_screen.dart';
import 'package:kokugo_kore/screens/settings_screen.dart';
import 'package:kokugo_kore/screens/quest_screen.dart';
import 'package:kokugo_kore/screens/result_screen.dart';
import 'package:kokugo_kore/theme/app_theme.dart';
import 'package:kokugo_kore/data/quiz_data.dart';
import 'package:kokugo_kore/providers/character_provider.dart';
import 'package:kokugo_kore/providers/equipped_items_provider.dart';

void main() {
  group('国語コレ！アプリケーション', () {
    // ===== スモークテスト =====
    testWidgets('App smoke test - アプリの基本的な起動', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: KokugoKoreApp()));
      await tester.pump();
      expect(find.byType(KokugoKoreApp), findsOneWidget);
    });

    // ===== スプラッシュスクリーンテスト =====
    group('SplashScreen', () {
      testWidgets('スプラッシュ画面の表示確認', (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: SplashScreen()),
          ),
        );
        expect(find.byType(SplashScreen), findsOneWidget);
        expect(find.text('小学コレ！国語'), findsOneWidget);
        expect(find.text('ひらがなから読解・作文まで'), findsOneWidget);
      });

      testWidgets('アニメーション実行確認', (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: SplashScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(FadeTransition), findsWidgets);
        expect(find.byType(ScaleTransition), findsWidgets);
      });
    });

    // ===== ホームスクリーンテスト =====
    group('HomeScreen', () {
      testWidgets('ホーム画面の表示確認', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              characterStateProvider.overrideWith(CharacterNotifier.new),
              equippedItemsProvider.overrideWith(EquippedItemsNotifier.new),
            ],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        expect(find.text('📚 小学コレ！国語'), findsOneWidget);
      });

      testWidgets('統計情報の表示確認', (WidgetTester tester) async {

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              characterStateProvider.overrideWith(CharacterNotifier.new),
              equippedItemsProvider.overrideWith(EquippedItemsNotifier.new),
            ],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        expect(find.text('れんぞく'), findsOneWidget);
        expect(find.text('コイン'), findsOneWidget);
        expect(find.text('バッジ'), findsOneWidget);
      });
    });

    // ===== ステージセレクトスクリーンテスト =====
    group('StageSelectScreen', () {
      testWidgets('ステージ選択画面の表示確認', (WidgetTester tester) async {

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: StageSelectScreen()),
          ),
        );

        expect(find.byType(StageSelectScreen), findsOneWidget);
      });
    });

    // ===== バッジスクリーンテスト =====
    group('BadgeScreen', () {
      testWidgets('バッジスクリーンの表示確認', (WidgetTester tester) async {

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: BadgeScreen()),
          ),
        );

        expect(find.text('バッジコレクション'), findsOneWidget);
      });
    });

    // ===== 設定スクリーンテスト =====
    group('SettingsScreen', () {
      testWidgets('設定画面の表示確認', (WidgetTester tester) async {

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: SettingsScreen()),
          ),
        );

        expect(find.text('せってい'), findsOneWidget);
        // きろく はスクロール領域内にあるため、drag で表示
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(find.text('きろく'), findsOneWidget);
      });
    });
  });

  group('テーマ機能テスト', () {
    test('テーマが正しく構成されている', () {
      final theme = buildAppTheme();
      expect(theme.useMaterial3, true);
      expect(theme.colorScheme.primary, kPrimaryColor);
      expect(theme.scaffoldBackgroundColor, kBgLight);
    });

    test('学年グループの色が正しく設定されている', () {
      expect(gradeColor(GradeGroup.low), const Color(0xFFF39C12));
      expect(gradeColor(GradeGroup.mid), const Color(0xFF27AE60));
      expect(gradeColor(GradeGroup.high), const Color(0xFF2980B9));
    });

    test('学年グループラベルが正しく設定されている', () {
      expect(gradeLabel(GradeGroup.low), '低学年');
      expect(gradeLabel(GradeGroup.mid), '中学年');
      expect(gradeLabel(GradeGroup.high), '高学年');
    });
  });

  group('データモデルテスト', () {
    test('QuizQuestionが正しく生成される', () {
      const question = QuizQuestion(
        id: 'test_1',
        type: QuizType.primary,
        grade: 1,
        question: '「山」の読み方は？',
        highlightChar: '山',
        choices: ['やま', 'かわ', 'き', 'ひ'],
        correctIndex: 0,
        explanation: '「山」は「やま」と読みます。',
      );

      expect(question.id, 'test_1');
      expect(question.grade, 1);
      expect(question.type, QuizType.primary);
      expect(question.correctIndex, 0);
      expect(question.highlightChar, '山');
    });

    test('Stageが正しく生成される', () {
      const stage = Stage(
        stageNumber: 1,
        title: 'テストステージ',
        grade: 1,
        quizType: QuizType.primary,
        questions: [
          QuizQuestion(
            id: 'test_1',
            type: QuizType.primary,
            grade: 1,
            question: 'テスト',
            highlightChar: '試',
            choices: ['し', 'た', 'テ', 'ス'],
            correctIndex: 0,
            explanation: 'テスト説明',
          ),
        ],
      );

      expect(stage.stageNumber, 1);
      expect(stage.totalQuestions, 1);
      expect(stage.quizType, QuizType.primary);
    });

    test('QuestResultが正しく生成される', () {
      const result = QuestResult(
        correctCount: 5,
        totalCount: 5,
        elapsed: Duration(minutes: 5),
      );

      expect(result.correctCount, 5);
      expect(result.totalCount, 5);
      expect(result.score, 100);
      expect(result.isPerfect, true);
      expect(result.isPassed, true);
    });

    test('QuestResult - 部分正解時のスコア計算', () {
      const result = QuestResult(
        correctCount: 3,
        totalCount: 5,
        elapsed: Duration(minutes: 2),
      );

      expect(result.score, 60);
      expect(result.isPerfect, false);
      expect(result.isPassed, true);
    });

    test('QuestResult - 不合格時の判定', () {
      const result = QuestResult(
        correctCount: 2,
        totalCount: 5,
        elapsed: Duration(minutes: 3),
      );

      expect(result.score, 40);
      expect(result.isPerfect, false);
      expect(result.isPassed, false);
    });

    test('BadgeModelが正しく生成される', () {
      const badge = BadgeModel(
        id: 'test_badge',
        title: 'テストバッジ',
        description: 'これはテストです',
        emoji: '⭐',
        category: BadgeCategory.score,
        requiredCount: 5,
      );

      expect(badge.id, 'test_badge');
      expect(badge.category, BadgeCategory.score);
      expect(badge.requiredCount, 5);
    });

    test('EarnedBadgeが正しく生成される', () {
      const badge = BadgeModel(
        id: 'test',
        title: 'Test',
        description: 'Test',
        emoji: '⭐',
        category: BadgeCategory.score,
        requiredCount: 1,
      );

      final earnedAt = DateTime.now();
      final earned = EarnedBadge(badge: badge, earnedAt: earnedAt);

      expect(earned.badge.id, 'test');
      expect(earned.earnedAt, earnedAt);
    });
  });

  group('クイズデータテスト', () {
    test('すべての学年のステージが存在する', () {
      for (int grade = 1; grade <= 6; grade++) {
        final stages = getStagesForGrade(grade);
        expect(stages.isNotEmpty, true, reason: '学年$gradeのステージが存在すること');
      }
    });

    test('各学年に複数のステージが存在する', () {
      for (int grade = 1; grade <= 6; grade++) {
        final stages = getStagesForGrade(grade);
        expect(stages.length, greaterThan(1),
            reason: '学年$gradeに複数のステージが存在すること');
      }
    });

    test('各ステージに複数の問題が存在する', () {
      for (int grade = 1; grade <= 6; grade++) {
        final stages = getStagesForGrade(grade);
        for (final stage in stages) {
          expect(stage.questions.isNotEmpty, true,
              reason: 'ステージ${stage.stageNumber}に問題が存在すること');
        }
      }
    });

    test('デフォルト学年は1年生', () {
      final stages = getStagesForGrade(999); // 無効な学年
      expect(stages.isNotEmpty, true);
    });

    test('小学1年生のステージ構成', () {
      final stages = getStagesForGrade(1);
      expect(stages[0].grade, 1);
      expect(stages[0].stageNumber, 1);
    });
  });
}
