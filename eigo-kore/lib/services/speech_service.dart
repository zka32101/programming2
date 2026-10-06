import 'dart:math' as math;
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._();
  factory SpeechService() => _instance;
  SpeechService._();

  final SpeechToText _speech = SpeechToText();
  bool _available = false;
  bool _initialized = false;

  Future<bool> init() async {
    if (_initialized) return _available;
    _available = await _speech.initialize(
      onError: (error) {},
      onStatus: (status) {},
    );
    _initialized = true;
    return _available;
  }

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    // Initialize lazily so the mic permission prompt appears only when the
    // learner actually starts speaking.
    if (!await init()) return;
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        localeId: 'en_US',
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  // 発音スコアを計算（0-100）
  //
  // 認識結果は音声認識側で補正されるため、甘くなりやすい。そこで
  // ・語順どおりに対応づける（順不同・余計な語は減点）
  // ・語ごとの類似度は3乗して、部分一致の加点を小さくする
  // ・乱数のゆらぎは入れない（同じ発音は同じ点）
  // という厳しめの採点にしている。
  int calculatePronunciationScore(String expected, String recognized) {
    if (recognized.isEmpty) return 0;

    final exp = _normalize(expected);
    final rec = _normalize(recognized);
    if (exp.isEmpty || rec.isEmpty) return 0;
    if (exp == rec) return 100;

    final expWords = exp.split(' ');
    final recWords = rec.split(' ');

    // 語順を保ったまま、期待語ごとに最も近い認識語を前から順に対応づける
    var credit = 0.0;
    var pos = 0;
    for (final word in expWords) {
      var best = 0.0;
      var bestIdx = -1;
      for (var i = pos; i < recWords.length; i++) {
        final sim = _similarity(recWords[i], word);
        if (sim > best) {
          best = sim;
          bestIdx = i;
        }
      }
      if (best >= 0.6 && bestIdx >= 0) {
        credit += best * best * best;
        pos = bestIdx + 1;
      }
    }
    final denom = math.max(expWords.length, recWords.length);
    final wordScore = credit / denom;
    final charSim = _similarity(exp, rec);

    final score = ((wordScore * 0.8 + charSim * 0.2) * 100).round();
    return score.clamp(0, 99);
  }

  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r"[',!?.]"), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  double _similarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    final longer = s1.length > s2.length ? s1 : s2;
    final longerLength = longer.length;
    if (longerLength == 0) return 1.0;
    return (longerLength - _editDistance(longer, longer == s1 ? s2 : s1)) / longerLength.toDouble();
  }

  int _editDistance(String s1, String s2) {
    final len1 = s1.length, len2 = s2.length;
    final dp = List.generate(len1 + 1, (i) => List.generate(len2 + 1, (j) => 0));
    for (var i = 0; i <= len1; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= len2; j++) {
      dp[0][j] = j;
    }
    for (var i = 1; i <= len1; i++) {
      for (var j = 1; j <= len2; j++) {
        dp[i][j] = s1[i - 1] == s2[j - 1]
            ? dp[i - 1][j - 1]
            : 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce(math.min);
      }
    }
    return dp[len1][len2];
  }

  String getFeedback(int score) {
    if (score >= 90) return 'すばらしい！ネイティブのような発音です！🌟';
    if (score >= 80) return 'とても上手！もう少しで完璧です！😊';
    if (score >= 70) return 'いい感じ！もう一度練習してみよう！👍';
    if (score >= 60) return '惜しい！ゆっくり発音してみよう！🎯';
    if (score >= 40) return 'もう一度チャレンジ！聞いてから真似してみよう！💪';
    return 'もう一度聞いて、ゆっくり言ってみよう！🎧';
  }

  String getParentFeedback(int score, String word) {
    if (score >= 90) return '"$word" の発音は完璧です！';
    if (score >= 80) return '"$word" の発音はとても良いです。少し練習を続けましょう。';
    if (score >= 70) return '"$word" の発音は良いですが、もう少し練習が必要です。';
    if (score >= 60) return '"$word" の発音に課題があります。一緒に練習してあげてください。';
    return '"$word" の発音は改善が必要です。ゆっくり区切って練習しましょう。';
  }
}
