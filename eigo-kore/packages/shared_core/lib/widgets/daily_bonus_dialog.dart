import 'package:flutter/material.dart';
import '../theme/app_theme_base.dart';

class DailyBonusDialog extends StatelessWidget {
  final int streak;
  final int bonusCoins;
  final Color primaryColor;
  final VoidCallback onClaim;

  const DailyBonusDialog({
    super.key,
    required this.streak,
    required this.bonusCoins,
    required this.primaryColor,
    required this.onClaim,
  });

  String get _streakLabel {
    if (streak >= 30) return '1ヶ月達成！👑';
    if (streak >= 14) return '2週間達成！🏆';
    if (streak >= 7) return '1週間達成！⭐';
    if (streak >= 5) return '5日連続！🔥🔥';
    if (streak >= 3) return '3日連続！🔥';
    if (streak >= 2) return '$streak日連続！';
    return 'ようこそ！';
  }

  String get _bonusType {
    if (streak >= 30) return '月間スペシャルボーナス';
    if (streak >= 14) return '2週間ボーナス';
    if (streak >= 7) return '週間ボーナス';
    return 'ログインボーナス';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎁', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 10),
            Text(
              _bonusType,
              style: TextStyle(
                fontSize: 13,
                color: primaryColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '今日もよろしく！',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kTextDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _streakLabel,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFFE67E22),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9CA24), Color(0xFFF0932B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF0932B).withAlpha(80),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 34)),
                  const SizedBox(width: 10),
                  Text(
                    '+$bonusCoins',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'コイン',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (streak >= 6) ...[
              const SizedBox(height: 12),
              _NextMilestone(streak: streak),
            ],
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'うけとる！🎉',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextMilestone extends StatelessWidget {
  final int streak;
  const _NextMilestone({required this.streak});

  @override
  Widget build(BuildContext context) {
    final (nextTarget, nextLabel, nextBonus) = streak < 7
        ? (7, '7日連続', 50)
        : streak < 14
            ? (14, '14日連続', 100)
            : (30, '30日連続', 200);
    final remaining = nextTarget - streak;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kBgLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'あと$remaining日で$nextLabel達成！ボーナス🪙$nextBonus枚',
        style: const TextStyle(fontSize: 12, color: kTextMuted),
        textAlign: TextAlign.center,
      ),
    );
  }
}
