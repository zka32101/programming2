import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/screen_time_model.dart';
import '../services/weekly_report_notification_scheduler.dart';

/// 保護者向け週次レポートの元データ。
class WeeklyLearningSummary {
  final int totalMinutes;
  final int activeDays; // 0-7
  final int quizzes;
  final double accuracy; // 0-100
  final int currentStreak;
  final int? previousWeekMinutes;
  final List<String> strongTopics;
  final List<String> weakTopics;

  const WeeklyLearningSummary({
    required this.totalMinutes,
    required this.activeDays,
    required this.quizzes,
    required this.accuracy,
    this.currentStreak = 0,
    this.previousWeekMinutes,
    this.strongTopics = const [],
    this.weakTopics = const [],
  });
}

/// 通知/メール本文用に整形したレポート。
class ParentReportMessage {
  final String title;
  final String body;

  /// 保護者がお子さんにかけられる声かけ例
  final List<String> tips;
  const ParentReportMessage(
      {required this.title, required this.body, required this.tips});
}

class ParentReportBuilder {
  static ParentReportMessage build(WeeklyLearningSummary s,
      {String childName = 'お子さま'}) {
    if (s.activeDays == 0) {
      return ParentReportMessage(
        title: '📊 今週の学習レポート',
        body: '$childNameは今週まだ学習していません。1日1問からで大丈夫です。',
        tips: const ['「今日は1問だけやってみようか」と声をかけてみましょう'],
      );
    }

    final parts = <String>[
      '$childNameは今週${s.activeDays}日、合計${s.totalMinutes}分学習しました',
      '${s.quizzes}問に挑戦、正答率${s.accuracy.round()}%',
    ];
    final prev = s.previousWeekMinutes;
    if (prev != null && prev > 0) {
      final diff = s.totalMinutes - prev;
      if (diff.abs() >= 5) {
        parts.add(diff > 0 ? '先週より${diff}分アップ' : '先週より${-diff}分ダウン');
      }
    }

    final tips = <String>[];
    if (s.currentStreak >= 3) {
      tips.add('${s.currentStreak}日連続です。「続けられてすごいね」と伝えましょう');
    }
    if (s.strongTopics.isNotEmpty) {
      tips.add('${s.strongTopics.first}が得意です。教えてもらうと自信につながります');
    }
    if (s.weakTopics.isNotEmpty) {
      tips.add('${s.weakTopics.first}は復習がおすすめです');
    }
    if (s.activeDays <= 2) {
      tips.add('学習する曜日・時間帯を一緒に決めると続きやすくなります');
    }
    if (tips.isEmpty) tips.add('がんばりをほめてあげましょう');

    return ParentReportMessage(
      title: '📊 今週の学習レポート',
      body: parts.join('。'),
      tips: tips,
    );
  }
}

/// 保護者向け週次レポート通知を予約する。
///
/// [MonitoringConfig.weeklyReportEnabled] が false のときは予約せず解除する。
class ParentReportScheduler {
  ParentReportScheduler(FlutterLocalNotificationsPlugin plugin)
      : _scheduler = WeeklyReportNotificationScheduler(plugin);

  final WeeklyReportNotificationScheduler _scheduler;

  Future<void> sync({
    required MonitoringConfig config,
    required int notificationId,
    required ParentReportMessage message,
    int weekday = DateTime.sunday,
    int hour = 19,
  }) async {
    if (!config.weeklyReportEnabled) {
      await _scheduler.cancelWeeklyReport(notificationId);
      return;
    }
    await _scheduler.scheduleWeeklyReport(
      notificationId: notificationId,
      title: message.title,
      body: message.body,
      weekday: weekday,
      hour: hour,
    );
  }
}
