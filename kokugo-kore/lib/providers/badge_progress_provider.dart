import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_core/models/badge_model.dart';
import '../models/badge_progress_model.dart';

import 'badge_provider.dart';

const _progressPrefix = 'badge_progress_';

const _rarePrefix = 'badge_rarity_';

/// バッジ進捗・レアリティデータを管理するプロバイダー
class BadgeProgressNotifier extends Notifier<Map<String, BadgeProgress>> {
  @override
  Map<String, BadgeProgress> build() => {};

  /// SharedPreferencesからバッジ進捗を復元
  Future<void> load() async {
    // バッジ進捗は個別に更新/取得されるため、load時は空状態で初期化
    state = {};
  }

  /// バッジ進捗を更新・保存
  Future<void> updateProgress(String badgeId, int currentValue,
      {int? targetValue, DateTime? unlockedAt}) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = state[badgeId];

    final updated = existing?.copyWith(
          currentValue: currentValue,
          targetValue: targetValue,
          unlockedAt: unlockedAt,
        ) ??
        BadgeProgress(
          badgeId: badgeId,
          currentValue: currentValue,
          targetValue: targetValue ?? currentValue,
          description: badgeId,
          unlockedAt: unlockedAt,
        );

    // SharedPreferencesに保存 (簡略形式)
    final progressJson = '${updated.currentValue}|${updated.targetValue}|'
        '${updated.unlockedAt?.toIso8601String() ?? ''}';
    await prefs.setString('$_progressPrefix$badgeId', progressJson);

    // ローカルステート更新
    final newMap = Map<String, BadgeProgress>.from(state);
    newMap[badgeId] = updated;
    state = newMap;
  }

  /// レアリティを設定・保存
  Future<void> setRarity(String badgeId, BadgeRarity rarity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_rarePrefix$badgeId', rarity.id);
  }

  /// 初期化: 推奨レアリティを設定
  Future<void> initializeRarities({
    required Map<String, BadgeRarity> rarityMap,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    for (final entry in rarityMap.entries) {
      await prefs.setString('$_rarePrefix${entry.key}', entry.value.id);
    }
  }

  /// 特定のバッジの進捗を取得
  BadgeProgress? getProgress(String badgeId) => state[badgeId];

  /// 進捗中のバッジ一覧を取得
  List<BadgeProgress> getProgressingBadges() {
    return state.values
        .where((p) => p.progressPercent > 0 && p.progressPercent < 1.0)
        .toList()
      ..sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
  }

  /// クリア（テスト用）
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_progressPrefix) || key.startsWith(_rarePrefix)) {
        await prefs.remove(key);
      }
    }
    state = {};
  }
}

/// バッジ進捗を管理するプロバイダー
final badgeProgressProvider =
    NotifierProvider<BadgeProgressNotifier, Map<String, BadgeProgress>>(
  BadgeProgressNotifier.new,
);

/// 進捗中のバッジ一覧を取得するプロバイダー
final progressingBadgesProvider =
    Provider<List<BadgeProgress>>((ref) {
  final progressMap = ref.watch(badgeProgressProvider);
  return progressMap.values
      .where((p) => p.progressPercent > 0 && p.progressPercent < 1.0)
      .toList()
    ..sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
});

/// バッジ獲得まであと少しのバッジ一覧（進捗率70%以上）
final nearbyCenterBadgesProvider =
    Provider<List<BadgeProgress>>((ref) {
  final progressMap = ref.watch(badgeProgressProvider);
  return progressMap.values
      .where((p) => p.progressPercent >= 0.7 && p.progressPercent < 1.0)
      .toList()
    ..sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
});
