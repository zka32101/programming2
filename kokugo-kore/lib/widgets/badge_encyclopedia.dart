import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/badge_model.dart';
import '../models/badge_set_bonus_model.dart';

import '../providers/badge_provider.dart';
import '../theme/app_theme.dart';
import 'badge_detail_dialog.dart';

/// バッジフィルタータイプ
enum BadgeFilterType {
  all,      // すべて
  acquired, // 獲得済み
  missing,  // 未獲得
}

/// バッジ図鑑ウィジェット
class BadgeEncyclopedia extends ConsumerStatefulWidget {
  final List<BadgeModel> allBadges;

  const BadgeEncyclopedia({
    super.key,
    required this.allBadges,
  });

  @override
  ConsumerState<BadgeEncyclopedia> createState() => _BadgeEncyclopediaState();
}

class _BadgeEncyclopediaState extends ConsumerState<BadgeEncyclopedia> {
  late BadgeFilterType _selectedFilter;
  late String _selectedSet;
  late List<String> _setOptions;

  @override
  void initState() {
    super.initState();
    _selectedFilter = BadgeFilterType.all;
    _setOptions = ['すべてのセット', ...badgeSetBonuses.keys];
    _selectedSet = _setOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final badgeState = ref.watch(badgeProvider);
    final earnedIds = badgeState.earnedBadges.map((e) => e.badge.id).toSet();

    // フィルタリング
    final filteredBadges = _filterBadges(earnedIds);

    // 統計情報
    final totalBadges = widget.allBadges.length;
    final acquiredCount = earnedIds.length;
    final acquiredPercent = totalBadges > 0 ? (acquiredCount / totalBadges * 100).toInt() : 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー：統計情報
          _buildStatisticsSection(acquiredCount, totalBadges, acquiredPercent),

          // フィルター・ソートコントロール
          _buildFilterControls(),

          // バッジグリッド
          _buildBadgeGrid(filteredBadges, earnedIds),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(int acquired, int total, int percent) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withAlpha(245),
            kPrimaryColor.withAlpha(210),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏆 バッジ図鑑',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // プログレスバー
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: acquired / total,
                    minHeight: 10,
                    backgroundColor: Colors.white.withAlpha(120),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$acquired/$total',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // フィルタータイプ
          const Text(
            'フィルター',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: BadgeFilterType.values.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_getFilterLabel(filter)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: kPrimaryColor,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // セット選択
          const Text(
            'セットで絞込',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _setOptions.map((setName) {
                final isSelected = _selectedSet == setName;
                final set = setName == 'すべてのセット'
                    ? null
                    : badgeSetBonuses[setName];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      set != null ? '${set.emoji} ${set.title}' : setName,
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedSet = setName);
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.amber.shade300,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.black87 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid(List<BadgeModel> badges, Set<String> earnedIds) {
    if (badges.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Text(
                _getEmptyMessage(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // レスポンシブ: デバイス幅に応じて列数を調整
          final screenWidth = constraints.maxWidth;
          final crossAxisCount = screenWidth > 600 ? 6 : 4;
          final childAspectRatio = screenWidth > 600 ? 1.0 : 0.9;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              final isAcquired = earnedIds.contains(badge.id);
              final acquiredAt = ref
                  .watch(badgeProvider)
                  .earnedBadges
                  .firstWhere(
                    (e) => e.badge.id == badge.id,
                    orElse: () =>
                        EarnedBadge(badge: badge, earnedAt: DateTime.now()),
                  )
                  .earnedAt;

              return _buildBadgeCard(badge, isAcquired, acquiredAt);
            },
          );
        },
      ),
    );
  }

  Widget _buildBadgeCard(
    BadgeModel badge,
    bool isAcquired,
    DateTime acquiredAt,
  ) {
    final relatedSets = _getRelatedSetBonuses(badge.id);

    return GestureDetector(
      onTap: () {
        showBadgeDetailDialog(
          context,
          badge: badge,
          acquiredAt: isAcquired ? acquiredAt : null,
          isAcquired: isAcquired,
          relatedSetBonuses: relatedSets,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAcquired ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isAcquired
                ? Colors.green.shade400
                : Colors.grey.shade300,
            width: isAcquired ? 2 : 1,
          ),
          boxShadow: isAcquired
              ? [
                  BoxShadow(
                    color: Colors.green.withAlpha(70),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // バッジコンテンツ
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // バッジアイコン
                Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 36,
                    color: isAcquired
                        ? Colors.black87
                        : Colors.black.withAlpha(120),
                  ),
                ),
                const SizedBox(height: 6),

                // バッジ名（省略）
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    badge.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isAcquired
                          ? Colors.black87
                          : Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),

            // 未獲得時のオーバーレイ
            if (!isAcquired)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),

            // 獲得済みバッジ
            if (isAcquired)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withAlpha(100),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<BadgeModel> _filterBadges(Set<String> earnedIds) {
    var filtered = widget.allBadges.toList();

    // フィルタータイプで絞込
    switch (_selectedFilter) {
      case BadgeFilterType.acquired:
        filtered =
            filtered.where((b) => earnedIds.contains(b.id)).toList();
        break;
      case BadgeFilterType.missing:
        filtered =
            filtered.where((b) => !earnedIds.contains(b.id)).toList();
        break;
      case BadgeFilterType.all:
        break;
    }

    // セットで絞込
    if (_selectedSet != 'すべてのセット') {
      final set = badgeSetBonuses[_selectedSet];
      if (set != null) {
        filtered = filtered
            .where((b) => set.requiredBadgeIds.contains(b.id))
            .toList();
      }
    }

    return filtered;
  }

  List<BadgeSetBonus> _getRelatedSetBonuses(String badgeId) {
    return badgeSetBonuses.values
        .where((set) => set.requiredBadgeIds.contains(badgeId))
        .toList();
  }

  String _getFilterLabel(BadgeFilterType filter) {
    switch (filter) {
      case BadgeFilterType.all:
        return 'すべて';
      case BadgeFilterType.acquired:
        return '獲得済み';
      case BadgeFilterType.missing:
        return '未獲得';
    }
  }

  String _getEmptyMessage() {
    switch (_selectedFilter) {
      case BadgeFilterType.acquired:
        return 'このセットで獲得済みのバッジはありません';
      case BadgeFilterType.missing:
        return 'このセットで未獲得のバッジはありません';
      case BadgeFilterType.all:
        return 'バッジがありません';
    }
  }
}
