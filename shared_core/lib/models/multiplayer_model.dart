// 小学コレシリーズ共通「マルチプレイ対戦（レートマッチング）」機能の型。
//
// 参考実装: social_quiz_app（社会科クイズアプリ）の
// lib/services/matchmaking_service.dart / lib/services/match_service.dart /
// lib/models/matchmaking_entry.dart / lib/models/player_stats.dart / lib/models/match.dart。
// 現時点で本実装・稼働しているのは social_quiz_app のみだが、Firestoreを使わない
// アプリ（shinshin = FastAPI REST など）にも将来展開できるよう、shared_core側は
// 特定のバックエンドに依存しない型のみを定義する。実データアクセス
// （Firestore/RTDB/REST等）は providers/matchmaking_provider.dart /
// providers/match_provider.dart のハンドラ注入方式でアプリ側に委ねる
// （friend_provider / ranking_provider と同じ設計思想）。

/// マッチングキュー内でのエントリ状態。
enum MatchmakingEntryStatus { waiting, matched, cancelled }

extension MatchmakingEntryStatusJson on MatchmakingEntryStatus {
  String get value => name;

  static MatchmakingEntryStatus fromValue(String? value) {
    switch (value) {
      case 'matched':
        return MatchmakingEntryStatus.matched;
      case 'cancelled':
        return MatchmakingEntryStatus.cancelled;
      case 'waiting':
      default:
        return MatchmakingEntryStatus.waiting;
    }
  }
}

/// 予約済みキー（[MatchmakingQueueEntry.toJson] のトップレベルに書き出す固定フィールド）。
/// これ以外のキーは [MatchmakingQueueEntry.metadata] との相互変換対象になる。
const _kMatchmakingReservedKeys = {
  'userId',
  'displayName',
  'rating',
  'joinedAt',
  'status',
  'matchId',
};

/// マッチングキューの1エントリ（1プレイヤー分）。
///
/// [metadata] には教科（subject）・学年（grade）など、アプリ固有の絞り込み条件を
/// 自由に詰められる。[toJson] ではトップレベルのフィールドとして展開するため、
/// Firestore等でそのままクエリ条件に使える（例: `.where('subject', isEqualTo: ...)`）。
class MatchmakingQueueEntry {
  final String userId;
  final String displayName;
  final double rating;
  final DateTime joinedAt;
  final MatchmakingEntryStatus status;
  final String? matchId;
  final Map<String, dynamic> metadata;

  const MatchmakingQueueEntry({
    required this.userId,
    required this.displayName,
    required this.rating,
    required this.joinedAt,
    this.status = MatchmakingEntryStatus.waiting,
    this.matchId,
    this.metadata = const {},
  });

  bool get isWaiting => status == MatchmakingEntryStatus.waiting;
  bool get isMatched => status == MatchmakingEntryStatus.matched;

  MatchmakingQueueEntry copyWith({
    String? userId,
    String? displayName,
    double? rating,
    DateTime? joinedAt,
    MatchmakingEntryStatus? status,
    String? matchId,
    bool clearMatchId = false,
    Map<String, dynamic>? metadata,
  }) =>
      MatchmakingQueueEntry(
        userId: userId ?? this.userId,
        displayName: displayName ?? this.displayName,
        rating: rating ?? this.rating,
        joinedAt: joinedAt ?? this.joinedAt,
        status: status ?? this.status,
        matchId: clearMatchId ? null : (matchId ?? this.matchId),
        metadata: metadata ?? this.metadata,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'rating': rating,
        'joinedAt': joinedAt.toIso8601String(),
        'status': status.value,
        if (matchId != null) 'matchId': matchId,
        ...metadata,
      };

  factory MatchmakingQueueEntry.fromJson(Map<String, dynamic> json) {
    final metadata = <String, dynamic>{
      for (final entry in json.entries)
        if (!_kMatchmakingReservedKeys.contains(entry.key)) entry.key: entry.value,
    };
    return MatchmakingQueueEntry(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String? ?? 'Player',
      rating: (json['rating'] as num?)?.toDouble() ?? 1500.0,
      joinedAt: DateTime.tryParse(json['joinedAt'] as String? ?? '') ?? DateTime.now(),
      status: MatchmakingEntryStatusJson.fromValue(json['status'] as String?),
      matchId: json['matchId'] as String?,
      metadata: metadata,
    );
  }

