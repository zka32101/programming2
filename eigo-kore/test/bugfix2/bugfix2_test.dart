import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/shared_core.dart';

import 'package:eigo_kore/data/lesson_data.dart';
import 'package:eigo_kore/models/challenge_model.dart';
import 'package:eigo_kore/models/question.dart';
import 'package:eigo_kore/providers/challenge_provider.dart';
import 'package:eigo_kore/screens/challenge_hub_screen.dart';
import 'package:eigo_kore/widgets/lesson_screen_components.dart';

Question _q(QuestionType t) => Question(
      id: 'x',
      type: t,
      difficulty: DifficultyLevel.beginner,
      text: '7',
      textJa: '「7」を英語で選ぼう',
      correctAnswer: 'seven',
    );

Future<void> _pumpExplain(WidgetTester t, Question q) => t.pumpWidget(
    MaterialApp(
        home: Scaffold(
            body: SingleChildScrollView(
                child: ImprovedAnswerExplanation(
                    question: q, isCorrect: true, onPlayCorrect: () {})))));

Widget _hub(List<Override> o) =>
    ProviderScope(overrides: o, child: const MaterialApp(home: ChallengeHubScreen()));

void main() {
  test('学ぶ一覧の表示用変換後に記法が残らない', () {
    for (final l in kLessons) {
      final all = [l.title, ...l.sections.expand((s) => [s.heading ?? '', s.body])];
      for (final s in all) {
        final p = FuriganaText.plainText(s);
        expect(p.contains(RegExp(r'[{|}]')), isFalse, reason: s);
      }
    }
  });

  testWidgets('ライティングは説明欄を出さない', (t) async {
    await _pumpExplain(t, _q(QuestionType.writing));
    expect(find.text('説明'), findsNothing);
  });
  testWidgets('リーディング等は説明を出す', (t) async {
    for (final ty in [QuestionType.reading, QuestionType.listening, QuestionType.speaking]) {
      await _pumpExplain(t, _q(ty));
      expect(find.text('説明'), findsOneWidget);
    }
  });

  testWidgets('チャレンジハブ: 空', (t) async {
    await t.pumpWidget(_hub([activeChallengesProvider.overrideWith((r) async => <SocialChallenge>[])]));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(find.text('チャレンジがありません'), findsOneWidget);
  });
  testWidgets('チャレンジハブ: エラー', (t) async {
    await t.pumpWidget(_hub([activeChallengesProvider.overrideWith((r) async => throw Exception('x'))]));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(find.text('再試行'), findsOneWidget);
  });
  testWidgets('チャレンジハブ: 読み込み中', (t) async {
    await t.pumpWidget(_hub([activeChallengesProvider.overrideWith((r) => Future<List<SocialChallenge>>.delayed(const Duration(seconds: 5), () => []))]));
    await t.pump();
    expect(t.takeException(), isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await t.pump(const Duration(seconds: 6));
  });
}
