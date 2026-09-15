// lib/providers/drawing_progress_provider.dart
// Persist drawing (かく) scores across sessions via SharedPreferences
// Key format:  draw_{mode}_{index}   e.g. draw_hiragana_3

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _drawPrefix = 'draw_';

class DrawingProgress {
  final Map<String, int> scores; // key → score

  const DrawingProgress(this.scores);

  int? getScore(String mode, int index) => scores['${_drawPrefix}${mode}_$index'];

  bool isCleared(String mode, int index) {
    final s = getScore(mode, index);
    return s != null && s >= 80;
  }

  bool isPassed(String mode, int index, int passingScore) {
    final s = getScore(mode, index);
    return s != null && s >= passingScore;
  }

  DrawingProgress withScore(String mode, int index, int score) {
    final updated = Map<String, int>.from(scores);
    final key = '${_drawPrefix}${mode}_$index';
    // Keep best score
    final current = updated[key] ?? 0;
    if (score > current) updated[key] = score;
    return DrawingProgress(updated);
  }
}

class DrawingProgressNotifier extends Notifier<DrawingProgress> {
  @override
  DrawingProgress build() => const DrawingProgress({});

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_drawPrefix));
    final scores = <String, int>{};
    for (final k in keys) {
      scores[k] = prefs.getInt(k) ?? 0;
    }
    state = DrawingProgress(scores);
  }

  Future<void> saveScore(String mode, int index, int score) async {
    final key = '${_drawPrefix}${mode}_$index';
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(key) ?? 0;
    if (score > current) {
      await prefs.setInt(key, score);
    }
    state = state.withScore(mode, index, score);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_drawPrefix)).toList();
    for (final k in keys) await prefs.remove(k);
    state = const DrawingProgress({});
  }

  Future<void> resetMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = '${_drawPrefix}${mode}_';
    final keys = prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (final k in keys) await prefs.remove(k);
    final remaining = Map<String, int>.from(state.scores)
      ..removeWhere((k, _) => k.startsWith(prefix));
    state = DrawingProgress(remaining);
  }
}

final drawingProgressProvider =
    NotifierProvider<DrawingProgressNotifier, DrawingProgress>(
        DrawingProgressNotifier.new);
