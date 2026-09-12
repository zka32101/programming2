import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest_model.dart';

const _adaptiveKey = 'adaptive_stats_v1';

class StageAttempt {
  final int correct;
  final int total;

  const StageAttempt({required this.correct, required this.total});

  Map<String, dynamic> toJson() => {'c': correct, 't': total};

  factory StageAttempt.fromJson(Map<String, dynamic> j) =>
      StageAttempt(correct: j['c'] as int, total: j['t'] as int);
}

class AdaptiveState {
  final Map<String, List<StageAttempt>> stageHistory;

  const AdaptiveState({required this.stageHistory});

  static const empty = AdaptiveState(stageHistory: {});

  double accuracyFor(String stageId) {
    final history = stageHistory[stageId] ?? [];
    if (history.isEmpty) return 1.0;
    final totalCorrect = history.fold(0, (s, a) => s + a.correct);
    final totalQ = history.fold(0, (s, a) => s + a.total);
    return totalQ == 0 ? 1.0 : totalCorrect / totalQ;
  }

  int attemptsFor(String stageId) => stageHistory[stageId]?.length ?? 0;

  bool needsReview(String stageId) {
    return attemptsFor(stageId) >= 1 && accuracyFor(stageId) < 0.6;
  }

  bool isStruggling(String stageId) {
    return attemptsFor(stageId) >= 3 && accuracyFor(stageId) < 0.5;
  }

  List<String> get weakStageIds =>
      stageHistory.keys.where((id) => needsReview(id)).toList();

  int get strugglingCount =>
      stageHistory.keys.where((id) => isStruggling(id)).length;

  Stage? getWeakStage(List<Stage> allStages) {
    Stage? weakest;
    double lowestAccuracy = 1.0;
    for (final stage in allStages) {
      final id = 'g${stage.grade}_s${stage.stageNumber}';
      if (needsReview(id)) {
        final acc = accuracyFor(id);
        if (acc < lowestAccuracy) {
          lowestAccuracy = acc;
          weakest = stage;
        }
      }
    }
    return weakest;
  }

  int weakCountForGrade(int grade) {
    return stageHistory.keys
        .where((id) => id.startsWith('g${grade}_') && needsReview(id))
        .length;
  }

  AdaptiveState withAttempt(String stageId, int correct, int total) {
    final history = List<StageAttempt>.from(stageHistory[stageId] ?? []);
    history.add(StageAttempt(correct: correct, total: total));
    if (history.length > 5) history.removeAt(0);
    return AdaptiveState(stageHistory: {...stageHistory, stageId: history});
  }

  Map<String, dynamic> toJson() => stageHistory.map(
        (k, v) => MapEntry(k, v.map((a) => a.toJson()).toList()),
      );

  factory AdaptiveState.fromJson(Map<String, dynamic> j) {
    final map = j.map((k, v) => MapEntry(
          k,
          (v as List)
              .map((a) => StageAttempt.fromJson(Map<String, dynamic>.from(a as Map)))
              .toList(),
        ));
    return AdaptiveState(stageHistory: map);
  }
}

class AdaptiveNotifier extends Notifier<AdaptiveState> {
  @override
  AdaptiveState build() => AdaptiveState.empty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_adaptiveKey);
    if (raw != null) {
      try {
        state = AdaptiveState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {}
    }
  }

  Future<void> recordAttempt({
    required int grade,
    required int stageNumber,
    required int correct,
    required int total,
  }) async {
    final stageId = 'g${grade}_s$stageNumber';
    state = state.withAttempt(stageId, correct, total);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adaptiveKey, jsonEncode(state.toJson()));
  }

  Future<void> reset() async {
    state = AdaptiveState.empty;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adaptiveKey);
  }
}

final adaptiveProvider =
    NotifierProvider<AdaptiveNotifier, AdaptiveState>(AdaptiveNotifier.new);
