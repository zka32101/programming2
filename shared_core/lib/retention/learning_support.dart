/// 解説の詳しさ。
enum ExplanationDepth { brief, standard, detailed }

/// 連続誤答数に応じて解説の詳しさを選ぶ純関数。
class ExplanationDepthSelector {
  const ExplanationDepthSelector({this.detailedThreshold = 2})
      : assert(detailedThreshold > 0);

  final int detailedThreshold;

  ExplanationDepth selectDepth(int consecutiveIncorrectCount) {
    if (consecutiveIncorrectCount >= detailedThreshold) {
      return ExplanationDepth.detailed;
    }
    return consecutiveIncorrectCount > 0
        ? ExplanationDepth.standard
        : ExplanationDepth.brief;
  }
}

/// 正答率が低い（または未学習）の単元で、ヒントを自動表示すべきか。
class AutoHintPolicy {
  const AutoHintPolicy({this.accuracyThreshold = 0.6})
      : assert(accuracyThreshold >= 0);

  final double accuracyThreshold;

  /// [accuracy] は 0.0-1.0。null は未学習。
  bool shouldShowHint(double? accuracy) =>
      accuracy == null || accuracy < accuracyThreshold;
}

/// バッジの解除条件（現在値が [threshold] 以上で解除）。
class AchievementProgress {
  final String id;
  final int current;
  final int threshold;
  const AchievementProgress(this.id, this.current, this.threshold);

  int get remaining => threshold - current;
  bool get unlocked => remaining <= 0;
}

/// 未解除バッジのうち、あとどれだけで解除できるかを返す純関数。
/// 「もうすぐ解除！」表示用。具体的な条件はアプリ側が [AchievementProgress] で渡す。
class AchievementProximityHint {
  const AchievementProximityHint();

  /// 未解除のバッジの残り回数（id → remaining）。
  Map<String, int> remainingToUnlock(List<AchievementProgress> all) => {
        for (final a in all)
          if (!a.unlocked) a.id: a.remaining
      };

  /// 最も近い未解除バッジ。なければ null。
  AchievementProgress? closest(List<AchievementProgress> all) {
    AchievementProgress? best;
    for (final a in all) {
      if (a.unlocked) continue;
      if (best == null || a.remaining < best.remaining) best = a;
    }
    return best;
  }
}
