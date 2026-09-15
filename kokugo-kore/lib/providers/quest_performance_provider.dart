import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _speedrunPrefix = 'speedrun_achievement_';
const _perfectDaysPrefix = 'perfect_days_';
const _sessionTimingPrefix = 'session_timing_';

/// クイズセッションのパフォーマンストラッキング
class QuestPerformanceNotifier extends Notifier<QuestPerformanceState> {
  @override
  QuestPerformanceState build() => QuestPerformanceState.empty;

  /// SharedPreferencesから復元
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // スピードラン達成を読み込み
    final speedrunAchieved = prefs.getBool(_speedrunPrefix) ?? false;

    // パーフェクト日数を読み込み
    final perfectDaysStr =
        prefs.getString(_perfectDaysPrefix) ?? '[]';
    final perfectDays = _parseDateList(perfectDaysStr);

    state = QuestPerformanceState(
      speedrunAchieved: speedrunAchieved,
      perfectDays: perfectDays,
    );
  }

  /// スピードラン達成を記録（10問を2分以内）
  Future<void> recordSpeedrunAttempt({
    required int questionCount,
    required Duration elapsedTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // 10問を2分（120秒）以内にクリア
    if (questionCount >= 10 && elapsedTime.inSeconds <= 120) {
      await prefs.setBool(_speedrunPrefix, true);
      state = state.copyWith(speedrunAchieved: true);
    }
  }

  /// パーフェクト日（100%正答率）を記録
  Future<void> recordPerfectDay(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();

    // その日にパーフェクトがまだ記録されていなければ追加
    if (!state.perfectDays.contains(date)) {
      final newDays = [...state.perfectDays, date];

      // SharedPreferencesに保存
      final dateStrings = newDays
          .map((d) => '${d.year}-${d.month}-${d.day}')
          .toList();
      await prefs.setString(_perfectDaysPrefix, dateStrings.join(','));

      state = state.copyWith(perfectDays: newDays);
    }
  }

  /// 連続パーフェクト日数を取得
  int getConsecutivePerfectDays() {
    if (state.perfectDays.isEmpty) return 0;

    // 昨日まで
    final today = DateTime.now();
    int consecutiveDays = 0;

    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (state.perfectDays.any((d) =>
          d.year == dateOnly.year &&
          d.month == dateOnly.month &&
          d.day == dateOnly.day)) {
        consecutiveDays++;
      } else {
        break; // 連続が途切れたら終了
      }
    }

    return consecutiveDays;
  }

  /// セッション時間を記録
  Future<void> recordSessionTiming({
    required int questionCount,
    required Duration duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final key = '$_sessionTimingPrefix${DateTime.now().toIso8601String()}';
    final timingData = '$questionCount|${duration.inSeconds}';
    await prefs.setString(key, timingData);

    // 平均回答時間を計算（今後の最適化用）
    _updateAverageResponseTime(prefs, duration, questionCount);
  }

  /// 平均回答時間を更新
  void _updateAverageResponseTime(
    SharedPreferences prefs,
    Duration duration,
    int questionCount,
  ) {
    if (questionCount == 0) return;

    final avgTimePerQuestion = duration.inMilliseconds / questionCount;
    // 今後、このデータを使用して最適な学習ペースを推奨できる
  }

  /// クリア（テスト用）
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_speedrunPrefix) ||
          key.startsWith(_perfectDaysPrefix) ||
          key.startsWith(_sessionTimingPrefix)) {
        await prefs.remove(key);
      }
    }
    state = QuestPerformanceState.empty;
  }

  /// 日付リストをパース
  static List<DateTime> _parseDateList(String dateStr) {
    if (dateStr.isEmpty || dateStr == '[]') return [];

    try {
      return dateStr.split(',').map((str) {
        final parts = str.trim().split('-');
        if (parts.length == 3) {
          final year = int.tryParse(parts[0]) ?? 0;
          final month = int.tryParse(parts[1]) ?? 0;
          final day = int.tryParse(parts[2]) ?? 0;
          return DateTime(year, month, day);
        }
        return null;
      }).whereType<DateTime>().toList();
    } catch (_) {
      return [];
    }
  }
}

/// クイズパフォーマンス状態
class QuestPerformanceState {
  final bool speedrunAchieved;
  final List<DateTime> perfectDays;

  const QuestPerformanceState({
    required this.speedrunAchieved,
    required this.perfectDays,
  });

  static const empty = QuestPerformanceState(
    speedrunAchieved: false,
    perfectDays: [],
  );

  QuestPerformanceState copyWith({
    bool? speedrunAchieved,
    List<DateTime>? perfectDays,
  }) =>
      QuestPerformanceState(
        speedrunAchieved: speedrunAchieved ?? this.speedrunAchieved,
        perfectDays: perfectDays ?? this.perfectDays,
      );
}

final questPerformanceProvider =
    NotifierProvider<QuestPerformanceNotifier, QuestPerformanceState>(
  QuestPerformanceNotifier.new,
);
