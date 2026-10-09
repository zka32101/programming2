import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/services/speech_service.dart';

void main() {
  group('numbersToWords', () {
    test('1桁・2桁の数字を英単語にする', () {
      expect(SpeechService.numbersToWords('1').trim(), 'one');
      expect(SpeechService.numbersToWords('10').trim(), 'ten');
      expect(SpeechService.numbersToWords('20').trim(), 'twenty');
      expect(SpeechService.numbersToWords('40').trim(), 'forty');
    });

    test('数字だけの認識結果を語に分ける', () {
      final r = SpeechService.numbersToWords('1 2 3').split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
      expect(r.toList(), ['one', 'two', 'three']);
    });

    test('「405-6」のように崩れた認識結果も1桁ずつ語にする', () {
      final r = SpeechService.numbersToWords('405-6').split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
      expect(r.toList(), ['four', 'zero', 'five', 'six']);
    });

    test('数字以外はそのまま', () {
      expect(SpeechService.numbersToWords('Hello'), 'Hello');
    });
  });

  group('calculatePronunciationScore', () {
    final svc = SpeechService();

    test('"1" と認識されても "One" は満点になる', () {
      expect(svc.calculatePronunciationScore('One', '1'), 100);
    });

    test('"1 2 3" と認識されても "One, two, three" は満点になる', () {
      expect(svc.calculatePronunciationScore('One, two, three', '1 2 3'), 100);
    });

    test('"4 5 6" と認識されても "Four, five, six" は満点になる', () {
      expect(svc.calculatePronunciationScore('Four, five, six', '4 5 6'), 100);
    });

    test('「405-6」でも、数字の語を拾って0点にならない', () {
      expect(svc.calculatePronunciationScore('Four, five, six', '405-6'), greaterThan(60));
    });

    test('関係ない数字は満点にならない', () {
      expect(svc.calculatePronunciationScore('One, two, three', '7 8 9'), lessThan(30));
    });

    test('数字を含まない既存の採点は変わらない', () {
      expect(svc.calculatePronunciationScore('Hello', 'hello'), 100);
      expect(svc.calculatePronunciationScore('Hello', ''), 0);
    });
  });
}
