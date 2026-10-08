import 'package:flutter/material.dart';
import 'package:kokugo_kore/widgets/ukalab_emoji.dart';

/// 実績バッジの共通意匠（assets/badges/badge_<意匠>.webp）。対応のないバッジは従来の絵文字で出す。
///
/// 意匠への対応は design/小学コレ！/共通/実績バッジ_意匠対応表_2026-10-07.md。
class BadgeEmblem extends StatelessWidget {
  const BadgeEmblem({super.key, required this.badgeId, required this.fallbackEmoji, this.size = 32});

  final String badgeId;
  final String fallbackEmoji;
  final double size;

  static const Map<String, String> _emblemOf = {
    'streak_3days': 'streak',
    'streak_7days': 'streak',
    'streak_30days': 'streak',
    'streak_60days': 'streak',
    'streak_100days': 'streak',
    'beginner_kokugo': 'book',
    'intermediate_kokugo': 'book',
    'perfect_quiz_10': 'perfect',
    'perfect_quiz_50': 'perfect',
    'perfect_quiz_100': 'perfect',
    'perfect_stage_clear': 'perfect',
    'high_score_master': 'master',
    'social_friend_3': 'handshake',
    'social_friend_10': 'handshake',
    'social_friend_30': 'handshake',
    'social_message_10': 'handshake',
    'social_battle_win_5': 'handshake',
    'character_level_5': 'levelup',
    'character_collection_5': 'collection',
    'character_collection_10': 'collection',
    'character_full_collection': 'collection',
    'character_stamp_collector': 'collection',
    'special_kokugo_kanji_master': 'book',
    'special_kokugo_reading_master': 'book',
    'master_three_subjects': 'master',
    'master_five_subjects': 'master',
    'master_all_subjects': 'gradcap',
    'ultimate_learner': 'gem',
    'legendary_collector': 'gem',
    'challenge_3days_perfect': 'perfect',
    'challenge_all_stages': 'gradcap',
    'challenge_speedrun': 'speed',
    'challenge_nonstop': 'challenge',
    'friend_invite_1': 'handshake',
    'friend_invite_5': 'handshake',
    'multiplayer_win_5': 'handshake',
    'multiplayer_rank_top10': 'trophy',
    'learning_1hour': 'clock',
    'learning_10hour': 'clock',
    'learning_100hour': 'clock',
    'coins_1000': 'gem',
    'early_bird': 'clock',
    'night_owl': 'clock',
    'afternoon_champion': 'clock',
    'consistent_learner': 'clock',
    'weekend_warrior': 'clock',
    'daily_grind': 'daily',
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
