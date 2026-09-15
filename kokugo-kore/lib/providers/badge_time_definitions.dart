import 'package:shared_core/models/badge_model.dart';
import '../models/badge_progress_model.dart';

import '../models/badge_reward_model.dart';

/// Phase 3で追加する時間帯別バッジの定義
///
/// 新規バッジ: 6個
/// - 時間帯: 3個（early_bird, night_owl, afternoon_champion）
/// - 習慣: 3個（consistent_learner, weekend_warrior, daily_grind）

/// 時間帯別バッジの定義
final timeBadgeDefinitions = <String, BadgeDefinitionWithTime>{
  'early_bird': BadgeDefinitionWithTime(
    id: 'early_bird',
    title: 'アーリーバード',
    emoji: '🌅',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 75),
    description: '朝6時～9時に学習',
    hoursRange: (6, 9),
  ),
  'night_owl': BadgeDefinitionWithTime(
    id: 'night_owl',
    title: 'ナイトアウル',
    emoji: '🌙',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 75),
    description: '夜21時～24時に学習',
    hoursRange: (21, 24),
  ),
  'afternoon_champion': BadgeDefinitionWithTime(
    id: 'afternoon_champion',
    title: 'アフタヌーンチャンピオン',
    emoji: '☀️',
    rarity: BadgeRarity.common,
    reward: const BadgeReward(coinAmount: 30),
    description: '昼12時～15時に学習',
    hoursRange: (12, 15),
  ),
  'consistent_learner': BadgeDefinitionWithTime(
    id: 'consistent_learner',
    title: '継続は力なり',
    emoji: '📚',
    rarity: BadgeRarity.epic,
    reward: const BadgeReward(coinAmount: 150),
    description: '同じ時間帯で5回学習',
    hoursRange: null, // 時間帯不問
  ),
  'weekend_warrior': BadgeDefinitionWithTime(
    id: 'weekend_warrior',
    title: 'ウィークエンドウォーリア',
    emoji: '⚔️',
    rarity: BadgeRarity.rare,
    reward: const BadgeReward(coinAmount: 80),
    description: '土日に10問以上解く',
    hoursRange: null, // 曜日チェック
  ),
  'daily_grind': BadgeDefinitionWithTime(
    id: 'daily_grind',
    title: 'デイリーグラインド',
    emoji: '💪',
    rarity: BadgeRarity.epic,
    reward: const BadgeReward(coinAmount: 120),
    description: '毎日3問以上解く（7日連続）',
    hoursRange: null, // 日付チェック
  ),
};

class BadgeDefinitionWithTime {
  final String id;
  final String title;
  final String emoji;
  final BadgeRarity rarity;
  final BadgeReward reward;
  final String description;
  final (int, int)? hoursRange; // (startHour, endHour)

  const BadgeDefinitionWithTime({
    required this.id,
    required this.title,
    required this.emoji,
    required this.rarity,
    required this.reward,
    required this.description,
    this.hoursRange,
  });
}

/// 全ての時間帯別バッジ定義をマージ
Map<String, BadgeDefinitionWithTime> getAllTimeBadgeDefinitions() {
  return timeBadgeDefinitions;
}

/// 時間帯別バッジ獲得条件チェッカー
class TimeBadgeUnlockChecker {
  /// 朝型学習者（6時～9時）
  static bool checkEarlyBird(DateTime studyTime) {
    return studyTime.hour >= 6 && studyTime.hour < 9;
  }

  /// 夜型学習者（21時～24時）
  static bool checkNightOwl(DateTime studyTime) {
    return studyTime.hour >= 21 && studyTime.hour < 24;
  }

  /// 昼間チャンピオン（12時～15時）
  static bool checkAfternoonChampion(DateTime studyTime) {
    return studyTime.hour >= 12 && studyTime.hour < 15;
  }

  /// 習慣形成者（同じ時間帯で5回以上）
  /// 実装: 時間帯別の学習日記を記録して判定
  static bool checkConsistentLearner({
    required Map<String, int> timeSlotCounts,
  }) {
    // timeSlotCounts: {'morning': 5, 'afternoon': 2, ...}
    return timeSlotCounts.values.any((count) => count >= 5);
  }

  /// ウィークエンドウォーリア（土日に10問以上）
  static bool checkWeekendWarrior({
    required DateTime studyTime,
    required int questionCount,
  }) {
    final isWeekend = studyTime.weekday == DateTime.saturday ||
        studyTime.weekday == DateTime.sunday;
    return isWeekend && questionCount >= 10;
  }

  /// デイリーグラインド（7日連続で毎日3問以上）
  /// 実装: 日ごとの学習記録を確認
  static bool checkDailyGrind({
    required List<DateTime> lastSevenDays,
    required Map<String, int> dailyQuestionCounts,
  }) {
    // lastSevenDays: 直近7日間の学習日
    // 7日すべてで3問以上かチェック
    if (lastSevenDays.length < 7) return false;

    for (final day in lastSevenDays) {
      final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      if ((dailyQuestionCounts[key] ?? 0) < 3) {
        return false;
      }
    }
    return true;
  }
}

/// 学習時間帯の分類
enum TimeSlot {
  earlyMorning('早朝', 5, 9),
  morning('朝', 6, 9),
  afternoon('昼', 12, 15),
  evening('夕方', 15, 18),
  night('夜', 18, 21),
  lateNight('深夜', 21, 24);

  final String label;
  final int startHour;
  final int endHour;

  const TimeSlot(this.label, this.startHour, this.endHour);

  /// 指定された時刻がこの時間帯に該当するかチェック
  bool contains(DateTime dateTime) {
    return dateTime.hour >= startHour && dateTime.hour < endHour;
  }

  /// 指定された時刻の時間帯を取得
  static TimeSlot? fromDateTime(DateTime dateTime) {
    for (final slot in TimeSlot.values) {
      if (slot.contains(dateTime)) {
        return slot;
      }
    }
    return null;
  }
}

/// 学習習慣の記録
class StudyHabitRecord {
  final DateTime dateTime;
  final int questionCount;
  final TimeSlot timeSlot;

  const StudyHabitRecord({
    required this.dateTime,
    required this.questionCount,
    required this.timeSlot,
  });
}

/// バッジ獲得条件の説明テキスト
Map<String, String> timeBadgeUnlockConditions = {
  'early_bird': '朝6時～9時の間に学習を完了',
  'night_owl': '夜21時～24時の間に学習を完了',
  'afternoon_champion': '昼12時～15時の間に学習を完了',
  'consistent_learner': '同じ時間帯で5回以上学習',
  'weekend_warrior': '土日に10問以上解く',
  'daily_grind': '7日連続で毎日3問以上解く',
};
