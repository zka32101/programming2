import 'package:shared_core/models/badge_model.dart';
import '../models/badge_progress_model.dart';

import '../models/badge_reward_model.dart';

/// Phase 2で追加する新規バッジの定義
///
/// 新規バッジ: 12個
/// - チャレンジ: 4個
/// - 社交: 4個
/// - マイルストーン: 4個

/// チャレンジバッジの定義
final challengeBadgeDefinitions = <String, BadgeDefinition>{
  'challenge_3days_perfect': BadgeDefinition(
    id: 'challenge_3days_perfect',
    title: '3日完璧',
    emoji: '🔥',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 50),
  ),
  'challenge_all_stages': BadgeDefinition(
    id: 'challenge_all_stages',
    title: '全ステージ制覇',
    emoji: '🏆',
    rarity: BadgeRarity.epic,
    reward: const BadgeReward(coinAmount: 100),
  ),
  'challenge_speedrun': BadgeDefinition(
    id: 'challenge_speedrun',
    title: 'スピードランナー',
    emoji: '⚡',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 60),
  ),
  'challenge_nonstop': BadgeDefinition(
    id: 'challenge_nonstop',
    title: 'ノンストップ',
    emoji: '💯',
    rarity: BadgeRarity.epic,
    reward: const BadgeReward(coinAmount: 80),
  ),
};

final socialBadgeDefinitions = <String, BadgeDefinition>{
  'friend_invite_1': BadgeDefinition(
    id: 'friend_invite_1',
    title: '友人を招待',
    emoji: '👫',
    rarity: BadgeRarity.common,
    reward: const BadgeReward(coinAmount: 20),
  ),
  'friend_invite_5': BadgeDefinition(
    id: 'friend_invite_5',
    title: 'インフルエンサー',
    emoji: '👥',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 100),
  ),
  'multiplayer_win_5': BadgeDefinition(
    id: 'multiplayer_win_5',
    title: '5勝達成',
    emoji: '⚔️',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 75),
  ),
  'multiplayer_rank_top10': BadgeDefinition(
    id: 'multiplayer_rank_top10',
    title: 'TOP 10ランカー',
    emoji: '🏅',
    rarity: BadgeRarity.legendary,
    reward: const BadgeReward(coinAmount: 200),
  ),
};

/// マイルストーンバッジの定義
final milestoneBadgeDefinitions = <String, BadgeDefinition>{
  'learning_1hour': BadgeDefinition(
    id: 'learning_1hour',
    title: '1時間達成',
    emoji: '⏰',
    rarity: BadgeRarity.common,
    reward: const BadgeReward(coinAmount: 30),
  ),
  'learning_10hour': BadgeDefinition(
    id: 'learning_10hour',
    title: '10時間達成',
    emoji: '📚',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 80),
  ),
  'learning_100hour': BadgeDefinition(
    id: 'learning_100hour',
    title: '100時間達成',
    emoji: '🎓',
    rarity: BadgeRarity.legendary,
    reward: const BadgeReward(coinAmount: 250),
  ),
  'coins_1000': BadgeDefinition(
    id: 'coins_1000',
    title: 'コイン富豪',
    emoji: '💰',
    rarity: BadgeRarity.epic,
    reward: const BadgeReward(coinAmount: 100),
  ),
};

/// 全ての新規バッジ定義をマージ
Map<String, BadgeDefinition> getAllNewBadgeDefinitions() {
  return {
    ...challengeBadgeDefinitions,
    ...socialBadgeDefinitions,
    ...milestoneBadgeDefinitions,
  };
}

/// バッジ定義情報
class BadgeDefinition {
  final String id;
  final String title;
  final String emoji;
  final BadgeRarity rarity;
  final BadgeReward reward;

  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.emoji,
    required this.rarity,
    required this.reward,
  });
}

/// バッジ獲得条件チェッカー
class BadgeUnlockChecker {
  /// チャレンジバッジの獲得条件チェック
  static bool checkChallengeBadge({
    required String badgeId,
    required int perfectDays,
    required int allStageClear,
    required int speedrunCount,
    required int nonStopCount,
  }) {
    return switch (badgeId) {
      'challenge_3days_perfect' => perfectDays >= 3,
      'challenge_all_stages' => allStageClear == 1,
      'challenge_speedrun' => speedrunCount >= 1,
      'challenge_nonstop' => nonStopCount >= 1,
      _ => false,
    };
  }

  /// 社交バッジの獲得条件チェック
  static bool checkSocialBadge({
    required String badgeId,
    required int friendInviteCount,
    required int multiplayerWins,
    required bool isTopTenRanker,
  }) {
    return switch (badgeId) {
      'friend_invite_1' => friendInviteCount >= 1,
      'friend_invite_5' => friendInviteCount >= 5,
      'multiplayer_win_5' => multiplayerWins >= 5,
      'multiplayer_rank_top10' => isTopTenRanker,
      _ => false,
    };
  }

  /// マイルストーンバッジの獲得条件チェック
  static bool checkMilestoneBadge({
    required String badgeId,
    required int learningMinutes,
    required int totalCoins,
  }) {
    return switch (badgeId) {
      'learning_1hour' => learningMinutes >= 60,
      'learning_10hour' => learningMinutes >= 600,
      'learning_100hour' => learningMinutes >= 6000,
      'coins_1000' => totalCoins >= 1000,
      _ => false,
    };
  }
}

/// バッジ獲得条件の説明テキスト
Map<String, String> badgeUnlockConditions = {
  // チャレンジバッジ
  'challenge_3days_perfect': '3日間連続で100%の正答率を達成',
  'challenge_all_stages': 'すべてのステージをクリア',
  'challenge_speedrun': '10問を2分以内にクリア',
  'challenge_nonstop': '20問連続で正答',

  // 社交バッジ
  'friend_invite_1': '1人の友人を招待',
  'friend_invite_5': '5人の友人を招待',
  'multiplayer_win_5': 'マルチプレイで5勝達成',
  'multiplayer_rank_top10': 'ランキングTOP10に入る',

  // マイルストーン
  'learning_1hour': '累計1時間学習',
  'learning_10hour': '累計10時間学習',
  'learning_100hour': '累計100時間学習',
  'coins_1000': '合計1000コイン獲得',
};
