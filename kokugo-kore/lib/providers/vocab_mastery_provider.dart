// lib/providers/vocab_mastery_provider.dart
// Tracks how many times each vocabulary word has been answered correctly.
// Words answered correctly 2+ times are excluded from future quizzes.

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VocabMasteryState {
  // word → correct count
  final Map<String, int> correctCounts;

  const VocabMasteryState(this.correctCounts);

  bool isMastered(String word) => (correctCounts[word] ?? 0) >= 2;

  VocabMasteryState withCorrect(String word) {
    final updated = Map<String, int>.from(correctCounts);
    updated[word] = (updated[word] ?? 0) + 1;
    return VocabMasteryState(updated);
  }
}

class VocabMasteryNotifier extends StateNotifier<VocabMasteryState> {
  static const _key = 'vocab_mastery_v1';

  VocabMasteryNotifier() : super(const VocabMasteryState({}));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      try {
        final map = (jsonDecode(raw) as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as int));
        state = VocabMasteryState(map);
      } catch (_) {}
    }
  }

  Future<void> recordCorrect(String word) async {
    state = state.withCorrect(word);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.correctCounts));
  }

  Future<void> reset() async {
    state = const VocabMasteryState({});
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

final vocabMasteryProvider =
    StateNotifierProvider<VocabMasteryNotifier, VocabMasteryState>(
  (ref) => VocabMasteryNotifier(),
);
