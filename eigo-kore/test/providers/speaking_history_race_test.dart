import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eigo_kore/providers/speaking_history_provider.dart';

void main() {
  test('addRecord right after creation is not lost to the initial load', () async {
    SharedPreferences.setMockInitialValues({});
    final n = SpeakingHistoryNotifier();
    await n.addRecord(
        wordCount: 3, phraseCount: 2, conversationCount: 1, avgScore: 80);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(n.state.records.length, 1);
    expect(n.state.records.first.totalCount, 6);
  });

  test('first launch has no fake records', () async {
    SharedPreferences.setMockInitialValues({});
    final n = SpeakingHistoryNotifier();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(n.state.records, isEmpty);
  });
}
