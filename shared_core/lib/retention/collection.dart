import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/coin_provider.dart';

/// コレクションの中のグループ（例: 関東地方）。
class CollectionGroup {
  final String id;
  final String name;
  final List<String> itemIds;
  const CollectionGroup(
      {required this.id, required this.name, required this.itemIds});
}

/// 集める対象のまとまり（例: 47都道府県）。
class CollectionSet {
  final String id;
  final String title;
  final List<CollectionGroup> groups;

  /// グループ完成・全完成の報酬コイン
  final int groupCoins;
  final int completeCoins;

  const CollectionSet({
    required this.id,
    required this.title,
    required this.groups,
    this.groupCoins = 100,
    this.completeCoins = 500,
  });

  List<String> get allItemIds => [for (final g in groups) ...g.itemIds];
}

/// 達成したマイルストーン。[id] をバッジ/称号のIDに対応づけて使う。
class CollectionMilestone {
  final String id; // '<setId>:group:<groupId>' / '<setId>:complete'
  final String title;
  final int coins;
  const CollectionMilestone(this.id, this.title, this.coins);
}

/// 純粋ロジック: 収集状況から、新たに達成したマイルストーンを返す。
List<CollectionMilestone> newMilestones(
  CollectionSet set,
  Set<String> collected,
  Set<String> alreadyClaimed,
) {
  final result = <CollectionMilestone>[];
  for (final g in set.groups) {
    final id = '${set.id}:group:${g.id}';
    if (!alreadyClaimed.contains(id) && g.itemIds.every(collected.contains)) {
      result.add(CollectionMilestone(id, '${g.name}コンプリート', set.groupCoins));
    }
  }
  final completeId = '${set.id}:complete';
  if (!alreadyClaimed.contains(completeId) &&
      set.allItemIds.every(collected.contains)) {
    result.add(CollectionMilestone(
        completeId, '${set.title}マスター', set.completeCoins));
  }
  return result;
}

class CollectionState {
  /// setId → 集めた itemId
  final Map<String, Set<String>> collected;
  final Set<String> claimedMilestones;
  const CollectionState(
      {this.collected = const {}, this.claimedMilestones = const {}});
}

const _collectedKey = 'sc_collection_collected';
const _claimedKey = 'sc_collection_milestones';

/// 汎用コレクション管理。社会の「都道府県コンプリート」などで使う。
///
/// `collect(set, itemId)` を、そのアイテムを初めて達成したタイミング
/// （例: 都道府県クイズに正解）で呼ぶ。新たに達成したマイルストーンを
/// 返し、コインは自動で加算する。バッジ/称号の付与は返り値の id で行う。
class CollectionNotifier extends Notifier<CollectionState> {
  @override
  CollectionState build() => const CollectionState();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final collected = <String, Set<String>>{};
    final raw = prefs.getString(_collectedKey);
    if (raw != null) {
      try {
        (jsonDecode(raw) as Map<String, dynamic>).forEach(
            (k, v) => collected[k] = (v as List).cast<String>().toSet());
      } catch (_) {}
    }
    state = CollectionState(
      collected: collected,
      claimedMilestones: (prefs.getStringList(_claimedKey) ?? []).toSet(),
    );
  }

  Set<String> collectedOf(String setId) => state.collected[setId] ?? const {};

  Future<List<CollectionMilestone>> collect(
      CollectionSet set, String itemId) async {
    if (!set.allItemIds.contains(itemId)) return const [];
    final current = collectedOf(set.id);
    if (current.contains(itemId)) return const [];

    final updated = {...current, itemId};
    final newlyReached =
        newMilestones(set, updated, state.claimedMilestones);
    final claimed = {
      ...state.claimedMilestones,
      ...newlyReached.map((m) => m.id)
    };
    state = CollectionState(
      collected: {...state.collected, set.id: updated},
      claimedMilestones: claimed,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _collectedKey,
        jsonEncode(
            state.collected.map((k, v) => MapEntry(k, v.toList()))));
    await prefs.setStringList(_claimedKey, claimed.toList());

    final coins = newlyReached.fold<int>(0, (a, m) => a + m.coins);
    if (coins > 0) await ref.read(coinProvider.notifier).addCoins(coins);
    return newlyReached;
  }
}

final collectionProvider =
    NotifierProvider<CollectionNotifier, CollectionState>(
        CollectionNotifier.new);
