/// 利用時間制限（スクリーンタイム管理）の共通モデル。
///
/// 各アプリは [BaseScreenTimeNotifier]（`providers/screen_time_provider.dart`）を
/// 継承し、これらのモデルをそのまま利用する想定。

/// 保護者が設定する制限内容。
class ScreenTimeSettings {
  /// 1日の利用上限（分）。null の場合は無制限。
  final int? dailyLimitMinutes;

  /// 機能そのもののON/OFF。false の場合は [dailyLimitMinutes] に関わらず
  /// 制限を適用しない。
  final bool enabled;

  /// Phase 4.21: 時間帯別の利用制限リスト。
  /// 複数の TimeSlot を設定可能（平日朝は30分、午後は60分など）。
  final List<TimeSlot> timeSlots;

  /// Phase 4.21: 保護者向けの監視・通知設定。
  final MonitoringConfig monitoringConfig;

  const ScreenTimeSettings({
    this.dailyLimitMinutes,
    this.enabled = false,
    this.timeSlots = const [],
    this.monitoringConfig = const MonitoringConfig(),
  });

  ScreenTimeSettings copyWith({
    int? dailyLimitMinutes,
    bool clearDailyLimitMinutes = false,
    bool? enabled,
    List<TimeSlot>? timeSlots,
    MonitoringConfig? monitoringConfig,
  }) =>
      ScreenTimeSettings(
        dailyLimitMinutes: clearDailyLimitMinutes
            ? null
            : (dailyLimitMinutes ?? this.dailyLimitMinutes),
        enabled: enabled ?? this.enabled,
        timeSlots: timeSlots ?? this.timeSlots,
        monitoringConfig: monitoringConfig ?? this.monitoringConfig,
      );

  Map<String, dynamic> toJson() => {
        'dailyLimitMinutes': dailyLimitMinutes,
        'enabled': enabled,
        'timeSlots': timeSlots.map((t) => t.toJson()).toList(),
        'monitoringConfig': monitoringConfig.toJson(),
      };

  factory ScreenTimeSettings.fromJson(Map<String, dynamic> j) =>
      ScreenTimeSettings(
        dailyLimitMinutes: j['dailyLimitMinutes'] as int?,
        enabled: j['enabled'] as bool? ?? false,
        timeSlots: ((j['timeSlots'] as List?) ?? [])
            .cast<Map<String, dynamic>>()
            .map((t) => TimeSlot.fromJson(t))
            .toList(),
        monitoringConfig: j['monitoringConfig'] != null
            ? MonitoringConfig.fromJson(j['monitoringConfig'] as Map<String, dynamic>)
            : const MonitoringConfig(),
      );
}

/// ある1日の利用実績。
class ScreenTimeUsage {
  /// 'YYYY-MM-DD' 形式の日付文字列（ローカル日付）。
  final String date;

  /// その日の利用済み分数。
  final int usedMinutes;

  const ScreenTimeUsage({
    required this.date,
    this.usedMinutes = 0,
  });

  ScreenTimeUsage copyWith({
    String? date,
    int? usedMinutes,
  }) =>
      ScreenTimeUsage(
        date: date ?? this.date,
        usedMinutes: usedMinutes ?? this.usedMinutes,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'usedMinutes': usedMinutes,
      };

  factory ScreenTimeUsage.fromJson(Map<String, dynamic> j) => ScreenTimeUsage(
        date: j['date'] as String? ?? '',
        usedMinutes: j['usedMinutes'] as int? ?? 0,
      );
}

/// Phase 4.21: 時間帯別の利用制限設定。
/// 平日/休日別、朝/昼/夜などの時間帯ごとに上限を設定可能。
class TimeSlot {
  /// 'weekday' または 'weekend'
  final String dayType;

  /// HH:MM 形式の開始時刻（例: '09:00'）
  final String startTime;

  /// HH:MM 形式の終了時刻（例: '12:00'）
  final String endTime;

  /// その時間帯の利用上限（分）。null の場合は制限なし。
  final int? limitMinutes;

  const TimeSlot({
    required this.dayType,
    required this.startTime,
    required this.endTime,
    this.limitMinutes,
  });

  TimeSlot copyWith({
    String? dayType,
    String? startTime,
    String? endTime,
    int? limitMinutes,
    bool clearLimitMinutes = false,
  }) =>
      TimeSlot(
        dayType: dayType ?? this.dayType,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        limitMinutes:
            clearLimitMinutes ? null : (limitMinutes ?? this.limitMinutes),
      );

