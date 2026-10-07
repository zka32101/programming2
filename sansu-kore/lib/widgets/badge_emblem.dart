import 'package:flutter/material.dart';
import 'package:sansu_kore/widgets/ukalab_emoji.dart';

/// 実績バッジの共通意匠（assets/badges/badge_<意匠>.webp）。対応のないバッジは従来の絵文字で出す。
///
/// 意匠への対応は design/小学コレ！/共通/実績バッジ_意匠対応表_2026-10-07.md。
class BadgeEmblem extends StatelessWidget {
  const BadgeEmblem({super.key, required this.badgeId, required this.fallbackEmoji, this.size = 32});

  final String badgeId;
  final String fallbackEmoji;
  final double size;

  static const Map<String, String> _emblemOf = {
    'streak_3': 'streak',
    'streak_7': 'daily',
    'streak_30': 'streak',
    'daily_7': 'daily',
    'daily_30': 'daily',
    'math_first': 'first_step',
    'math_50': 'check',
    'math_100': 'check',
    'perfect_score': 'perfect',
    'perfect_3': 'perfect',
    'stage_5': 'challenge',
    'stage_10': 'challenge',
    'stage_20': 'master',
    'stage_30': 'master',
    'stage_50': 'master',
    'stage_92': 'gradcap',
    'math_200': 'check',
    'math_300': 'check',
    'math_500': 'check',
    'weekly_challenge_1': 'challenge',
    'weekly_challenge_4': 'challenge',
    'streak_1': 'first_step',
    'streak_14': 'streak',
    'streak_100': 'streak',
    'ranking_top100': 'trophy',
    'ranking_top10': 'trophy',
    'weekly_ranking_win': 'trophy',
    'character_levelup_3': 'levelup',
    'character_levelup_5': 'levelup',
    'character_max_all': 'levelup',
    'grade_complete_1': 'gradcap',
    'grade_complete_2': 'gradcap',
    'grade_complete_3': 'gradcap',
    'grade_complete_4': 'gradcap',
    'grade_complete_5': 'gradcap',
    'grade_complete_6': 'gradcap',
    'stage_perfect_all': 'perfect',
    'math_1000': 'check',
    'perfect_10': 'perfect',
    'perfect_50': 'perfect',
    'speed_clear': 'speed',
    'accuracy_90': 'check',
    'badge_collector_10': 'collection',
    'badge_collector_20': 'collection',
    'badge_collector_30': 'collection',
    'social_share': 'handshake',
    'friend_invite': 'handshake',
  };

  /// バッジIDに対応する意匠名。なければ null。
  static String? emblemOf(String badgeId) => _emblemOf[badgeId];

  @override
  Widget build(BuildContext context) {
    final name = _emblemOf[badgeId];
    if (name == null) return UkalabEmoji(fallbackEmoji, size: size);
    return Image.asset(
      'assets/badges/badge_$name.webp',
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) => UkalabEmoji(fallbackEmoji, size: size),
    );
  }
}
