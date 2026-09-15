import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/reading_passage_model.dart';
import '../services/firebase_realtime_db.dart';

final currentReadingSessionProvider = StateNotifierProvider<ReadingSessionNotifier, ReadingSession?>((ref) {
  return ReadingSessionNotifier();
});

final readingAnalyticsProvider = StateNotifierProvider<ReadingAnalyticsNotifier, ReadingAnalytics?>((ref) {
  return ReadingAnalyticsNotifier();
});

final readingPassagesProvider = FutureProvider<List<ReadingPassage>>((ref) async {
  // Sample reading passages (can be extended to fetch from Firebase)
  return [
    const ReadingPassage(
      passageId: 'passage_001',
      title: 'ウサギとカメ',
      content: 'むかし、足の速いウサギと足の遅いカメがいました。ウサギはいつもカメのことを馬鹿にしていました。「君のろのろ歩きなんて見てられないね」とウサギは言いました。カメは静かに答えました。「よければ競争をしましょう」。ウサギはこの申し出を笑い飛ばしました。「面白い。やってみようか。どうせすぐに勝つさ」。競争が始まりました。ウサギは自分の足の速さを信じて、さっさと先に行ってしまいました。そして、道の途中で昼寝をしてしまいました。一方、カメはゆっくりと、でも着実に歩き続けました。いつの間にか、カメがウサギを追い越していました。ウサギが目を覚ましたときは、もう遅かったのです。カメがゴールに着いていました。ウサギはこのとき初めて、速さだけが大切ではないことを学びました。',
      author: '伊索',
      grade: 1,
      difficulty: 'basic',
      estimatedReadingTimeSeconds: 300,
      genre: 'folk_tale',
      wordCount: 186,
      vocabularyList: ['競争', 'ろのろ', '着実', 'ゴール'],
    ),
    const ReadingPassage(
      passageId: 'passage_002',
      title: '手紙',
      content: 'おばあさんに手紙を書きました。おばあさんは田舎に住んでいます。毎月一度、私は手紙を書きます。おばあさんはいつも、その手紙をとても喜んでくれます。「孫から手紙をもらうほど、嬉しいことはない」とおばあさんは言います。今月も、学校のことや、友だちのことを書きました。また、テストで百点を取ったことも書きました。おばあさんはこの手紙を読んで、どんな顔をするだろう。いつも返事の手紙には、「頑張ってね。応援しているよ」と書いてあります。おばあさんの手紙をもらうと、また頑張ろうという気持ちになります。手紙は、離れている人とつなぐ大切な橋なのだと思います。',
      author: '著者不明',
      grade: 2,
      difficulty: 'basic',
      estimatedReadingTimeSeconds: 240,
      genre: 'modern_fiction',
      wordCount: 165,
      vocabularyList: ['田舎', '応援', 'つなぐ', '橋'],
    ),
    const ReadingPassage(
      passageId: 'passage_003',
      title: '春が来た',
      content: '冬が終わり、春がやってきました。雪は溶け始め、地面が見えてきました。花がさくために、地中で眠っていた種たちも、目を覚ましました。梅の花が最初に咲きます。桜はまだ少し先です。でも、その準備は始まっています。枝には、やがて花になる蕾がいっぱいついています。春の空は明るくなり、太陽の光も温かくなってきました。冬の寒さに耐えた木や花たちも、一斉に動き始めます。小さな虫たちも出てきました。蝶々が舞い始めます。野鳥たちは、よりよい声で歌い始めます。春は、すべての生き物に新しい始まりをもたらすのです。春は本当に素晴らしい季節です。',
      author: '著者不明',
      grade: 1,
      difficulty: 'standard',
      estimatedReadingTimeSeconds: 280,
      genre: 'essay',
      wordCount: 172,
      vocabularyList: ['春', '蕾', '耐える', '一斉'],
    ),
  ];
});

final userReadingHistoryProvider = FutureProvider.family<List<ReadingSession>, String>((ref, userId) async {
  return FirebaseRealtimeAPI.getReadingHistory(userId);
});

class ReadingSessionNotifier extends StateNotifier<ReadingSession?> {
  ReadingSessionNotifier() : super(null);

  /// Start a new reading session
  Future<void> startReadingSession(String userId, String passageId) async {
    try {
      final session = ReadingSession(
        sessionId: const Uuid().v4(),
        userId: userId,
        passageId: passageId,
        startedDate: DateTime.now(),
        completedDate: null,
        readingDurationSeconds: 0,
        answeredQuestionIds: [],
        answerCorrectness: [],
        comprehensionScore: 0.0,
        isCompleted: false,
      );

      state = session;
    } catch (e) {
      debugPrint('❌ Error starting reading session: $e');
      rethrow;
    }
  }

