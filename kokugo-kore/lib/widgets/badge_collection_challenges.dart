import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/badge_model.dart';
import '../models/badge_challenge_model.dart';

import '../models/badge_progress_model.dart';
import '../providers/badge_provider.dart';
import '../theme/app_theme.dart';

/// バッジコレクションチャレンジ表示ウィジェット
class BadgeCollectionChallenges extends ConsumerWidget {
  const BadgeCollectionChallenges({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeState = ref.watch(badgeProvider);
    final earnedIds = badgeState.earnedBadges.map((e) => e.badge.id).toSet();

    final activeChallenges = BadgeChallengeManager.getActiveChallenges();
    if (activeChallenges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 バッジチャレンジ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...activeChallenges.map((challenge) {
            final progress = challenge.getProgressPercent(earnedIds);
            final isCompleted = challenge.isCompleted(earnedIds);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildChallengeCard(
                challenge: challenge,
                progress: progress,
                isCompleted: isCompleted,
                earnedBadgeCount: earnedIds.length,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChallengeCard({
    required BadgeChallenge challenge,
    required double progress,
    required bool isCompleted,
    required int earnedBadgeCount,
  }) {
    final progressPercent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCompleted
              ? [Colors.green.shade400, Colors.green.shade600]
              : [Colors.blue.shade100, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.blue.shade300,
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.emoji + ' ' + challenge.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: isCompleted ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // 報酬
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '💰',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      challenge.rewardCoins.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // プログレスバーと進捗テキスト
          if (!isCompleted) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor:
                          Colors.white.withAlpha(150),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$progressPercent%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(200),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '✅ チャレンジ完了！',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 期間限定バッジ
          if (challenge.isLimitedTime) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  '期間限定: ${challenge.expiresAt!.month}月${challenge.expiresAt!.day}日まで',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// バッジコレクション統計パネル
class BadgeCollectionStats extends ConsumerWidget {
  const BadgeCollectionStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeState = ref.watch(badgeProvider);
    final earnedIds = badgeState.earnedBadges.map((e) => e.badge.id).toSet();

    // allBadges は badge_provider で管理（初期化時に設定）
    // 仮の総数を使用（将来的に shared_core から動的に取得）
    final totalBadgeCount = 50;
    final status = BadgeChallengeManager.getCollectionStatus(
      totalBadgeCount,
      earnedIds,
      badgeState.rarities,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトル
          const Text(
            '📊 コレクション統計',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // 全体進捗
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'コレクション進捗',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                '${status.completionPercentage}% (${status.earnedBadges}/${status.totalBadges})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: status.completionPercent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                status.isFullyCompleted ? Colors.green : kPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // チャレンジ完了数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: '🎯',
                label: 'チャレンジ完了',
                value: status.completedChallenges.length.toString(),
              ),
              _buildStatDivider(),
              _buildStatItem(
                icon: '📈',
                label: 'チャレンジ進捗中',
                value: status.inProgressChallenges.length.toString(),
              ),
            ],
          ),

          // レアリティ別内訳
          if (status.rarityBreakdown.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'レアリティ別',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: status.rarityBreakdown.entries.map((entry) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRarityColor(entry.key).withAlpha(100),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${entry.key.label} ${entry.value}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getRarityColor(entry.key),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey.shade300,
    );
  }

  Color _getRarityColor(BadgeRarity rarity) {
    return switch (rarity) {
      BadgeRarity.common => Colors.grey,
      BadgeRarity.rare => Colors.purple,
      BadgeRarity.epic => Colors.orange,
      BadgeRarity.legendary => Colors.amber,
      BadgeRarity.secret => Colors.black54,
    };
  }
}
