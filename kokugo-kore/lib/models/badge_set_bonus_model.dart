/// バッジセットボーナス定義
class BadgeSetBonus {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final List<String> requiredBadgeIds;
  final int rewardCoins;
  final String rewardDescription;

  const BadgeSetBonus({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.requiredBadgeIds,
    required this.rewardCoins,
    required this.rewardDescription,
  });

  /// セットが完了したかチェック
  bool isCompleted(Set<String> earnedBadgeIds) {
    return requiredBadgeIds.every((id) => earnedBadgeIds.contains(id));
  }

  /// セットの進捗率を取得（0.0～1.0）
  double getProgressPercent(Set<String> earnedBadgeIds) {
    if (requiredBadgeIds.isEmpty) return 0.0;
    final earned =
        requiredBadgeIds.where((id) => earnedBadgeIds.contains(id)).length;
    return earned / requiredBadgeIds.length;
  }
}

/// 定義済みバッジセットボーナス
final badgeSetBonuses = <String, BadgeSetBonus>{
  // チャレンジセット：難しい挑戦を完成させた者へ
  'challenge_master_set': BadgeSetBonus(
    id: 'challenge_master_set',
    title: 'チャレンジマスター',
    emoji: '🏆',
    description: 'すべてのチャレンジバッジを集める',
    requiredBadgeIds: [
      'challenge_3days_perfect',
      'challenge_all_stages',
      'challenge_speedrun',
      'challenge_nonstop',
    ],
    rewardCoins: 500,
    rewardDescription: 'チャレンジマスター達成！500コイン獲得',
  ),

  // ソーシャルセット：友達と交流した者へ
  'social_butterfly_set': BadgeSetBonus(
    id: 'social_butterfly_set',
    title: 'ソーシャルバタフライ',
    emoji: '🦋',
    description: 'すべての社交バッジを集める',
    requiredBadgeIds: [
      'friend_invite_1',
      'friend_invite_5',
      'multiplayer_win_5',
      'multiplayer_rank_top10',
    ],
    rewardCoins: 400,
    rewardDescription: 'ソーシャルバタフライ達成！400コイン獲得',
  ),

  // マイルストーンセット：成長を記録した者へ
  'milestone_achiever_set': BadgeSetBonus(
    id: 'milestone_achiever_set',
    title: 'マイルストーン達成者',
    emoji: '🎯',
    description: 'すべてのマイルストーンバッジを集める',
    requiredBadgeIds: [
      'learning_1hour',
      'learning_10hour',
      'learning_100hour',
      'coins_1000',
    ],
    rewardCoins: 450,
    rewardDescription: 'マイルストーン達成者認定！450コイン獲得',
  ),

  // 習慣セット：毎日学習した者へ
  'habit_champion_set': BadgeSetBonus(
    id: 'habit_champion_set',
    title: '習慣チャンピオン',
    emoji: '⭐',
    description: 'すべての習慣バッジを集める',
    requiredBadgeIds: [
      'consistent_learner',
      'weekend_warrior',
      'daily_grind',
      'early_bird',
      'night_owl',
      'afternoon_champion',
    ],
    rewardCoins: 600,
    rewardDescription: '習慣チャンピオン認定！600コイン獲得',
  ),

  // 時間マスターセット：全時間帯で活動した者へ
  'time_master_set': BadgeSetBonus(
    id: 'time_master_set',
    title: '時間マスター',
    emoji: '⏰',
    description: '朝・昼・夜すべての時間帯バッジを集める',
    requiredBadgeIds: [
      'early_bird',
      'afternoon_champion',
      'night_owl',
    ],
    rewardCoins: 300,
    rewardDescription: '時間マスター達成！300コイン獲得',
  ),
};

/// バッジセットボーナス管理クラス
class BadgeSetBonusManager {
  /// 完了したセットボーナスを取得
  static List<BadgeSetBonus> getCompletedSets(Set<String> earnedBadgeIds) {
    return badgeSetBonuses.values
        .where((set) => set.isCompleted(earnedBadgeIds))
        .toList();
  }

  /// 進捗中のセットボーナスを取得（10%以上進捗）
  static List<BadgeSetBonus> getInProgressSets(Set<String> earnedBadgeIds) {
    return badgeSetBonuses.values
        .where((set) =>
            !set.isCompleted(earnedBadgeIds) &&
            set.getProgressPercent(earnedBadgeIds) >= 0.1)
        .toList();
  }

  /// 利用可能なセットボーナスを取得
  static List<BadgeSetBonus> getAvailableSets(Set<String> earnedBadgeIds) {
    return badgeSetBonuses.values
        .where((set) =>
            !set.isCompleted(earnedBadgeIds) &&
            set.getProgressPercent(earnedBadgeIds) > 0)
        .toList();
  }

  /// 完了したセットボーナスの総報酬を計算
  static int getCompletedSetRewards(Set<String> earnedBadgeIds) {
    final completedSets = getCompletedSets(earnedBadgeIds);
    return completedSets.fold<int>(
      0,
      (total, set) => total + set.rewardCoins,
    );
  }

  /// セットボーナスの進捗統計を取得
  static Map<String, int> getSetBonusStats(Set<String> earnedBadgeIds) {
    final completed = getCompletedSets(earnedBadgeIds).length;
    final inProgress = getInProgressSets(earnedBadgeIds).length;
    final total = badgeSetBonuses.length;
    final available = getAvailableSets(earnedBadgeIds).length;

    return {
      'completed': completed,
      'inProgress': inProgress,
      'total': total,
      'available': available,
      'rewards': getCompletedSetRewards(earnedBadgeIds),
    };
  }
}