  /// Record a question answer
  Future<void> recordAnswer(String questionId, bool isCorrect) async {
    try {
      if (state == null) return;

      final updated = ReadingSession(
        sessionId: state!.sessionId,
        userId: state!.userId,
        passageId: state!.passageId,
        startedDate: state!.startedDate,
        completedDate: state!.completedDate,
        readingDurationSeconds: state!.readingDurationSeconds,
        answeredQuestionIds: [...state!.answeredQuestionIds, questionId],
        answerCorrectness: [...state!.answerCorrectness, isCorrect],
        comprehensionScore: state!.comprehensionScore,
        isCompleted: state!.isCompleted,
      );

      state = updated;
    } catch (e) {
      debugPrint('❌ Error recording answer: $e');
      rethrow;
    }
  }

  /// Complete reading session
  Future<void> completeSession(double comprehensionScore) async {
    try {
      if (state == null) return;

      final updated = ReadingSession(
        sessionId: state!.sessionId,
        userId: state!.userId,
        passageId: state!.passageId,
        startedDate: state!.startedDate,
        completedDate: DateTime.now(),
        readingDurationSeconds: DateTime.now().difference(state!.startedDate).inSeconds,
        answeredQuestionIds: state!.answeredQuestionIds,
        answerCorrectness: state!.answerCorrectness,
        comprehensionScore: comprehensionScore,
        isCompleted: true,
      );

      await FirebaseRealtimeAPI.saveReadingSession(state!.userId, updated);
      state = updated;
    } catch (e) {
      debugPrint('❌ Error completing session: $e');
      rethrow;
    }
  }

  /// Calculate comprehension score
  double calculateComprehensionScore() {
    if (state == null || state!.answerCorrectness.isEmpty) return 0.0;

    final correct = state!.answerCorrectness.where((a) => a).length;
    return (correct / state!.answerCorrectness.length) * 100;
  }

  /// Get reading duration in minutes
  int getReadingDurationMinutes() {
    if (state == null) return 0;
    return (state!.readingDurationSeconds / 60).toInt();
  }
}

class ReadingAnalyticsNotifier extends StateNotifier<ReadingAnalytics?> {
  ReadingAnalyticsNotifier() : super(null);

  /// Load reading analytics from Firebase
  Future<void> loadAnalytics(String userId) async {
    try {
      FirebaseRealtimeAPI.getReadingAnalyticsStream(userId).listen((analytics) {
        state = analytics;
      });
    } catch (e) {
      debugPrint('❌ Error loading reading analytics: $e');
    }
  }

  /// Update reading analytics
  Future<void> updateAnalytics(
    String userId, {
    required int passagesRead,
    required double avgComprehensionScore,
    required int totalReadingMinutes,
  }) async {
    try {
      if (state == null) return;

      final updated = ReadingAnalytics(
        userId: userId,
        totalPassagesRead: passagesRead,
        averageComprehensionScore: avgComprehensionScore,
        totalReadingMinutes: totalReadingMinutes,
        difficultyDistribution: state!.difficultyDistribution,
        favoritedGenres: state!.favoritedGenres,
        lastReadingDate: DateTime.now(),
      );

      state = updated;
    } catch (e) {
      debugPrint('❌ Error updating analytics: $e');
      rethrow;
    }
  }

  /// Get average reading speed (characters per minute)
  Future<int> getReadingSpeed() async {
    if (state == null) return 0;
    // This would require passage character count data
    // Placeholder for now
    return 150; // Average reading speed in CPM
  }

  /// Get reading difficulty level distribution
  Map<String, int> getDifficultyDistribution() {
    if (state == null) return {};
    return state!.difficultyDistribution.cast<String, int>();
  }

  /// Get reading level assessment
  String getReadingLevelAssessment() {
    if (state == null) return '不明';

    final avgScore = state!.averageComprehensionScore;
    if (avgScore >= 90) return '上級';
    if (avgScore >= 70) return '中級';
    if (avgScore >= 50) return '初級';
    return '初心者';
  }

  /// Get reading recommendations based on performance
  List<String> getReadingRecommendations() {
    if (state == null) return [];

    final recommendations = <String>[];
    final avgScore = state!.averageComprehensionScore;

    if (avgScore < 60) {
      recommendations.add('「初級」レベルの記事から始めてみてください。');
    }

    if (state!.difficultyDistribution['advanced'] == null || ((state!.difficultyDistribution['advanced'] as int?) ?? 0) == 0) {
      recommendations.add('難しい記事にも挑戦して、読解力を伸ばしましょう。');
    }

    if ((state!.totalReadingMinutes ~/ 60) < 5) {
      recommendations.add('毎日の読書習慣をつけることが大切です。');
    }

    return recommendations;
  }

  /// Track favorite genres
  void addFavoriteGenre(String genre) {
    if (state == null) return;

    final updated = state!.favoritedGenres.toSet();
    updated.add(genre);

    state = ReadingAnalytics(
      userId: state!.userId,
      totalPassagesRead: state!.totalPassagesRead,
      averageComprehensionScore: state!.averageComprehensionScore,
      totalReadingMinutes: state!.totalReadingMinutes,
      difficultyDistribution: state!.difficultyDistribution,
      favoritedGenres: updated.toList(),
      lastReadingDate: state!.lastReadingDate,
    );
  }
}
