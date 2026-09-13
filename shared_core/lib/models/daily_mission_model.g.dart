// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyMissionImpl _$$DailyMissionImplFromJson(Map<String, dynamic> json) =>
    _$DailyMissionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      missionId: json['missionId'] as String,
      title: json['title'] as String,
      currentProgress: (json['currentProgress'] as num).toInt(),
      targetProgress: (json['targetProgress'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      date: DateTime.parse(json['date'] as String),
      rewardAmount: (json['rewardAmount'] as num).toInt(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$DailyMissionImplToJson(_$DailyMissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'missionId': instance.missionId,
      'title': instance.title,
      'currentProgress': instance.currentProgress,
      'targetProgress': instance.targetProgress,
      'isCompleted': instance.isCompleted,
      'date': instance.date.toIso8601String(),
      'rewardAmount': instance.rewardAmount,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
