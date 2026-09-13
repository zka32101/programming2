// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retention_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RetentionMetricImpl _$$RetentionMetricImplFromJson(
        Map<String, dynamic> json) =>
    _$RetentionMetricImpl(
      userId: json['userId'] as String,
      lastActiveDate: DateTime.parse(json['lastActiveDate'] as String),
      daysSinceLastActive: (json['daysSinceLastActive'] as num).toInt(),
      totalLearningDays: (json['totalLearningDays'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      isAtRisk: json['isAtRisk'] as bool? ?? false,
      engagementScore: (json['engagementScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RetentionMetricImplToJson(
        _$RetentionMetricImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lastActiveDate': instance.lastActiveDate.toIso8601String(),
      'daysSinceLastActive': instance.daysSinceLastActive,
      'totalLearningDays': instance.totalLearningDays,
      'currentStreak': instance.currentStreak,
      'isAtRisk': instance.isAtRisk,
      'engagementScore': instance.engagementScore,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
