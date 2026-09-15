/// バッジのレアリティレベル
enum BadgeRarity {
  common('common', '🟦', '通常'),
  rare('rare', '🟪', 'レア'),
  epic('epic', '🟧', 'エピック'),
  legendary('legendary', '🟨', 'レジェンダリー'),
  secret('secret', '⬛', 'シークレット');

  final String id;
  final String emoji;
  final String label;

  const BadgeRarity(this.id, this.emoji, this.label);

  /// IDからレアリティを取得
  static BadgeRarity? fromId(String id) {
    try {
      return BadgeRarity.values.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// バッジの獲得進捗情報
class BadgeProgress {
  /// バッジID
  final String badgeId;

  /// 現在値
  final int currentValue;

  /// 目標値
  final int targetValue;

  /// バッジの説明（進捗表示用）
  /// 例: "連続学習 3/7日", "正答数 234/500問"
  final String description;

  /// アンロック日時（nullの場合は未獲得）
  final DateTime? unlockedAt;

  const BadgeProgress({
    required this.badgeId,
    required this.currentValue,
    required this.targetValue,
    required this.description,
    this.unlockedAt,
  });

  /// 進捗率（0.0 - 1.0）
  double get progressPercent =>
      (currentValue / targetValue.clamp(1, targetValue)).clamp(0.0, 1.0);

  /// バッジ獲得済みかチェック
  bool get isComplete => unlockedAt != null;

  /// 獲得予想日を計算（線形補間）
  DateTime? get estimatedUnlockDate {
    if (isComplete || targetValue <= currentValue) return null;
    if (currentValue == 0) return null;

    final remaining = targetValue - currentValue;
    final now = DateTime.now();
    final elapsedDays = 1; // 簡略化: 1日単位の進捗と仮定

    // 平均進捗速度から予想
    final avgDaysPerValue = elapsedDays / (currentValue.toDouble());
    final estimatedDays = (remaining * avgDaysPerValue).ceil();

    return now.add(Duration(days: estimatedDays));
  }

  /// 進捗率のパーセンテージ文字列
  String get progressText => '${(progressPercent * 100).toStringAsFixed(0)}%';

  /// 進捗バーの表示用テキスト
  /// 例: "234 / 500"
  String get progressCountText => '$currentValue / $targetValue';

  /// 進捗をコピー
  BadgeProgress copyWith({
    String? badgeId,
    int? currentValue,
    int? targetValue,
    String? description,
    DateTime? unlockedAt,
  }) {
    return BadgeProgress(
      badgeId: badgeId ?? this.badgeId,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      description: description ?? this.description,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// 進捗を更新
  BadgeProgress updateProgress(int newValue) {
    return copyWith(currentValue: newValue);
  }

  /// バッジをアンロック
  BadgeProgress unlock() {
    return copyWith(
      currentValue: targetValue,
      unlockedAt: DateTime.now(),
    );
  }
}
