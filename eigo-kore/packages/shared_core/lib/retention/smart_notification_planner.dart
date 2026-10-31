import '../utils/date_key.dart';

/// 通知の語り口（A/B テストで切り替える）。
enum NotificationTone { standard, playful }

/// 保護者が決める「勉強してほしい時間帯」。時刻は 0-23 の時。
class StudyWindow {
  final int startHour;
  final int endHour; // 終了（この時は含まない）

  const StudyWindow({required this.startHour, required this.endHour});

  /// 「夜の勉強時間」プリセット（18-20 時）。
  static const evening = StudyWindow(startHour: 18, endHour: 20);

  /// 「帰宅後」プリセット（16-18 時）。
  static const afterSchool = StudyWindow(startHour: 16, endHour: 18);

  /// 「朝の勉強時間」プリセット（7-8 時）。
  static const morning = StudyWindow(startHour: 7, endHour: 8);

  bool contains(int hour) => hour >= startHour && hour < endHour;

  Map<String, dynamic> toJson() => {'s': startHour, 'e': endHour};

  factory StudyWindow.fromJson(Map<String, dynamic> j) =>
      StudyWindow(startHour: j['s'] as int, endHour: j['e'] as int);
}

/// 通知文面を決めるための現在の状況。
class NotificationContext {
  final int currentStreak;
  final int daysAway; // 最後に学習してからの日数（今日学習済みなら 0）
  final bool doneToday;
  final int dueReviewCount;

  const NotificationContext({
    this.currentStreak = 0,
    this.daysAway = 0,
    this.doneToday = false,
    this.dueReviewCount = 0,
  });
}

/// 計画された通知 1 件。
class PlannedNotification {
  final int hour;
  final int minute;
  final String title;
  final String body;
  final String reason; // 'comeback' | 'review' | 'streak' | 'daily'

  /// true の場合、今日はもう学習済みなので「明日」から送る。
  final bool startTomorrow;

  const PlannedNotification({
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    required this.reason,
    required this.startTomorrow,
  });
}

/// 学習時間帯の履歴から通知時刻を選び、状況に合った文面を作る純粋ロジック。
class SmartNotificationPlanner {
  static const defaultHour = 17;
  static const minSamples = 5;

  /// 0-23 の時ごとのヒストグラムに [hour] の活動を 1 回加える。
  static List<int> recordHour(List<int> histogram, int hour) {
    final h = List<int>.of(normalize(histogram));
    h[hour.clamp(0, 23)] += 1;
    return h;
  }

  static List<int> normalize(List<int> h) =>
      h.length == 24 ? h : List<int>.filled(24, 0);

  /// 夜間（[quietStartHour] 以上 or [quietEndHour] 未満）か。
  static bool isQuietHour(int hour, int quietStartHour, int quietEndHour) {
    if (quietStartHour == quietEndHour) return false;
    return quietStartHour > quietEndHour
        ? (hour >= quietStartHour || hour < quietEndHour)
        : (hour >= quietStartHour && hour < quietEndHour);
  }

  /// 通知を送る時刻（時）を選ぶ。
  ///
  /// - 夜間は必ず避ける
  /// - [window] があれば、その範囲内で最も活動の多い時を選ぶ
  /// - 履歴が少ないときは [window] の開始時、なければ [defaultHour]
  static int recommendHour(
    List<int> histogram, {
    int quietStartHour = 21,
    int quietEndHour = 7,
    StudyWindow? window,
  }) {
    final h = normalize(histogram);
    bool allowed(int x) =>
        !isQuietHour(x, quietStartHour, quietEndHour) &&
        (window == null || window.contains(x));

    final candidates = [for (var x = 0; x < 24; x++) if (allowed(x)) x];
    final fallback = window != null && allowed(window.startHour)
        ? window.startHour
        : (isQuietHour(defaultHour, quietStartHour, quietEndHour)
            ? quietEndHour
            : defaultHour);
    if (candidates.isEmpty) return fallback;

    if (h.fold<int>(0, (a, b) => a + b) < minSamples) {
      return candidates.contains(defaultHour) ? defaultHour : fallback;
    }

    double score(int x) =>
        h[x] + 0.5 * (h[(x + 23) % 24] + h[(x + 1) % 24]);
    var best = candidates.first;
    for (final c in candidates) {
      if (score(c) > score(best)) best = c;
    }
    return best;
  }

  /// 状況に合った文面を作る。
  static PlannedNotification plan({
    required List<int> histogram,
    required NotificationContext context,
    NotificationTone tone = NotificationTone.standard,
    int quietStartHour = 21,
    int quietEndHour = 7,
    StudyWindow? window,
  }) {
    final hour = recommendHour(
      histogram,
      quietStartHour: quietStartHour,
      quietEndHour: quietEndHour,
      window: window,
    );
    final playful = tone == NotificationTone.playful;
    String title, body, reason;

    if (context.daysAway >= 7) {
      reason = 'comeback';
      title = playful ? 'キャラたちが待ってるよ！' : 'おかえりなさい！';
      body = 'しばらくぶり！やさしい問題から再開しよう';
    } else if (context.daysAway >= 3) {
      reason = 'comeback';
      title = '${context.daysAway}日ぶりだね';
      body = playful ? '今日は1問だけでもOK！いっしょにやろう' : '1問だけでも今日の学習を始めよう';
    } else if (context.dueReviewCount > 0) {
      reason = 'review';
      title = '今日の復習 ${context.dueReviewCount}問';
      body = playful ? '前にまちがえた問題、今ならきっと解けるよ！' : '忘れる前に復習しよう';
    } else if (context.currentStreak >= 2) {
      reason = 'streak';
      title = '🔥${context.currentStreak}日連続中！';
      body = playful ? '記録がとぎれちゃう前に、あと1問！' : '今日学習すると連続記録がのびます';
    } else {
      reason = 'daily';
      title = '今日のクイズ';
      body = playful ? 'ちょっとだけ挑戦してみよう！' : '今日も少しだけ学習しよう';
    }

    return PlannedNotification(
      hour: hour,
      minute: 0,
      title: title,
      body: body,
      reason: reason,
      startTomorrow: context.doneToday,
    );
  }

  /// 最終学習日 [lastActive] から今日 [today] までの経過日数。
  static int daysAway(DateTime? lastActive, DateTime today) =>
      lastActive == null ? 0 : calendarDaysBetween(lastActive, today).clamp(0, 9999);
}
