import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/data/quiz_data.dart';
import 'package:kokugo_kore/models/quest_model.dart';
import 'package:kokugo_kore/utils/shuffle_choices.dart';

QuizQuestion _q(List<String> c, int ci) => QuizQuestion(
      id: 'x',
      type: QuizType.primary,
      grade: 1,
      question: 'q',
      choices: c,
      correctIndex: ci,
      explanation: '',
    );

void main() {
  test('中身が保たれ正解が付け替わる', () {
    for (var s = 0; s < 50; s++) {
      final r = withShuffledChoices(_q(['a', 'b', 'c', 'd'], 1), Random(s));
      expect([...r.choices]..sort(), ['a', 'b', 'c', 'd']);
      expect(r.choices[r.correctIndex], 'b');
    }
  });

  test('正解位置がA〜Dに散る', () {
    final rng = Random(3);
    final seen = <int>{};
    for (var i = 0; i < 200; i++) {
      seen.add(withShuffledChoices(_q(['a', 'b', 'c', 'd'], 1), rng).correctIndex);
    }
    expect(seen, {0, 1, 2, 3});
  });

  test('重複選択肢でも正解の個数と位置を保つ', () {
    for (var s = 0; s < 50; s++) {
      final r = withShuffledChoices(_q(['x', 'x', 'y', 'z'], 1), Random(s));
      expect(r.choices.where((c) => c == 'x').length, 2);
      expect(r.choices[r.correctIndex], 'x');
    }
  });

  test('「上のすべて」は末尾固定', () {
    for (var s = 0; s < 50; s++) {
      final r = withShuffledChoices(_q(['a', 'b', 'c', '上のすべて'], 3), Random(s));
      expect(r.choices.last, '上のすべて');
      expect(r.correctIndex, 3);
    }
  });

  test('getStagesForGrade: 正解の文言が元データと一致し、位置が散る', () {
    final dist = List.filled(4, 0);
    for (var g = 1; g <= 6; g++) {
      for (final st in getStagesForGrade(g)) {
        for (final q in st.questions) {
          dist[q.correctIndex]++;
        }
      }
    }
    for (final d in dist) {
      expect(d, greaterThan(0));
    }
    expect(dist[1] / dist.reduce((a, b) => a + b), lessThan(0.4));
  });
}
