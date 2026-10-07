import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/models/quest_model.dart';

QuizQuestion _q(List<String> c, int ci) => QuizQuestion(
      id: 'x',
      type: MathTopicType.addition,
      grade: 1,
      question: 'q',
      choices: c,
      correctIndex: ci,
      explanation: '',
    );

void main() {
  test('中身が保たれ正解が付け替わる', () {
    for (var s = 0; s < 50; s++) {
      QuizQuestion.setTestRandom(Random(s));
      final r = _q(['1', '2', '3', '4'], 1).randomizeChoices();
      expect([...r.choices]..sort(), ['1', '2', '3', '4']);
      expect(r.choices[r.correctIndex], '2');
    }
  });

  test('正解位置がA〜Dに散る', () {
    final seen = <int>{};
    QuizQuestion.setTestRandom(Random(1));
    for (var i = 0; i < 200; i++) {
      seen.add(_q(['a', 'b', 'c', 'd'], 1).randomizeChoices().correctIndex);
    }
    expect(seen, {0, 1, 2, 3});
  });

  test('重複選択肢でも正解の位置を保つ', () {
    for (var s = 0; s < 50; s++) {
      QuizQuestion.setTestRandom(Random(s));
      final src = _q(['5', '5', '7', '9'], 1);
      final r = src.randomizeChoices();
      // 元の2番目の「5」が指していた要素の個数関係が崩れない
      expect(r.choices.where((c) => c == '5').length, 2);
      expect(r.choices[r.correctIndex], '5');
    }
  });
  tearDown(() => QuizQuestion.setTestRandom(null));
}