  @override
  String toString() =>
      'MatchmakingQueueEntry(userId: $userId, rating: $rating, status: $status, matchId: $matchId)';
}

/// 対戦（マッチ）の進行状況。
enum MatchStatus { waiting, inProgress, finished }

extension MatchStatusJson on MatchStatus {
  String get value => name;

  static MatchStatus fromValue(String? value) {
    switch (value) {
      case 'finished':
        return MatchStatus.finished;
      case 'inProgress':
        return MatchStatus.inProgress;
      case 'waiting':
      default:
        return MatchStatus.waiting;
    }
  }
}

/// 対戦中に共通して必要となる最小限の状態。
///
/// 問題文・選択肢など教科固有のコンテンツはアプリ側が別途保持する想定で、
/// ここではスコア同期・進行状況・勝敗判定に必要な部分のみを扱う。
class MatchState {
  final String matchId;
  final List<String> playerIds;
  final Map<String, int> scores; // userId -> score
  final MatchStatus status;
  final int currentQuestionIndex;
  final int totalQuestions;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  const MatchState({
    required this.matchId,
    required this.playerIds,
    this.scores = const {},
    this.status = MatchStatus.waiting,
    this.currentQuestionIndex = 0,
    this.totalQuestions = 10,
    required this.createdAt,
    this.completedAt,
    this.metadata = const {},
  });

  bool get isFinished => status == MatchStatus.finished;
  bool get isInProgress => status == MatchStatus.inProgress;

  int scoreFor(String userId) => scores[userId] ?? 0;

  /// 勝者の userId。引き分けなら 'draw'、まだ終了していない／2人揃っていない場合は null。
  String? get winnerUserId {
    if (!isFinished || playerIds.length < 2) return null;
    final sorted = [...playerIds]..sort((a, b) => scoreFor(b).compareTo(scoreFor(a)));
    final top = sorted.first;
    final second = sorted[1];
    if (scoreFor(top) == scoreFor(second)) return 'draw';
    return top;
  }

  /// [userId] から見た対戦結果。'win' / 'lose' / 'draw' / null（未終了）。
  String? resultFor(String userId) {
    final winner = winnerUserId;
    if (winner == null) return null;
    if (winner == 'draw') return 'draw';
    return winner == userId ? 'win' : 'lose';
  }

  /// 2人対戦を前提に、[userId] から見た相手の userId を返す。見つからなければ null。
  String? opponentOf(String userId) {
    for (final id in playerIds) {
      if (id != userId) return id;
    }
    return null;
  }

  MatchState copyWith({
    String? matchId,
    List<String>? playerIds,
    Map<String, int>? scores,
    MatchStatus? status,
    int? currentQuestionIndex,
    int? totalQuestions,
    DateTime? createdAt,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) =>
      MatchState(
        matchId: matchId ?? this.matchId,
        playerIds: playerIds ?? this.playerIds,
        scores: scores ?? this.scores,
        status: status ?? this.status,
        currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
        totalQuestions: totalQuestions ?? this.totalQuestions,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt ?? this.completedAt,
        metadata: metadata ?? this.metadata,
      );

  Map<String, dynamic> toJson() => {
        'matchId': matchId,
        'playerIds': playerIds,
        'scores': scores,
        'status': status.value,
        'currentQuestionIndex': currentQuestionIndex,
        'totalQuestions': totalQuestions,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'metadata': metadata,
      };

  factory MatchState.fromJson(Map<String, dynamic> json) => MatchState(
        matchId: json['matchId'] as String,
        playerIds: (json['playerIds'] as List?)?.map((e) => e as String).toList() ?? const [],
        scores: (json['scores'] as Map?)?.map((k, v) => MapEntry(k as String, (v as num).toInt())) ?? const {},
        status: MatchStatusJson.fromValue(json['status'] as String?),
        currentQuestionIndex: json['currentQuestionIndex'] as int? ?? 0,
        totalQuestions: json['totalQuestions'] as int? ?? 10,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt'] as String) : null,
        metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? const {},
      );

  @override
  String toString() =>
      'MatchState(matchId: $matchId, players: $playerIds, scores: $scores, status: $status)';
}

/// プレイヤー1人分のレーティング・対戦成績。
class PlayerRating {
  final String userId;
  final String displayName;
  final double rating;
  final int wins;
  final int losses;
  final int streak; // 正: 連勝数、負: 連敗数、0: 直近が引き分け／未対戦
  final DateTime? lastMatchAt;

