import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/models/question.dart';
import 'package:eigo_kore/utils/shuffle_choices.dart';

Question _q(List<String> c, String ans) => Question(
      id: 'x',
      type: QuestionType.reading,
      difficulty: DifficultyLevel.beginner,
      text: 't',
      textJa: 'j',
      choices: c,
      correctAnswer: ans,
    );

void main() {
  test('中身が保たれ正解の文言が選択肢に残る', () {
    for (var s = 0; s < 50; s++) {
      final r = withShuffledChoices(_q(['a', 'b', 'c', 'd'], 'a'), Random(s));
      expect([...r.choices]..sort(), ['a', 'b', 'c', 'd']);
      expect(r.choices.contains(r.correctAnswer), isTrue);
    }
  });

  test('正解位置がA〜Dに散る', () {
    final rng = Random(5);
    final seen = <int>{};
    for (var i = 0; i < 200; i++) {
      final r = withShuffledChoices(_q(['a', 'b', 'c', 'd'], 'a'), rng);
      seen.add(r.choices.indexOf(r.correctAnswer));
    }
    expect(seen, {0, 1, 2, 3});
  });

  test('重複選択肢でも個数が保たれる', () {
    for (var s = 0; s < 30; s++) {
      final r = withShuffledChoices(_q(['x', 'x', 'y', 'z'], 'x'), Random(s));
      expect(r.choices.where((c) => c == 'x').length, 2);
    }
  });

  test('All of the above は末尾固定', () {
    for (var s = 0; s < 30; s++) {
      final r = withShuffledChoices(
          _q(['a', 'b', 'c', 'All of the above'], 'All of the above'), Random(s));
      expect(r.choices.last, 'All of the above');
    }
  });

  test('選択肢なし(発話)はそのまま', () {
    final q = _q(const [], 'hello');
    expect(identical(withShuffledChoices(q), q), isTrue);
  });
}
