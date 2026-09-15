import 'package:shared_core/shared_core.dart'
    show FirestoreMatchmakingService, MatchmakingHandlers, MatchHandlers, MatchState;

export 'package:shared_core/shared_core.dart' show RatingCalculator;

/// 国語コレ！用のマルチプレイ対戦（レートマッチング）サービス。
///
/// shared_core の [FirestoreMatchmakingService] をそのまま使い、Firestore の
/// コレクション名にだけ `kokugo_` プレフィックスを付けて、他アプリ（social_quiz_app,
/// sansu-kore, newrepo 等）のコレクションと衝突しないようにする。
///
/// `matchmakingHandlers` / `matchHandlers` を `ProviderScope` の
/// `matchmakingHandlersProvider` / `matchHandlersProvider` にそのまま override して使う。
class KokugoMatchmakingService {
  KokugoMatchmakingService._();

  static final FirestoreMatchmakingService _delegate = FirestoreMatchmakingService(
    matchmakingQueueCollection: 'kokugo_matchmaking_queue',
    matchesCollection: 'kokugo_matches',
    playerRatingsCollection: 'kokugo_player_ratings',
  );

  static MatchmakingHandlers get matchmakingHandlers => _delegate.matchmakingHandlers;

  static MatchHandlers get matchHandlers => _delegate.matchHandlers;

  /// マッチ終了時にレーティングを更新する。
  ///
  /// shared_core の [MatchHandlers.completeMatch] はマッチ自体の状態(finished)を
  /// 更新するだけでレーティングには触れないため、対戦本編側（国語コレの
  /// マルチプレイクイズ画面）から明示的に呼び出して両者のレートを反映させる。
  static Future<void> updateRatingsAfterMatch(MatchState match) async {
    if (match.playerIds.length < 2) return;
    final winnerId = match.winnerUserId;
    if (winnerId == null) return;

    if (winnerId == 'draw') {
      await _delegate.updateRatingAfterMatch(
        winnerId: match.playerIds[0],
        loserId: match.playerIds[1],
        isDraw: true,
      );
      return;
    }

    final loserId = match.opponentOf(winnerId);
    if (loserId == null) return;
    await _delegate.updateRatingAfterMatch(winnerId: winnerId, loserId: loserId);
  }
}