  const PlayerRating({
    required this.userId,
    required this.displayName,
    this.rating = 1500.0,
    this.wins = 0,
    this.losses = 0,
    this.streak = 0,
    this.lastMatchAt,
  });

  int get matchCount => wins + losses;
  double get winRate => matchCount == 0 ? 0 : wins / matchCount;

  PlayerRating copyWith({
    String? userId,
    String? displayName,
    double? rating,
    int? wins,
    int? losses,
    int? streak,
    DateTime? lastMatchAt,
  }) =>
      PlayerRating(
        userId: userId ?? this.userId,
        displayName: displayName ?? this.displayName,
        rating: rating ?? this.rating,
        wins: wins ?? this.wins,
        losses: losses ?? this.losses,
        streak: streak ?? this.streak,
        lastMatchAt: lastMatchAt ?? this.lastMatchAt,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'rating': rating,
        'wins': wins,
        'losses': losses,
        'streak': streak,
        'lastMatchAt': lastMatchAt?.toIso8601String(),
      };

  factory PlayerRating.fromJson(Map<String, dynamic> json) => PlayerRating(
        userId: json['userId'] as String,
        displayName: json['displayName'] as String? ?? 'Player',
        rating: (json['rating'] as num?)?.toDouble() ?? 1500.0,
        wins: json['wins'] as int? ?? 0,
        losses: json['losses'] as int? ?? 0,
        streak: json['streak'] as int? ?? 0,
        lastMatchAt:
            json['lastMatchAt'] != null ? DateTime.tryParse(json['lastMatchAt'] as String) : null,
      );

  factory PlayerRating.initial({required String userId, required String displayName}) =>
      PlayerRating(userId: userId, displayName: displayName);

  @override
  String toString() =>
      'PlayerRating(userId: $userId, rating: $rating, wins: $wins, losses: $losses)';
}

/// レーティングシステムの種類（Elo vs Glicko-2）。
enum RatingSystem { elo, glicko2 }

extension RatingSystemJson on RatingSystem {
  String get value => name;

  static RatingSystem fromValue(String? value) {
    switch (value) {
      case 'glicko2':
        return RatingSystem.glicko2;
      case 'elo':
      default:
        return RatingSystem.elo;
    }
  }
}

/// より詳細なユーザーレーティング情報（Glicko-2対応）。
///
/// [PlayerRating] との主な違い：
/// - [rating] の他に [ratingDeviation]（信頼度）と [volatility]（ボラティリティ）を持つ
/// - レーティングシステムを [RatingSystem] で明示的に指定
/// - Glicko-2の時間経過による減衰に対応
class UserRating {
  final String userId;
  final double rating; // 1500-3000 推奨
  final double ratingDeviation; // RD, Glicko-2用。高いほど信頼度低い
  final double volatility; // σ, Glicko-2用
  final int totalMatches;
  final int winCount;
  final DateTime lastUpdatedAt;
  final RatingSystem system;

  const UserRating({
    required this.userId,
    required this.rating,
    required this.ratingDeviation,
    required this.volatility,
    required this.totalMatches,
    required this.winCount,
    required this.lastUpdatedAt,
    required this.system,
  });

  int get lossCount => totalMatches - winCount;
  double get winRate => totalMatches == 0 ? 0 : winCount / totalMatches;

