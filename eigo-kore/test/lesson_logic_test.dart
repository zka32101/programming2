import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/models/question.dart';
import 'package:eigo_kore/services/speech_service.dart';
import 'package:eigo_kore/utils/listening_accuracy.dart';

Question _q(String id, QuestionType t) => Question(
      id: id,
      type: t,
      difficulty: DifficultyLevel.beginner,
      text: 't',
      textJa: 'j',
      correctAnswer: 'a',
    );

typedef _Log = ({String id, QuestionType type, bool correct, int speakingScore});
_Log _l(String id, QuestionType t, bool c) =>
    (id: id, type: t, correct: c, speakingScore: 0);

void main() {
  group('listeningAccuracyOf', () {
    test('他タイプの正解を数えず、100%を超えない(214%の再現)', () {
      final qs = [
        _q('l1', QuestionType.listening),
        _q('l2', QuestionType.listening),
        for (var i = 0; i < 6; i++) _q('r$i', QuestionType.reading),
      ];
      final log = [
        _l('l1', QuestionType.listening, true),
        _l('l2', QuestionType.listening, false),
        for (var i = 0; i < 6; i++) _l('r$i', QuestionType.reading, true),
      ];
      expect(listeningAccuracyOf(qs, log), 0.5);
    });
    test('全問正解で1.0・リスニング無しで0', () {
      final qs = [_q('l1', QuestionType.listening)];
      expect(listeningAccuracyOf(qs, [_l('l1', QuestionType.listening, true)]), 1.0);
      expect(listeningAccuracyOf([_q('r', QuestionType.reading)], []), 0.0);
    });
  });

  group('音声認識の待ち時間', () {
    test('語数が多いほど無音の許容が長い', () {
      expect(SpeechService.pauseForFor('Hello').inSeconds, 2);
      expect(SpeechService.pauseForFor('Good morning').inSeconds, 3);
      expect(SpeechService.pauseForFor('Seven, eight, nine, ten').inSeconds, 4);
      expect(SpeechService.pauseForFor(null).inSeconds, 3);
    });
    test('listenForは8〜14秒', () {
      expect(SpeechService.listenForFor('Hello').inSeconds, 8);
      expect(SpeechService.listenForFor('a b c d e f g h i j k l m n o').inSeconds, 14);
    });
  });
}
