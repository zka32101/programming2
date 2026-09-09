import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeakingHistory {
  final double weeklyAvgScore;
  final int weeklyWordCount;
  final int weeklyPhraseCount;
  final int weeklyConversationCount;

  SpeakingHistory({
    this.weeklyAvgScore = 0.0,
    this.weeklyWordCount = 0,
    this.weeklyPhraseCount = 0,
    this.weeklyConversationCount = 0,
  });
}

final speakingHistoryProvider = StateProvider<SpeakingHistory>((ref) {
  return SpeakingHistory();
});