  UserRating copyWith({
    String? userId,
    double? rating,
    double? ratingDeviation,
    double? volatility,
    int? totalMatches,
    int? winCount,
    DateTime? lastUpdatedAt,
    RatingSystem? system,
  }) =>
      UserRating(
        userId: userId ?? this.userId,
        rating: rating ?? this.rating,
        ratingDeviation: ratingDeviation ?? this.ratingDeviation,
        volatility: volatility ?? this.volatility,
        totalMatches: totalMatches ?? this.totalMatches,
        winCount: winCount ?? this.winCount,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        system: system ?? this.system,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'rating': rating,
        'ratingDeviation': ratingDeviation,
        'volatility': volatility,
        'totalMatches': totalMatches,
        'winCount': winCount,
        'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
        'system': system.value,
      };

  factory UserRating.fromJson(Map<String, dynamic> json) => UserRating(
        userId: json['userId'] as String,
        rating: (json['rating'] as num?)?.toDouble() ?? 1500.0,
        ratingDeviation: (json['ratingDeviation'] as num?)?.toDouble() ?? 350.0,
        volatility: (json['volatility'] as num?)?.toDouble() ?? 0.06,
        totalMatches: json['totalMatches'] as int? ?? 0,
        winCount: json['winCount'] as int? ?? 0,
        lastUpdatedAt:
            DateTime.tryParse(json['lastUpdatedAt'] as String? ?? '') ?? DateTime.now(),
        system: RatingSystemJson.fromValue(json['system'] as String?),
      );

  factory UserRating.initial(String userId) => UserRating(
        userId: userId,
        rating: 1500.0,
        ratingDeviation: 350.0,
        volatility: 0.06,
        totalMatches: 0,
        winCount: 0,
        lastUpdatedAt: DateTime.now(),
        system: RatingSystem.glicko2,
      );

  @override
  String toString() =>
      'UserRating(userId: $userId, rating: $rating±$ratingDeviation, wins: $winCount/$totalMatches)';
}

/// 対戦結果（勝敗・スコア・レート変動）。
class MatchResult {
  final String matchId;
  final String winnerId;
  final String loserId;
  final int winnerScore;
  final int loserScore;
  final int durationSeconds;
  final double ratingChange; // 勝者のレート変動（負の値もあり得る）
  final DateTime completedAt;
  final Map<String, dynamic> metadata;

  const MatchResult({
    required this.matchId,
    required this.winnerId,
    required this.loserId,
    required this.winnerScore,
    required this.loserScore,
    required this.durationSeconds,
    required this.ratingChange,
    required this.completedAt,
    this.metadata = const {},
  });

  bool get isWinnerDraw => winnerScore == loserScore;

  MatchResult copyWith({
    String? matchId,
    String? winnerId,
    String? loserId,
    int? winnerScore,
    int? loserScore,
    int? durationSeconds,
    double? ratingChange,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) =>
      MatchResult(
        matchId: matchId ?? this.matchId,
        winnerId: winnerId ?? this.winnerId,
        loserId: loserId ?? this.loserId,
        winnerScore: winnerScore ?? this.winnerScore,
        loserScore: loserScore ?? this.loserScore,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        ratingChange: ratingChange ?? this.ratingChange,
        completedAt: completedAt ?? this.completedAt,
        metadata: metadata ?? this.metadata,
      );

  Map<String, dynamic> toJson() => {
        'matchId': matchId,
        'winnerId': winnerId,
        'loserId': loserId,
        'winnerScore': winnerScore,
        'loserScore': loserScore,
        'durationSeconds': durationSeconds,
        'ratingChange': ratingChange,
        'completedAt': completedAt.toIso8601String(),
        'metadata': metadata,
      };

  factory MatchResult.fromJson(Map<String, dynamic> json) => MatchResult(
        matchId: json['matchId'] as String,
        winnerId: json['winnerId'] as String,
        loserId: json['loserId'] as String,
        winnerScore: json['winnerScore'] as int? ?? 0,
        loserScore: json['loserScore'] as int? ?? 0,
        durationSeconds: json['durationSeconds'] as int? ?? 0,
        ratingChange: (json['ratingChange'] as num?)?.toDouble() ?? 0.0,
        completedAt:
            DateTime.tryParse(json['completedAt'] as String? ?? '') ?? DateTime.now(),
        metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? const {},
      );

  @override
  String toString() =>
      'MatchResult(match: $matchId, winner: $winnerId($winnerScore), loser: $loserId($loserScore), ratingChange: $ratingChange)';
}

/// 1ラウンド分の対戦データ。
class BattleRound {
  final int roundNumber; // 1-based
  final String questionId;
  final String? player1Answer;
  final String? player2Answer;
  final bool? player1Correct;
  final bool? player2Correct;
  final int player1AnswerTimeMs;
  final int player2AnswerTimeMs;
  final DateTime questionShowedAt;
  final DateTime? roundCompletedAt;

