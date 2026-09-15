import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/badge_set_bonus_model.dart';

final badgeToSetBonusMapProvider = Provider((ref) {
  final map = <String, List<BadgeSetBonus>>{};
  for (final set in badgeSetBonuses.values) {
    for (final badgeId in set.requiredBadgeIds) {
      map.putIfAbsent(badgeId, () => []).add(set);
    }
  }
  return map;
});

/// セットボーナス統計情報キャッシュ
final setBonusStatsProvider = Provider((ref) {
  return BadgeSetBonusManager.getSetBonusStats(const {});
});
