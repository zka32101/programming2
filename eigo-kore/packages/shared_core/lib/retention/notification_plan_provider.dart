import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'smart_notification_planner.dart';

const _histKey = 'sc_retention_hour_hist';
const _quietKey = 'sc_retention_quiet_hours';
const _windowKey = 'sc_retention_study_window';

class NotificationPlanState {
  final List<int> hourHistogram;
  final int quietStartHour;
  final int quietEndHour;

  /// 保護者が設定した勉強時間帯（null = 指定なし）
  final StudyWindow? studyWindow;

  const NotificationPlanState({
    required this.hourHistogram,
    this.quietStartHour = 21,
    this.quietEndHour = 7,
    this.studyWindow,
  });

  NotificationPlanState copyWith({
    List<int>? hourHistogram,
    int? quietStartHour,
    int? quietEndHour,
    StudyWindow? studyWindow,
    bool clearStudyWindow = false,
  }) =>
      NotificationPlanState(
        hourHistogram: hourHistogram ?? this.hourHistogram,
        quietStartHour: quietStartHour ?? this.quietStartHour,
        quietEndHour: quietEndHour ?? this.quietEndHour,
        studyWindow: clearStudyWindow ? null : (studyWindow ?? this.studyWindow),
      );
}

/// 学習した時間帯を記録し、通知計画を作る。
///
/// 使い方: アプリ起動時に `load()`、クイズ完了時に `recordActivity()`、
/// 通知を予約するときに `planFor(...)` の結果をアプリ側の通知サービスへ渡す。
class NotificationPlanNotifier extends Notifier<NotificationPlanState> {
  @override
  NotificationPlanState build() =>
      NotificationPlanState(hourHistogram: List<int>.filled(24, 0));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    var hist = List<int>.filled(24, 0);
    final rawHist = prefs.getString(_histKey);
    if (rawHist != null) {
      try {
        hist = SmartNotificationPlanner.normalize(
            (jsonDecode(rawHist) as List).cast<int>());
      } catch (_) {}
    }
    final quiet = prefs.getStringList(_quietKey);
    StudyWindow? window;
    final rawWindow = prefs.getString(_windowKey);
    if (rawWindow != null) {
      try {
        window = StudyWindow.fromJson(
            jsonDecode(rawWindow) as Map<String, dynamic>);
      } catch (_) {}
    }
    state = NotificationPlanState(
      hourHistogram: hist,
      quietStartHour: quiet != null ? int.tryParse(quiet[0]) ?? 21 : 21,
      quietEndHour: quiet != null ? int.tryParse(quiet[1]) ?? 7 : 7,
      studyWindow: window,
    );
  }

  /// 学習した時刻を記録する（クイズ完了時などに呼ぶ）。
  Future<void> recordActivity([DateTime? at]) async {
    final hist = SmartNotificationPlanner.recordHour(
        state.hourHistogram, (at ?? DateTime.now()).hour);
    state = state.copyWith(hourHistogram: hist);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_histKey, jsonEncode(hist));
  }

  /// 保護者が「勉強時間帯」を設定する（null で解除）。
  Future<void> setStudyWindow(StudyWindow? window) async {
    state = window == null
        ? state.copyWith(clearStudyWindow: true)
        : state.copyWith(studyWindow: window);
    final prefs = await SharedPreferences.getInstance();
    if (window == null) {
      await prefs.remove(_windowKey);
    } else {
      await prefs.setString(_windowKey, jsonEncode(window.toJson()));
    }
  }

  Future<void> setQuietHours(int startHour, int endHour) async {
    state = state.copyWith(quietStartHour: startHour, quietEndHour: endHour);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_quietKey, ['$startHour', '$endHour']);
  }

  /// 現在の状況から通知計画を作る。
  PlannedNotification planFor(
    NotificationContext context, {
    NotificationTone tone = NotificationTone.standard,
  }) =>
      SmartNotificationPlanner.plan(
        histogram: state.hourHistogram,
        context: context,
        tone: tone,
        quietStartHour: state.quietStartHour,
        quietEndHour: state.quietEndHour,
        window: state.studyWindow,
      );
}

final notificationPlanProvider =
    NotifierProvider<NotificationPlanNotifier, NotificationPlanState>(
        NotificationPlanNotifier.new);
