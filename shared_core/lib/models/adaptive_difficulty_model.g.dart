// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adaptive_difficulty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdaptiveDifficultyImpl _$$AdaptiveDifficultyImplFromJson(
        Map<String, dynamic> json) =>
    _$AdaptiveDifficultyImpl(
      userId: json['userId'] as String,
      subject: json['subject'] as String,
      currentLevel: json['currentLevel'] as String? ?? 'intermediate',
      performanceScore: (json['performanceScore'] as num?)?.toDouble() ?? 0.0,
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      correctRate: (json['correctRate'] as num?)?.toDouble() ?? 0.0,
      recommendedTopics: (json['recommendedTopics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$AdaptiveDifficultyImplToJson(
        _$AdaptiveDifficultyImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'subject': instance.subject,
      'currentLevel': instance.currentLevel,
      'performanceScore': instance.performanceScore,
      'correctCount': instance.correctCount,
      'totalCount': instance.totalCount,
      'correctRate': instance.correctRate,
      'recommendedTopics': instance.recommendedTopics,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
