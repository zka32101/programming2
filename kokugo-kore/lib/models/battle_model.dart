import 'package:freezed_annotation/freezed_annotation.dart';

part 'battle_model.freezed.dart';

part 'battle_model.g.dart';

@freezed
class Battle with _$Battle {
  const factory Battle({
    required String battleId,
    required String player1Id,
    required String player2Id,
    required String? player1Name,
    required String? player2Name,
    required int? player1ImageUrl,
    required int? player2ImageUrl,
    required DateTime createdDate,
    required DateTime? startedDate,
    required DateTime? endedDate,
    required String status, // waiting, active, completed
    required int currentRound, // 1-5
    required String? winnerId,
  }) = _Battle;

  factory Battle.fromJson(Map<String, dynamic> json) => _$BattleFromJson(json);
}

@freezed
class BattleRound with _$BattleRound {
  const factory BattleRound({
    required String battleId,
    required int roundNumber,
    required String questionId,
    required String questionText,
    required List<String> choices,
    required String? correctAnswer,
    required String? player1Answer,
    required String? player2Answer,
    required int? player1ResponseTime, // ミリ秒
    required int? player2ResponseTime,
    required bool? player1Correct,
    required bool? player2Correct,
  }) = _BattleRound;

  factory BattleRound.fromJson(Map<String, dynamic> json) =>
      _$BattleRoundFromJson(json);
}

@freezed
class BattleResult with _$BattleResult {
  const factory BattleResult({
    required String battleId,
    required String player1Id,
    required String player2Id,
    required int player1Score,
    required int player2Score,
    required String winnerId,
    required DateTime completedDate,
    required List<BattleRound> rounds,
    required int totalDurationSeconds,
  }) = _BattleResult;

  factory BattleResult.fromJson(Map<String, dynamic> json) =>
      _$BattleResultFromJson(json);
}

@freezed
class BattlePlayer with _$BattlePlayer {
  const factory BattlePlayer({
    required String playerId,
    required String displayName,
    required String profileImageUrl,
    required int grade,
    required double totalBattlesPlayed,
    required double totalWins,
    required double winRate,
    required double averageScore,
  }) = _BattlePlayer;

  factory BattlePlayer.fromJson(Map<String, dynamic> json) =>
      _$BattlePlayerFromJson(json);
}
