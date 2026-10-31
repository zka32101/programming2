import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/date_key.dart';

/// 1 ユーザーの利用実績（インストール日と学習した日付の集合）。
class UserActivity {
  final DateTime installDate;
  final Set<String> activeDateKeys; // 'YYYY-MM-DD'
  const UserActivity(this.installDate, this.activeDateKeys);
}

/// D1 / D7 / D30 継続率などの KPI 計算（純粋ロジック）。
class RetentionKpi {
  /// [day] 日後（インストール日 = 0 日目）に学習した割合。
  /// 分母は「インストールから [day] 日以上経過したユーザー」。
  /// 該当ユーザーがいなければ null。
  static double? dayNRetention(
      List<UserActivity> users, int day, DateTime today) {
    var eligible = 0, retained = 0;
    for (final u in users) {
      if (calendarDaysBetween(u.installDate, today) < day) continue;
      eligible++;
      final target = DateTime(
          u.installDate.year, u.installDate.month, u.installDate.day + day);
      if (u.activeDateKeys.contains(dateKeyOf(target))) retained++;
    }
    return eligible == 0 ? null : retained / eligible;
  }

  /// 直近 7 日間（今日を含む）の学習日数。
  static int activeDaysLast7(Set<String> activeDateKeys, DateTime today) {
    var n = 0;
    for (var i = 0; i < 7; i++) {
      final d = DateTime(today.year, today.month, today.day - i);
      if (activeDateKeys.contains(dateKeyOf(d))) n++;
    }
    return n;
  }

  /// 現在の連続学習日数（今日未学習でも昨日まで続いていれば維持）。
  static int currentStreak(Set<String> activeDateKeys, DateTime today) {
    var d = DateTime(today.year, today.month, today.day);
    if (!activeDateKeys.contains(dateKeyOf(d))) {
      d = DateTime(d.year, d.month, d.day - 1);
    }
    var n = 0;
    while (activeDateKeys.contains(dateKeyOf(d))) {
      n++;
      d = DateTime(d.year, d.month, d.day - 1);
    }
    return n;
  }

  /// 離脱リスクの目安: 最終学習から [thresholdDays] 日以上空いている。
  static bool isChurnRisk(Set<String> activeDateKeys, DateTime today,
      {int thresholdDays = 3}) {
    if (activeDateKeys.isEmpty) return false;
    final last = activeDateKeys.map(parseDateKey).whereType<DateTime>().reduce(
        (a, b) => a.isAfter(b) ? a : b);
    return calendarDaysBetween(last, today) >= thresholdDays;
  }
}

class RetentionTrackerState {
  final DateTime? installDate;
  final Set<String> activeDateKeys;
  const RetentionTrackerState({this.installDate, this.activeDateKeys = const {}});

  UserActivity? get activity =>
      installDate == null ? null : UserActivity(installDate!, activeDateKeys);
}

const _installKey = 'sc_kpi_install_date';
const _activeKey = 'sc_kpi_active_dates';
const _maxStoredDays = 120;

/// 端末内で学習した日を記録する。集計（D1/D7/D30）は
/// このデータを Firestore の analytics に送って Cloud Functions 側で行う。
class RetentionTrackerNotifier extends Notifier<RetentionTrackerState> {
  @override
  RetentionTrackerState build() => const RetentionTrackerState();

  Future<void> load({DateTime? now}) async {
    final today = now ?? DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    var install = parseDateKey(prefs.getString(_installKey));
    if (install == null) {
      install = DateTime(today.year, today.month, today.day);
      await prefs.setString(_installKey, dateKeyOf(install));
    }
    state = RetentionTrackerState(
      installDate: install,
      activeDateKeys: (prefs.getStringList(_activeKey) ?? []).toSet(),
    );
  }

  /// 今日学習したことを記録する（クイズ完了時などに呼ぶ）。
  Future<void> markActiveToday({DateTime? now}) async {
    final key = dateKeyOf(now ?? DateTime.now());
    if (state.activeDateKeys.contains(key)) return;
    final keys = {...state.activeDateKeys, key}.toList()..sort();
    final trimmed = keys.length > _maxStoredDays
        ? keys.sublist(keys.length - _maxStoredDays)
        : keys;
    state = RetentionTrackerState(
        installDate: state.installDate, activeDateKeys: trimmed.toSet());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_activeKey, trimmed);
  }
}

final retentionTrackerProvider =
    NotifierProvider<RetentionTrackerNotifier, RetentionTrackerState>(
        RetentionTrackerNotifier.new);