  const BattleRound({
    required this.roundNumber,
    required this.questionId,
    this.player1Answer,
    this.player2Answer,
    this.player1Correct,
    this.player2Correct,
    this.player1AnswerTimeMs = 0,
    this.player2AnswerTimeMs = 0,
    required this.questionShowedAt,
    this.roundCompletedAt,
  });

  bool get isCompleted => player1Correct != null && player2Correct != null;

  BattleRound copyWith({
    int? roundNumber,
    String? questionId,
    String? player1Answer,
    String? player2Answer,
    bool? player1Correct,
    bool? player2Correct,
    int? player1AnswerTimeMs,
    int? player2AnswerTimeMs,
    DateTime? questionShowedAt,
    DateTime? roundCompletedAt,
  }) =>
      BattleRound(
        roundNumber: roundNumber ?? this.roundNumber,
        questionId: questionId ?? this.questionId,
        player1Answer: player1Answer ?? this.player1Answer,
        player2Answer: player2Answer ?? this.player2Answer,
        player1Correct: player1Correct ?? this.player1Correct,
        player2Correct: player2Correct ?? this.player2Correct,
        player1AnswerTimeMs: player1AnswerTimeMs ?? this.player1AnswerTimeMs,
        player2AnswerTimeMs: player2AnswerTimeMs ?? this.player2AnswerTimeMs,
        questionShowedAt: questionShowedAt ?? this.questionShowedAt,
        roundCompletedAt: roundCompletedAt ?? this.roundCompletedAt,
      );

  Map<String, dynamic> toJson() => {
        'roundNumber': roundNumber,
        'questionId': questionId,
        'player1Answer': player1Answer,
        'player2Answer': player2Answer,
        'player1Correct': player1Correct,
        'player2Correct': player2Correct,
        'player1AnswerTimeMs': player1AnswerTimeMs,
        'player2AnswerTimeMs': player2AnswerTimeMs,
        'questionShowedAt': questionShowedAt.toIso8601String(),
        'roundCompletedAt': roundCompletedAt?.toIso8601String(),
      };

  factory BattleRound.fromJson(Map<String, dynamic> json) => BattleRound(
        roundNumber: json['roundNumber'] as int? ?? 0,
        questionId: json['questionId'] as String,
        player1Answer: json['player1Answer'] as String?,
        player2Answer: json['player2Answer'] as String?,
        player1Correct: json['player1Correct'] as bool?,
        player2Correct: json['player2Correct'] as bool?,
        player1AnswerTimeMs: json['player1AnswerTimeMs'] as int? ?? 0,
        player2AnswerTimeMs: json['player2AnswerTimeMs'] as int? ?? 0,
        questionShowedAt:
            DateTime.tryParse(json['questionShowedAt'] as String? ?? '') ?? DateTime.now(),
        roundCompletedAt: json['roundCompletedAt'] != null
            ? DateTime.tryParse(json['roundCompletedAt'] as String)
            : null,
      );

  @override
  String toString() =>
      'BattleRound(round: $roundNumber, q: $questionId, p1: ${player1Correct == true ? '✓' : '✗'}, p2: ${player2Correct == true ? '✓' : '✗'})';
}

/// 全体の対戦セッション。
class BattleSession {
  final String sessionId; // 'match_TIMESTAMP'
  final String player1Id;
  final String player2Id;
  final String player1Name;
  final String player2Name;
  final int player1Rating;
  final int player2Rating;
  final MatchStatus status;
  final List<BattleRound> rounds;
  final int player1CurrentScore;
  final int player2CurrentScore;
  final int currentRound; // 1-based, 0 = not started
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? winnerId;
  final List<String> questionIds; // 出題ID
  final Map<String, dynamic> metadata;

