import '../design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../reward_assets.dart';
import 'streak_calendar.dart';

class StreakBadge extends StatelessWidget {
  final int days;
  const StreakBadge({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    if (days == 0) return const SizedBox.shrink();

    final Color color = days >= 30
        ? const Color(0xFFF59E0B)
        : days >= 7
            ? AppColors.accentOrange
            : AppColors.primary;

    return GestureDetector(
      onTap: () => showStreakCalendar(context, days),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: color.withAlpha(76), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            streakFlameAsset(days)!,
            height: 18,
            errorBuilder: (_, __, ___) => const Text('🔥', style: TextStyle(fontSize: 14)),
          ),
          if (streakCrownAsset(days) != null) ...[
            const SizedBox(width: 2),
            Image.asset(
              streakCrownAsset(days)!,
              height: 18,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ],
          const SizedBox(width: 4),
          Text(
            '$days日連続',
            style: const TextStyle(
              color:AppColors.textWhite,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
