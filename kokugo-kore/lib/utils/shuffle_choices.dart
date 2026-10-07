import 'dart:math';

import '../models/quest_model.dart';

/// 「上のすべて」「どれでもない」など、位置が意味を持つ選択肢か。
bool isPinnedChoice(String s) {
  final t = s.replaceAll(RegExp(r'[\s　。．.]'), '');
  return RegExp(
    r'(どれでもない|いずれでもない|どれもちがう|どれも正しくない|'
    r'(上|以上)の(すべて|全て|どれも|いずれも)|'
    r'(すべて|全て)(正しい|あてはまる|当てはまる|同じ|ちがう|違う))',
  ).hasMatch(t);
}

/// 0..n-1 の並べ替え順(order[新しい位置] = 元の位置)。位置が固定の選択肢は末尾に残す。
List<int> shuffledOrder(List<String> choices, [Random? rng]) {
  final free = <int>[];
  final pinned = <int>[];
  for (var i = 0; i < choices.length; i++) {
    (isPinnedChoice(choices[i]) ? pinned : free).add(i);
  }
  free.shuffle(rng ?? Random());
  return [...free, ...pinned];
}

/// 文言キーで正誤判定する問題用。選択肢だけシャッフルして返す。
List<String> shuffledChoices(List<String> choices, [Random? rng]) {
  final order = shuffledOrder(choices, rng);
  return [for (final i in order) choices[i]];
}

/// 選択肢をシャッフルし、正解インデックスを付け替えた問題を返す。
/// 重複した文言があっても、インデックスで追跡するので正解がずれない。
QuizQuestion withShuffledChoices(QuizQuestion q, [Random? rng]) {
  if (q.choices.length < 2 || q.correctIndex < 0 || q.correctIndex >= q.choices.length) {
    return q;
  }
  final order = shuffledOrder(q.choices, rng);
  return QuizQuestion(
    id: q.id,
    type: q.type,
    grade: q.grade,
    question: q.question,
    context: q.context,
    choices: [for (final i in order) q.choices[i]],
    correctIndex: order.indexOf(q.correctIndex),
    explanation: q.explanation,
    highlightChar: q.highlightChar,
  );
}

List<Stage> withShuffledStages(List<Stage> stages, [Random? rng]) => [
      for (final s in stages)
        Stage(
          stageNumber: s.stageNumber,
          title: s.title,
          grade: s.grade,
          quizType: s.quizType,
          questions: [for (final q in s.questions) withShuffledChoices(q, rng)],
        ),
    ];
