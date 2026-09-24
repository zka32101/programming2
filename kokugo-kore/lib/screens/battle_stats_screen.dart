import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/battle_stats_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';

class BattleStatsScreen extends ConsumerWidget {
  const BattleStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(battleStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦統計'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('統計を取得できませんでした: $err')),
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatCard('総対戦数', '${stats.totalBattles}', Colors.blue),
              const SizedBox(height: 12),
              _buildStatCard('勝利数', '${stats.wins}', Colors.green),
              const SizedBox(height: 12),
              _buildStatCard('敗北数', '${stats.losses}', Colors.red),
              const SizedBox(height: 24),
              const Text(
                '統計情報',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('勝率', '${stats.winRate.toStringAsFixed(1)}%'),
              _buildDetailRow('平均スコア', '${stats.averageScore.toStringAsFixed(1)}点'),
              _buildDetailRow('最高スコア', '${stats.highestScore}点'),
              _buildDetailRow('最低スコア', '${stats.lowestScore}点'),
              const SizedBox(height: 24),
              const Text(
                '最近の対戦',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (stats.recentBattles.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'まだ対戦記録がありません',
                    style: TextStyle(color: kTextMuted),
                  ),
                )
              else
                ...stats.recentBattles.map((battle) {
                  final userId = ref.read(profileProvider).currentProfile?.id;
                  final myScore = battle.player1Id == userId ? battle.player1Score : battle.player2Score;
                  final isWin = battle.winnerId.isNotEmpty && battle.winnerId == userId;
                  return _buildBattleRecord(
                    isWin ? '勝ち' : '負け',
                    '$myScore点',
                    _relativeTime(battle.completedDate),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color.withAlpha(100)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: kTextMuted)),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: kTextMuted)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBattleRecord(String result, String score, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(time, style: const TextStyle(fontSize: 11, color: kTextMuted)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: result == '勝ち' ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              result,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: result == '勝ち' ? Colors.green : Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(score, style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
        ],
      ),
    );
  }

  String _relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}分前';
    if (diff.inHours < 24) return '${diff.inHours}時間前';
    return '${diff.inDays}日前';
  }
}
