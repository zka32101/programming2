// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GlobalRankingImpl _$$GlobalRankingImplFromJson(Map<String, dynamic> json) =>
    _$GlobalRankingImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      rank: (json['rank'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      correctCount: (json['correctCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      correctRate: (json['correctRate'] as num?)?.toDouble() ?? 0.0,
      subject: json['subject'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      grade: json['grade'] as String? ?? '',
    );

Map<String, dynamic> _$$GlobalRankingImplToJson(_$GlobalRankingImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'rank': instance.rank,
      'score': instance.score,
      'correctCount': instance.correctCount,
      'totalCount': instance.totalCount,
      'correctRate': instance.correctRate,
      'subject': instance.subject,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'avatarUrl': instance.avatarUrl,
      'grade': instance.grade,
    };
