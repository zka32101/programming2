import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/data/stage_data.dart';
import 'package:eigo_kore/models/question.dart';

void main() {
  final writing = [
    for (final s in allStages)
      for (final q in s.questions)
        if (q.type == QuestionType.writing) q,
  ];

  test('ライティング問題が存在する', () {
    expect(writing, isNotEmpty);
  });

  test('ライティング問題の問題文(text/textJa)に答えの英語が出ていない', () {
    final leaks = <String>[];
    for (final q in writing) {
      final ans = q.correctAnswer.toLowerCase();
      if (q.text.toLowerCase().contains(ans) ||
          q.textJa.toLowerCase().contains(ans)) {
        leaks.add('${q.id}: ${q.text} / ${q.textJa} -> ${q.correctAnswer}');
      }
    }
    expect(leaks, isEmpty, reason: leaks.join('\n'));
  });

  test('ライティング問題は正解が選択肢に含まれる', () {
    for (final q in writing) {
      expect(q.choices, contains(q.correctAnswer), reason: q.id);
    }
  });
}
