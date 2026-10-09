import 'dart:math' as math;
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._();
  factory SpeechService() => _instance;
  SpeechService._();

  final SpeechToText _speech = SpeechToText();
  bool _available = false;
  bool _initialized = false;

  /// 認識の状態('listening' / 'notListening' / 'done')とエラーを画面側へ伝える。
  void Function(String status)? onStatus;
  void Function(String error)? onError;

  Future<bool> init() async {
    if (_initialized) return _available;
    _available = await _speech.initialize(
      onError: (error) => onError?.call(error.errorMsg),
      onStatus: (status) => onStatus?.call(status),
    );
    _initialized = true;
    return _available;
  }

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  /// 開始できたら true。マイク権限なし・認識サービスなしなら false。
  Future<bool> startListening({
    required void Function(String text, bool isFinal) onResult,
    String? expected,
  }) async {
    // Initialize lazily so the mic permission prompt appears only when the
    // learner actually starts speaking.
    if (!await init()) return false;
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        localeId: 'en_US',
        listenFor: listenForFor(expected),
        pauseFor: pauseForFor(expected),
      ),
    );
    return true;
  }

  /// 期待文の語数に応じた「無音で打ち切るまでの時間」。
  /// 「Seven, eight, nine, ten」のように間をあけて言う文が途中で確定しないよう、
  /// 語数が多いほど長く待つ(1語=2秒、2語=3秒、3語以上=4秒、不明=3秒)。
  @visibleForTesting
  static Duration pauseForFor(String? expected) {
    final n = _wordCount(expected);
    if (n == 0) return const Duration(seconds: 3);
    if (n == 1) return const Duration(seconds: 2);
    if (n == 2) return const Duration(seconds: 3);
    return const Duration(seconds: 4);
  }

  /// 認識全体の最大時間。語数が多いほど長くする(8〜14秒)。
  @visibleForTesting
  static Duration listenForFor(String? expected) {
    final n = _wordCount(expected);
    return Duration(seconds: (8 + (n > 3 ? n - 3 : 0)).clamp(8, 14));
  }

  static int _wordCount(String? s) => s == null
      ? 0
      : s.split(RegExp(r'[\s,]+')).where((w) => w.isNotEmpty).length;

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

  String _normalize(String s) => numbersToWords(s)
      .toLowerCase()
      .replaceAll(RegExp(r"[',!?.]"), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static const _numberWords = <String>[
    'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight',
    'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen',
    'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty',
  ];
  static const _tensWords = <int, String>{
    30: 'thirty', 40: 'forty', 50: 'fifty', 60: 'sixty', 70: 'seventy',
    80: 'eighty', 90: 'ninety', 100: 'one hundred',
  };

  /// 音声認識は「one two three」を「1 2 3」、「four five six」を「405-6」のように
  /// 数字で返すことがある。採点では英単語に直して比べる。
  /// 0〜20・30,40,…,100 はそのまま単語に、それ以外の数字列は1桁ずつ単語にする。
  /// 数字どうしをつなぐ「-」は区切りとして扱う。
  @visibleForTesting
  static String numbersToWords(String s) {
    final separated = s.replaceAllMapped(
      RegExp(r'(?<=\d)-(?=\d)'),
      (_) => ' ',
    );
    return separated.replaceAllMapped(RegExp(r'\d+'), (m) {
      final digits = m.group(0)!;
      final n = int.parse(digits);
      if (digits.length <= 3 && !digits.startsWith('0') || digits == '0') {
        if (n >= 0 && n < _numberWords.length) return ' ${_numberWords[n]} ';
        final tens = _tensWords[n];
        if (tens != null) return ' $tens ';
      }
      return digits
          .split('')
          .map((d) => ' ${_numberWords[int.parse(d)]} ')
          .join();
    });
  }

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
