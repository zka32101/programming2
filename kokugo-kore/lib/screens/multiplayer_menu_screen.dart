import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/battle_stats_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';

class MultiplayerMenuScreen extends ConsumerStatefulWidget {
  const MultiplayerMenuScreen({super.key});

  @override
  ConsumerState<MultiplayerMenuScreen> createState() => _MultiplayerMenuScreenState();
}

class _MultiplayerMenuScreenState extends ConsumerState<MultiplayerMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(battleStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('マルチプレイ'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヒーローセクション
            _buildHeroSection(),
            const SizedBox(height: 24),

            // クイック統計
            _buildQuickStats(statsAsync),
            const SizedBox(height: 24),

            // メニューオプション
            const Text(
              'プレイモード',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildMenuOptions(),
            const SizedBox(height: 24),

            // 最近の対戦
            const Text(
              '最近の対戦',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRecentBattles(statsAsync),
          ],
        ),
      ),
    );
  }

  /// ヒーローセクション
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚔️ マルチプレイバトル',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '友人と対戦して、スコアを競おう！',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// クイック統計
  Widget _buildQuickStats(AsyncValue<BattleStats> statsAsync) {
    final stats = statsAsync.valueOrNull ?? const BattleStats();

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard('対戦数', '${stats.totalBattles}', Icons.sports_score),
        _buildStatCard('勝利数', '${stats.wins}', Icons.emoji_events),
        _buildStatCard('勝率', '${stats.winRate.toStringAsFixed(0)}%', Icons.trending_up),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: kPrimaryColor, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: kTextMuted),
          ),
        ],
      ),
    );
  }

  /// メニューオプション
  Widget _buildMenuOptions() {
    return Column(
      children: [
        _buildMenuButton(
          '👥 友人と対戦',
          '登録済みの友人を選んで対戦します',
          Colors.blue,
          () => Navigator.pushNamed(context, '/friend-invitation'),
        ),
        const SizedBox(height: 12),
        _buildMenuButton(
          '🎲 ランダムマッチ（練習）',
          'AI練習相手とオフラインで練習',
          Colors.purple,
          () {
            Navigator.pushNamed(context, '/random-match');
          },
        ),
        const SizedBox(height: 12),
        _buildMenuButton(
          '🏅 ランキング',
          'グローバルランキングを確認',
          Colors.orange,
          () => Navigator.pushNamed(context, '/ranking'),
        ),
        const SizedBox(height: 12),
        _buildMenuButton(
          '📊 統計',
          'あなたの対戦統計を表示',
          Colors.green,
          () {
            Navigator.pushNamed(context, '/battle-stats');
          },
        ),
      ],
    );
  }

  Widget _buildMenuButton(
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(title[0], style: TextStyle(fontSize: 24, color: color)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: kTextMuted),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  /// 最近の対戦
  Widget _buildRecentBattles(AsyncValue<BattleStats> statsAsync) {
    return statsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Text('対戦履歴を取得できませんでした: $err', style: const TextStyle(color: kTextMuted)),
      data: (stats) {
        if (stats.recentBattles.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.sports_score, size: 36, color: kTextMuted),
                SizedBox(height: 8),
                Text(
                  'まだ対戦記録がありません',
                  style: TextStyle(fontWeight: FontWeight.bold, color: kTextMuted),
                ),
                SizedBox(height: 4),
                Text(
                  '友人と対戦するとここに記録が表示されます',
                  style: TextStyle(fontSize: 12, color: kTextMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final userId = ref.read(profileProvider).currentProfile?.id;

        return Column(
          children: stats.recentBattles.map((battle) {
            final isWin = battle.winnerId.isNotEmpty && battle.winnerId == userId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('😊', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _relativeTime(battle.completedDate),
                        style: const TextStyle(fontSize: 11, color: kTextMuted),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isWin ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isWin ? '勝ち' : '負け',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isWin ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}分前';
    if (diff.inHours < 24) return '${diff.inHours}時間前';
    return '${diff.inDays}日前';
  }
}
