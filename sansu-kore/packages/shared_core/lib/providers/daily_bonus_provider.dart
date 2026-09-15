import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lastBonusKey = 'daily_bonus_last_date';
const _bonusStreakKey = 'daily_bonus_streak';

class DailyBonusState {
  final int bonusStreak;
  final DateTime? lastBonusDate;
  final bool claimedToday;
  final int todayBonus;

  const DailyBonusState({
    required this.bonusStreak,
    this.lastBonusDate,
    required this.claimedToday,
    required this.todayBonus,
  });

  static const empty = DailyBonusState(
    bonusStreak: 0,
    claimedToday: false,
    todayBonus: 5,
  );

  DailyBonusState copyWith({
    int? bonusStreak,
    DateTime? lastBonusDate,
    bool? claimedToday,
    int? todayBonus,
  }) =>
      DailyBonusState(
        bonusStreak: bonusStreak ?? this.bonusStreak,
        lastBonusDate: lastBonusDate ?? this.lastBonusDate,
        claimedToday: claimedToday ?? this.claimedToday,
        todayBonus: todayBonus ?? this.todayBonus,
      );
}

int calcDailyBonus(int streak) {
  if (streak >= 30) return 200;
  if (streak >= 14) return 100;
  if (streak >= 7) return 50;
  if (streak >= 5) return 20;
  if (streak >= 3) return 15;
  if (streak >= 2) return 10;
  return 5;
}

class DailyBonusNotifier extends Notifier<DailyBonusState> {
  @override
  DailyBonusState build() => DailyBonusState.empty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStr = prefs.getString(_lastBonusKey);
    DateTime? lastDate;
    if (lastStr != null) lastDate = DateTime.tryParse(lastStr);

    int streak = prefs.getInt(_bonusStreakKey) ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    bool claimed = false;

    if (lastDate != null) {
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 0) {
        claimed = true;
      } else if (diff > 1) {
        streak = 0;
        await prefs.setInt(_bonusStreakKey, 0);
      }
    }

    state = DailyBonusState(
      bonusStreak: streak,
      lastBonusDate: lastDate,
      claimedToday: claimed,
      todayBonus: claimed ? 0 : calcDailyBonus(streak + 1),
    );
  }

  Future<int> claim() async {
    if (state.claimedToday) return 0;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final newStreak = state.bonusStreak + 1;
    final bonus = calcDailyBonus(newStreak);

    await prefs.setString(_lastBonusKey, today.toIso8601String());
    await prefs.setInt(_bonusStreakKey, newStreak);

    state = state.copyWith(
      bonusStreak: newStreak,
      lastBonusDate: today,
      claimedToday: true,
      todayBonus: bonus,
    );
    return bonus;
  }
}

final dailyBonusProvider =
    NotifierProvider<DailyBonusNotifier, DailyBonusState>(DailyBonusNotifier.new);
