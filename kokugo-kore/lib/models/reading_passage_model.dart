import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_passage_model.freezed.dart';

part 'reading_passage_model.g.dart';

@freezed
class ReadingPassage with _$ReadingPassage {
  const factory ReadingPassage({
    required String passageId,
    required String title,
    required String content,
    required String author,
    required int grade, // 1-6
    required String difficulty, // basic, standard, advanced
    required int estimatedReadingTimeSeconds,
    required String genre, // folk_tale, modern_fiction, essay, etc.
    required int wordCount,
    required List<String> vocabularyList,
  }) = _ReadingPassage;

  factory ReadingPassage.fromJson(Map<String, dynamic> json) =>
      _$ReadingPassageFromJson(json);
}

@freezed
class ComprehensionQuestion with _$ComprehensionQuestion {
  const factory ComprehensionQuestion({
    required String questionId,
    required String passageId,
    required String questionType, // summary, vocabulary, structure, expression
    required String questionText,
    required List<String> choices,
    required String correctAnswer,
    required String explanation,
    required int difficultyScore, // 1-10
  }) = _ComprehensionQuestion;

  factory ComprehensionQuestion.fromJson(Map<String, dynamic> json) =>
      _$ComprehensionQuestionFromJson(json);
}

@freezed
class ReadingSession with _$ReadingSession {
  const factory ReadingSession({
    required String sessionId,
    required String userId,
    required String passageId,
    required DateTime startedDate,
    required DateTime? completedDate,
    required int readingDurationSeconds,
    required List<String> answeredQuestionIds,
    required List<bool> answerCorrectness, // [true, false, true, ...]
    required double comprehensionScore, // 0.0 ~ 1.0
    required bool isCompleted,
  }) = _ReadingSession;

  factory ReadingSession.fromJson(Map<String, dynamic> json) =>
      _$ReadingSessionFromJson(json);
}

@freezed
class ReadingAnalytics with _$ReadingAnalytics {
  const factory ReadingAnalytics({
    required String userId,
    required int totalPassagesRead,
    required double averageComprehensionScore,
    required int totalReadingMinutes,
    required Map<String, int> difficultyDistribution, // {basic: 5, standard: 3, advanced: 1}
    required List<String> favoritedGenres,
    required DateTime lastReadingDate,
  }) = _ReadingAnalytics;

  factory ReadingAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ReadingAnalyticsFromJson(json);
}

@freezed
class SummaryQuestionSet with _$SummaryQuestionSet {
  const factory SummaryQuestionSet({
    required String setId,
    required String passageId,
    required List<String> summaryOptions, // 複数の要約候補
    required String correctSummary,
    required String explanation,
  }) = _SummaryQuestionSet;

  factory SummaryQuestionSet.fromJson(Map<String, dynamic> json) =>
      _$SummaryQuestionSetFromJson(json);
}

@freezed
class ExpressionQuestion with _$ExpressionQuestion {
  const factory ExpressionQuestion({
    required String questionId,
    required String passageId,
    required String phrase, // 本文中の表現
    required List<String> meaningOptions,
    required String correctMeaning,
    required String contextExplanation,
  }) = _ExpressionQuestion;

  factory ExpressionQuestion.fromJson(Map<String, dynamic> json) =>
      _$ExpressionQuestionFromJson(json);
}

@freezed
class TextStructureAnalysis with _$TextStructureAnalysis {
  const factory TextStructureAnalysis({
    required String analysisId,
    required String passageId,
    required List<String> paragraphs,
    required List<String> mainPoints,
    required String climax, // クライマックス部分
    required String resolution, // 解決部分
    required Map<String, String> characterDescriptions, // キャラクター説明
  }) = _TextStructureAnalysis;

  factory TextStructureAnalysis.fromJson(Map<String, dynamic> json) =>
      _$TextStructureAnalysisFromJson(json);
}
