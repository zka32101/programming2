import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/badge_model.dart';
import '../providers/badge_provider.dart';

import '../models/badge_progress_model.dart';
import '../theme/app_theme.dart';

class BadgeStatsCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const BadgeStatsCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeState = ref.watch(badgeProvider);
    final earnedCount = badgeState.earnedBadges.length;
    // allBadges は badge_provider で管理されており、初期化されるまで空
    // 仮の総数として使用（将来的に shared_core から取得）
    final totalCount = 50; // 予想されるバッジの総数
    final progressingBadges = badgeState.getProgressingBadges();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimaryColor.withAlpha(220),
              kPrimaryColor.withAlpha(180),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
                const Text(
                  '🏅 バッジコレクション',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$earnedCount / $totalCount',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // プログレスバー
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: earnedCount / totalCount,
                minHeight: 6,
                backgroundColor: Colors.white.withAlpha(100),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // 獲得・進捗バッジ情報
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: '✅',
                  label: '取得済み',
                  value: earnedCount.toString(),
                ),
                _buildStatDivider(),
                _buildStatItem(
                  icon: '📈',
                  label: '進捗中',
                  value: progressingBadges.length.toString(),
                ),
                _buildStatDivider(),
                _buildStatItem(
                  icon: '🔒',
                  label: '未取得',
                  value: (totalCount - earnedCount).toString(),
                ),
              ],
            ),

            // 進捗バッジプレビュー
            if (progressingBadges.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'あと少しのバッジ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: progressingBadges.take(3).length,
                  itemBuilder: (context, index) {
                    final progress = progressingBadges[index];
                    return _buildProgressBadgePreview(progress);
                  },
                ),
              ),
            ],
          ],
        ),
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
        Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.white.withAlpha(150),
    );
  }

  Widget _buildProgressBadgePreview(BadgeProgress progress) {
    return Container(
      width: 56,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            progress.badgeId.split('_').first,
            style: const TextStyle(fontSize: 8, color: kTextMuted),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress.progressPercent * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
