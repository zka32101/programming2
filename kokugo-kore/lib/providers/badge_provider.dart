import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_core/models/badge_model.dart';

import '../models/badge_reward_model.dart';
import '../models/badge_progress_model.dart';
import '../models/badge_set_bonus_model.dart';
import 'badge_definitions.dart';
import 'badge_time_definitions.dart';
import 'study_habit_provider.dart';

const _earnedPrefix = 'badge_earned_';
const _completedSetBonusPrefix = 'set_bonus_completed_';

/// 既知のバッジ ID リスト
const List<String> knownBadgeIds = [
  'streak_3', 'streak_7', 'streak_14', 'streak_30', 'streak_60', 'streak_100',
  'score_first', 'perfect_score', 'quiz_total_100', 'quiz_total_500',
  'perfect_3', 'kanji_first', 'kanji_10', 'reading_first', 'reading_10',
  'character_3', 'character_lv_max', 'stage_20', 'stage_30', 'badge_collector',
  'challenge_3days_perfect', 'challenge_all_stages', 'challenge_speedrun', 'challenge_nonstop',
  'friend_invite_1', 'friend_invite_5', 'multiplayer_win_5', 'multiplayer_rank_top10',
  'learning_1hour', 'learning_10hour', 'learning_100hour', 'coins_1000',
  'early_bird', 'afternoon_champion', 'night_owl', 'consistent_learner', 'weekend_warrior', 'daily_grind',
];

/// 全バッジリスト - 初期値は空、実行時に shared_core から初期化
List<BadgeModel> allBadges = [];

class BadgeState {
  final List<EarnedBadge> earnedBadges;
  final List<BadgeModel> newlyEarned; // 直近で獲得したバッジ（表示後クリア）
  final List<BadgeSetBonus> newlyCompletedSetBonuses; // 直近で完成したセットボーナス（表示後クリア）
  final Map<String, BadgeProgress> progress; // バッジ進捗情報
  final Map<String, BadgeReward> rewards; // バッジ報酬情報
  final Map<String, BadgeRarity> rarities; // バッジレアリティ情報

  const BadgeState({
    required this.earnedBadges,
    required this.newlyEarned,
    this.newlyCompletedSetBonuses = const [],
    this.progress = const {},
    this.rewards = const {},
    this.rarities = const {},
  });

  static const empty = BadgeState(
    earnedBadges: [],
    newlyEarned: [],
    newlyCompletedSetBonuses: [],
    progress: {},
    rewards: {},
    rarities: {},
  );

  /// 特定のバッジの進捗を取得
  BadgeProgress? getProgress(String badgeId) => progress[badgeId];

  /// 特定のバッジの報酬を取得
  BadgeReward? getReward(String badgeId) => rewards[badgeId];

  /// 特定のバッジのレアリティを取得
  BadgeRarity? getRarity(String badgeId) => rarities[badgeId];

  /// 進捗中のバッジ一覧を取得（獲得率が0%超100%未満）
  List<BadgeProgress> getProgressingBadges() {
    return progress.values
        .where((p) => p.progressPercent > 0 && p.progressPercent < 1.0)
        .toList()
      ..sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
  }

  /// 特定のレアリティのバッジ数
  int getBadgeCountByRarity(BadgeRarity rarity) {
    return rarities.values.where((r) => r == rarity).length;
  }

  /// 獲得済みのバッジ内訳（レアリティ別）
  Map<BadgeRarity, int> getEarnedCountByRarity() {
    final result = <BadgeRarity, int>{};
    for (final badge in earnedBadges) {
      final rarity = rarities[badge.badge.id];
      if (rarity != null) {
        result[rarity] = (result[rarity] ?? 0) + 1;
      }
    }
    return result;
  }

  BadgeState copyWith({
    List<EarnedBadge>? earnedBadges,
    List<BadgeModel>? newlyEarned,
    List<BadgeSetBonus>? newlyCompletedSetBonuses,
    Map<String, BadgeProgress>? progress,
    Map<String, BadgeReward>? rewards,
    Map<String, BadgeRarity>? rarities,
  }) =>
      BadgeState(
        earnedBadges: earnedBadges ?? this.earnedBadges,
        newlyEarned: newlyEarned ?? this.newlyEarned,
        newlyCompletedSetBonuses:
            newlyCompletedSetBonuses ?? this.newlyCompletedSetBonuses,
        progress: progress ?? this.progress,
        rewards: rewards ?? this.rewards,
        rarities: rarities ?? this.rarities,
      );
}

