import 'package:flutter/material.dart';
import 'package:eigo_kore/widgets/ukalab_emoji.dart';

/// 実績バッジの共通意匠（assets/badges/badge_<意匠>.webp）。対応のないバッジは従来の絵文字で出す。
///
/// 意匠への対応は design/小学コレ！/共通/実績バッジ_意匠対応表_2026-10-07.md。
class BadgeEmblem extends StatelessWidget {
  const BadgeEmblem({super.key, required this.badgeId, required this.fallbackEmoji, this.size = 32});

  final String badgeId;
  final String fallbackEmoji;
  final double size;

  static const Map<String, String> _emblemOf = {
    'firstLesson': 'first_step',
    'wordMaster': 'book',
    'phraseMaster': 'book',
    'conversationChamp': 'handshake',
    'streakWeek': 'streak',
    'streakMonth': 'streak',
    'perfectScore': 'perfect',
    'speakingPro': 'master',
    'listeningPro': 'master',
    'stage1Clear': 'challenge',
    'stage5Clear': 'challenge',
    'stage10Clear': 'gradcap',
    'streak_3': 'streak',
    'streak_7': 'streak',
    'streak_14': 'streak',
    'streak_30': 'streak',
    'streak_60': 'streak',
    'streak_100': 'streak',
    'score_first': 'first_step',
    'perfect_score': 'perfect',
    'quiz_total_100': 'check',
    'quiz_total_500': 'check',
    'perfect_3': 'perfect',
    'kanji_first': 'book',
    'kanji_10': 'book',
    'reading_first': 'book',
    'reading_10': 'book',
    'writing_first': 'pencil',
    'writing_10': 'pencil',
    'writing_all': 'gradcap',
    'grammar_first': 'book',
    'grammar_master': 'master',
    'vocab_first': 'book',
    'vocab_master': 'master',
    'character_3': 'collection',
    'character_lv_max': 'levelup',
    'prediction_master': 'idea',
    'troubleshoot_detective': 'idea',
    'badge_collector': 'collection',
    'stage_20': 'challenge',
    'stage_30': 'challenge',
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
