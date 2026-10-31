/// ローカル日付を 'YYYY-MM-DD' 形式の文字列にする。
String dateKeyOf(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// 'YYYY-MM-DD' を日付（時刻 0:00）に戻す。不正な値は null。
DateTime? parseDateKey(String? s) {
  if (s == null) return null;
  final p = s.split('-');
  if (p.length != 3) return null;
  final y = int.tryParse(p[0]), m = int.tryParse(p[1]), d = int.tryParse(p[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

/// 2つの日付の暦日差（DST の影響を受けない）。
int calendarDaysBetween(DateTime from, DateTime to) =>
    DateTime.utc(to.year, to.month, to.day)
        .difference(DateTime.utc(from.year, from.month, from.day))
        .inDays;
