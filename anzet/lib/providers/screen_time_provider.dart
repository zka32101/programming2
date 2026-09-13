import 'package:flutter_riverpod/flutter_riverpod.dart';

/// スクリーンタイム設定の状態
class ScreenTimeSettings {
  final String childId;
  final Duration dailyLimit;
  final Duration usedToday;
  final DateTime lastResetTime;
  final bool isLimitExceeded;

  ScreenTimeSettings({
    required this.childId,
    this.dailyLimit = const Duration(hours: 2),
    this.usedToday = const Duration(minutes: 0),
    DateTime? lastResetTime,
    this.isLimitExceeded = false,
  }) : lastResetTime = lastResetTime ?? DateTime.now();

  ScreenTimeSettings copyWith({
    String? childId,
    Duration? dailyLimit,
    Duration? usedToday,
    DateTime? lastResetTime,
    bool? isLimitExceeded,
  }) {
    return ScreenTimeSettings(
      childId: childId ?? this.childId,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      usedToday: usedToday ?? this.usedToday,
      lastResetTime: lastResetTime ?? this.lastResetTime,
      isLimitExceeded: isLimitExceeded ?? this.isLimitExceeded,
    );
  }

  Duration getRemainingTime() {
    return (dailyLimit - usedToday);
  }

  bool shouldResetDaily() {
    final now = DateTime.now();
    return now.day != lastResetTime.day;
  }
}

/// スクリーンタイム設定 Provider
final screenTimeProvider = StateNotifierProvider.family<
    ScreenTimeNotifier,
    ScreenTimeSettings,
    String>((ref, childId) {
  return ScreenTimeNotifier(childId);
});

/// スクリーンタイム状態管理
class ScreenTimeNotifier extends StateNotifier<ScreenTimeSettings> {
  final String childId;

  ScreenTimeNotifier(this.childId)
      : super(ScreenTimeSettings(childId: childId));

  /// 使用時間を追加
  void addUsageTime(Duration duration) {
    state = state.copyWith(
      usedToday: state.usedToday + duration,
      isLimitExceeded: (state.usedToday + duration) >= state.dailyLimit,
    );
  }

  /// 日ごとにリセット（自動）
  void resetDaily() {
    state = state.copyWith(
      usedToday: const Duration(minutes: 0),
      lastResetTime: DateTime.now(),
      isLimitExceeded: false,
    );
  }

  /// 日替わり上限を設定
  void setDailyLimit(Duration limit) {
    state = state.copyWith(dailyLimit: limit);
  }

  /// 使用時間を手動リセット
  void manualReset() {
    state = state.copyWith(
      usedToday: const Duration(minutes: 0),
      isLimitExceeded: false,
    );
  }
}

/// 残り時間 Provider（計算型）
final remainingTimeProvider = Provider.family<Duration, String>((ref, childId) {
  final settings = ref.watch(screenTimeProvider(childId));
  return settings.getRemainingTime().clamp(
        const Duration(seconds: 0),
        settings.dailyLimit,
      );
});

/// 制限超過フラグ Provider（計算型）
final isLimitExceededProvider = Provider.family<bool, String>((ref, childId) {
  final settings = ref.watch(screenTimeProvider(childId));
  return settings.isLimitExceeded || settings.getRemainingTime().inSeconds <= 0;
});

/// 本日使用率 Provider（計算型、0.0-1.0）
final usagePercentageProvider = Provider.family<double, String>((ref, childId) {
  final settings = ref.watch(screenTimeProvider(childId));
  if (settings.dailyLimit.inSeconds == 0) return 0.0;
  return (settings.usedToday.inSeconds / settings.dailyLimit.inSeconds)
      .clamp(0.0, 1.0);
});
