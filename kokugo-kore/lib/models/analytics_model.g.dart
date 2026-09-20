// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyStatsImpl _$$DailyStatsImplFromJson(Map<String, dynamic> json) =>
    _$DailyStatsImpl(
      date: json['date'] as String,
      questsCompleted: (json['questsCompleted'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      totalAnswers: (json['totalAnswers'] as num).toInt(),
      coinsEarned: (json['coinsEarned'] as num).toInt(),
      studyMinutes: (json['studyMinutes'] as num).toInt(),
      categoryStats: json['categoryStats'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$DailyStatsImplToJson(_$DailyStatsImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'questsCompleted': instance.questsCompleted,
      'correctAnswers': instance.correctAnswers,
      'totalAnswers': instance.totalAnswers,
      'coinsEarned': instance.coinsEarned,
      'studyMinutes': instance.studyMinutes,
      'categoryStats': instance.categoryStats,
    };

_$WeeklyStatsImpl _$$WeeklyStatsImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyStatsImpl(
      weekStart: json['weekStart'] as String,
      totalStudyMinutes: (json['totalStudyMinutes'] as num).toInt(),
      totalQuestsCompleted: (json['totalQuestsCompleted'] as num).toInt(),
      averageAccuracy: (json['averageAccuracy'] as num).toDouble(),
      dailyCounts: Map<String, int>.from(json['dailyCounts'] as Map),
    );

Map<String, dynamic> _$$WeeklyStatsImplToJson(_$WeeklyStatsImpl instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart,
      'totalStudyMinutes': instance.totalStudyMinutes,
      'totalQuestsCompleted': instance.totalQuestsCompleted,
      'averageAccuracy': instance.averageAccuracy,
      'dailyCounts': instance.dailyCounts,
    };

_$MonthlyStatsImpl _$$MonthlyStatsImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyStatsImpl(
      month: json['month'] as String,
      totalQuestsCompleted: (json['totalQuestsCompleted'] as num).toInt(),
      totalCorrectAnswers: (json['totalCorrectAnswers'] as num).toInt(),
      totalAnswers: (json['totalAnswers'] as num).toInt(),
      accuracyRate: (json['accuracyRate'] as num).toDouble(),
      totalStudyMinutes: (json['totalStudyMinutes'] as num).toInt(),
      totalCoinsEarned: (json['totalCoinsEarned'] as num).toInt(),
      studyDaysCount: (json['studyDaysCount'] as num).toInt(),
      categoryStats: json['categoryStats'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$MonthlyStatsImplToJson(_$MonthlyStatsImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'totalQuestsCompleted': instance.totalQuestsCompleted,
      'totalCorrectAnswers': instance.totalCorrectAnswers,
      'totalAnswers': instance.totalAnswers,
      'accuracyRate': instance.accuracyRate,
      'totalStudyMinutes': instance.totalStudyMinutes,
      'totalCoinsEarned': instance.totalCoinsEarned,
      'studyDaysCount': instance.studyDaysCount,
      'categoryStats': instance.categoryStats,
    };

_$ProgressAnalyticsImpl _$$ProgressAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$ProgressAnalyticsImpl(
  userId: json['userId'] as String,
  dailyHistory: (json['dailyHistory'] as List<dynamic>)
      .map((e) => DailyStats.fromJson(e as Map<String, dynamic>))
      .toList(),
  weeklyHistory: (json['weeklyHistory'] as List<dynamic>)
      .map((e) => WeeklyStats.fromJson(e as Map<String, dynamic>))
      .toList(),
  overallAccuracy: (json['overallAccuracy'] as num).toDouble(),
  totalQuestsCompleted: (json['totalQuestsCompleted'] as num).toInt(),
  totalCoinsEarned: (json['totalCoinsEarned'] as num).toInt(),
  categoryMastery: (json['categoryMastery'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, CategoryMastery.fromJson(e as Map<String, dynamic>)),
  ),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$ProgressAnalyticsImplToJson(
  _$ProgressAnalyticsImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'dailyHistory': instance.dailyHistory,
  'weeklyHistory': instance.weeklyHistory,
  'overallAccuracy': instance.overallAccuracy,
  'totalQuestsCompleted': instance.totalQuestsCompleted,
  'totalCoinsEarned': instance.totalCoinsEarned,
  'categoryMastery': instance.categoryMastery,
  'lastUpdated': instance.lastUpdated.toIso8601String(),
};

_$CategoryMasteryImpl _$$CategoryMasteryImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryMasteryImpl(
  categoryId: json['categoryId'] as String,
  categoryName: json['categoryName'] as String,
  correctCount: (json['correctCount'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  masteryLevel: (json['masteryLevel'] as num).toDouble(),
  lastPracticedDate: DateTime.parse(json['lastPracticedDate'] as String),
  recentScores: (json['recentScores'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$$CategoryMasteryImplToJson(
  _$CategoryMasteryImpl instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'correctCount': instance.correctCount,
  'totalCount': instance.totalCount,
  'masteryLevel': instance.masteryLevel,
  'lastPracticedDate': instance.lastPracticedDate.toIso8601String(),
  'recentScores': instance.recentScores,
};

_$LearningPaceDataImpl _$$LearningPaceDataImplFromJson(
  Map<String, dynamic> json,
) => _$LearningPaceDataImpl(
  userId: json['userId'] as String,
  recommendedQuestsPerDay: (json['recommendedQuestsPerDay'] as num).toInt(),
  averageQuestsPerDay: (json['averageQuestsPerDay'] as num).toInt(),
  inconsistencyDays: (json['inconsistencyDays'] as num).toInt(),
  studyConsistencyScore: (json['studyConsistencyScore'] as num).toDouble(),
  nextCheckDate: DateTime.parse(json['nextCheckDate'] as String),
);

Map<String, dynamic> _$$LearningPaceDataImplToJson(
  _$LearningPaceDataImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'recommendedQuestsPerDay': instance.recommendedQuestsPerDay,
  'averageQuestsPerDay': instance.averageQuestsPerDay,
  'inconsistencyDays': instance.inconsistencyDays,
  'studyConsistencyScore': instance.studyConsistencyScore,
  'nextCheckDate': instance.nextCheckDate.toIso8601String(),
};
