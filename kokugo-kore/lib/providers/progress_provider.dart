import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _clearedPrefix = 'stage_cleared_';
const _streakKey = 'streak_count';
const _lastStudyKey = 'last_study_date';
const _totalCorrectKey = 'total_correct';
const _totalKanjiKey = 'total_kanji_correct';
const _totalReadingKey = 'total_reading_correct';
const _maxClearedKey = 'max_stage_cleared';
const _perfectStageKey = 'perfect_stage_count';
const _perfectStreakKey = 'current_perfect_streak';

class LearningProgress {
  final Set<String> clearedStageIds;
  final int streakDays;
  final DateTime? lastStudyDate;
  final int totalCorrect;
  final int totalKanjiCorrect;
  final int totalReadingCorrect;
  final int maxStageCleared;
  final int perfectStageCount;
  final int currentPerfectStreak;

  const LearningProgress({
    required this.clearedStageIds,
    required this.streakDays,
    this.lastStudyDate,
    required this.totalCorrect,
    required this.totalKanjiCorrect,
    required this.totalReadingCorrect,
    required this.maxStageCleared,
    required this.perfectStageCount,
    this.currentPerfectStreak = 0,
  });

  LearningProgress copyWith({
    Set<String>? clearedStageIds,
    int? streakDays,
    DateTime? lastStudyDate,
    int? totalCorrect,
    int? totalKanjiCorrect,
    int? totalReadingCorrect,
    int? maxStageCleared,
    int? perfectStageCount,
    int? currentPerfectStreak,
  }) {
    return LearningProgress(
      clearedStageIds: clearedStageIds ?? this.clearedStageIds,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalKanjiCorrect: totalKanjiCorrect ?? this.totalKanjiCorrect,
      totalReadingCorrect: totalReadingCorrect ?? this.totalReadingCorrect,
      maxStageCleared: maxStageCleared ?? this.maxStageCleared,
      perfectStageCount: perfectStageCount ?? this.perfectStageCount,
      currentPerfectStreak: currentPerfectStreak ?? this.currentPerfectStreak,
    );
  }

  bool isCleared(int grade, int stageNumber) {
    return clearedStageIds.contains('g${grade}_s$stageNumber');
  }

  static const empty = LearningProgress(
    clearedStageIds: {},
    streakDays: 0,
    totalCorrect: 0,
    totalKanjiCorrect: 0,
    totalReadingCorrect: 0,
    maxStageCleared: 0,
    perfectStageCount: 0,
    currentPerfectStreak: 0,
  );
}

class ProgressNotifier extends Notifier<LearningProgress> {
  @override
  LearningProgress build() => LearningProgress.empty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_clearedPrefix)).toSet();
    final cleared = keys.map((k) => k.replaceFirst(_clearedPrefix, '')).toSet();

    final lastStudyStr = prefs.getString(_lastStudyKey);
    DateTime? lastStudy;
    if (lastStudyStr != null) {
      lastStudy = DateTime.tryParse(lastStudyStr);
    }

    state = LearningProgress(
      clearedStageIds: cleared,
      streakDays: prefs.getInt(_streakKey) ?? 0,
      lastStudyDate: lastStudy,
      totalCorrect: prefs.getInt(_totalCorrectKey) ?? 0,
      totalKanjiCorrect: prefs.getInt(_totalKanjiKey) ?? 0,
      totalReadingCorrect: prefs.getInt(_totalReadingKey) ?? 0,
      maxStageCleared: prefs.getInt(_maxClearedKey) ?? 0,
      perfectStageCount: prefs.getInt(_perfectStageKey) ?? 0,
      currentPerfectStreak: prefs.getInt(_perfectStreakKey) ?? 0,
    );
  }

  Future<void> recordResult({
    required int grade,
    required int stageNumber,
    required int correct,
    required int total,
    required bool isKanji,
    required bool isPerfect,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final stageId = 'g${grade}_s$stageNumber';
    // 既にクリア済みのステージの再プレイかどうか。再プレイでは正解数などの
    // 累計カウンター（バッジ判定や保護者レポートに使う）は二重加算しない。
    final isFirstClear = !state.clearedStageIds.contains(stageId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ストリーク更新（端末の時計が巻き戻った場合は「同日扱い」にして
    // ストリークを不当にリセットしない）
    int streak = state.streakDays;
    final lastStudy = state.lastStudyDate;
    if (lastStudy == null) {
      streak = 1;
    } else {
      final lastDay = DateTime(lastStudy.year, lastStudy.month, lastStudy.day);
      final diff = today.difference(lastDay).inDays;
      if (diff <= 0) {
        // 同日、または時計が巻き戻った場合は変化なし
      } else if (diff == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
    }

    final newCleared = {...state.clearedStageIds, stageId};
    final newTotal = state.totalCorrect + (isFirstClear ? correct : 0);
    final newKanji = state.totalKanjiCorrect + (isFirstClear && isKanji ? correct : 0);
    final newReading = state.totalReadingCorrect + (isFirstClear && !isKanji ? correct : 0);
    final newMax = stageNumber > state.maxStageCleared ? stageNumber : state.maxStageCleared;
    final newPerfect = (isFirstClear && isPerfect) ? state.perfectStageCount + 1 : state.perfectStageCount;
    final newPerfectStreak = isPerfect ? state.currentPerfectStreak + 1 : 0;

    await prefs.setBool('$_clearedPrefix$stageId', true);
    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastStudyKey, today.toIso8601String());
    await prefs.setInt(_totalCorrectKey, newTotal);
    await prefs.setInt(_totalKanjiKey, newKanji);
    await prefs.setInt(_totalReadingKey, newReading);
    await prefs.setInt(_maxClearedKey, newMax);
    await prefs.setInt(_perfectStageKey, newPerfect);
    await prefs.setInt(_perfectStreakKey, newPerfectStreak);

    state = state.copyWith(
      clearedStageIds: newCleared,
      streakDays: streak,
      lastStudyDate: today,
      totalCorrect: newTotal,
      totalKanjiCorrect: newKanji,
      totalReadingCorrect: newReading,
      maxStageCleared: newMax,
      perfectStageCount: newPerfect,
      currentPerfectStreak: newPerfectStreak,
    );
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    final keysToRemove = prefs.getKeys()
        .where((k) =>
            k.startsWith(_clearedPrefix) ||
            k == _streakKey ||
            k == _lastStudyKey ||
            k == _totalCorrectKey ||
            k == _totalKanjiKey ||
            k == _totalReadingKey ||
            k == _maxClearedKey ||
            k == _perfectStageKey ||
            k == _perfectStreakKey)
        .toList();
    for (final k in keysToRemove) {
      await prefs.remove(k);
    }
    state = LearningProgress.empty;
  }
}

final progressProvider =
    NotifierProvider<ProgressNotifier, LearningProgress>(ProgressNotifier.new);