  Map<String, dynamic> toJson() => {
        'dayType': dayType,
        'startTime': startTime,
        'endTime': endTime,
        'limitMinutes': limitMinutes,
      };

  factory TimeSlot.fromJson(Map<String, dynamic> j) => TimeSlot(
        dayType: j['dayType'] as String? ?? 'weekday',
        startTime: j['startTime'] as String? ?? '09:00',
        endTime: j['endTime'] as String? ?? '12:00',
        limitMinutes: j['limitMinutes'] as int?,
      );
}

/// Phase 4.21: 保護者向け監視・通知設定。
class MonitoringConfig {
  /// 上限に達する前に通知する割合（0.0-1.0）。例: 0.8 = 80%
  final double notificationThreshold;

  /// 通知を有効にするか。
  final bool notificationsEnabled;

  /// 週単位のレポート生成を有効にするか。
  final bool weeklyReportEnabled;

  const MonitoringConfig({
    this.notificationThreshold = 0.8,
    this.notificationsEnabled = true,
    this.weeklyReportEnabled = true,
  });

  MonitoringConfig copyWith({
    double? notificationThreshold,
    bool? notificationsEnabled,
    bool? weeklyReportEnabled,
  }) =>
      MonitoringConfig(
        notificationThreshold:
            notificationThreshold ?? this.notificationThreshold,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        weeklyReportEnabled: weeklyReportEnabled ?? this.weeklyReportEnabled,
      );

  Map<String, dynamic> toJson() => {
        'notificationThreshold': notificationThreshold,
        'notificationsEnabled': notificationsEnabled,
        'weeklyReportEnabled': weeklyReportEnabled,
      };

  factory MonitoringConfig.fromJson(Map<String, dynamic> j) =>
      MonitoringConfig(
        notificationThreshold: j['notificationThreshold'] as double? ?? 0.8,
        notificationsEnabled: j['notificationsEnabled'] as bool? ?? true,
        weeklyReportEnabled: j['weeklyReportEnabled'] as bool? ?? true,
      );
}

/// Phase 4.21: 週間・月間の利用統計レポート。
class UsageReport {
  /// レポート開始日（'YYYY-MM-DD'）
  final String startDate;

  /// レポート終了日（'YYYY-MM-DD'）
  final String endDate;

  /// 期間内の総利用時間（分）
  final int totalMinutes;

  /// 期間内の日数
  final int dayCount;

  /// 1日あたりの平均利用時間（分）
  final double averageMinutesPerDay;

  /// 日別の利用時間（Map<YYYY-MM-DD, 分数>）
  final Map<String, int> dailyBreakdown;

  const UsageReport({
    required this.startDate,
    required this.endDate,
    required this.totalMinutes,
    required this.dayCount,
    required this.averageMinutesPerDay,
    required this.dailyBreakdown,
  });

  UsageReport copyWith({
    String? startDate,
    String? endDate,
    int? totalMinutes,
    int? dayCount,
    double? averageMinutesPerDay,
    Map<String, int>? dailyBreakdown,
  }) =>
      UsageReport(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        totalMinutes: totalMinutes ?? this.totalMinutes,
        dayCount: dayCount ?? this.dayCount,
        averageMinutesPerDay: averageMinutesPerDay ?? this.averageMinutesPerDay,
        dailyBreakdown: dailyBreakdown ?? this.dailyBreakdown,
      );

  Map<String, dynamic> toJson() => {
        'startDate': startDate,
        'endDate': endDate,
        'totalMinutes': totalMinutes,
        'dayCount': dayCount,
        'averageMinutesPerDay': averageMinutesPerDay,
        'dailyBreakdown': dailyBreakdown,
      };

  factory UsageReport.fromJson(Map<String, dynamic> j) => UsageReport(
        startDate: j['startDate'] as String? ?? '',
        endDate: j['endDate'] as String? ?? '',
        totalMinutes: j['totalMinutes'] as int? ?? 0,
        dayCount: j['dayCount'] as int? ?? 0,
        averageMinutesPerDay: j['averageMinutesPerDay'] as double? ?? 0.0,
        dailyBreakdown:
            Map<String, int>.from(j['dailyBreakdown'] as Map? ?? {}),
      );
}
