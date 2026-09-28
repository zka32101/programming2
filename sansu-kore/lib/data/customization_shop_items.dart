import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

// ─── テーマカラー ────────────────────────────────────────────────────────────
// 購入すると設定画面から選んでホーム画面のヘッダー色を変更できる。

const kThemeColorItems = [
  AppShopItem(id: 'theme_blue', emoji: '🔵', name: 'クールブルー',
      description: 'さわやかな青のテーマカラー', category: 'テーマカラー', coinCost: 100),
  AppShopItem(id: 'theme_green', emoji: '🟢', name: 'フレッシュグリーン',
      description: '元気な緑のテーマカラー', category: 'テーマカラー', coinCost: 100),
  AppShopItem(id: 'theme_purple', emoji: '🟣', name: 'ミステリアスパープル',
      description: 'かっこいい紫のテーマカラー', category: 'テーマカラー', coinCost: 120),
  AppShopItem(id: 'theme_orange', emoji: '🟠', name: 'サンシャインオレンジ',
      description: '元気いっぱいの橙のテーマカラー', category: 'テーマカラー', coinCost: 100),
  AppShopItem(id: 'theme_pink', emoji: '🩷', name: 'ポップピンク',
      description: 'かわいいピンクのテーマカラー', category: 'テーマカラー', coinCost: 120),
];

const Map<String, Color> kThemeColorPrimary = {
  'theme_blue': Color(0xFF3498DB),
  'theme_green': Color(0xFF27AE60),
  'theme_purple': Color(0xFF9B59B6),
  'theme_orange': Color(0xFFE67E22),
  'theme_pink': Color(0xFFEC5FA0),
};

const Map<String, Color> kThemeColorDark = {
  'theme_blue': Color(0xFF2471A3),
  'theme_green': Color(0xFF1E8449),
  'theme_purple': Color(0xFF76448A),
  'theme_orange': Color(0xFFB9770E),
  'theme_pink': Color(0xFFC2185B),
};

// ─── 背景 ────────────────────────────────────────────────────────────────
// 購入するとホーム画面ヘッダーの背景がグラデーション柄に変わる。

const kBackgroundShopItems = [
  AppShopItem(id: 'bg_sunset', emoji: '🌅', name: 'サンセット',
      description: '夕焼けのグラデーション背景', category: '背景', coinCost: 150),
  AppShopItem(id: 'bg_night', emoji: '🌌', name: '星空',
      description: 'きらめく星空の背景', category: '背景', coinCost: 150),
  AppShopItem(id: 'bg_forest', emoji: '🌲', name: 'もりのなか',
      description: 'さわやかな森の背景', category: '背景', coinCost: 150),
  AppShopItem(id: 'bg_ocean', emoji: '🌊', name: 'うみのなか',
      description: '涼しげな海の背景', category: '背景', coinCost: 150),
];

const Map<String, List<Color>> kBackgroundGradients = {
  'bg_sunset': [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
  'bg_night': [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
  'bg_forest': [Color(0xFF134E5E), Color(0xFF71B280)],
  'bg_ocean': [Color(0xFF2193B0), Color(0xFF6DD5ED)],
};

// ─── 称号 ────────────────────────────────────────────────────────────────
// 購入するとホーム画面のニックネーム横にバッジとして表示できる。

const kTitleShopItems = [
  AppShopItem(id: 'title_master', emoji: '🏅', name: '算数マスター',
      description: 'ホーム画面に表示できる称号', category: '称号', coinCost: 200),
  AppShopItem(id: 'title_genius', emoji: '🧠', name: '計算の天才',
      description: 'ホーム画面に表示できる称号', category: '称号', coinCost: 200),
  AppShopItem(id: 'title_effort', emoji: '⭐', name: 'がんばり屋さん',
      description: 'ホーム画面に表示できる称号', category: '称号', coinCost: 100),
  AppShopItem(id: 'title_ace', emoji: '💯', name: '満点職人',
      description: 'ホーム画面に表示できる称号', category: '称号', coinCost: 250),
];

/// ショップの交換所に並べる商品一覧（テーマカラー・背景・称号）。
const kCustomizationShopItems = [
  ...kThemeColorItems,
  ...kBackgroundShopItems,
  ...kTitleShopItems,
];
