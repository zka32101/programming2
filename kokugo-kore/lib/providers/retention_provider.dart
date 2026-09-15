import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Phase 4.13: Retention Provider（デイリーミッション・ストリークシステム）
///
/// ユーザーの学習継続性を追跡・奨励するためのプロバイダー
/// - デイリーミッション進捗
/// - ストリーク（連続学習日数）
/// - リワード（報酬）管理

class RetentionState {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final int dailyMissionsCompleted;
  final bool bonusClaimedToday;

  const RetentionState({
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    required this.dailyMissionsCompleted,
    required this.bonusClaimedToday,
  });

  RetentionState copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    int? dailyMissionsCompleted,
    bool? bonusClaimedToday,
  }) =>
      RetentionState(
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastActivityDate: lastActivityDate ?? this.lastActivityDate,
        dailyMissionsCompleted: dailyMissionsCompleted ?? this.dailyMissionsCompleted,
        bonusClaimedToday: bonusClaimedToday ?? this.bonusClaimedToday,
      );
}

class RetentionNotifier extends StateNotifier<RetentionState> {
  final SharedPreferences _prefs;

  static const String _streakKey = 'kokugo_retention_current_streak';
  static const String _longestStreakKey = 'kokugo_retention_longest_streak';
  static const String _lastActivityDateKey = 'kokugo_retention_last_activity_date';
  static const String _dailyMissionsKey = 'kokugo_retention_daily_missions_completed';
  static const String _bonusClaimedKey = 'kokugo_retention_bonus_claimed_today';

  RetentionNotifier(this._prefs)
      : super(RetentionState(
          currentStreak: _prefs.getInt(_streakKey) ?? 0,
          longestStreak: _prefs.getInt(_longestStreakKey) ?? 0,
          lastActivityDate: _prefs.getString(_lastActivityDateKey) != null
              ? DateTime.parse(_prefs.getString(_lastActivityDateKey)!)
              : null,
          dailyMissionsCompleted: _prefs.getInt(_dailyMissionsKey) ?? 0,
          bonusClaimedToday: _prefs.getBool(_bonusClaimedKey) ?? false,
        ));

  /// 学習活動を記録（クイズ完了時に呼び出し）
  Future<void> recordLearningActivity() async {
    final today = DateTime.now();
    final lastDate = state.lastActivityDate;

    int newStreak = state.currentStreak;
    int newLongestStreak = state.longestStreak;

    // 前回の活動日をチェック
    if (lastDate != null) {
      final daysSince = today.difference(lastDate).inDays;

      if (daysSince == 0) {
        // 同じ日内での複数活動
        newStreak = state.currentStreak;
      } else if (daysSince == 1) {
        // 連続した日（ストリーク継続）
        newStreak = state.currentStreak + 1;
      } else {
        // ストリーク途絶
        newStreak = 1;
      }
    } else {
      // 初回活動
      newStreak = 1;
    }

    // 最長ストリーク更新
    newLongestStreak = newStreak > state.longestStreak ? newStreak : state.longestStreak;

    // 状態更新
    state = state.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      lastActivityDate: today,
    );

    // SharedPreferences に保存
    await _prefs.setInt(_streakKey, newStreak);
    await _prefs.setInt(_longestStreakKey, newLongestStreak);
    await _prefs.setString(_lastActivityDateKey, today.toIso8601String());
  }

  /// デイリーミッション進捗を更新
  Future<void> incrementDailyMissions({int count = 1}) async {
    final newCount = state.dailyMissionsCompleted + count;

    state = state.copyWith(dailyMissionsCompleted: newCount);
    await _prefs.setInt(_dailyMissionsKey, newCount);
  }

  /// 毎日のリセット処理
  Future<void> resetDailyData() async {
    state = state.copyWith(
      dailyMissionsCompleted: 0,
      bonusClaimedToday: false,
    );

    await _prefs.setInt(_dailyMissionsKey, 0);
    await _prefs.setBool(_bonusClaimedKey, false);
  }

  /// ボーナス取得フラグを設定
  Future<void> claimBonusToday() async {
    state = state.copyWith(bonusClaimedToday: true);
    await _prefs.setBool(_bonusClaimedKey, true);
  }
}

// Phase 4.13: Retention Provider
final retentionNotifierProvider =
    StateNotifierProvider<RetentionNotifier, RetentionState>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  return prefsAsync.when(
    data: (prefs) => RetentionNotifier(prefs),
    loading: () => RetentionNotifier(SharedPreferences.getInstance().then((_) => null) as SharedPreferences),
    error: (_, __) => RetentionNotifier(SharedPreferences.getInstance().then((_) => null) as SharedPreferences),
  );
});

// SharedPreferences Provider（ユーティリティ）
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
