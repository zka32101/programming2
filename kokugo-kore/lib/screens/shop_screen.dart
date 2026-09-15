import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart'
    hide kTextDark, kTextMuted;

import '../data/kokugo_characters.dart';
import '../widgets/kokugo_shop_page.dart';
import '../providers/avatar_unlock_provider.dart';

// Get coin-unlock avatars for shop display (paid avatars only)
List<AvatarModel> _getCoinUnlockAvatars() {
  return getPaidAvatars();

}

// ── 国語コレ 交換所アイテム ───────────────────────────────────────────────

const _exchangeItems = [
  // 全アプリ共通のショップアイテム（背景テーマ・フレーム、装着対応）
  ...kCommonShopItems,
  AppShopItem(id: 'hat_crown',   emoji: '👑', name: '金のおうかん',
      description: 'キャラに金色の王冠をかぶせる', category: '帽子', coinCost: 100),
  AppShopItem(id: 'hat_bear',    emoji: '🐻', name: 'クマ耳',
      description: 'かわいいクマの耳をつける', category: '帽子', coinCost: 80),
  AppShopItem(id: 'hat_book',    emoji: '📚', name: '本の博士帽',
      description: '国語博士の証し、博士帽', category: '帽子', coinCost: 120),
  AppShopItem(id: 'bg_space',    emoji: '🌌', name: '宇宙の背景',
      description: '星と銀河の幻想的な背景', category: '背景', coinCost: 200),
  AppShopItem(id: 'bg_library',  emoji: '📖', name: '図書館の背景',
      description: '本棚が並ぶ素敵な図書館', category: '背景', coinCost: 200),
  AppShopItem(id: 'bg_ocean',    emoji: '🌊', name: '深海の背景',
      description: '海の中のような青い背景', category: '背景', coinCost: 200),
  AppShopItem(id: 'bgm_jazz',    emoji: '🎵', name: 'ジャズBGM',
      description: '学習中のBGMをジャズに変更', category: 'BGM', coinCost: 150),
  AppShopItem(id: 'bgm_nature',  emoji: '🌿', name: '自然音BGM',
      description: '小鳥のさえずりと川の音', category: 'BGM', coinCost: 150),
  AppShopItem(id: 'frame_rainbow', emoji: '🌈', name: '虹色フレーム',
      description: 'プロフカードに虹色の縁取り', category: 'フレーム', coinCost: 250),
  AppShopItem(id: 'frame_book',  emoji: '📔', name: '本のフレーム',
      description: '国語らしい本のフレーム', category: 'フレーム', coinCost: 200),
  AppShopItem(id: 'avatar_panda',     emoji: '🐼', name: 'パンダアイコン',
      description: 'プロフィールアイコンをパンダに', category: 'アイコン', coinCost: 50),
  AppShopItem(id: 'avatar_tiger',     emoji: '🐯', name: 'トラアイコン',
      description: 'プロフィールアイコンをトラに', category: 'アイコン', coinCost: 80),
  AppShopItem(id: 'avatar_koala',     emoji: '🐨', name: 'コアラアイコン',
      description: 'プロフィールアイコンをコアラに', category: 'アイコン', coinCost: 80),
  AppShopItem(id: 'avatar_fox',       emoji: '🦊', name: 'キツネアイコン',
      description: 'プロフィールアイコンをキツネに', category: 'アイコン', coinCost: 80),
  AppShopItem(id: 'avatar_penguin',   emoji: '🐧', name: 'ペンギンアイコン',
      description: 'プロフィールアイコンをペンギンに', category: 'アイコン', coinCost: 100),
  AppShopItem(id: 'avatar_lion',      emoji: '🦁', name: 'ライオンアイコン',
      description: 'プロフィールアイコンをライオンに', category: 'アイコン', coinCost: 120),
  AppShopItem(id: 'avatar_wolf',      emoji: '🐺', name: 'オオカミアイコン',
      description: 'プロフィールアイコンをオオカミに', category: 'アイコン', coinCost: 120),
  AppShopItem(id: 'avatar_dolphin',   emoji: '🐬', name: 'イルカアイコン',
      description: 'プロフィールアイコンをイルカに', category: 'アイコン', coinCost: 150),
  AppShopItem(id: 'avatar_eagle',     emoji: '🦅', name: 'ワシアイコン',
      description: 'プロフィールアイコンをワシに', category: 'アイコン', coinCost: 150),
  AppShopItem(id: 'avatar_butterfly', emoji: '🦋', name: 'チョウアイコン',
      description: 'プロフィールアイコンをチョウに', category: 'アイコン', coinCost: 150),
  // LINE スタンプ引換券は今後のリリース予定
  // AppShopItem(id: 'stamp_coupon_general', emoji: '🎁',
  //     name: 'LINEスタンプ無料引換券',
  //     description: '好きなスタンプ1セットが無料に！',
  //     category: 'スペシャル', coinCost: 1000),
];

