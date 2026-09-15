import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';

class MultiplayerMenuScreen extends ConsumerStatefulWidget {
  const MultiplayerMenuScreen({super.key});

  @override
  ConsumerState<MultiplayerMenuScreen> createState() => _MultiplayerMenuScreenState();
}

class _MultiplayerMenuScreenState extends ConsumerState<MultiplayerMenuScreen> {
  @override
  Widget build(BuildContext context) {
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
            _buildQuickStats(),
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
            _buildRecentBattles(),
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🏆 ランキング1位まであと42ポイント',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// クイック統計
  Widget _buildQuickStats() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard('対戦数', '24', Icons.sports_score),
        _buildStatCard('勝利数', '18', Icons.emoji_events),
        _buildStatCard('勝率', '75%', Icons.trending_up),
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
          '⚔️ レートマッチ',
          'レートが近い相手と実際にオンライン対戦',
          Colors.teal,
          () => Navigator.pushNamed(context, '/multiplayer/rated-match'),
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
          '🏆 対戦レートランキング',
          'レートマッチの順位を確認',
          Colors.orange,
          () => Navigator.pushNamed(context, '/multiplayer/leaderboard'),
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
  Widget _buildRecentBattles() {
    final recentBattles = [
      ('太郎', '勝ち', '95点', '2時間前'),
      ('花子', '負け', '78点', '5時間前'),
      ('次郎', '勝ち', '88点', '1日前'),
      ('三郎', '勝ち', '92点', '3日前'),
    ];

    return Column(
      children: recentBattles
          .map(
            (battle) => Padding(
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
                    // アバター
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            battle.$1,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            battle.$4,
                            style: const TextStyle(
                              fontSize: 11,
                              color: kTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: battle.$2 == '勝ち' ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        battle.$2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: battle.$2 == '勝ち' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      battle.$3,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
