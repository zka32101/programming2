/// 国語コレ独自のキャラクター状態管理
/// shared_core.CharacterState を拡張し、EXP と進化レベルを管理

import 'package:shared_core/shared_core.dart';

/// 国語コレ版キャラクター状態（shared_core のCharacterStateを独立）
class KokugoCharacterState {
  final String characterId;

  final bool isUnlocked;
  final int level; // 従来のレベル（1-5）
  final int experience; // EXP（進化用、0～）
  final bool hasExpressions; // Lv.2: 表情3種
  final bool hasPoses; // Lv.3: ポーズ3種
  final bool hasBackstory; // Lv.4: バックストーリー
  final bool hasSparkle; // Lv.5: きらきらエフェクト
  final bool hasStampCoupon; // Lv.MAX: LINEスタンプ券

  const KokugoCharacterState({
    required this.characterId,
    this.isUnlocked = false,
    this.level = 1,
    this.experience = 0,
    this.hasExpressions = false,
    this.hasPoses = false,
    this.hasBackstory = false,
    this.hasSparkle = false,
    this.hasStampCoupon = false,
  });

  bool get isMaxLevel => level >= 5;
  String get levelLabel => isMaxLevel ? 'MAX ✨' : 'Lv.$level';
  int? get nextLevelCost => isMaxLevel ? null : const {2: 50, 3: 100, 4: 200, 5: 500}[level + 1];

  /// EXP ベースの進化レベル（1-3）
  /// Lv1→2: 100 EXP, Lv2→3: 300 EXP (累計 400)
  int get evolutionLevel {
    if (experience < 100) return 1;
    if (experience < 400) return 2;
    return 3;
  }

  /// 次のレベルまでに必要な EXP
  int get experienceForNextLevel {
    if (evolutionLevel >= 3) return 0;
    if (evolutionLevel == 1) return 100 - experience;
    return 400 - experience;
  }

  /// 進捗率（0.0～1.0）
  double get experienceProgress {
    if (evolutionLevel >= 3) return 1.0;
    const thresholds = {1: 0, 2: 100, 3: 400};
    final current = thresholds[evolutionLevel] ?? 0;
    final next = thresholds[evolutionLevel + 1] ?? 400;
    final levelExp = next - current;
    return levelExp == 0 ? 1.0 : ((experience - current) / levelExp).clamp(0.0, 1.0);
  }

  /// EXP を加算してレベルアップを判定
  KokugoCharacterState addExperience(int exp) {
    final newExp = experience + exp;
    final oldLevel = evolutionLevel;
    final newLevel = newExp < 100 ? 1 : (newExp < 400 ? 2 : 3);

    return KokugoCharacterState(
      characterId: characterId,
      isUnlocked: isUnlocked,
      level: level,
      experience: newExp,
      hasExpressions: hasExpressions || (newLevel >= 2),
      hasPoses: hasPoses || (newLevel >= 3),
      hasBackstory: hasBackstory,
      hasSparkle: hasSparkle,
      hasStampCoupon: hasStampCoupon,
    );
  }

  /// JSON シリアライゼーション
  Map<String, dynamic> toJson() => {
        'characterId': characterId,
        'isUnlocked': isUnlocked,
        'level': level,
        'experience': experience,
        'hasExpressions': hasExpressions,
        'hasPoses': hasPoses,
        'hasBackstory': hasBackstory,
        'hasSparkle': hasSparkle,
        'hasStampCoupon': hasStampCoupon,
      };

  factory KokugoCharacterState.fromJson(Map<String, dynamic> json) =>
      KokugoCharacterState(
        characterId: json['characterId'] ?? '',
        isUnlocked: json['isUnlocked'] ?? false,
        level: json['level'] ?? 1,
        experience: json['experience'] ?? 0,
        hasExpressions: json['hasExpressions'] ?? false,
        hasPoses: json['hasPoses'] ?? false,
        hasBackstory: json['hasBackstory'] ?? false,
        hasSparkle: json['hasSparkle'] ?? false,
        hasStampCoupon: json['hasStampCoupon'] ?? false,
      );
}
