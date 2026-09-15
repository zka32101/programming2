// QuizType は各アプリで意味を割り当てる
// 例: 国語 → primary=漢字, secondary=読解 / 算数 → primary=計算, secondary=文章題
enum QuizType { primary, secondary }

class QuizQuestion {
  final String id;
  final QuizType type;
  final int grade;
  final String question;
  final String? context;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final String? highlightChar;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.grade,
    required this.question,
    this.context,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    this.highlightChar,
  });
}

class Stage {
  final int stageNumber;
  final String title;
  final int grade;
  final QuizType quizType;
  final List<QuizQuestion> questions;

  const Stage({
    required this.stageNumber,
    required this.title,
    required this.grade,
    required this.quizType,
    required this.questions,
  });

  int get totalQuestions => questions.length;
}

class QuestResult {
  final int correctCount;
  final int totalCount;
  final Duration elapsed;

  const QuestResult({
    required this.correctCount,
    required this.totalCount,
    required this.elapsed,
  });

  int get score => (correctCount / totalCount * 100).round();
  bool get isPerfect => correctCount == totalCount;
  bool get isPassed => correctCount >= (totalCount * 0.6).ceil();
}
