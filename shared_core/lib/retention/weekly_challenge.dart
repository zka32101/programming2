import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/coin_provider.dart';
import '../utils/date_key.dart';

/// 今週の月曜（日付のみ）。
DateTime weekStartOf(DateTime at) {
  final d = DateTime(at.year, at.month, at.day);
  return DateTime(d.year, d.month, d.day - (d.weekday - 1));
}

class WeeklyChallengeState {
  final DateTime? weekStart;
  final int completed;
  final bool rewardClaimed;
  final int target;
  const WeeklyChallengeState(
      {this.weekStart,
      this.completed = 0,
      this.rewardClaimed = false,
      this.target = 15});

  int get remaining => (target - completed).clamp(0, target);
  bool get isComplete => completed >= target;
  double get progress => target == 0 ? 0 : (completed / target).clamp(0.0, 1.0);
}

const _weekKey = 'sc_weekly_challenge_week';
const _countKey = 'sc_weekly_challenge_count';
const _claimedKey = 'sc_weekly_challenge_claimed';

/// 「今週あと N 問正解で達成」の週次目標（月曜始まりで自動リセット）。
///
/// 正解のたびに `recordCorrectAnswer()`。達成するとコインを一度だけ付与し、
/// 返り値は付与コイン（達成した回のみ > 0）。
class WeeklyChallengeNotifier extends Notifier<WeeklyChallengeState> {
  /// 週次目標（正解数）と達成報酬。アプリ起動時に変更可。
  int target = 15;
  int rewardCoins = 100;

  @override
  WeeklyChallengeState build() => const WeeklyChallengeState();

  Future<void> load({DateTime? now}) async {
    final week = weekStartOf(now ?? DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    final stored = parseDateKey(prefs.getString(_weekKey));
    state = stored == week
        ? WeeklyChallengeState(
            weekStart: week,
            completed: prefs.getInt(_countKey) ?? 0,
            rewardClaimed: prefs.getBool(_claimedKey) ?? false,
            target: target)
        : WeeklyChallengeState(weekStart: week, target: target);
  }

  Future<int> recordCorrectAnswer({DateTime? now}) async {
    final week = weekStartOf(now ?? DateTime.now());
    var s = state;
    if (s.weekStart != week) s = WeeklyChallengeState(weekStart: week, target: target);
    if (s.isComplete) {
      state = s;
      return 0;
    }
    final completed = s.completed + 1;
    final justDone = completed >= target && !s.rewardClaimed;
    state = WeeklyChallengeState(
        weekStart: week,
        completed: completed,
        rewardClaimed: s.rewardClaimed || justDone,
        target: target);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weekKey, dateKeyOf(week));
    await prefs.setInt(_countKey, completed);
    await prefs.setBool(_claimedKey, state.rewardClaimed);
    if (justDone) {
      await ref.read(coinProvider.notifier).addCoins(rewardCoins);
      return rewardCoins;
    }
    return 0;
  }
}

final weeklyChallengeProvider =
    NotifierProvider<WeeklyChallengeNotifier, WeeklyChallengeState>(
        WeeklyChallengeNotifier.new);
