import 'dart:convert';
import '../models/badge_acquisition_history.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeAcquisitionHistoryState {
  final List<BadgeAcquisitionRecord> badgeRecords;
  final List<SetBonusAcquisitionRecord> setBonusRecords;

  const BadgeAcquisitionHistoryState({
    required this.badgeRecords,
    required this.setBonusRecords,
  });

  BadgeAcquisitionHistoryState copyWith({
    List<BadgeAcquisitionRecord>? badgeRecords,
    List<SetBonusAcquisitionRecord>? setBonusRecords,
  }) {
    return BadgeAcquisitionHistoryState(
      badgeRecords: badgeRecords ?? this.badgeRecords,
      setBonusRecords: setBonusRecords ?? this.setBonusRecords,
    );
  }

  /// 直近30日のバッジ獲得記録を取得
  List<BadgeAcquisitionRecord> getRecentBadges({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return badgeRecords.where((r) => r.acquiredAt.isAfter(cutoff)).toList();
  }

  /// 直近30日のセットボーナス獲得記録を取得
  List<SetBonusAcquisitionRecord> getRecentSetBonuses({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return setBonusRecords.where((r) => r.acquiredAt.isAfter(cutoff)).toList();
  }
}

/// バッジ獲得履歴管理Notifier
class BadgeAcquisitionHistoryNotifier
    extends StateNotifier<BadgeAcquisitionHistoryState> {
  static const String _badgeHistoryKey = 'badge_acquisition_history';
  static const String _setBonusHistoryKey = 'set_bonus_acquisition_history';

  BadgeAcquisitionHistoryNotifier()
      : super(const BadgeAcquisitionHistoryState(
          badgeRecords: [],
          setBonusRecords: [],
        )) {
    _loadHistory();
  }

  /// 履歴をSharedPreferencesから読み込む
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // バッジ履歴を読み込む
    final badgeJson = prefs.getStringList(_badgeHistoryKey) ?? [];
    final badgeRecords = badgeJson
        .map((json) => BadgeAcquisitionRecord.fromJson(jsonDecode(json)))
        .toList();

    // セットボーナス履歴を読み込む
    final setBonusJson = prefs.getStringList(_setBonusHistoryKey) ?? [];
    final setBonusRecords = setBonusJson
        .map((json) => SetBonusAcquisitionRecord.fromJson(jsonDecode(json)))
        .toList();

    state = state.copyWith(
      badgeRecords: badgeRecords,
      setBonusRecords: setBonusRecords,
    );
  }

  /// バッジ獲得を記録
  Future<void> recordBadgeAcquisition(
    String badgeId,
    String badgeTitle,
    String emoji,
  ) async {
    final record = BadgeAcquisitionRecord(
      badgeId: badgeId,
      badgeTitle: badgeTitle,
      emoji: emoji,
      acquiredAt: DateTime.now(),
    );

    final newRecords = [...state.badgeRecords, record];
    state = state.copyWith(badgeRecords: newRecords);

    // SharedPreferencesに保存
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        newRecords.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_badgeHistoryKey, jsonList);
  }

  /// セットボーナス獲得を記録
  Future<void> recordSetBonusAcquisition(
    String setId,
    String setTitle,
    String emoji,
    int rewardCoins,
  ) async {
    final record = SetBonusAcquisitionRecord(
      setId: setId,
      setTitle: setTitle,
      emoji: emoji,
      rewardCoins: rewardCoins,
      acquiredAt: DateTime.now(),
    );

    final newRecords = [...state.setBonusRecords, record];
    state = state.copyWith(setBonusRecords: newRecords);

    // SharedPreferencesに保存
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        newRecords.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_setBonusHistoryKey, jsonList);
  }

  /// 履歴をクリア
  Future<void> clearHistory() async {
    state = const BadgeAcquisitionHistoryState(
      badgeRecords: [],
      setBonusRecords: [],
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_badgeHistoryKey);
    await prefs.remove(_setBonusHistoryKey);
  }

  /// 古い記録を削除（デフォルト90日以上前）
  Future<void> cleanupOldRecords({int daysToKeep = 90}) async {
    final cutoff = DateTime.now().subtract(Duration(days: daysToKeep));

    final newBadgeRecords =
        state.badgeRecords.where((r) => r.acquiredAt.isAfter(cutoff)).toList();
    final newSetBonusRecords = state.setBonusRecords
        .where((r) => r.acquiredAt.isAfter(cutoff))
        .toList();

    state = state.copyWith(
      badgeRecords: newBadgeRecords,
      setBonusRecords: newSetBonusRecords,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _badgeHistoryKey,
      newBadgeRecords.map((r) => jsonEncode(r.toJson())).toList(),
    );
    await prefs.setStringList(
      _setBonusHistoryKey,
      newSetBonusRecords.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }
}

/// バッジ獲得履歴プロバイダ
final badgeAcquisitionHistoryProvider =
    StateNotifierProvider<BadgeAcquisitionHistoryNotifier,
        BadgeAcquisitionHistoryState>(
  (ref) => BadgeAcquisitionHistoryNotifier(),
);
