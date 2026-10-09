import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show inventoryProvider;
import '../../../design_system/app_colors.dart';
import 'decor_items.dart';
import 'decor_provider.dart';
import 'decor_scope.dart';
import 'title_items.dart';
import 'title_provider.dart';

/// 買ったきせかえ（背景・フレーム・エフェクト）をえらんでつける画面。
class DecorScreen extends ConsumerWidget {
  const DecorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = ref.watch(inventoryProvider);
    final active = ref.watch(activeDecorProvider);
    final mine = [for (final i in kDecorItems) if (owned.contains(i.id)) i];

    return Scaffold(
      backgroundColor: DecorScope.pageBg(context, const Color(0xFFF7F9FC)),
      appBar: AppBar(
        title: const Text('きせかえ'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (mine.isEmpty)
            const _Empty()
          else
            for (final kind in DecorKind.values) ...[
              _Section(
                kind: kind,
                items: [for (final i in mine) if (i.kind == kind) i],
                activeId: active.of(kind),
              ),
              const SizedBox(height: 16),
            ],
          const _TitleSection(),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/illustrations/empty_closet.webp', width: 160, key: const ValueKey('decor_empty_illust')),
            const SizedBox(height: 12),
            const Text(
              'まだきせかえをもっていないよ。\nショップでコインとこうかんして、背景やフレームをゲットしよう！',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// しょうごう(称号)をえらぶ。買った・たっせいしたものだけえらべて、ほかは鍵つきで条件を出す。
class _TitleSection extends ConsumerWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = ref.watch(inventoryProvider);
    final stats = ref.watch(titleStatsProvider);
    final active = ref.watch(activeTitleProvider);
    final notifier = ref.read(titleProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('しょうごう', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Tile(
              label: 'なし',
              selected: active == null,
              onTap: notifier.unequip,
              child: const Icon(Icons.block, color: Colors.grey),
            ),
            for (final t in kTitleDefs)
              if (isTitleAvailable(t, stats, owned))
                _Tile(
                  label: t.name,
                  selected: active?.id == t.id,
                  onTap: () => notifier.equip(t.id),
                  child: const Center(child: Text('🏅', style: TextStyle(fontSize: 30))),
                ),
          ],
        ),
        const SizedBox(height: 8),
        for (final t in kTitleDefs)
          if (!isTitleAvailable(t, stats, owned))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('${t.name}　${t.conditionText}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ),
              ]),
            ),
      ],
    );
  }
}

class _Section extends ConsumerWidget {
  const _Section({required this.kind, required this.items, required this.activeId});

  final DecorKind kind;
  final List<DecorItem> items;
  final String? activeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();
    final notifier = ref.read(decorProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kind.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Tile(
              label: 'なし',
              selected: activeId == null,
              onTap: () => notifier.unequip(kind),
              child: const Icon(Icons.block, color: Colors.grey),
            ),
            for (final item in items)
              _Tile(
                label: item.name,
                selected: activeId == item.id,
                onTap: () => notifier.equip(item),
                child: Image.asset(
                  item.thumb,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(child: Text(item.emoji, style: const TextStyle(fontSize: 26))),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.selected, required this.onTap, required this.child});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label${selected ? '、つけています' : ''}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 92,
          child: Column(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? primary : Colors.grey.shade300, width: selected ? 3 : 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
              const SizedBox(height: 4),
              Text(
                selected ? '✓ $label' : label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