  const BattleSession({
    required this.sessionId,
    required this.player1Id,
    required this.player2Id,
    required this.player1Name,
    required this.player2Name,
    required this.player1Rating,
    required this.player2Rating,
    required this.status,
    required this.rounds,
    required this.player1CurrentScore,
    required this.player2CurrentScore,
    required this.currentRound,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.winnerId,
    required this.questionIds,
    this.metadata = const {},
  });

  int get totalRounds => questionIds.length;

  BattleSession copyWith({
    String? sessionId,
    String? player1Id,
    String? player2Id,
    String? player1Name,
    String? player2Name,
    int? player1Rating,
    int? player2Rating,
    MatchStatus? status,
    List<BattleRound>? rounds,
    int? player1CurrentScore,
    int? player2CurrentScore,
    int? currentRound,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? winnerId,
    List<String>? questionIds,
    Map<String, dynamic>? metadata,
  }) =>
      BattleSession(
        sessionId: sessionId ?? this.sessionId,
        player1Id: player1Id ?? this.player1Id,
        player2Id: player2Id ?? this.player2Id,
        player1Name: player1Name ?? this.player1Name,
        player2Name: player2Name ?? this.player2Name,
        player1Rating: player1Rating ?? this.player1Rating,
        player2Rating: player2Rating ?? this.player2Rating,
        status: status ?? this.status,
        rounds: rounds ?? this.rounds,
        player1CurrentScore: player1CurrentScore ?? this.player1CurrentScore,
        player2CurrentScore: player2CurrentScore ?? this.player2CurrentScore,
        currentRound: currentRound ?? this.currentRound,
        createdAt: createdAt ?? this.createdAt,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt ?? this.completedAt,
        winnerId: winnerId ?? this.winnerId,
        questionIds: questionIds ?? this.questionIds,
        metadata: metadata ?? this.metadata,
      );

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'player1Id': player1Id,
        'player2Id': player2Id,
        'player1Name': player1Name,
        'player2Name': player2Name,
        'player1Rating': player1Rating,
        'player2Rating': player2Rating,
        'status': status.value,
        'rounds': rounds.map((r) => r.toJson()).toList(),
        'player1CurrentScore': player1CurrentScore,
        'player2CurrentScore': player2CurrentScore,
        'currentRound': currentRound,
        'createdAt': createdAt.toIso8601String(),
        'startedAt': startedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'winnerId': winnerId,
        'questionIds': questionIds,
        'metadata': metadata,
      };

  factory BattleSession.fromJson(Map<String, dynamic> json) => BattleSession(
        sessionId: json['sessionId'] as String,
        player1Id: json['player1Id'] as String,
        player2Id: json['player2Id'] as String,
        player1Name: json['player1Name'] as String? ?? 'Player 1',
        player2Name: json['player2Name'] as String? ?? 'Player 2',
        player1Rating: json['player1Rating'] as int? ?? 1500,
        player2Rating: json['player2Rating'] as int? ?? 1500,
        status: MatchStatusJson.fromValue(json['status'] as String?),
        rounds: (json['rounds'] as List?)?.map((r) => BattleRound.fromJson(r as Map<String, dynamic>)).toList() ?? const [],
        player1CurrentScore: json['player1CurrentScore'] as int? ?? 0,
        player2CurrentScore: json['player2CurrentScore'] as int? ?? 0,
        currentRound: json['currentRound'] as int? ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt'] as String) : null,
        completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt'] as String) : null,
        winnerId: json['winnerId'] as String?,
        questionIds: (json['questionIds'] as List?)?.map((q) => q as String).toList() ?? const [],
        metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? const {},
      );

