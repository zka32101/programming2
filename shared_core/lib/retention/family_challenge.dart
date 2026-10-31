enum FamilyTurn { child, parent, finished }

/// 子どもと保護者が交代で同じ問題数に挑戦する「家族チャレンジ」の進行管理。
///
/// 子どもの回答は通常どおり学習記録に残し、保護者の回答は採点のみで
/// 記録しない（保護者の習熟度を測るものではないため）。呼び出し側は
/// [shouldRecordProgress] を見て記録の有無を決める。
class FamilyChallengeSession {
  FamilyChallengeSession({this.questionsPerPlayer = 5})
      : assert(questionsPerPlayer > 0);

  final int questionsPerPlayer;
  FamilyTurn _turn = FamilyTurn.child;
  int _answeredInTurn = 0;
  int _childScore = 0;
  int _parentScore = 0;

  FamilyTurn get turn => _turn;
  int get childScore => _childScore;
  int get parentScore => _parentScore;
  bool get isFinished => _turn == FamilyTurn.finished;

  /// 現在の回答者のぶんを学習記録に残すか（子どものときだけ true）。
  bool get shouldRecordProgress => _turn == FamilyTurn.child;

  /// 回答を記録し、必要なら手番を進める。終了済みなら何もしない。
  void recordAnswer(bool correct) {
    if (isFinished) return;
    if (correct) {
      _turn == FamilyTurn.child ? _childScore++ : _parentScore++;
    }
    _answeredInTurn++;
    if (_answeredInTurn >= questionsPerPlayer) {
      _answeredInTurn = 0;
      _turn = _turn == FamilyTurn.child ? FamilyTurn.parent : FamilyTurn.finished;
    }
  }

  /// 勝敗。同点は null。
  FamilyTurn? get winner => !isFinished || _childScore == _parentScore
      ? null
      : (_childScore > _parentScore ? FamilyTurn.child : FamilyTurn.parent);
}
