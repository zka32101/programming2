import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/services/speech_service.dart';

void main() {
  final svc = SpeechService();

  test('exact match is 100 and deterministic', () {
    expect(svc.calculatePronunciationScore('Hello', 'hello'), 100);
    expect(svc.calculatePronunciationScore('Thank you very much', 'thank you very much!'), 100);
  });

  test('empty recognition is 0', () {
    expect(svc.calculatePronunciationScore('Hello', ''), 0);
  });

  test('close but wrong word does not pass', () {
    expect(svc.calculatePronunciationScore('Hello', 'hell'), lessThan(70));
    expect(svc.calculatePronunciationScore('Goodbye', 'good'), lessThan(70));
  });

  test('missing or extra words are penalised', () {
    expect(svc.calculatePronunciationScore('Thank you very much', 'thank you'), lessThan(70));
    expect(svc.calculatePronunciationScore('Thank you', 'oh thank you very much'), lessThan(70));
  });

  test('wrong order does not score well', () {
    expect(svc.calculatePronunciationScore('good morning', 'morning good'), lessThan(70));
  });

  test('same input gives same score', () {
    final a = svc.calculatePronunciationScore('How are you', 'how r you');
    final b = svc.calculatePronunciationScore('How are you', 'how r you');
    expect(a, b);
  });
}
