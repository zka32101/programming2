import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show AppShopItem, inventoryProvider;
import '../data/customization_shop_items.dart';
import '../providers/customization_provider.dart';
import '../theme/app_theme.dart';
import 'shop_screen.dart';

/// ショップで購入したテーマカラー・背景・称号の中から、
/// 実際に使うものを選ぶ画面。
class CustomizationScreen extends ConsumerWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = ref.watch(inventoryProvider);
    final custom = ref.watch(customizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('見た目をカスタマイズ'),
        backgroundColor: kPrimaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CustomizationSection(
            title: '🎨 テーマカラー',
            items: kThemeColorItems,
            owned: owned,
            selectedId: custom.themeId,
            onSelect: (id) => ref.read(customizationProvider.notifier).selectTheme(id),
          ),
          const SizedBox(height: 20),
          _CustomizationSection(
            title: '🖼 背景',
            items: kBackgroundShopItems,
            owned: owned,
            selectedId: custom.backgroundId,
            onSelect: (id) => ref.read(customizationProvider.notifier).selectBackground(id),
          ),
          const SizedBox(height: 20),
          _CustomizationSection(
            title: '🏅 称号',
            items: kTitleShopItems,
            owned: owned,
            selectedId: custom.titleId,
            onSelect: (id) => ref.read(customizationProvider.notifier).selectTitle(id),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ShopScreen()),
            ),
            icon: const Icon(Icons.storefront),
            label: const Text('ショップでもっと購入する'),
          ),
        ],
      ),
    );
  }
}

class _CustomizationSection extends StatelessWidget {
  final String title;
  final List<AppShopItem> items;
  final Set<String> owned;
  final String? selectedId;
  final ValueChanged<String?> onSelect;

  const _CustomizationSection({
    required this.title,
    required this.items,
    required this.owned,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final ownedItems = items.where((i) => owned.contains(i.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (ownedItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'まだ持っていないよ。ショップで購入してみよう！',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // 「なし（デフォルトに戻す）」チップ
              ChoiceChip(
                label: const Text('なし'),
                selected: selectedId == null,
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  onSelect(null);
                },
              ),
              for (final item in ownedItems)
                ChoiceChip(
                  label: Text('${item.emoji} ${item.name}'),
                  selected: selectedId == item.id,
                  onSelected: (_) {
                    HapticFeedback.selectionClick();
                    onSelect(item.id);
                  },
                ),
            ],
          ),
      ],
    );
  }
}
