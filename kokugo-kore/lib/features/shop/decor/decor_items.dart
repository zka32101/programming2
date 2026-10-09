/// きせかえの種類。
enum DecorKind {
  background('背景'),
  frame('フレーム'),
  effect('エフェクト');

  const DecorKind(this.label);
  final String label;
}

/// コインで買えるきせかえ（背景・フレーム・エフェクト）。見た目だけで、学習には影響しない。
///
/// 画像は `assets/shop/<id>.webp`（国語では既存の商品ID・背景テーマIDと重ならないよう、すべて dc_ を付ける）、一覧用のサムネイルは `assets/shop/thumb/<id>.webp`。
/// 画像と価格は design/小学コレ！/共通/コインショップ詳細実装設計書 と images/小学コレ！/コインショップ/README.md に対応。
class DecorItem {
  const DecorItem({
    required this.id,
    required this.name,
    required this.description,
    required this.kind,
    required this.coinCost,
    this.season,
  });

  final String id;
  final String name;
  final String description;
  final DecorKind kind;
  final int coinCost;

  /// null なら常設。spring / summer / autumn / winter は期間限定タブに出る。
  final String? season;

  String get asset => 'assets/shop/$id.webp';
  String get thumb => 'assets/shop/thumb/$id.webp';

  String get emoji {
    switch (kind) {
      case DecorKind.background:
        return '🖼️';
      case DecorKind.frame:
        return '🪞';
      case DecorKind.effect:
        return '✨';
    }
  }
}

const List<DecorItem> kDecorItems = [
  // ── 背景（常設） ──
  DecorItem(id: 'dc_bg_kokugo', name: '国語のせかい', description: 'ことばと本がならぶ背景', kind: DecorKind.background, coinCost: 200),
  DecorItem(id: 'dc_bg_space', name: '宇宙の背景', description: '星と銀河のきれいな背景', kind: DecorKind.background, coinCost: 200),
  DecorItem(id: 'dc_bg_ocean', name: '深海の背景', description: '海の中のような青い背景', kind: DecorKind.background, coinCost: 200),
  DecorItem(id: 'dc_bg_forest', name: '森の背景', description: '光がさす緑の森の背景', kind: DecorKind.background, coinCost: 200),
  DecorItem(id: 'dc_bg_sky', name: '空の背景', description: '虹と気球の青い空の背景', kind: DecorKind.background, coinCost: 200),
  // ── 背景（季節） ──
  DecorItem(id: 'dc_bg_sakura', name: '桜の背景', description: '桜の花びらがまう春の背景', kind: DecorKind.background, coinCost: 300, season: 'spring'),
  DecorItem(id: 'dc_bg_fireworks', name: '花火の背景', description: '夏まつりの花火の背景', kind: DecorKind.background, coinCost: 300, season: 'summer'),
  DecorItem(id: 'dc_bg_leaves', name: '紅葉の背景', description: '赤や黄色の葉っぱの秋の背景', kind: DecorKind.background, coinCost: 300, season: 'autumn'),
  DecorItem(id: 'dc_bg_snow', name: '雪の背景', description: '雪がふる冬の村の背景', kind: DecorKind.background, coinCost: 300, season: 'winter'),
  DecorItem(id: 'dc_bg_christmas', name: 'クリスマスのよる', description: 'ツリーがひかる雪のよるの背景', kind: DecorKind.background, coinCost: 300, season: 'winter'),
  DecorItem(id: 'dc_bg_newyear', name: 'はつひので', description: 'お正月の初日の出の背景', kind: DecorKind.background, coinCost: 300, season: 'winter'),
  // ── フレーム（常設） ──
  DecorItem(id: 'dc_frame_rainbow', name: '虹色フレーム', description: 'アイコンに虹色のふち', kind: DecorKind.frame, coinCost: 250),
  DecorItem(id: 'dc_frame_ribbon', name: 'リボンフレーム', description: 'かわいいリボンのふち', kind: DecorKind.frame, coinCost: 250),
  DecorItem(id: 'dc_frame_star', name: 'スターフレーム', description: 'キラキラ星のふち', kind: DecorKind.frame, coinCost: 250),
  DecorItem(id: 'dc_frame_party', name: 'お祝いフレーム', description: '風船とはたのふち', kind: DecorKind.frame, coinCost: 250),
  DecorItem(id: 'dc_frame_kokugo', name: 'こくごのフレーム', description: 'げんこう用紙とえんぴつのかざり', kind: DecorKind.frame, coinCost: 250),
  // ── フレーム（季節） ──
  DecorItem(id: 'dc_frame_entrance', name: '入学式フレーム', description: '桜とランドセルのふち', kind: DecorKind.frame, coinCost: 200, season: 'spring'),
  DecorItem(id: 'dc_frame_book', name: '読書フレーム', description: '本と紅葉のふち', kind: DecorKind.frame, coinCost: 200, season: 'autumn'),
  DecorItem(id: 'dc_frame_newyear', name: 'お正月フレーム', description: '松と梅のお正月のふち', kind: DecorKind.frame, coinCost: 200, season: 'winter'),
  DecorItem(id: 'dc_frame_christmas', name: 'クリスマスのフレーム', description: 'リースとオーナメントのふち', kind: DecorKind.frame, coinCost: 200, season: 'winter'),
  // ── エフェクト（季節・常設） ──
  DecorItem(id: 'dc_effect_waves', name: '波エフェクト', description: '画面の下にさざ波が広がる', kind: DecorKind.effect, coinCost: 250, season: 'summer'),
  DecorItem(id: 'dc_effect_snow', name: '雪エフェクト', description: '画面に雪の結晶がふる', kind: DecorKind.effect, coinCost: 200, season: 'winter'),
  DecorItem(id: 'dc_effect_sakura', name: 'さくらふぶき', description: 'さくらの花びらがまいちる', kind: DecorKind.effect, coinCost: 200, season: 'spring'),
  DecorItem(id: 'dc_effect_leaves', name: 'もみじのまい', description: '赤や黄色の葉っぱがまいおちる', kind: DecorKind.effect, coinCost: 200, season: 'autumn'),
  DecorItem(id: 'dc_effect_fireworks', name: 'はなび', description: '夜空に大きな花火がひらく', kind: DecorKind.effect, coinCost: 250, season: 'summer'),
  DecorItem(id: 'dc_effect_twinkle', name: 'きらきらほし', description: '画面のふちに星がきらきらひかる', kind: DecorKind.effect, coinCost: 250),
  DecorItem(id: 'dc_effect_christmas', name: 'クリスマスのかざり', description: 'オーナメントやほしがふってくる', kind: DecorKind.effect, coinCost: 200, season: 'winter'),
  DecorItem(id: 'dc_effect_newyear', name: 'おしょうがつのかざり', description: 'おめでたいかざりがまいちる', kind: DecorKind.effect, coinCost: 200, season: 'winter'),
  DecorItem(id: 'dc_effect_kokugo', name: 'こくごのエフェクト', description: 'ひらがなやことばがちらばるよ', kind: DecorKind.effect, coinCost: 200),
];

DecorItem? decorItemById(String? id) {
  if (id == null) return null;
  for (final i in kDecorItems) {
    if (i.id == id) return i;
  }
  return null;
}