// ── 国語コレ 期間限定アイテム ─────────────────────────────────────────────

// 期間限定商品は一時的に非表示（2026-07-22）。復活時はこのマップに戻す。
// const _seasonalItems = <String, List<AppShopItem>>{
//   'spring': [
//     AppShopItem(id: 'bg_sakura', emoji: '🌸', name: '桜の背景',
//         description: '春らしい満開の桜', category: '期間限定', coinCost: 300),
//     AppShopItem(id: 'frame_entrance', emoji: '🎒', name: '入学式フレーム',
//         description: '新学期を彩るフレーム', category: '期間限定', coinCost: 200),
//     AppShopItem(id: 'hat_flowerCrown', emoji: '💐', name: '花かんむり',
//         description: '春の花を頭に飾ろう', category: '期間限定', coinCost: 150),
//   ],
//   'summer': [
//     AppShopItem(id: 'bg_fireworks', emoji: '🎆', name: '花火の背景',
//         description: '夏の夜空を彩る花火', category: '期間限定', coinCost: 300),
//     AppShopItem(id: 'hat_sunhat', emoji: '👒', name: '麦わら帽子',
//         description: '夏の定番、麦わら帽子', category: '期間限定', coinCost: 100),
//     AppShopItem(id: 'effect_waves', emoji: '🌊', name: '波エフェクト',
//         description: '涼しげな波のエフェクト', category: '期間限定', coinCost: 250),
//   ],
//   'autumn': [
//     AppShopItem(id: 'bg_leaves', emoji: '🍁', name: '紅葉の背景',
//         description: '秋の美しい紅葉の背景', category: '期間限定', coinCost: 300),
//     AppShopItem(id: 'frame_autumn_book', emoji: '📚', name: '読書フレーム',
//         description: '読書の秋にぴったり', category: '期間限定', coinCost: 200),
//     AppShopItem(id: 'hat_mushroom', emoji: '🍄', name: 'キノコ帽子',
//         description: '秋の森のキノコ帽子', category: '期間限定', coinCost: 120),
//   ],
//   'winter': [
//     AppShopItem(id: 'bg_snow', emoji: '❄️', name: '雪の背景',
//         description: '白銀の世界が広がる背景', category: '期間限定', coinCost: 300),
//     AppShopItem(id: 'hat_santa', emoji: '🎅', name: 'サンタ帽',
//         description: 'クリスマスのサンタ帽', category: '期間限定', coinCost: 150),
//     AppShopItem(id: 'frame_newyear', emoji: '🎍', name: 'お正月フレーム',
//         description: '新年を彩るフレーム', category: '期間限定', coinCost: 200),
//     AppShopItem(id: 'effect_snow', emoji: '🌨️', name: '雪のエフェクト',
//         description: 'ふわふわ雪が降るエフェクト', category: '期間限定', coinCost: 200),
//   ],
// };
const _seasonalItems = <String, List<AppShopItem>>{};

// ── ShopScreen ────────────────────────────────────────────────────────────

/// 国語コレ版ショップ（キャラ画像対応）。
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KokugoShopPage(
      characters: kKokugoCharacters,
      exchangeItems: _exchangeItems,
      seasonalItems: _seasonalItems,
      coinUnlockAvatars: _getCoinUnlockAvatars(),
    );
  }
}
