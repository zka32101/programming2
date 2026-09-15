import 'package:flutter/material.dart';
import 'package:shared_core/models/badge_model.dart';

import '../theme/app_theme.dart';

class BadgeWidget extends StatelessWidget {
  final EarnedBadge earnedBadge;

  const BadgeWidget({super.key, required this.earnedBadge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimaryColor.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BadgeIconImage(badgeId: earnedBadge.badge.id, fallbackEmoji: earnedBadge.badge.emoji),
          const SizedBox(height: 6),
          Text(
            earnedBadge.badge.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class LockedBadgeWidget extends StatelessWidget {
  final BadgeModel badge;
  const LockedBadgeWidget({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 0.4, 0,
              ]),
              child: _BadgeIconImage(badgeId: badge.id, fallbackEmoji: badge.emoji, isLocked: true),
            ),
            const SizedBox(height: 6),
            Text(
              badge.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            const Icon(Icons.lock, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// バッジアイコン画像表示ヘルパー（画像 or 絵文字フォールバック）
class _BadgeIconImage extends StatelessWidget {
  final String badgeId;
  final String fallbackEmoji;
  final bool isLocked;

  const _BadgeIconImage({
    required this.badgeId,
    required this.fallbackEmoji,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = 'packages/shared_core/assets/badge_icons/badge_$badgeId.jpg';

    return SizedBox(
      width: 64,
      height: 64,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // 画像が見つからない場合は絵文字で代替
          return Center(
            child: Text(
              fallbackEmoji,
              style: const TextStyle(fontSize: 40),
            ),
          );
        },
      ),
    );
  }
}
