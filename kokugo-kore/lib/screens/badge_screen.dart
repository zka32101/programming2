import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/badge_model.dart' hide allBadges;

import '../providers/badge_provider.dart' show badgeProvider, allBadges, BadgeState;
import '../models/badge_progress_model.dart';
import '../theme/app_theme.dart';
import '../widgets/badge_widget.dart';
import '../widgets/badge_collection_challenges.dart';
import '../widgets/badge_set_bonus_display.dart';

enum BadgeFilterType {
  all('すべて'),
  earned('取得済'),
  unearned('未取得'),
  nearby('あと少し');

  final String label;
  const BadgeFilterType(this.label);
}

enum BadgeSortType {
  normal('デフォルト'),
  rarity('レア度順'),
  earned('獲得日順');

  final String label;
  const BadgeSortType(this.label);
}

class BadgeScreen extends ConsumerStatefulWidget {
  const BadgeScreen({super.key});

  @override
  ConsumerState<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends ConsumerState<BadgeScreen> {
  BadgeFilterType _filter = BadgeFilterType.all;
  BadgeSortType _sort = BadgeSortType.normal;

  @override
  Widget build(BuildContext context) {
    final badgeState = ref.watch(badgeProvider);
    final earnedIds = badgeState.earnedBadges.map((e) => e.badge.id).toSet();
    final earnedCount = badgeState.earnedBadges.length;

    // allBadges は badge_provider で管理（初期化時に自動設定）
    // 初期化されるまで空リストとして機能
    final allBadgesRef = allBadges; // badge_provider.dart で定義
    final totalCount = allBadgesRef.length;

    // フィルタと絞り込み
    var displayBadges = _filterAndSortBadges(
      allBadgesRef,
      earnedIds,
      _filter,
      _sort,
      badgeState,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('バッジコレクション'),
        backgroundColor: kPrimaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          // ヘッダー
          SliverToBoxAdapter(
            child: _BadgeHeader(earned: earnedCount, total: totalCount),
          ),

          // バッジコレクション統計
          SliverToBoxAdapter(
            child: BadgeCollectionStats(),
          ),

          // バッジコレクションチャレンジ
          SliverToBoxAdapter(
            child: BadgeCollectionChallenges(),
          ),

          // バッジセットボーナス
          SliverToBoxAdapter(
            child: BadgeSetBonusDisplay(),
          ),

          // フィルタ・ソートボタン
          SliverToBoxAdapter(
            child: _FilterSortBar(
              filter: _filter,
              sort: _sort,
              onFilterChanged: (f) => setState(() => _filter = f),
              onSortChanged: (s) => setState(() => _sort = s),
            ),
          ),

          // バッジグリッド
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final badge = displayBadges[i];
                  final isEarned = earnedIds.contains(badge.id);

                  if (isEarned) {
                    final earned = badgeState.earnedBadges
                        .firstWhere((e) => e.badge.id == badge.id);
                    return GestureDetector(
                      onTap: () => _showBadgeDetail(context, earned, badgeState),
                      child: BadgeWidget(earnedBadge: earned),
                    );
                  }
                  return GestureDetector(
                    onTap: () => _showLockedDetail(context, badge, badgeState),
                    child: LockedBadgeWidget(badge: badge),
                  );
                },
                childCount: displayBadges.length,
              ),
            ),
          ),

          // 下余白
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  List<BadgeModel> _filterAndSortBadges(
    List<BadgeModel> badges,
    Set<String> earnedIds,
    BadgeFilterType filter,
    BadgeSortType sort,
    BadgeState badgeState,
  ) {
    var result = badges.toList();

    // フィルタ適用
    switch (filter) {
      case BadgeFilterType.earned:
        result = result.where((b) => earnedIds.contains(b.id)).toList();
      case BadgeFilterType.unearned:
        result = result.where((b) => !earnedIds.contains(b.id)).toList();
      case BadgeFilterType.nearby:
        // 進捗が70%以上のバッジ
        result = result
            .where((b) {
              final progress = badgeState.getProgress(b.id);
              return progress != null && progress.progressPercent >= 0.7;
            })
            .toList();
      case BadgeFilterType.all:
        break;
    }

    // ソート適用
    switch (sort) {
      case BadgeSortType.rarity:
        result.sort((a, b) {
          final rarityA = badgeState.getRarity(a.id) ?? BadgeRarity.common;
          final rarityB = badgeState.getRarity(b.id) ?? BadgeRarity.common;
          return rarityB.index.compareTo(rarityA.index);
        });
      case BadgeSortType.earned:
        result.sort((a, b) {
          final earnedA = badgeState.earnedBadges
              .firstWhereOrNull((e) => e.badge.id == a.id);
          final earnedB = badgeState.earnedBadges
              .firstWhereOrNull((e) => e.badge.id == b.id);

          if (earnedA == null) return 1;
          if (earnedB == null) return -1;

          return earnedB.earnedAt.compareTo(earnedA.earnedAt);
        });
      case BadgeSortType.normal:
        break;
    }

    return result;
  }

  void _showBadgeDetail(
      BuildContext context, EarnedBadge earned, BadgeState badgeState) {
    final rarity = badgeState.getRarity(earned.badge.id);
    final reward = badgeState.getReward(earned.badge.id);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(earned.badge.emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(earned.badge.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            if (rarity != null) ...[
              const SizedBox(height: 6),
              Chip(
                label: Text(rarity.label,
                    style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: _getRarityColor(rarity),
              ),
            ],
            const SizedBox(height: 8),
            Text(earned.badge.description,
                style: const TextStyle(color: kTextMuted, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            if (reward != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.card_giftcard,
                        size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      reward.getRewardDescription(),
                      style: const TextStyle(fontSize: 12, color: Colors.amber),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              '獲得日: ${earned.earnedAt.year}/${earned.earnedAt.month}/${earned.earnedAt.day}',
              style: const TextStyle(color: kTextMuted, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLockedDetail(
      BuildContext context, BadgeModel badge, BadgeState badgeState) {
    final rarity = badgeState.getRarity(badge.id);
    final reward = badgeState.getReward(badge.id);
    final progress = badgeState.getProgress(badge.id);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 0.4, 0,
              ]),
              child: Text(badge.emoji, style: const TextStyle(fontSize: 56)),
            ),
            const SizedBox(height: 12),
            Text(badge.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
            if (rarity != null) ...[
              const SizedBox(height: 6),
              Chip(
                label: Text(rarity.label,
                    style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: _getRarityColor(rarity),
              ),
            ],
            const SizedBox(height: 8),
            Text(badge.description,
                style: const TextStyle(color: kTextMuted, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            // 進捗表示
            if (progress != null && progress.progressPercent > 0) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('進捗',
                            style: TextStyle(fontSize: 12, color: kTextMuted)),
                        Text('${progress.progressText}',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.progressPercent,
                        minHeight: 6,
                        backgroundColor: Colors.blue.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            // 報酬表示
            if (reward != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.card_giftcard,
                        size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      reward.getRewardDescription(),
                      style: const TextStyle(fontSize: 12, color: Colors.amber),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            // ロック表示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: kBgLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 16, color: kTextMuted),
                  SizedBox(width: 6),
                  Text('まだ獲得していません',
                      style: TextStyle(color: kTextMuted, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(BadgeRarity rarity) {
    return switch (rarity) {
      BadgeRarity.common => Colors.grey,
      BadgeRarity.rare => Colors.purple,
      BadgeRarity.epic => Colors.orange,
      BadgeRarity.legendary => Colors.amber,
      BadgeRarity.secret => Colors.black54,
    };
  }
}

class _FilterSortBar extends StatelessWidget {
  final BadgeFilterType filter;
  final BadgeSortType sort;
  final ValueChanged<BadgeFilterType> onFilterChanged;
  final ValueChanged<BadgeSortType> onSortChanged;

  const _FilterSortBar({
    required this.filter,
    required this.sort,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 2)
        ],
      ),
      child: Row(
        children: [
          // フィルタ
          Expanded(
            child: PopupMenuButton<BadgeFilterType>(
              initialValue: filter,
              onSelected: onFilterChanged,
              itemBuilder: (context) => BadgeFilterType.values
                  .map((f) => PopupMenuItem(
                        value: f,
                        child: Row(
                          children: [
                            if (f == filter)
                              const Icon(Icons.check,
                                  size: 16, color: kPrimaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(f.label),
                          ],
                        ),
                      ))
                  .toList(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.filter_list, size: 16, color: kPrimaryColor),
                    const SizedBox(width: 4),
                    Text(filter.label,
                        style: const TextStyle(
                            fontSize: 12, color: kPrimaryColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // ソート
          Expanded(
            child: PopupMenuButton<BadgeSortType>(
              initialValue: sort,
              onSelected: onSortChanged,
              itemBuilder: (context) => BadgeSortType.values
                  .map((s) => PopupMenuItem(
                        value: s,
                        child: Row(
                          children: [
                            if (s == sort)
                              const Icon(Icons.check,
                                  size: 16, color: kPrimaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(s.label),
                          ],
                        ),
                      ))
                  .toList(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort, size: 16, color: kPrimaryColor),
                    const SizedBox(width: 4),
                    Text(sort.label,
                        style: const TextStyle(
                            fontSize: 12, color: kPrimaryColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeHeader extends StatelessWidget {
  final int earned;
  final int total;
  const _BadgeHeader({required this.earned, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : earned / total;
    final percentage = pct.isFinite ? (pct * 100).round() : 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🏅', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('$earned / $total バッジ',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Text('$percentage%',
                  style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
