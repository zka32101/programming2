import '../models/question.dart';

/// リスニング問題だけの正答率(0.0〜1.0)。
/// 分子はリスニング問題の正解数のみ(全タイプの正解数を使うと100%を超える)。
double listeningAccuracyOf(
  List<Question> questions,
  List<({String id, QuestionType type, bool correct, int speakingScore})> log,
) {
  final ids = questions
      .where((q) => q.type == QuestionType.listening)
      .map((q) => q.id)
      .toSet();
  if (ids.isEmpty) return 0.0;
  final correctIds = log
      .where((r) => r.type == QuestionType.listening && r.correct && ids.contains(r.id))
      .map((r) => r.id)
      .toSet();
  return (correctIds.length / ids.length).clamp(0.0, 1.0);
}
