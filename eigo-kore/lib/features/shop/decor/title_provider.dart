import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show inventoryProvider;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/badge_provider.dart';
import '../../../providers/level_provider.dart';
import '../../../providers/progress_provider.dart';
import 'title_items.dart';

const _kTitleKey = 'decor_title';

/// いま「つけている」称号のID。つけていなければ null。
class TitleNotifier extends Notifier<String?> {
  @override
  String? build() {
    Future.microtask(load);
    return null;
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    state = p.getString(_kTitleKey);
  }

  Future<void> equip(String id) async {
    state = id;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kTitleKey, id);
  }

  Future<void> unequip() async {
    state = null;
    final p = await SharedPreferences.getInstance();
    await p.remove(_kTitleKey);
  }
}

final titleProvider = NotifierProvider<TitleNotifier, String?>(TitleNotifier.new);

/// 既存の進捗値から作る称号判定用の値。
final titleStatsProvider = Provider<TitleStats>((ref) => TitleStats(
      level: ref.watch(levelProvider).level,
      streakDays: ref.watch(progressProvider).streakDays,
      badgeCount: ref.watch(badgeProvider).earnedBadges.length,
    ));

/// 使える状態のときだけ返す、いまの称号。
final activeTitleProvider = Provider<TitleDef?>((ref) => resolveActiveTitle(
      ref.watch(titleProvider),
      ref.watch(titleStatsProvider),
      ref.watch(inventoryProvider),
    ));
