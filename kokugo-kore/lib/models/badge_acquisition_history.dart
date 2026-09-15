import 'package:shared_core/models/badge_model.dart';
import 'badge_set_bonus_model.dart';

class BadgeAcquisitionRecord {
  final String badgeId;
  final String badgeTitle;
  final String emoji;
  final DateTime acquiredAt;

  const BadgeAcquisitionRecord({
    required this.badgeId,
    required this.badgeTitle,
    required this.emoji,
    required this.acquiredAt,
  });

  /// JSONシリアライズ（SharedPreferences保存用）
  Map<String, dynamic> toJson() => {
    'badgeId': badgeId,
    'badgeTitle': badgeTitle,
    'emoji': emoji,
    'acquiredAt': acquiredAt.toIso8601String(),
  };

  factory BadgeAcquisitionRecord.fromJson(Map<String, dynamic> json) =>
      BadgeAcquisitionRecord(
        badgeId: json['badgeId'] as String,
        badgeTitle: json['badgeTitle'] as String,
        emoji: json['emoji'] as String,
        acquiredAt: DateTime.parse(json['acquiredAt'] as String),
      );
}

/// セットボーナス獲得履歴
class SetBonusAcquisitionRecord {
  final String setId;
  final String setTitle;
  final String emoji;
  final int rewardCoins;
  final DateTime acquiredAt;

  const SetBonusAcquisitionRecord({
    required this.setId,
    required this.setTitle,
    required this.emoji,
    required this.rewardCoins,
    required this.acquiredAt,
  });

  /// JSONシリアライズ（SharedPreferences保存用）
  Map<String, dynamic> toJson() => {
    'setId': setId,
    'setTitle': setTitle,
    'emoji': emoji,
    'rewardCoins': rewardCoins,
    'acquiredAt': acquiredAt.toIso8601String(),
  };

  factory SetBonusAcquisitionRecord.fromJson(Map<String, dynamic> json) =>
      SetBonusAcquisitionRecord(
        setId: json['setId'] as String,
        setTitle: json['setTitle'] as String,
        emoji: json['emoji'] as String,
        rewardCoins: json['rewardCoins'] as int,
        acquiredAt: DateTime.parse(json['acquiredAt'] as String),
      );
}

/// 通知タイプ
enum NotificationType {
  badge,      // 通常のバッジ獲得
  setBonus,   // セットボーナス完成
  multiple,   // 複数バッジ同時獲得
}

/// バッジ通知データ
class BadgeNotificationData {
  final NotificationType type;
  final List<BadgeModel>? badges;        // 通常バッジ、複数バッジの場合
  final BadgeSetBonus? setBonus;         // セットボーナスの場合
  final int? totalCoinsEarned;           // セットボーナスで獲得したコイン
  final DateTime timestamp;

  const BadgeNotificationData({
    required this.type,
    this.badges,
    this.setBonus,
    this.totalCoinsEarned,
    required this.timestamp,
  });
}
