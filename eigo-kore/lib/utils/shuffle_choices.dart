import 'dart:math';

import '../models/question.dart';

/// 「All of the above」「どれでもない」など、位置が意味を持つ選択肢か。
bool isPinnedChoice(String s) {
  final t = s.toLowerCase().replaceAll(RegExp(r'[\s　。．.]'), '');
  return RegExp(
    r'(allof(the)?above|noneof(the)?above|bothaandb|aandb|'
    r'どれでもない|いずれでもない|上のすべて|上のどれも|すべて正しい|すべてあてはまる)',
  ).hasMatch(t);
}

/// order[新しい位置] = 元の位置。位置が固定の選択肢は末尾に残す。
List<int> shuffledOrder(List<String> choices, [Random? rng]) {
  final free = <int>[];
  final pinned = <int>[];
  for (var i = 0; i < choices.length; i++) {
    (isPinnedChoice(choices[i]) ? pinned : free).add(i);
  }
  free.shuffle(rng ?? Random());
  return [...free, ...pinned];
}

/// 選択肢の並びだけをシャッフルして返す(正解は文言で判定する問題用)。
List<String> shuffledChoices(List<String> choices, [Random? rng]) {
  final order = shuffledOrder(choices, rng);
  return [for (final i in order) choices[i]];
}

/// 選択肢をシャッフルした問題を返す。eigo の Question は正解を文言
/// (correctAnswer)で持つので付け替えは不要。選択肢なし(発話など)はそのまま。
Question withShuffledChoices(Question q, [Random? rng]) {
  if (q.choices.length < 2) return q;
  return Question(
    id: q.id,
    type: q.type,
    difficulty: q.difficulty,
    text: q.text,
    textJa: q.textJa,
    imageEmoji: q.imageEmoji,
    choices: shuffledChoices(q.choices, rng),
    correctAnswer: q.correctAnswer,
    phonetic: q.phonetic,
    points: q.points,
  );
}