  @override
  String toString() =>
      'BattleSession(session: $sessionId, p1: $player1Name($player1CurrentScore), p2: $player2Name($player2CurrentScore), status: $status)';
}

/// マッチメイキング要求（キューエントリの詳細版）。
class MatchmakingRequest {
  final String userId;
  final String userName;
  final int userRating;
  final int minRatingRange; // -300
  final int maxRatingRange; // +300
  final int maxWaitTimeSeconds;
  final String subject; // 教科（sansu, kokugo等）
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const MatchmakingRequest({
    required this.userId,
    required this.userName,
    required this.userRating,
    required this.minRatingRange,
    required this.maxRatingRange,
    required this.maxWaitTimeSeconds,
    required this.subject,
    required this.createdAt,
    this.metadata = const {},
  });

  MatchmakingRequest copyWith({
    String? userId,
    String? userName,
    int? userRating,
    int? minRatingRange,
    int? maxRatingRange,
    int? maxWaitTimeSeconds,
    String? subject,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) =>
      MatchmakingRequest(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userRating: userRating ?? this.userRating,
        minRatingRange: minRatingRange ?? this.minRatingRange,
        maxRatingRange: maxRatingRange ?? this.maxRatingRange,
        maxWaitTimeSeconds: maxWaitTimeSeconds ?? this.maxWaitTimeSeconds,
        subject: subject ?? this.subject,
        createdAt: createdAt ?? this.createdAt,
        metadata: metadata ?? this.metadata,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'userRating': userRating,
        'minRatingRange': minRatingRange,
        'maxRatingRange': maxRatingRange,
        'maxWaitTimeSeconds': maxWaitTimeSeconds,
        'subject': subject,
        'createdAt': createdAt.toIso8601String(),
        'metadata': metadata,
      };

  factory MatchmakingRequest.fromJson(Map<String, dynamic> json) => MatchmakingRequest(
        userId: json['userId'] as String,
        userName: json['userName'] as String? ?? 'Player',
        userRating: json['userRating'] as int? ?? 1500,
        minRatingRange: json['minRatingRange'] as int? ?? 1200,
        maxRatingRange: json['maxRatingRange'] as int? ?? 1800,
        maxWaitTimeSeconds: json['maxWaitTimeSeconds'] as int? ?? 60,
        subject: json['subject'] as String? ?? 'sansu',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? const {},
      );

  @override
  String toString() =>
      'MatchmakingRequest(userId: $userId, rating: $userRating, subject: $subject)';
}

/// リーダーボード1行分のエントリ。
class LeaderboardEntry {
  final int rank;
  final String userId;
  final String userName;
  final int rating;
  final int wins;
  final int totalMatches;
  final double winRate;
  final int? avatarId;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.wins,
    required this.totalMatches,
    required this.winRate,
    this.avatarId,
    required this.updatedAt,
    this.metadata = const {},
  });

  int get losses => totalMatches - wins;

  LeaderboardEntry copyWith({
    int? rank,
    String? userId,
    String? userName,
    int? rating,
    int? wins,
    int? totalMatches,
    double? winRate,
    int? avatarId,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) =>
      LeaderboardEntry(
        rank: rank ?? this.rank,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        rating: rating ?? this.rating,
        wins: wins ?? this.wins,
        totalMatches: totalMatches ?? this.totalMatches,
        winRate: winRate ?? this.winRate,
        avatarId: avatarId ?? this.avatarId,
        updatedAt: updatedAt ?? this.updatedAt,
        metadata: metadata ?? this.metadata,
      );

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'userId': userId,
        'userName': userName,
        'rating': rating,
        'wins': wins,
        'totalMatches': totalMatches,
        'winRate': winRate,
        'avatarId': avatarId,
        'updatedAt': updatedAt.toIso8601String(),
        'metadata': metadata,
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
        rank: json['rank'] as int? ?? 0,
        userId: json['userId'] as String,
        userName: json['userName'] as String? ?? 'Player',
        rating: json['rating'] as int? ?? 1500,
        wins: json['wins'] as int? ?? 0,
        totalMatches: json['totalMatches'] as int? ?? 0,
        winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
        avatarId: json['avatarId'] as int?,
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
        metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? const {},
      );

  @override
  String toString() =>
      'LeaderboardEntry(rank: $rank, user: $userName, rating: $rating, wins: $wins/$totalMatches)';
}