class BadgeNotifier extends Notifier<BadgeState> {
  @override
  BadgeState build() => BadgeState.empty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final earned = <EarnedBadge>[];

    // allBadges が初期化されていない場合はスキップ
    if (allBadges.isEmpty) {
      _initializeBadgeMetadata();
      state = BadgeState(earnedBadges: earned, newlyEarned: []);
      return;
    }

    for (final badge in allBadges) {
      final dateStr = prefs.getString('$_earnedPrefix${badge.id}');
      if (dateStr != null) {
        final date = DateTime.tryParse(dateStr);
        if (date != null) {
          earned.add(EarnedBadge(badge: badge, earnedAt: date));
        }
      }
    }

    // Initialize badge metadata (Phase 2+)
    _initializeBadgeMetadata();

    state = BadgeState(earnedBadges: earned, newlyEarned: []);
  }

  /// バッジメタデータを初期化（レアリティ・報酬）
  void _initializeBadgeMetadata() {
    final definitions = getAllNewBadgeDefinitions();
    final rarities = <String, BadgeRarity>{};
    final rewards = <String, BadgeReward>{};

    // 既存バッジのデフォルトレアリティ
    if (allBadges.isNotEmpty) {
      for (final badge in allBadges) {
        if (!definitions.containsKey(badge.id)) {
          // 既存バッジはcommonをデフォルト
          rarities[badge.id] = BadgeRarity.common;
          // 既存バッジの報酬は null（後で個別に設定可能）
        }
      }
    } else {
      // allBadges が空の場合、knownBadgeIds から初期化
      for (final badgeId in knownBadgeIds) {
        if (!definitions.containsKey(badgeId)) {
          rarities[badgeId] = BadgeRarity.common;
        }
      }
    }

    // 新規バッジのメタデータ
    for (final entry in definitions.entries) {
      rarities[entry.key] = entry.value.rarity;
      rewards[entry.key] = entry.value.reward;
    }

    state = state.copyWith(
      rarities: rarities,
      rewards: rewards,
    );
  }

  Future<List<BadgeModel>> checkAndAward({
    required int streakDays,
    required int totalKanjiCorrect,
    required int totalReadingCorrect,
    required int maxStageCleared,
    required int perfectStageCount,
    required bool justPerfect,
    int totalCorrect = 0,
    int clearedStageCount = 0,
    int currentPerfectStreak = 0,
    int unlockedCharacterCount = 0,
    bool hasMaxLevelCharacter = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyEarned = state.earnedBadges.map((e) => e.badge.id).toSet();
    final newBadges = <BadgeModel>[];

    // allBadges が初期化されていない場合はスキップ
    if (allBadges.isEmpty) {
      return newBadges;
    }

    for (final badge in allBadges) {
      if (alreadyEarned.contains(badge.id)) continue;
      bool earned = false;

      switch (badge.id) {
        case 'streak_3': earned = streakDays >= 3; break;
        case 'streak_7': earned = streakDays >= 7; break;
        case 'streak_14': earned = streakDays >= 14; break;
        case 'streak_30': earned = streakDays >= 30; break;
        case 'streak_60': earned = streakDays >= 60; break;
        case 'streak_100': earned = streakDays >= 100; break;
        case 'score_first': earned = clearedStageCount >= 1; break;
        case 'perfect_score': earned = justPerfect; break;
        case 'quiz_total_100': earned = totalCorrect >= 100; break;
        case 'quiz_total_500': earned = totalCorrect >= 500; break;
        case 'perfect_3': earned = currentPerfectStreak >= 3; break;
        case 'kanji_first': earned = totalKanjiCorrect >= 1; break;
        case 'kanji_10': earned = totalKanjiCorrect >= 10; break;
        case 'reading_first': earned = totalReadingCorrect >= 1; break;
        // reading_10: 「読解クイズで10問達成」。専用トラッキングがまだ無いため
        // totalReadingCorrectで代用（読解力強化機能側の保存実装と合わせて要見直し）。
        case 'reading_10': earned = totalReadingCorrect >= 10; break;
        case 'character_3': earned = unlockedCharacterCount >= 3; break;
        case 'character_lv_max': earned = hasMaxLevelCharacter; break;
        case 'stage_20': earned = clearedStageCount >= 20; break;
        case 'stage_30': earned = clearedStageCount >= 30; break;
        // badge_collectorはこのループ内では判定せず、下で別途チェックする
        // （「10個獲得」は他バッジの獲得数に依存するため）。
        // writing_*/grammar_*/vocab_* は「かく」「文法」「ことば」機能側の
        // 実績トラッキングが未実装のため、現時点では判定できない（既知の未対応）。
      }

      if (earned) {
        final now = DateTime.now();
        await prefs.setString('$_earnedPrefix${badge.id}', now.toIso8601String());
        newBadges.add(badge);
      }
    }

    // badge_collector: 上のループで新規獲得したものも含めた合計が10個以上か
    if (!alreadyEarned.contains('badge_collector') &&
        alreadyEarned.length + newBadges.length >= 10) {
      final collector = allBadges.firstWhere((b) => b.id == 'badge_collector');
      await prefs.setString(
        '$_earnedPrefix${collector.id}', DateTime.now().toIso8601String());
      newBadges.add(collector);
    }

    if (newBadges.isNotEmpty) {
      final nowEarned = [
        ...state.earnedBadges,
        ...newBadges.map((b) => EarnedBadge(badge: b, earnedAt: DateTime.now())),
      ];
      state = state.copyWith(earnedBadges: nowEarned, newlyEarned: newBadges);
    }
    return newBadges;
  }

  void clearNewlyEarned() {
    state = state.copyWith(newlyEarned: []);
  }

  /// バッジ報酬情報を設定
  void setRewards(Map<String, BadgeReward> rewards) {
    state = state.copyWith(rewards: rewards);
  }

  /// 特定のバッジに報酬を設定
  void setReward(String badgeId, BadgeReward reward) {
    final updated = Map<String, BadgeReward>.from(state.rewards);
    updated[badgeId] = reward;
    state = state.copyWith(rewards: updated);
  }

  /// バッジレアリティ情報を設定
  void setRarities(Map<String, BadgeRarity> rarities) {
    state = state.copyWith(rarities: rarities);
  }

  /// 特定のバッジにレアリティを設定
  void setRarity(String badgeId, BadgeRarity rarity) {
    final updated = Map<String, BadgeRarity>.from(state.rarities);
    updated[badgeId] = rarity;
    state = state.copyWith(rarities: updated);
  }

  /// バッジ進捗を更新
  void updateProgress(String badgeId, int currentValue) {
    final updated = Map<String, BadgeProgress>.from(state.progress);
    final existing = updated[badgeId];

    if (existing != null) {
      updated[badgeId] = existing.updateProgress(currentValue);
    } else {
      // 進捗情報が存在しない場合は新規作成
      updated[badgeId] = BadgeProgress(
        badgeId: badgeId,
        currentValue: currentValue,
        targetValue: currentValue, // 仮の値
        description: badgeId,
      );
    }

    state = state.copyWith(progress: updated);
  }

  /// バッジ進捗を設定（詳細情報付き）
  void setProgress(BadgeProgress progress) {
    final updated = Map<String, BadgeProgress>.from(state.progress);
    updated[progress.badgeId] = progress;
    state = state.copyWith(progress: updated);
  }

  /// 複数のバッジ進捗を一括設定
  void setProgressBatch(List<BadgeProgress> progressList) {
    final updated = Map<String, BadgeProgress>.from(state.progress);
    for (final p in progressList) {
      updated[p.badgeId] = p;
    }
    state = state.copyWith(progress: updated);
  }

  /// Phase 2+ チャレンジバッジの獲得チェック
  Future<List<BadgeModel>> checkChallengeBadges({
    required int perfectDays,
    required bool allStageCleared,
    required bool speedrunAchieved,
    required bool nonStopAchieved,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyEarned = state.earnedBadges.map((e) => e.badge.id).toSet();
    final newBadges = <BadgeModel>[];

    final definitions = getAllNewBadgeDefinitions();

    // チャレンジバッジチェック
    for (final badgeId in challengeBadgeDefinitions.keys) {
      if (alreadyEarned.contains(badgeId)) continue;

      final earned = BadgeUnlockChecker.checkChallengeBadge(
        badgeId: badgeId,
        perfectDays: perfectDays,
        allStageClear: allStageCleared ? 1 : 0,
        speedrunCount: speedrunAchieved ? 1 : 0,
        nonStopCount: nonStopAchieved ? 1 : 0,
      );

      if (earned) {
        final badge = allBadges.firstWhereOrNull((b) => b.id == badgeId);
        if (badge != null) {
          final now = DateTime.now();
          await prefs.setString('$_earnedPrefix$badgeId', now.toIso8601String());
          newBadges.add(badge);
        }
      }
    }

    // ローカルステート更新
    if (newBadges.isNotEmpty) {
      final nowEarned = [
        ...state.earnedBadges,
        ...newBadges.map((b) => EarnedBadge(badge: b, earnedAt: DateTime.now())),
      ];
      state = state.copyWith(earnedBadges: nowEarned, newlyEarned: newBadges);
    }

    return newBadges;
  }

  /// Phase 2+ 社交バッジの獲得チェック
  Future<List<BadgeModel>> checkSocialBadges({
    required int friendInviteCount,
    required int multiplayerWins,
    required bool isTopTenRanker,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyEarned = state.earnedBadges.map((e) => e.badge.id).toSet();
    final newBadges = <BadgeModel>[];

    for (final badgeId in socialBadgeDefinitions.keys) {
      if (alreadyEarned.contains(badgeId)) continue;

      final earned = BadgeUnlockChecker.checkSocialBadge(
        badgeId: badgeId,
        friendInviteCount: friendInviteCount,
        multiplayerWins: multiplayerWins,
        isTopTenRanker: isTopTenRanker,
      );

      if (earned) {
        final badge = allBadges.firstWhereOrNull((b) => b.id == badgeId);
        if (badge != null) {
          final now = DateTime.now();
          await prefs.setString('$_earnedPrefix$badgeId', now.toIso8601String());
          newBadges.add(badge);
        }
      }
    }

    if (newBadges.isNotEmpty) {
      final nowEarned = [
        ...state.earnedBadges,
        ...newBadges.map((b) => EarnedBadge(badge: b, earnedAt: DateTime.now())),
      ];
      state = state.copyWith(earnedBadges: nowEarned, newlyEarned: newBadges);
    }

    return newBadges;
  }

  /// Phase 2+ マイルストーンバッジの獲得チェック
  Future<List<BadgeModel>> checkMilestoneBadges({
    required int learningMinutes,
    required int totalCoins,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyEarned = state.earnedBadges.map((e) => e.badge.id).toSet();
    final newBadges = <BadgeModel>[];

    for (final badgeId in milestoneBadgeDefinitions.keys) {
      if (alreadyEarned.contains(badgeId)) continue;

      final earned = BadgeUnlockChecker.checkMilestoneBadge(
        badgeId: badgeId,
        learningMinutes: learningMinutes,
        totalCoins: totalCoins,
      );

      if (earned) {
        final badge = allBadges.firstWhereOrNull((b) => b.id == badgeId);
        if (badge != null) {
          final now = DateTime.now();
          await prefs.setString('$_earnedPrefix$badgeId', now.toIso8601String());
          newBadges.add(badge);
        }
      }
    }

    if (newBadges.isNotEmpty) {
      final nowEarned = [
        ...state.earnedBadges,
        ...newBadges.map((b) => EarnedBadge(badge: b, earnedAt: DateTime.now())),
      ];
      state = state.copyWith(earnedBadges: nowEarned, newlyEarned: newBadges);
    }

    return newBadges;
  }

  /// 複数のバッジチェック結果をマージ
  List<BadgeModel> _mergeBadgeResults(List<List<BadgeModel>> results) {
    final merged = <String, BadgeModel>{};
    for (final badgeList in results) {
      for (final badge in badgeList) {
        merged[badge.id] = badge; // 重複排除
      }
    }
    return merged.values.toList();
  }

  /// Phase 3+ 時間帯別バッジの獲得チェック
  Future<List<BadgeModel>> checkTimeBadges({
    required DateTime studyTime,
    required int questionCount,
    required Map<String, int> timeSlotCounts,
    required int weekendQuestions,
    required List<DateTime> lastSevenDays,
    required Map<String, int> dailyQuestionCounts,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyEarned = state.earnedBadges.map((e) => e.badge.id).toSet();
    final newBadges = <BadgeModel>[];

    for (final badgeId in timeBadgeDefinitions.keys) {
      if (alreadyEarned.contains(badgeId)) continue;

      bool earned = false;

      switch (badgeId) {
        case 'early_bird':
          earned = TimeBadgeUnlockChecker.checkEarlyBird(studyTime);
          break;
        case 'night_owl':
          earned = TimeBadgeUnlockChecker.checkNightOwl(studyTime);
          break;
        case 'afternoon_champion':
          earned = TimeBadgeUnlockChecker.checkAfternoonChampion(studyTime);
          break;
        case 'consistent_learner':
          earned = TimeBadgeUnlockChecker.checkConsistentLearner(
            timeSlotCounts: timeSlotCounts,
          );
          break;
        case 'weekend_warrior':
          earned = TimeBadgeUnlockChecker.checkWeekendWarrior(
            studyTime: studyTime,
            questionCount: weekendQuestions,
          );
          break;
        case 'daily_grind':
          earned = TimeBadgeUnlockChecker.checkDailyGrind(
            lastSevenDays: lastSevenDays,
            dailyQuestionCounts: dailyQuestionCounts,
          );
          break;
      }

      if (earned) {
        final badge = allBadges.firstWhereOrNull((b) => b.id == badgeId);
        if (badge != null) {
          final now = DateTime.now();
          await prefs.setString('$_earnedPrefix$badgeId', now.toIso8601String());
          newBadges.add(badge);
        }
      }
    }

    if (newBadges.isNotEmpty) {
      final nowEarned = [
        ...state.earnedBadges,
        ...newBadges.map((b) => EarnedBadge(badge: b, earnedAt: DateTime.now())),
      ];
      state = state.copyWith(earnedBadges: nowEarned, newlyEarned: newBadges);
    }

    return newBadges;
  }

  /// セットボーナスの完成をチェック
  Future<List<BadgeSetBonus>> checkSetBonuses() async {
    final prefs = await SharedPreferences.getInstance();
    final earnedIds = state.earnedBadges.map((e) => e.badge.id).toSet();

    // 既に完成済みのセットボーナスを取得
    final completedSetIds = <String>{};
    for (final setId in badgeSetBonuses.keys) {
      if (prefs.getBool('$_completedSetBonusPrefix$setId') ?? false) {
        completedSetIds.add(setId);
      }
    }

    // 新しく完成したセットボーナスをチェック
    final newlyCompleted = <BadgeSetBonus>[];
    for (final entry in badgeSetBonuses.entries) {
      final setId = entry.key;
      final set = entry.value;

      // 既に完成済みならスキップ
      if (completedSetIds.contains(setId)) continue;

      // セット完成をチェック
      if (set.isCompleted(earnedIds)) {
        await prefs.setBool('$_completedSetBonusPrefix$setId', true);
        newlyCompleted.add(set);
      }
    }

    if (newlyCompleted.isNotEmpty) {
      state = state.copyWith(newlyCompletedSetBonuses: newlyCompleted);
    }

    return newlyCompleted;
  }

  /// 新規獲得セットボーナスをクリア
  void clearNewlyCompletedSetBonuses() {
    state = state.copyWith(newlyCompletedSetBonuses: []);
  }
}

final badgeProvider = NotifierProvider<BadgeNotifier, BadgeState>(BadgeNotifier.new);
