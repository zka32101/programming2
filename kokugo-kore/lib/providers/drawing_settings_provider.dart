import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawingSettingsState {
  final int passingScore; // 60, 70, 80, or 90

  const DrawingSettingsState({this.passingScore = 80});

  DrawingSettingsState copyWith({int? passingScore}) =>
      DrawingSettingsState(passingScore: passingScore ?? this.passingScore);
}

class DrawingSettingsNotifier extends StateNotifier<DrawingSettingsState> {
  static const _keyPassingScore = 'drawing_passing_score';

  DrawingSettingsNotifier() : super(const DrawingSettingsState());

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final score = prefs.getInt(_keyPassingScore) ?? 80;
    state = DrawingSettingsState(passingScore: score);
  }

  Future<void> setPassingScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPassingScore, score);
    state = state.copyWith(passingScore: score);
  }
}

final drawingSettingsProvider =
    StateNotifierProvider<DrawingSettingsNotifier, DrawingSettingsState>(
  (ref) => DrawingSettingsNotifier(),
);
