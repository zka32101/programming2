import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'badge_time_definitions.dart';

const _habitPrefix = 'study_habit_';

const _consistentSlotPrefix = 'consistent_slot_';
const _weekendQuestionsKey = 'weekend_questions_';
const _dailyQuestionsPrefix = 'daily_questions_';

/// 学習習慣を追跡するプロバイダー
class StudyHabitNotifier extends Notifier<StudyHabitState> {
  @override
  StudyHabitState build() => StudyHabitState.empty;

  /// SharedPreferencesから復元
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // 習慣記録を読み込み
    final habits = <StudyHabitRecord>[];
    final habitKeys = prefs.getKeys().where((k) => k.startsWith(_habitPrefix));

    for (final key in habitKeys) {
      try {
        final habitJson = prefs.getString(key);
        if (habitJson != null) {
          final parts = habitJson.split('|');
          if (parts.length >= 3) {
            final timestamp = int.tryParse(parts[0]);
            final questions = int.tryParse(parts[1]);
            final slotName = parts[2];

            if (timestamp != null && questions != null) {
              final timeSlot = TimeSlot.values.firstWhere(
                (slot) => slot.name == slotName,
                orElse: () => TimeSlot.morning,
              );

              habits.add(StudyHabitRecord(
                dateTime: DateTime.fromMillisecondsSinceEpoch(timestamp),
                questionCount: questions,
                timeSlot: timeSlot,
              ));
            }
          }
        }
      } catch (_) {}
    }

    state = StudyHabitState(habits: habits);
  }

  /// 学習習慣を記録
  Future<void> recordStudySession({
    required int questionCount,
    required DateTime studyTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final timeSlot = TimeSlot.fromDateTime(studyTime) ?? TimeSlot.morning;

    final habit = StudyHabitRecord(
      dateTime: studyTime,
      questionCount: questionCount,
      timeSlot: timeSlot,
    );

    // SharedPreferencesに保存
    final key = '$_habitPrefix${DateTime.now().millisecondsSinceEpoch}';
    final habitJson =
        '${studyTime.millisecondsSinceEpoch}|$questionCount|${timeSlot.name}';
    await prefs.setString(key, habitJson);

    // 時間帯別カウントを更新
    await _updateTimeSlotCount(prefs, timeSlot);

    // ローカルステート更新
    final newHabits = [...state.habits, habit];
    state = state.copyWith(habits: newHabits);
  }

  /// 時間帯別学習カウントを更新
  Future<void> _updateTimeSlotCount(
    SharedPreferences prefs,
    TimeSlot timeSlot,
  ) async {
    final countKey = '$_consistentSlotPrefix${timeSlot.name}';
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);
  }

  /// 指定した時間帯の学習回数を取得
  Future<int> getTimeSlotCount(TimeSlot timeSlot) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_consistentSlotPrefix${timeSlot.name}') ?? 0;
  }

  /// 週末の学習問題数を取得
  Future<int> getWeekendQuestionCount() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekendQuestionsKey +
        '${DateTime.now().year}-W${(DateTime.now().month)}';
    return prefs.getInt(key) ?? 0;
  }

  /// 週末の問題数を追加
  Future<void> addWeekendQuestions(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekendQuestionsKey +
        '${DateTime.now().year}-W${(DateTime.now().month)}';
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + count);
  }

  /// 今日の問題数を取得
  Future<int> getTodayQuestionCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key = '$_dailyQuestionsPrefix${today.year}-${today.month}-${today.day}';
    return prefs.getInt(key) ?? 0;
  }

  /// 今日の問題数を追加
  Future<void> addTodayQuestions(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key = '$_dailyQuestionsPrefix${today.year}-${today.month}-${today.day}';
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + count);
  }

  /// 直近7日間の学習日を取得
  List<DateTime> getLastSevenDays() {
    final today = DateTime.now();
    return List.generate(7, (i) => today.subtract(Duration(days: i)));
  }

  /// 直近7日間の日ごと問題数を取得
  Future<Map<String, int>> getLastSevenDaysCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final counts = <String, int>{};
    final lastSevenDays = getLastSevenDays();

    for (final day in lastSevenDays) {
      final key =
          '$_dailyQuestionsPrefix${day.year}-${day.month}-${day.day}';
      counts[key] = prefs.getInt(key) ?? 0;
    }

    return counts;
  }

  /// クリア（テスト用）
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_habitPrefix) ||
          key.startsWith(_consistentSlotPrefix) ||
          key.startsWith(_weekendQuestionsKey) ||
          key.startsWith(_dailyQuestionsPrefix)) {
        await prefs.remove(key);
      }
    }
    state = StudyHabitState.empty;
  }
}

/// 学習習慣ステート
class StudyHabitState {
  final List<StudyHabitRecord> habits;

  const StudyHabitState({required this.habits});

  static const empty = StudyHabitState(habits: []);

  StudyHabitState copyWith({
    List<StudyHabitRecord>? habits,
  }) =>
      StudyHabitState(
        habits: habits ?? this.habits,
      );

  /// 特定の時間帯の学習回数
  int getTimeSlotCount(TimeSlot timeSlot) {
    return habits.where((h) => h.timeSlot == timeSlot).length;
  }

  /// 最近の学習時間帯（直近7日）
  TimeSlot? getMostRecentTimeSlot() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recent = habits.where((h) => h.dateTime.isAfter(sevenDaysAgo));
    if (recent.isEmpty) return null;
    return recent.first.timeSlot;
  }
}

final studyHabitProvider =
    NotifierProvider<StudyHabitNotifier, StudyHabitState>(
  StudyHabitNotifier.new,
);
