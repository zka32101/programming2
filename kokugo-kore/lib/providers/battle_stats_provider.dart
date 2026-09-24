import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/battle_model.dart';
import '../services/firebase_realtime_db.dart';
import 'profile_provider.dart';

/// 対戦統計（実データ）。バトル履歴が存在しない場合はすべて0件のゼロ状態。
class BattleStats {
  final int totalBattles;
  final int wins;
  final int losses;
  final double averageScore;
  final int highestScore;
  final int lowestScore;
  final List<BattleResult> recentBattles;

  const BattleStats({
    this.totalBattles = 0,
    this.wins = 0,
    this.losses = 0,
    this.averageScore = 0,
    this.highestScore = 0,
    this.lowestScore = 0,
    this.recentBattles = const [],
  });

  double get winRate => totalBattles == 0 ? 0 : wins / totalBattles * 100;

  factory BattleStats.fromHistory(String userId, List<BattleResult> history) {
    if (history.isEmpty) return const BattleStats();

    final sorted = [...history]
      ..sort((a, b) => b.completedDate.compareTo(a.completedDate));

    int wins = 0;
    final scores = <int>[];
    for (final battle in sorted) {
      final myScore = battle.player1Id == userId ? battle.player1Score : battle.player2Score;
      scores.add(myScore);
      if (battle.winnerId == userId) wins++;
    }

    return BattleStats(
      totalBattles: sorted.length,
      wins: wins,
      losses: sorted.length - wins,
      averageScore: scores.reduce((a, b) => a + b) / scores.length,
      highestScore: scores.reduce((a, b) => a > b ? a : b),
      lowestScore: scores.reduce((a, b) => a < b ? a : b),
      recentBattles: sorted.take(10).toList(),
    );
  }
}

final battleStatsProvider = FutureProvider<BattleStats>((ref) async {
  final userId = ref.watch(profileProvider).currentProfile?.id;
  if (userId == null) return const BattleStats();

  final history = await FirebaseRealtimeAPI.getBattleHistory(userId);
  return BattleStats.fromHistory(userId, history);
});
