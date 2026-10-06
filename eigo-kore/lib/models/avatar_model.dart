/// アバター（プロフィール画像）。16種の動物イラスト。
///
/// - id 1〜4 : 最初から使える
/// - id 5〜16: コインでショップ購入（プロフィール編集画面）
class AvatarIcon {
  final String id;
  final String emoji; // 画像が読めない場合の代替表示
  final String name;
  final int price; // -1 = デフォルト無料
  final bool isDefault; // true = 最初から利用可

  const AvatarIcon({
    required this.id,
    required this.emoji,
    required this.name,
    required this.price,
    required this.isDefault,
  });

  bool get isPurchasable => price > 0;

  /// 画像アセット（assets/avatars/avatar_N.jpg）
  String get imageAsset => 'assets/avatars/$id.jpg';
}

/// 旧バージョンで保存された絵文字アバター → 新しい動物アバターID への対応
const Map<String, String> legacyAvatarEmojiToId = {
  '👧': 'avatar_1',
  '👦': 'avatar_2',
  '🧒': 'avatar_3',
  '👶': 'avatar_4',
};

// 16個のアバターアイコン
const allAvatarIcons = [
  AvatarIcon(
    id: 'avatar_1',
    emoji: '🐻',
    name: '茶色クマ',
    price: -1,
    isDefault: true,
  ),
  AvatarIcon(
    id: 'avatar_2',
    emoji: '🐱',
    name: '黒猫',
    price: -1,
    isDefault: true,
  ),
  AvatarIcon(
    id: 'avatar_3',
    emoji: '🐼',
    name: 'パンダ',
    price: -1,
    isDefault: true,
  ),
  AvatarIcon(
    id: 'avatar_4',
    emoji: '🦊',
    name: 'キツネ',
    price: -1,
    isDefault: true,
  ),
  AvatarIcon(
    id: 'avatar_5',
    emoji: '🐰',
    name: 'ウサギ',
    price: 150,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_6',
    emoji: '🐯',
    name: 'トラ',
    price: 150,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_7',
    emoji: '🦁',
    name: 'ライオン',
    price: 150,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_8',
    emoji: '🐸',
    name: 'カエル',
    price: 150,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_9',
    emoji: '🦆',
    name: 'アヒル',
    price: 150,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_10',
    emoji: '🐷',
    name: 'ブタ',
    price: 120,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_11',
    emoji: '🐨',
    name: 'コアラ',
    price: 120,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_12',
    emoji: '🦒',
    name: 'キリン',
    price: 120,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_13',
    emoji: '🦘',
    name: 'カンガルー',
    price: 200,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_14',
    emoji: '🐶',
    name: 'イヌ',
    price: 200,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_15',
    emoji: '🦝',
    name: 'アライグマ',
    price: 200,
    isDefault: false,
  ),
  AvatarIcon(
    id: 'avatar_16',
    emoji: '🦥',
    name: 'ナマケモノ',
    price: 200,
    isDefault: false,
  ),
];
