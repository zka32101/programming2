import 'package:shared_core/models/badge_model.dart';
import 'badge_progress_model.dart';

class BadgeChallenge {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final List<String> requiredBadgeIds; // チャレンジに含まれるバッジID
  final int rewardCoins;
  final bool isLimitedTime;
  final DateTime? expiresAt;

  const BadgeChallenge({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.requiredBadgeIds,
    required this.rewardCoins,
    this.isLimitedTime = false,
    this.expiresAt,
  });

  /// チャレンジの進捗率を取得（0.0～1.0）
  double getProgressPercent(Set<String> earnedBadgeIds) {
    if (requiredBadgeIds.isEmpty) return 0.0;

    final earned = requiredBadgeIds.where((id) => earnedBadgeIds.contains(id)).length;
    return earned / requiredBadgeIds.length;
  }

  /// チャレンジが完了したかチェック
  bool isCompleted(Set<String> earnedBadgeIds) {
    return requiredBadgeIds.every((id) => earnedBadgeIds.contains(id));
  }

  /// チャレンジが期限切れかチェック
  bool isExpired() {
    if (!isLimitedTime || expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

/// バッジコレクション達成状況
class BadgeCollectionStatus {
  final int totalBadges;
  final int earnedBadges;
  final Map<BadgeRarity, int> rarityBreakdown; // レアリティ別の獲得数
  final List<BadgeChallenge> completedChallenges;
  final List<BadgeChallenge> inProgressChallenges;

  const BadgeCollectionStatus({
    required this.totalBadges,
    required this.earnedBadges,
    required this.rarityBreakdown,
    required this.completedChallenges,
    required this.inProgressChallenges,
  });

  /// 獲得率（0.0～1.0）
  double get completionPercent => earnedBadges / totalBadges;

  /// コレクション完了度（パーセント）
  int get completionPercentage => (completionPercent * 100).toInt();

  /// すべてのバッジを獲得済みかチェック
  bool get isFullyCompleted => earnedBadges == totalBadges;

  /// 最も獲得しているレアリティを取得
  BadgeRarity? getMostCommonRarity() {
    if (rarityBreakdown.isEmpty) return null;
    var maxEntry = rarityBreakdown.entries.first;
    for (final entry in rarityBreakdown.entries) {
      if (entry.value > maxEntry.value) {
        maxEntry = entry;
      }
    }
    return maxEntry.key;
  }
}

/// 定義済みバッジコレクションチャレンジ
final badgeChallenges = <String, BadgeChallenge>{
  'rookie_collector': BadgeChallenge(
    id: 'rookie_collector',
    title: 'ルーキーコレクター',
    emoji: '🌱',
    description: '10個のバッジを集めよう',
    requiredBadgeIds: [
      'streak_3',
      'streak_7',
      'perfect_score',
      'kanji_first',
      'reading_first',
      'score_first',
      'quiz_total_100',
      'character_3',
      'stage_20',
      'early_bird',
    ],
    rewardCoins: 100,
  ),
  'badge_master': BadgeChallenge(
    id: 'badge_master',
    title: 'バッジマスター',
    emoji: '🏆',
    description: 'レアバッジを5個集めよう',
    requiredBadgeIds: [
      'streak_30',
      'challenge_all_stages',
      'learning_10hour',
      'multiplayer_rank_top10',
      'challenge_speedrun',
    ],
    rewardCoins: 250,
  ),
  'legend_collector': BadgeChallenge(
    id: 'legend_collector',
    title: 'レジェンドコレクター',
    emoji: '👑',
    description: 'すべてのレジェンダリーバッジを集める',
    requiredBadgeIds: [
      'challenge_all_stages',
      'learning_100hour',
      'multiplayer_rank_top10',
    ],
    rewardCoins: 500,
  ),
  'time_badge_collector': BadgeChallenge(
    id: 'time_badge_collector',
    title: '時間帯マスター',
    emoji: '⏰',
    description: '朝・昼・夜のバッジを全て集める',
    requiredBadgeIds: [
      'early_bird',
      'afternoon_champion',
      'night_owl',
    ],
    rewardCoins: 150,
  ),
  'habit_builder': BadgeChallenge(
    id: 'habit_builder',
    title: '習慣形成者',
    emoji: '📚',
    description: '習慣系バッジ全てを集める',
    requiredBadgeIds: [
      'consistent_learner',
      'weekend_warrior',
      'daily_grind',
    ],
    rewardCoins: 200,
  ),
  'limited_speedrun': BadgeChallenge(
    id: 'limited_speedrun',
    title: '⚡ スピードランチャレンジ（期間限定）',
    emoji: '⚡',
    description: '今月中にスピードランバッジを獲得しよう',
    requiredBadgeIds: [
      'challenge_speedrun',
    ],
    rewardCoins: 300,
    isLimitedTime: true,
    expiresAt: DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
  ),
};

/// バッジチャレンジマネージャー
class BadgeChallengeManager {
  /// 特定のチャレンジの進捗を取得
  static double getChallengeProgress(
    String challengeId,
    Set<String> earnedBadgeIds,
  ) {
    final challenge = badgeChallenges[challengeId];
    if (challenge == null) return 0.0;
    return challenge.getProgressPercent(earnedBadgeIds);
  }

  /// チャレンジが完了したか確認
  static bool isChallengeCompleted(
    String challengeId,
    Set<String> earnedBadgeIds,
  ) {
    final challenge = badgeChallenges[challengeId];
    if (challenge == null) return false;
    return challenge.isCompleted(earnedBadgeIds);
  }

  /// 有効なチャレンジを取得（期限切れを除外）
  static List<BadgeChallenge> getActiveChallenges() {
    return badgeChallenges.values
        .where((challenge) => !challenge.isExpired())
        .toList();
  }

  /// ユーザーのコレクション状況を取得
  static BadgeCollectionStatus getCollectionStatus(
    int totalBadges,
    Set<String> earnedBadgeIds,
    Map<String, BadgeRarity> rarities,
  ) {
    // レアリティ別の獲得数を計算
    final rarityBreakdown = <BadgeRarity, int>{};
    for (final badgeId in earnedBadgeIds) {
      final rarity = rarities[badgeId];
      if (rarity != null) {
        rarityBreakdown[rarity] = (rarityBreakdown[rarity] ?? 0) + 1;
      }
    }

    // 完了・進捗中のチャレンジを分類
    final completedChallenges = <BadgeChallenge>[];
    final inProgressChallenges = <BadgeChallenge>[];

    for (final challenge in getActiveChallenges()) {
      if (challenge.isCompleted(earnedBadgeIds)) {
        completedChallenges.add(challenge);
      } else if (challenge.getProgressPercent(earnedBadgeIds) > 0) {
        inProgressChallenges.add(challenge);
      }
    }

    return BadgeCollectionStatus(
      totalBadges: totalBadges,
      earnedBadges: earnedBadgeIds.length,
      rarityBreakdown: rarityBreakdown,
      completedChallenges: completedChallenges,
      inProgressChallenges: inProgressChallenges,
    );
  }
}
