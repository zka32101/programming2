import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/coin_provider.dart';

/// 連続正解数に応じたボーナスコインを計算する純関数（学習日の連続とは別物）。
class AnswerStreakBonus {
  const AnswerStreakBonus({this.interval = 5, this.bonusPerInterval = 10})
      : assert(interval > 0),
        assert(bonusPerInterval >= 0);

  /// この回数の連続正解ごとにボーナスを付与する。
  final int interval;
  final int bonusPerInterval;

  int bonusFor(int consecutiveCorrectCount) =>
      consecutiveCorrectCount > 0 && consecutiveCorrectCount % interval == 0
          ? bonusPerInterval
          : 0;
}

/// 回答ごとの連続正解数を数え、ボーナスをコインに加算する（セッション内のみ）。
///
/// クイズ画面で回答のたびに `recordAnswer(correct)` を呼ぶ。返り値はこの回答で
/// 付与したボーナスコイン（0 ならなし）。開始時に `reset()` する。
class AnswerStreakNotifier extends Notifier<int> {
  AnswerStreakBonus bonus = const AnswerStreakBonus();

  @override
  int build() => 0;

  void reset() => state = 0;

  Future<int> recordAnswer(bool correct) async {
    if (!correct) {
      state = 0;
      return 0;
    }
    state += 1;
    final coins = bonus.bonusFor(state);
    if (coins > 0) await ref.read(coinProvider.notifier).addCoins(coins);
    return coins;
  }
}

final answerStreakProvider =
    NotifierProvider<AnswerStreakNotifier, int>(AnswerStreakNotifier.new);
