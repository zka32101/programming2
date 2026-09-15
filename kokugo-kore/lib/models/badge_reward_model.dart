/// バッジの報酬情報
class BadgeReward {
  /// 獲得コイン数
  final int coinAmount;

  /// アンロックするアバターID
  final List<String>? unlockedAvatarIds;

  /// アンロックするキャラクタースキンID
  final List<String>? unlockedCharacterSkins;

  /// プレミアムユーザーのみが獲得可能
  final bool isPremiumOnly;

  const BadgeReward({
    required this.coinAmount,
    this.unlockedAvatarIds,
    this.unlockedCharacterSkins,
    this.isPremiumOnly = false,
  });

  /// 報酬が複数存在するかチェック
  bool get hasMultipleRewards {
    final rewards = [
      coinAmount > 0,
      unlockedAvatarIds?.isNotEmpty ?? false,
      unlockedCharacterSkins?.isNotEmpty ?? false,
    ].where((r) => r).length;
    return rewards > 1;
  }

  /// 報酬の説明テキスト
  String getRewardDescription() {
    final rewards = <String>[];
    if (coinAmount > 0) {
      rewards.add('コイン x$coinAmount');
    }
    if (unlockedAvatarIds?.isNotEmpty ?? false) {
      rewards.add('アバター ${unlockedAvatarIds!.length}個');
    }
    if (unlockedCharacterSkins?.isNotEmpty ?? false) {
      rewards.add('キャラスキン ${unlockedCharacterSkins!.length}個');
    }
    return rewards.join(' + ');
  }

  /// 報酬をコピー
  BadgeReward copyWith({
    int? coinAmount,
    List<String>? unlockedAvatarIds,
    List<String>? unlockedCharacterSkins,
    bool? isPremiumOnly,
  }) {
    return BadgeReward(
      coinAmount: coinAmount ?? this.coinAmount,
      unlockedAvatarIds: unlockedAvatarIds ?? this.unlockedAvatarIds,
      unlockedCharacterSkins: unlockedCharacterSkins ?? this.unlockedCharacterSkins,
      isPremiumOnly: isPremiumOnly ?? this.isPremiumOnly,
    );
  }
}
