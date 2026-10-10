import 'package:shared_preferences/shared_preferences.dart';

/// 連続学習カレンダー用の「学習した日」の履歴（純関数 + SharedPreferences）。
/// 既存のストリーク計算には一切触れない（追記専用）。
const studyDatesKey = 'study_dates';
const studyDatesKeepDays = 180;

/// 連続日数がこの値に達した日に stamp_coin を出す。
const streakMilestones = <int>{7, 14, 30, 60, 100};

String formatStudyDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime? parseStudyDate(String s) {
  final p = s.split('-');
  if (p.length != 3) return null;
  final y = int.tryParse(p[0]), m = int.tryParse(p[1]), d = int.tryParse(p[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// [today] を重複なく追記し、直近 [keepDays] 日より古いものを切り捨てる（昇順で返す）。
List<String> appendStudyDate(List<String> existing, DateTime today,
    {int keepDays = studyDatesKeepDays}) {
  final t = _dayOnly(today);
  final set = {...existing, formatStudyDate(t)};
  final limit = DateTime(t.year, t.month, t.day - (keepDays - 1));
  final out = set.where((s) {
    final d = parseStudyDate(s);
    return d != null && !d.isBefore(limit);
  }).toList()
    ..sort();
  return out;
}

/// 既存ユーザー向け。連続日数 [streak] と最終学習日 [last] から、
/// 最終日までの [streak] 日分を埋める。
List<String> backfillStudyDates(int streak, DateTime? last) {
  if (streak <= 0 || last == null) return [];
  final l = _dayOnly(last);
  final n = streak > studyDatesKeepDays ? studyDatesKeepDays : streak;
  return [
    for (var i = n - 1; i >= 0; i--)
      formatStudyDate(DateTime(l.year, l.month, l.day - i)),
  ];
}

/// 学習日の集合から「連続何日目か」が節目の日を返す。
Set<DateTime> milestoneDays(Set<DateTime> studied,
    {Set<int> milestones = streakMilestones}) {
  final sorted = studied.map(_dayOnly).toSet().toList()..sort();
  final result = <DateTime>{};
  var run = 0;
  DateTime? prev;
  for (final d in sorted) {
    if (prev != null && DateTime(prev.year, prev.month, prev.day + 1) == d) {
      run++;
    } else {
      run = 1;
    }
    if (milestones.contains(run)) result.add(d);
    prev = d;
  }
  return result;
}

/// 学習完了時に1回呼ぶ。[streak] は今日を含む更新後の連続日数。
/// 初回（キー未作成）の既存ユーザーは連続日数からバックフィルする。
Future<void> recordStudyDay(SharedPreferences prefs, DateTime now,
    {required int streak}) async {
  final today = _dayOnly(now);
  final list = prefs.getStringList(studyDatesKey) ?? backfillStudyDates(streak, today);
  await prefs.setStringList(studyDatesKey, appendStudyDate(list, today));
}

Future<Set<DateTime>> loadStudyDays() async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(studyDatesKey) ?? const <String>[];
  final out = <DateTime>{};
  for (final s in list) {
    final d = parseStudyDate(s);
    if (d != null) out.add(d);
  }
  return out;
}
