import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'smart_notification_planner.dart';

/// [PlannedNotification] を `FlutterLocalNotificationsPlugin` に 1 件予約する。
///
/// プラグインの初期化・権限取得は各アプリの通知サービス側で行う
/// （`WeeklyReportNotificationScheduler` と同じ方針）。
/// 学習のたびに予約し直す運用（毎回 cancel → 再予約）を想定し、
/// 繰り返しではなく「次の 1 回」だけを予約する。
class SmartReminderScheduler {
  SmartReminderScheduler(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> schedule(
    PlannedNotification plan, {
    required int notificationId,
    String channelId = 'smart_reminder_channel',
    String channelName = '学習リマインダー',
    DateTime? now,
  }) async {
    await _plugin.cancel(notificationId);
    final at = nextFireTime(plan, now ?? DateTime.now());
    await _plugin.zonedSchedule(
      notificationId,
      plan.title,
      plan.body,
      tz.TZDateTime.from(at, tz.UTC),
      NotificationDetails(
        android: AndroidNotificationDetails(channelId, channelName),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int notificationId) => _plugin.cancel(notificationId);

  /// 次に送る日時（ローカル時刻）。今日学習済み、または今日の時刻を過ぎていれば翌日。
  static DateTime nextFireTime(PlannedNotification plan, DateTime now) {
    var at = DateTime(now.year, now.month, now.day, plan.hour, plan.minute);
    if (plan.startTomorrow || !at.isAfter(now)) {
      at = DateTime(now.year, now.month, now.day + 1, plan.hour, plan.minute);
    }
    return at;
  }
}
