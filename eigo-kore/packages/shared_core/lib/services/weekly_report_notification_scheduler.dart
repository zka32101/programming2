import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

/// 保護者向け週次サマリー通知のスケジューリングを共通化したヘルパー。
///
/// shogaku-kore-programming の `notification_service.dart`
/// (`scheduleWeeklyReport()` / `sendWeeklyReportNow()`) を一般化したもの。
///
/// このクラスは通知の「初期化」や「権限リクエスト」は行わない。
/// `FlutterLocalNotificationsPlugin` の初期化・パーミッション管理は
/// 各アプリの既存の通知サービス（例: `NotificationService`）が担当し、
/// このクラスにはそのインスタンスを渡すだけでよい。
///
/// 使い方の例:
/// ```dart
/// final scheduler = WeeklyReportNotificationScheduler(myPlugin);
///
/// // 毎週日曜 19:00 に通知をスケジュール
/// await scheduler.scheduleWeeklyReport(
///   notificationId: 3,
///   title: '📊 週次レポート',
///   body: '今週もがんばろう！先週の成果を確認してみよう✨',
/// );
///
/// // 重複送信防止付きで即時送信する場合
/// if (await scheduler.shouldSendThisWeek('weekly_report_sent_week')) {
///   await myPlugin.show(3, title, body, details);
///   await scheduler.markSentThisWeek('weekly_report_sent_week');
/// }
/// ```
class WeeklyReportNotificationScheduler {
  WeeklyReportNotificationScheduler(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  // ── スケジューリング ──────────────────────────────────────────

  /// 指定した曜日・時刻に繰り返し週次レポート通知をスケジュールする。
  ///
  /// [notificationId] は通知ID（アプリ内で他の通知と重複しない値を指定）。
  /// [title] / [body] は通知の文言（アプリごとにカスタマイズ可能）。
  /// [weekday] は `DateTime.monday`〜`DateTime.sunday`（デフォルトは日曜）。
  /// [hour] / [minute] は送信時刻（デフォルトは 19:00）。
  /// [importance] / [priority] は通知の重要度（デフォルトは通常）。
  /// [channelId] / [channelName] は Android の通知チャンネル
  /// （未指定の場合はデフォルトの週次レポート用チャンネルを使う）。
  Future<void> scheduleWeeklyReport({
    required int notificationId,
    required String title,
    required String body,
    int weekday = DateTime.sunday,
    int hour = 19,
    int minute = 0,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
    String channelId = 'weekly_report_channel',
    String channelName = '週次レポート',
  }) async {
    await _plugin.cancel(notificationId);

    final scheduledTime = _nextOccurrenceOfWeekday(weekday, hour, minute);

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: importance,
          priority: priority,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// スケジュール済みの週次レポート通知を解除する。
  Future<void> cancelWeeklyReport(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  // ── 重複送信防止（送信済み週の管理） ────────────────────────────

  /// [storageKey] に保存されている「最後に送信した週」と今週を比較し、
  /// まだ今週分を送信していなければ true を返す。
  ///
  /// 「週」は ISO8601 の年+週番号（例: `2026-W37`）で判定するため、
  /// 端末のタイムゾーンやアプリの再起動タイミングに関わらず
  /// 同じ週内での重複送信を防げる。
  Future<bool> shouldSendThisWeek(String storageKey) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSent = prefs.getString(storageKey);
    return lastSent != _currentWeekKey();
  }

  /// 今週分の週次レポートを送信済みとして [storageKey] に記録する。
  Future<void> markSentThisWeek(String storageKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, _currentWeekKey());
  }

  // ── ヘルパー ──────────────────────────────────────────────────

  /// 次に来る [weekday] の [hour]:[minute] を返す（デバイスのローカル時刻基準）。
  /// すでに今日がその曜日かつ時刻を過ぎている場合は翌週になる。
  tz.TZDateTime _nextOccurrenceOfWeekday(int weekday, int hour, int minute) {
    final nowLocal = DateTime.now();
    final daysUntil = (weekday - nowLocal.weekday + 7) % 7;
    var nextLocal = DateTime(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day + daysUntil,
      hour,
      minute,
    );
    if (nextLocal.isBefore(nowLocal)) {
      nextLocal = nextLocal.add(const Duration(days: 7));
    }
    // Dart の DateTime.now() は常にデバイスローカル時刻のため、
    // 同じ瞬間を保ったまま TZDateTime(UTC) に変換する
    // （tz.local が setLocalLocation() 未呼び出しで UTC 扱いになる問題を回避）。
    return tz.TZDateTime.from(nextLocal, tz.UTC);
  }

  /// 今週を表すキー（例: `2026-W37`）を返す。ISO8601 の週番号（月曜始まり）を使う。
  String _currentWeekKey() {
    final now = DateTime.now();
    final year = _isoWeekYear(now);
    final week = _isoWeekNumber(now);
    return '$year-W${week.toString().padLeft(2, '0')}';
  }

  int _isoWeekNumber(DateTime date) {
    final thursday = date.add(Duration(days: 3 - ((date.weekday + 6) % 7)));
    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    final dayOfYear = thursday.difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear - 1) / 7).floor() + 1;
  }

  int _isoWeekYear(DateTime date) {
    final thursday = date.add(Duration(days: 3 - ((date.weekday + 6) % 7)));
    return thursday.year;
  }
}
