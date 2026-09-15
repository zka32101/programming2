import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/battle_model.dart';
import '../services/firebase_realtime_db.dart';

final currentBattleProvider = StateNotifierProvider<BattleNotifier, Battle?>((ref) {
  return BattleNotifier();
});

final battleResultProvider = StateProvider<BattleResult?>((ref) => null);

class BattleNotifier extends StateNotifier<Battle?> {
  BattleNotifier() : super(null);

  /// Create a new battle with a friend
  Future<void> createBattle(
    String player1Id,
    String player1Name,
    String player2Id,
    String player2Name,
    {int? player1ImageUrl, int? player2ImageUrl}
  ) async {
    try {
      final battle = Battle(
        battleId: const Uuid().v4(),
        player1Id: player1Id,
        player2Id: player2Id,
        player1Name: player1Name,
        player2Name: player2Name,
        player1ImageUrl: player1ImageUrl,
        player2ImageUrl: player2ImageUrl,
        createdDate: DateTime.now(),
        startedDate: null,
        endedDate: null,
        status: 'waiting',
        currentRound: 1,
        winnerId: null,
      );

      await FirebaseRealtimeAPI.createBattle(battle);
      state = battle;
    } catch (e) {
      debugPrint('❌ Error creating battle: $e');
      rethrow;
    }
  }

  /// Start a battle
  Future<void> startBattle(String battleId) async {
    try {
      if (state == null) return;
      // Update battle status to active
      final updatedBattle = state!.copyWith(
        status: 'active',
        startedDate: DateTime.now(),
      );
      state = updatedBattle;
    } catch (e) {
      debugPrint('❌ Error starting battle: $e');
      rethrow;
    }
  }

  /// Record a battle round result
  Future<void> recordRoundResult(
    String battleId,
    int roundNumber,
    String player1Answer,
    String player2Answer,
    String correctAnswer,
    int player1ResponseTime,
    int player2ResponseTime,
  ) async {
    try {
      final player1Correct = player1Answer == correctAnswer;
      final player2Correct = player2Answer == correctAnswer;

      // Save round result to Firebase
      // Note: Rounds are typically saved as part of the final BattleResult
      // This method can be extended to save individual rounds for real-time updates
      debugPrint('✅ Round $roundNumber recorded: P1=${player1Correct ? '✓' : '✗'} P2=${player2Correct ? '✓' : '✗'}');
    } catch (e) {
      debugPrint('❌ Error recording round: $e');
      rethrow;
    }
  }

  /// Complete the battle and determine winner
  Future<BattleResult?> completeBattle(
    String battleId,
    int player1Score,
    int player2Score,
    {List<BattleRound> rounds = const []}
  ) async {
    try {
      if (state == null) return null;

      final winner = player1Score > player2Score ? state!.player1Id : state!.player2Id;

      final result = BattleResult(
        battleId: battleId,
        player1Id: state!.player1Id,
        player2Id: state!.player2Id,
        player1Score: player1Score,
        player2Score: player2Score,
        winnerId: winner,
        completedDate: DateTime.now(),
        rounds: rounds,
        totalDurationSeconds: DateTime.now().difference(state!.createdDate).inSeconds,
      );

      await FirebaseRealtimeAPI.saveBattleResult(result);

      state = state!.copyWith(
        status: 'completed',
        endedDate: DateTime.now(),
        winnerId: winner,
      );

      return result;
    } catch (e) {
      debugPrint('❌ Error completing battle: $e');
      rethrow;
    }
  }

  /// Get battle status stream
  Stream<Battle?> watchBattle(String battleId) {
    return FirebaseRealtimeAPI.getBattleStream(battleId);
  }

  /// Get battle history for a player
  Future<List<BattleResult>> getBattleHistory(String userId, {int limit = 20}) async {
    try {
      final history = await FirebaseRealtimeAPI.getBattleHistory(userId);
      return history.take(limit).toList();
    } catch (e) {
      debugPrint('❌ Error fetching battle history: $e');
      return [];
    }
  }

  /// Calculate win rate for a player
  Future<double> calculateWinRate(String userId) async {
    try {
      final history = await getBattleHistory(userId, limit: 100);
      if (history.isEmpty) return 0.0;

      final wins = history.where((result) => result.winnerId == userId).length;
      return (wins / history.length) * 100;
    } catch (e) {
      debugPrint('❌ Error calculating win rate: $e');
      return 0.0;
    }
  }

  /// Get average score in battles
  Future<int> getAverageScore(String userId) async {
    try {
      final history = await getBattleHistory(userId, limit: 50);
      if (history.isEmpty) return 0;

      int total = 0;
      for (final result in history) {
        if (result.player1Id == userId) {
          total += result.player1Score;
        } else {
          total += result.player2Score;
        }
      }
      return (total / history.length).toInt();
    } catch (e) {
      debugPrint('❌ Error calculating average score: $e');
      return 0;
    }
  }

  /// Get head-to-head record against a specific friend
  Future<Map<String, int>> getHeadToHead(String userId, String friendId) async {
    try {
      final history = await getBattleHistory(userId, limit: 100);

      int userWins = 0;
      int friendWins = 0;

      for (final result in history) {
        if ((result.player1Id == userId && result.player2Id == friendId) ||
            (result.player1Id == friendId && result.player2Id == userId)) {
          if (result.winnerId == userId) {
            userWins++;
          } else if (result.winnerId == friendId) {
            friendWins++;
          }
        }
      }

      return {'userWins': userWins, 'friendWins': friendWins};
    } catch (e) {
      debugPrint('❌ Error fetching head-to-head: $e');
      return {'userWins': 0, 'friendWins': 0};
    }
  }
}
