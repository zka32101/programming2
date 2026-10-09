/// 称号の定義と、解放条件の判定(純関数)。
///
/// 称号は「きせかえ」ショップの一区分。コインで買うものと、がんばりで自動解放されるものがある。
/// 商品IDは国語のきせかえと同じく dc_ 接頭辞。
enum TitleUnlockKind {
  /// バッジをこれだけ集める。
  badgeCount('バッジ'),

  /// 漢字クイズの正解の合計。
  kanjiCorrect('漢字の正解'),

  /// 読解の正解の合計。
  readingCorrect('読解の正解');

  const TitleUnlockKind(this.label);
  final String label;
}

/// 称号の解放判定に使う進捗値(既存の値だけ。新しい計測はしない)。
class TitleStats {
  const TitleStats({this.badgeCount = 0, this.kanjiCorrect = 0, this.readingCorrect = 0});

  final int badgeCount;
  final int kanjiCorrect;
  final int readingCorrect;

  int valueOf(TitleUnlockKind kind) {
    switch (kind) {
      case TitleUnlockKind.badgeCount:
        return badgeCount;
      case TitleUnlockKind.kanjiCorrect:
        return kanjiCorrect;
      case TitleUnlockKind.readingCorrect:
        return readingCorrect;
    }
  }
}

class TitleDef {
  const TitleDef({
    required this.id,
    required this.name,
    required this.description,
    this.coinCost,
    this.unlockKind,
    this.unlockAt = 0,
  });

  final String id;
  final String name;
  final String description;

  /// コインで買う称号の値段。null なら達成で解放される称号。
  final int? coinCost;
  final TitleUnlockKind? unlockKind;
  final int unlockAt;

  bool get isPurchasable => coinCost != null;

  /// 未解放のときに見せる条件の文。
  String get conditionText {
    final k = unlockKind;
    if (k == null) return '${coinCost}コインでこうかん';
    return '${k.label}を$unlockAt${k == TitleUnlockKind.badgeCount ? "こ" : "かい"}';
  }
}

const List<TitleDef> kTitleDefs = [
  // ── コインで買う ──
  TitleDef(id: 'dc_title_kana', name: 'かなのたつじん', description: 'ひらがなとカタカナがとくい', coinCost: 100),
  TitleDef(id: 'dc_title_kotowaza', name: 'ことわざめいじん', description: 'ことわざをたくさん知っている', coinCost: 200),
  TitleDef(id: 'dc_title_yomikaki', name: 'よみかきなんでもや', description: '読むのも書くのも大とくい', coinCost: 300),
  TitleDef(id: 'dc_title_bunsho', name: 'ぶんしょうめいじん', description: 'すてきな文章を作れる', coinCost: 400),
  TitleDef(id: 'dc_title_mahou', name: 'ことばのまほうつかい', description: 'ことばをじゆうにあやつる', coinCost: 500),
  // ── 達成で自動解放 ──
  TitleDef(
      id: 'dc_title_kanji',
      name: 'かんじはかせ',
      description: '漢字をたくさん正解した',
      unlockKind: TitleUnlockKind.kanjiCorrect,
      unlockAt: 100),
  TitleDef(
      id: 'dc_title_yomitori',
      name: 'よみとりめいじん',
      description: '読解をたくさん正解した',
      unlockKind: TitleUnlockKind.readingCorrect,
      unlockAt: 50),
  TitleDef(
      id: 'dc_title_takara',
      name: 'ことばのたからもの',
      description: 'バッジをたくさん集めた',
      unlockKind: TitleUnlockKind.badgeCount,
      unlockAt: 10),
];

TitleDef? titleById(String? id) {
  if (id == null) return null;
  for (final t in kTitleDefs) {
    if (t.id == id) return t;
  }
  return null;
}

/// 達成で解放される称号が、いまの進捗で解放済みか。コインで買う称号は常に false。
bool isTitleAchieved(TitleDef def, TitleStats stats) {
  final k = def.unlockKind;
  if (k == null) return false;
  return stats.valueOf(k) >= def.unlockAt;
}

/// つけられるか(買った、または達成した)。
bool isTitleAvailable(TitleDef def, TitleStats stats, Set<String> ownedIds) {
  return def.isPurchasable ? ownedIds.contains(def.id) : isTitleAchieved(def, stats);
}
