enum AvatarUnlockType { free, coin, premium }

class AvatarModel {
  final String id;
  final String name;
  final String emoji;
  final AvatarUnlockType unlockType;
  final int? coinCost;

  /// Asset path (package-qualified) for the illustrated avatar icon.
  /// Falls back to [emoji] wherever the image can't be loaded.
  String get imageAsset => 'packages/shared_core/assets/avatars/avatar_$id.jpg';

  const AvatarModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.unlockType,
    this.coinCost,
  });
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
  // 有料解放4種類（プレミアム）
  AvatarModel(
    id: 'honhon',
    name: '茶色クマ',
    emoji: '🐻',
    unlockType: AvatarUnlockType.premium,
  ),
  AvatarModel(
    id: 'panda',
    name: 'パンダ',
    emoji: '🐼',
    unlockType: AvatarUnlockType.premium,
  ),
  AvatarModel(
    id: 'raion',
    name: 'ライオン',
    emoji: '🦁',
    unlockType: AvatarUnlockType.premium,
  ),
  AvatarModel(
    id: 'koala',
    name: 'コアラ',
    emoji: '🐨',
    unlockType: AvatarUnlockType.premium,
  ),
  // コイン解放8種類（価格はばらつき）
  AvatarModel(
    id: 'tora',
    name: 'トラ',
    emoji: '🐯',
    unlockType: AvatarUnlockType.coin,
    coinCost: 150,
  ),
  AvatarModel(
    id: 'usagi',
    name: 'ウサギ',
    emoji: '🐰',
    unlockType: AvatarUnlockType.coin,
    coinCost: 200,
  ),
  AvatarModel(
    id: 'kaeru',
    name: 'カエル',
    emoji: '🐸',
    unlockType: AvatarUnlockType.coin,
    coinCost: 250,
  ),
  AvatarModel(
    id: 'buta',
    name: 'ブタ',
    emoji: '🐷',
    unlockType: AvatarUnlockType.coin,
    coinCost: 300,
  ),
  AvatarModel(
    id: 'kirin',
    name: 'キリン',
    emoji: '🦒',
    unlockType: AvatarUnlockType.coin,
    coinCost: 350,
  ),
  AvatarModel(
    id: 'kangaroo',
    name: 'カンガルー',
    emoji: '🦘',
    unlockType: AvatarUnlockType.coin,
    coinCost: 400,
  ),
  AvatarModel(
    id: 'arai_guma',
    name: 'アライグマ',
    emoji: '🦝',
    unlockType: AvatarUnlockType.coin,
    coinCost: 450,
  ),
  AvatarModel(
    id: 'namakemono',
    name: 'ナマケモノ',
    emoji: '🦥',
    unlockType: AvatarUnlockType.coin,
    coinCost: 500,
  ),
];
