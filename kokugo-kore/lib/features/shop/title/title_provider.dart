import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/badge_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/purchased_items_provider.dart';
import 'title_data.dart';

/// 既存の進捗(バッジ数・漢字/読解の正解数)から作る、称号の解放判定用の値。
final titleStatsProvider = Provider<TitleStats>((ref) {
  final progress = ref.watch(progressProvider);
  final badges = ref.watch(badgeProvider);
  return TitleStats(
    badgeCount: badges.earnedBadges.length,
    kanjiCorrect: progress.totalKanjiCorrect,
    readingCorrect: progress.totalReadingCorrect,
  );
});

/// いま選んでいる称号ID(保存値)。未選択は null。
class TitleSelectionNotifier extends Notifier<String?> {
  static const _key = 'decor_title';

  @override
  String? build() {
    Future.microtask(load);
    return null;
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    state = p.getString(_key);
  }

  /// つけられる称号だけ選べる。
  Future<bool> select(TitleDef def) async {
    final stats = ref.read(titleStatsProvider);
    final owned = ref.read(purchasedItemsProvider).ownedItemIds;
    if (!isTitleAvailable(def, stats, owned)) return false;
    state = def.id;
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, def.id);
    return true;
  }

  Future<void> clear() async {
    state = null;
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}

final titleSelectionProvider =
    NotifierProvider<TitleSelectionNotifier, String?>(TitleSelectionNotifier.new);

/// つけられる状態の称号だけ(持っていない・知らないIDは無視)。ホームの表示に使う。
final activeTitleProvider = Provider<TitleDef?>((ref) {
  final def = titleById(ref.watch(titleSelectionProvider));
  if (def == null) return null;
  final stats = ref.watch(titleStatsProvider);
  final owned = ref.watch(purchasedItemsProvider).ownedItemIds;
  return isTitleAvailable(def, stats, owned) ? def : null;
});
