enum AvatarUnlockType { free, coin, premium }

class AvatarModel {
  final String id;
  final String name;
  final String emoji;
  final AvatarUnlockType unlockType;
  final int? coinCost;

  const AvatarModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.unlockType,
    this.coinCost,
  });

  /// 各アプリ共通で lib/assets/avatars/ に同梱されているイラスト画像。
  String get imageAsset => 'packages/shared_core/lib/assets/avatars/avatar_$id.jpg';
}

const List<AvatarModel> allAvatars = [
  // 初期4種類（無料）
  AvatarModel(
    id: 'kuroneko',
    name: '黒猫',
    emoji: '🐱',
    unlockType: AvatarUnlockType.free,
  ),
  AvatarModel(
    id: 'ahiru',
    name: 'アヒル',
    emoji: '🦆',
    unlockType: AvatarUnlockType.free,
  ),
  AvatarModel(
    id: 'inu',
    name: 'イヌ',
    emoji: '🐶',
    unlockType: AvatarUnlockType.free,
  ),
  AvatarModel(
    id: 'kitsune',
    name: 'キツネ',
    emoji: '🦊',
    unlockType: AvatarUnlockType.free,
  ),
  // 5種類目以降はすべてコインで解放できるショップ商品（価格は昇順）
  AvatarModel(
    id: 'honhon',
    name: '茶色クマ',
    emoji: '🐻',
    unlockType: AvatarUnlockType.coin,
    coinCost: 150,
  ),
  AvatarModel(
    id: 'panda',
    name: 'パンダ',
    emoji: '🐼',
    unlockType: AvatarUnlockType.coin,
    coinCost: 200,
  ),
  AvatarModel(
    id: 'raion',
    name: 'ライオン',
    emoji: '🦁',
    unlockType: AvatarUnlockType.coin,
    coinCost: 250,
  ),
  AvatarModel(
    id: 'koala',
    name: 'コアラ',
    emoji: '🐨',
    unlockType: AvatarUnlockType.coin,
    coinCost: 300,
  ),
  AvatarModel(
    id: 'tora',
    name: 'トラ',
    emoji: '🐯',
    unlockType: AvatarUnlockType.coin,
    coinCost: 350,
  ),
  AvatarModel(
    id: 'usagi',
    name: 'ウサギ',
    emoji: '🐰',
    unlockType: AvatarUnlockType.coin,
    coinCost: 400,
  ),
  AvatarModel(
    id: 'kaeru',
    name: 'カエル',
    emoji: '🐸',
    unlockType: AvatarUnlockType.coin,
    coinCost: 450,
  ),
  AvatarModel(
    id: 'buta',
    name: 'ブタ',
    emoji: '🐷',
    unlockType: AvatarUnlockType.coin,
    coinCost: 500,
  ),
  AvatarModel(
    id: 'kirin',
    name: 'キリン',
    emoji: '🦒',
    unlockType: AvatarUnlockType.coin,
    coinCost: 550,
  ),
  AvatarModel(
    id: 'kangaroo',
    name: 'カンガルー',
    emoji: '🦘',
    unlockType: AvatarUnlockType.coin,
    coinCost: 600,
  ),
  AvatarModel(
    id: 'arai_guma',
    name: 'アライグマ',
    emoji: '🦝',
    unlockType: AvatarUnlockType.coin,
    coinCost: 650,
  ),
  AvatarModel(
    id: 'namakemono',
    name: 'ナマケモノ',
    emoji: '🦥',
    unlockType: AvatarUnlockType.coin,
    coinCost: 700,
  ),
];
