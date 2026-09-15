import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _timerActiveKey = 'learning_timer_active';
const _timerEndKey = 'learning_timer_end_ms';
const _timerMinutesKey = 'learning_timer_target_minutes';

class LearningTimerState {
  final bool isActive;
  final int targetMinutes;
  final int remainingSeconds;

  const LearningTimerState({
    this.isActive = false,
    this.targetMinutes = 30,
    this.remainingSeconds = 0,
  });

  LearningTimerState copyWith({
    bool? isActive,
    int? targetMinutes,
    int? remainingSeconds,
  }) =>
      LearningTimerState(
        isActive: isActive ?? this.isActive,
        targetMinutes: targetMinutes ?? this.targetMinutes,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      );

  String get displayTime {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (!isActive || targetMinutes == 0) return 0.0;
    final total = targetMinutes * 60;
    final elapsed = total - remainingSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  bool get isAlmostDone => isActive && remainingSeconds <= 300 && remainingSeconds > 0;
  bool get isExpired => isActive && remainingSeconds <= 0;
}

class LearningTimerNotifier extends Notifier<LearningTimerState> {
  Timer? _ticker;

  @override
  LearningTimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
    });
    return const LearningTimerState();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final active = prefs.getBool(_timerActiveKey) ?? false;
    if (!active) return;

    final endMs = prefs.getInt(_timerEndKey);
    final targetMinutes = prefs.getInt(_timerMinutesKey) ?? 30;
    if (endMs == null) return;

    final endTime = DateTime.fromMillisecondsSinceEpoch(endMs);
    final remaining = endTime.difference(DateTime.now());
    if (remaining.inSeconds <= 0) {
      await _clearPrefs(prefs);
      return;
    }

    state = LearningTimerState(
      isActive: true,
      targetMinutes: targetMinutes,
      remainingSeconds: remaining.inSeconds,
    );
    _startTicker();
  }

  Future<void> start(int minutes) async {
    _ticker?.cancel();

    final endTime = DateTime.now().add(Duration(minutes: minutes));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_timerActiveKey, true);
    await prefs.setInt(_timerEndKey, endTime.millisecondsSinceEpoch);
    await prefs.setInt(_timerMinutesKey, minutes);

    state = LearningTimerState(
      isActive: true,
      targetMinutes: minutes,
      remainingSeconds: minutes * 60,
    );
    _startTicker();
  }

  Future<void> stop() async {
    _ticker?.cancel();
    _ticker = null;
    final prefs = await SharedPreferences.getInstance();
    await _clearPrefs(prefs);
    state = const LearningTimerState();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = state.remainingSeconds - 1;
      if (remaining <= 0) {
        _ticker?.cancel();
        _ticker = null;
        state = state.copyWith(remainingSeconds: 0);
        _onExpired();
      } else {
        state = state.copyWith(remainingSeconds: remaining);
      }
    });
  }

  void _onExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await _clearPrefs(prefs);
    state = state.copyWith(remainingSeconds: 0);
  }

  Future<void> _clearPrefs(SharedPreferences prefs) async {
    await prefs.remove(_timerActiveKey);
    await prefs.remove(_timerEndKey);
    await prefs.remove(_timerMinutesKey);
  }
}

final learningTimerProvider =
    NotifierProvider<LearningTimerNotifier, LearningTimerState>(
        LearningTimerNotifier.new);
