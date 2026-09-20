// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_passage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReadingPassageImpl _$$ReadingPassageImplFromJson(Map<String, dynamic> json) =>
    _$ReadingPassageImpl(
      passageId: json['passageId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      grade: (json['grade'] as num).toInt(),
      difficulty: json['difficulty'] as String,
      estimatedReadingTimeSeconds: (json['estimatedReadingTimeSeconds'] as num)
          .toInt(),
      genre: json['genre'] as String,
      wordCount: (json['wordCount'] as num).toInt(),
      vocabularyList: (json['vocabularyList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ReadingPassageImplToJson(
  _$ReadingPassageImpl instance,
) => <String, dynamic>{
  'passageId': instance.passageId,
  'title': instance.title,
  'content': instance.content,
  'author': instance.author,
  'grade': instance.grade,
  'difficulty': instance.difficulty,
  'estimatedReadingTimeSeconds': instance.estimatedReadingTimeSeconds,
  'genre': instance.genre,
  'wordCount': instance.wordCount,
  'vocabularyList': instance.vocabularyList,
};

_$ComprehensionQuestionImpl _$$ComprehensionQuestionImplFromJson(
  Map<String, dynamic> json,
) => _$ComprehensionQuestionImpl(
  questionId: json['questionId'] as String,
  passageId: json['passageId'] as String,
  questionType: json['questionType'] as String,
  questionText: json['questionText'] as String,
  choices: (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
  correctAnswer: json['correctAnswer'] as String,
  explanation: json['explanation'] as String,
  difficultyScore: (json['difficultyScore'] as num).toInt(),
);

Map<String, dynamic> _$$ComprehensionQuestionImplToJson(
  _$ComprehensionQuestionImpl instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'passageId': instance.passageId,
  'questionType': instance.questionType,
  'questionText': instance.questionText,
  'choices': instance.choices,
  'correctAnswer': instance.correctAnswer,
  'explanation': instance.explanation,
  'difficultyScore': instance.difficultyScore,
};

_$ReadingSessionImpl _$$ReadingSessionImplFromJson(Map<String, dynamic> json) =>
    _$ReadingSessionImpl(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      passageId: json['passageId'] as String,
      startedDate: DateTime.parse(json['startedDate'] as String),
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      readingDurationSeconds: (json['readingDurationSeconds'] as num).toInt(),
      answeredQuestionIds: (json['answeredQuestionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      answerCorrectness: (json['answerCorrectness'] as List<dynamic>)
          .map((e) => e as bool)
          .toList(),
      comprehensionScore: (json['comprehensionScore'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$$ReadingSessionImplToJson(
  _$ReadingSessionImpl instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'userId': instance.userId,
  'passageId': instance.passageId,
  'startedDate': instance.startedDate.toIso8601String(),
  'completedDate': instance.completedDate?.toIso8601String(),
  'readingDurationSeconds': instance.readingDurationSeconds,
  'answeredQuestionIds': instance.answeredQuestionIds,
  'answerCorrectness': instance.answerCorrectness,
  'comprehensionScore': instance.comprehensionScore,
  'isCompleted': instance.isCompleted,
};

_$ReadingAnalyticsImpl _$$ReadingAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$ReadingAnalyticsImpl(
  userId: json['userId'] as String,
  totalPassagesRead: (json['totalPassagesRead'] as num).toInt(),
  averageComprehensionScore: (json['averageComprehensionScore'] as num)
      .toDouble(),
  totalReadingMinutes: (json['totalReadingMinutes'] as num).toInt(),
  difficultyDistribution: Map<String, int>.from(
    json['difficultyDistribution'] as Map,
  ),
  favoritedGenres: (json['favoritedGenres'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastReadingDate: DateTime.parse(json['lastReadingDate'] as String),
);

Map<String, dynamic> _$$ReadingAnalyticsImplToJson(
  _$ReadingAnalyticsImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'totalPassagesRead': instance.totalPassagesRead,
  'averageComprehensionScore': instance.averageComprehensionScore,
  'totalReadingMinutes': instance.totalReadingMinutes,
  'difficultyDistribution': instance.difficultyDistribution,
  'favoritedGenres': instance.favoritedGenres,
  'lastReadingDate': instance.lastReadingDate.toIso8601String(),
};

_$SummaryQuestionSetImpl _$$SummaryQuestionSetImplFromJson(
  Map<String, dynamic> json,
) => _$SummaryQuestionSetImpl(
  setId: json['setId'] as String,
  passageId: json['passageId'] as String,
  summaryOptions: (json['summaryOptions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  correctSummary: json['correctSummary'] as String,
  explanation: json['explanation'] as String,
);

Map<String, dynamic> _$$SummaryQuestionSetImplToJson(
  _$SummaryQuestionSetImpl instance,
) => <String, dynamic>{
  'setId': instance.setId,
  'passageId': instance.passageId,
  'summaryOptions': instance.summaryOptions,
  'correctSummary': instance.correctSummary,
  'explanation': instance.explanation,
};

_$ExpressionQuestionImpl _$$ExpressionQuestionImplFromJson(
  Map<String, dynamic> json,
) => _$ExpressionQuestionImpl(
  questionId: json['questionId'] as String,
  passageId: json['passageId'] as String,
  phrase: json['phrase'] as String,
  meaningOptions: (json['meaningOptions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  correctMeaning: json['correctMeaning'] as String,
  contextExplanation: json['contextExplanation'] as String,
);

Map<String, dynamic> _$$ExpressionQuestionImplToJson(
  _$ExpressionQuestionImpl instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'passageId': instance.passageId,
  'phrase': instance.phrase,
  'meaningOptions': instance.meaningOptions,
  'correctMeaning': instance.correctMeaning,
  'contextExplanation': instance.contextExplanation,
};

_$TextStructureAnalysisImpl _$$TextStructureAnalysisImplFromJson(
  Map<String, dynamic> json,
) => _$TextStructureAnalysisImpl(
  analysisId: json['analysisId'] as String,
  passageId: json['passageId'] as String,
  paragraphs: (json['paragraphs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  mainPoints: (json['mainPoints'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  climax: json['climax'] as String,
  resolution: json['resolution'] as String,
  characterDescriptions: Map<String, String>.from(
    json['characterDescriptions'] as Map,
  ),
);

Map<String, dynamic> _$$TextStructureAnalysisImplToJson(
  _$TextStructureAnalysisImpl instance,
) => <String, dynamic>{
  'analysisId': instance.analysisId,
  'passageId': instance.passageId,
  'paragraphs': instance.paragraphs,
  'mainPoints': instance.mainPoints,
  'climax': instance.climax,
  'resolution': instance.resolution,
  'characterDescriptions': instance.characterDescriptions,
};
