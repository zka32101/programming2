import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/badge_progress_model.dart';
import '../providers/badge_progress_provider.dart';
import '../theme/app_theme.dart';

/// バッジ進捗追跡ウィジェット（ホーム画面用）
/// あと少しで獲得できるバッジを表示
class BadgeProgressTracker extends ConsumerWidget {
  final VoidCallback? onViewMore;

  const BadgeProgressTracker({super.key, this.onViewMore});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyCenters = ref.watch(nearbyCenterBadgesProvider);

    if (nearbyCenters.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Column(
            children: [
              const Text(
                '🎯 あと少しのバッジはありません',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kTextMuted,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'もっと学習してバッジに近づきましょう！',
                style: TextStyle(
                  fontSize: 12,
                  color: kTextMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトル
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🎯 あと少しのバッジ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (nearbyCenters.length > 3)
                GestureDetector(
                  onTap: onViewMore,
                  child: const Text(
                    'もっと見る',
                    style: TextStyle(
                      fontSize: 12,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // バッジリスト
          ...nearbyCenters.take(3).map((progress) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildProgressItem(progress),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProgressItem(BadgeProgress progress) {
    final progressPercent = (progress.progressPercent * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // バッジ名と進捗率
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.badgeId,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      progress.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: kTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getProgressColor(progress.progressPercent).withAlpha(100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$progressPercent%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getProgressColor(progress.progressPercent),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // プログレスバー
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.progressPercent,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(progress.progressPercent),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // 進捗テキスト
          Text(
            progress.progressText,
            style: const TextStyle(
              fontSize: 10,
              color: kTextMuted,
            ),
          ),

          // 予測解除日（利用可能な場合）
          if (progress.estimatedUnlockDate != null) ...[
            const SizedBox(height: 4),
            Text(
              '予測解除日: ${progress.estimatedUnlockDate!.year}/${progress.estimatedUnlockDate!.month}/${progress.estimatedUnlockDate!.day}',
              style: const TextStyle(
                fontSize: 9,
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.9) return Colors.green;
    if (progress >= 0.7) return Colors.orange;
    return Colors.blue;
  }
}
