// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BattleImpl _$$BattleImplFromJson(Map<String, dynamic> json) => _$BattleImpl(
  battleId: json['battleId'] as String,
  player1Id: json['player1Id'] as String,
  player2Id: json['player2Id'] as String,
  player1Name: json['player1Name'] as String?,
  player2Name: json['player2Name'] as String?,
  player1ImageUrl: (json['player1ImageUrl'] as num?)?.toInt(),
  player2ImageUrl: (json['player2ImageUrl'] as num?)?.toInt(),
  createdDate: DateTime.parse(json['createdDate'] as String),
  startedDate: json['startedDate'] == null
      ? null
      : DateTime.parse(json['startedDate'] as String),
  endedDate: json['endedDate'] == null
      ? null
      : DateTime.parse(json['endedDate'] as String),
  status: json['status'] as String,
  currentRound: (json['currentRound'] as num).toInt(),
  winnerId: json['winnerId'] as String?,
);

Map<String, dynamic> _$$BattleImplToJson(_$BattleImpl instance) =>
    <String, dynamic>{
      'battleId': instance.battleId,
      'player1Id': instance.player1Id,
      'player2Id': instance.player2Id,
      'player1Name': instance.player1Name,
      'player2Name': instance.player2Name,
      'player1ImageUrl': instance.player1ImageUrl,
      'player2ImageUrl': instance.player2ImageUrl,
      'createdDate': instance.createdDate.toIso8601String(),
      'startedDate': instance.startedDate?.toIso8601String(),
      'endedDate': instance.endedDate?.toIso8601String(),
      'status': instance.status,
      'currentRound': instance.currentRound,
      'winnerId': instance.winnerId,
    };

_$BattleRoundImpl _$$BattleRoundImplFromJson(Map<String, dynamic> json) =>
    _$BattleRoundImpl(
      battleId: json['battleId'] as String,
      roundNumber: (json['roundNumber'] as num).toInt(),
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswer: json['correctAnswer'] as String?,
      player1Answer: json['player1Answer'] as String?,
      player2Answer: json['player2Answer'] as String?,
      player1ResponseTime: (json['player1ResponseTime'] as num?)?.toInt(),
      player2ResponseTime: (json['player2ResponseTime'] as num?)?.toInt(),
      player1Correct: json['player1Correct'] as bool?,
      player2Correct: json['player2Correct'] as bool?,
    );

Map<String, dynamic> _$$BattleRoundImplToJson(_$BattleRoundImpl instance) =>
    <String, dynamic>{
      'battleId': instance.battleId,
      'roundNumber': instance.roundNumber,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'choices': instance.choices,
      'correctAnswer': instance.correctAnswer,
      'player1Answer': instance.player1Answer,
      'player2Answer': instance.player2Answer,
      'player1ResponseTime': instance.player1ResponseTime,
      'player2ResponseTime': instance.player2ResponseTime,
      'player1Correct': instance.player1Correct,
      'player2Correct': instance.player2Correct,
    };

_$BattleResultImpl _$$BattleResultImplFromJson(Map<String, dynamic> json) =>
    _$BattleResultImpl(
      battleId: json['battleId'] as String,
      player1Id: json['player1Id'] as String,
      player2Id: json['player2Id'] as String,
      player1Score: (json['player1Score'] as num).toInt(),
      player2Score: (json['player2Score'] as num).toInt(),
      winnerId: json['winnerId'] as String,
      completedDate: DateTime.parse(json['completedDate'] as String),
      rounds: (json['rounds'] as List<dynamic>)
          .map((e) => BattleRound.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDurationSeconds: (json['totalDurationSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$$BattleResultImplToJson(_$BattleResultImpl instance) =>
    <String, dynamic>{
      'battleId': instance.battleId,
      'player1Id': instance.player1Id,
      'player2Id': instance.player2Id,
      'player1Score': instance.player1Score,
      'player2Score': instance.player2Score,
      'winnerId': instance.winnerId,
      'completedDate': instance.completedDate.toIso8601String(),
      'rounds': instance.rounds,
      'totalDurationSeconds': instance.totalDurationSeconds,
    };

_$BattlePlayerImpl _$$BattlePlayerImplFromJson(Map<String, dynamic> json) =>
    _$BattlePlayerImpl(
      playerId: json['playerId'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      grade: (json['grade'] as num).toInt(),
      totalBattlesPlayed: (json['totalBattlesPlayed'] as num).toDouble(),
      totalWins: (json['totalWins'] as num).toDouble(),
      winRate: (json['winRate'] as num).toDouble(),
      averageScore: (json['averageScore'] as num).toDouble(),
    );

Map<String, dynamic> _$$BattlePlayerImplToJson(_$BattlePlayerImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'grade': instance.grade,
      'totalBattlesPlayed': instance.totalBattlesPlayed,
      'totalWins': instance.totalWins,
      'winRate': instance.winRate,
      'averageScore': instance.averageScore,
    };
