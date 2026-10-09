import 'package:shared_core/shared_core.dart' show AppShopItem;

/// 称号の入手方法。
enum TitleUnlock {
  /// コインで買う。
  coin,

  /// 連続日数が [TitleDef.threshold] 日以上。
  streak,

  /// レベルが [TitleDef.threshold] 以上。
  level,

  /// 獲得バッジ数が [TitleDef.threshold] 以上。
  badges,
}

/// 称号の判定に使う、すでにある進捗値(新しい計測は不要)。
class TitleStats {
  const TitleStats({this.level = 1, this.streakDays = 0, this.badgeCount = 0});
  final int level;
  final int streakDays;
  final int badgeCount;
}

class TitleDef {
  const TitleDef({
    required this.id,
    required this.name,
    required this.description,
    required this.unlock,
    this.coinCost = 0,
    this.threshold = 0,
  });

  final String id;
  final String name;
  final String description;
  final TitleUnlock unlock;
  final int coinCost;
  final int threshold;

  bool get isPurchasable => unlock == TitleUnlock.coin;

  /// 鍵つきのときに見せる「どうすればもらえるか」。
  String get conditionText {
    switch (unlock) {
      case TitleUnlock.coin:
        return '$coinCostコインでこうかん';
      case TitleUnlock.streak:
        return '$threshold日れんぞくでがくしゅう';
      case TitleUnlock.level:
        return 'レベル$thresholdになる';
      case TitleUnlock.badges:
        return 'バッジを$threshold個ゲット';
    }
  }

  AppShopItem toShopItem() => AppShopItem(
        id: id,
        emoji: '🏅',
        name: name,
        description: description,
        category: 'しょうごう',
        coinCost: coinCost,
      );
}

const List<TitleDef> kTitleDefs = [
  // コインで買う
  TitleDef(id: 'title_debut', name: 'えいごデビュー', description: 'ホームにひょうじできるしょうごう', unlock: TitleUnlock.coin, coinCost: 100),
  TitleDef(id: 'title_talker', name: 'おしゃべりめいじん', description: 'ホームにひょうじできるしょうごう', unlock: TitleUnlock.coin, coinCost: 200),
  TitleDef(id: 'title_words', name: 'たんごはかせ', description: 'ホームにひょうじできるしょうごう', unlock: TitleUnlock.coin, coinCost: 300),
  TitleDef(id: 'title_abc', name: 'ABCマスター', description: 'ホームにひょうじできるしょうごう', unlock: TitleUnlock.coin, coinCost: 400),
  TitleDef(id: 'title_world', name: 'せかいのともだち', description: 'ホームにひょうじできるしょうごう', unlock: TitleUnlock.coin, coinCost: 500),
  // たっせいで解放
  TitleDef(id: 'title_streak7', name: 'まいにちえいご', description: '7日れんぞくでがくしゅうしたしょうごう', unlock: TitleUnlock.streak, threshold: 7),
  TitleDef(id: 'title_lv10', name: 'レベルアップめいじん', description: 'レベル10になったしょうごう', unlock: TitleUnlock.level, threshold: 10),
  TitleDef(id: 'title_badge5', name: 'バッジコレクター', description: 'バッジを5個あつめたしょうごう', unlock: TitleUnlock.badges, threshold: 5),
];

TitleDef? titleDefById(String? id) {
  if (id == null) return null;
  for (final t in kTitleDefs) {
    if (t.id == id) return t;
  }
  return null;
}

/// 達成型の称号が解放済みか(コイン型は常に false。所持は別で見る)。
bool isAchievementMet(TitleDef t, TitleStats s) {
  switch (t.unlock) {
    case TitleUnlock.coin:
      return false;
    case TitleUnlock.streak:
      return s.streakDays >= t.threshold;
    case TitleUnlock.level:
      return s.level >= t.threshold;
    case TitleUnlock.badges:
      return s.badgeCount >= t.threshold;
  }
}

/// 使える称号か(買った、または達成した)。
bool isTitleAvailable(TitleDef t, TitleStats s, Set<String> owned) =>
    t.isPurchasable ? owned.contains(t.id) : isAchievementMet(t, s);

/// 保存されたIDが有効なら称号を返す。使えない・知らないIDは null。
TitleDef? resolveActiveTitle(String? savedId, TitleStats s, Set<String> owned) {
  final t = titleDefById(savedId);
  if (t == null) return null;
  return isTitleAvailable(t, s, owned) ? t : null;
}
