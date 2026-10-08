import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show coinProvider;
import '../../../providers/purchased_items_provider.dart';
import '../../../theme/app_theme.dart';
import 'decor_items.dart';
import 'decor_screen.dart';

String _season() {
  final m = DateTime.now().month;
  if (m >= 3 && m <= 5) return 'spring';
  if (m >= 6 && m <= 8) return 'summer';
  if (m >= 9 && m <= 11) return 'autumn';
  return 'winter';
}

/// ショップの「きせかえ」タブ。背景・フレーム・エフェクトをコインで買う。
/// 常設と、いまの季節の商品を出す。買ったものは「きせかえ」画面でつける。
class DecorShopTab extends ConsumerWidget {
  const DecorShopTab({super.key, this.season});

  /// テスト用。null なら今日の日付から決める。
  final String? season;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = ref.watch(purchasedItemsProvider).ownedItemIds;
    final coins = ref.watch(coinProvider).totalCoins;
    final now = season ?? _season();
    final shown = [for (final i in kDecorItems) if (i.season == null || i.season == now) i];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DecorScreen())),
          icon: const Icon(Icons.palette_outlined),
          label: const Text('買ったきせかえをえらぶ'),
        ),
        const SizedBox(height: 12),
        for (final kind in DecorKind.values) ...[
          if (shown.any((i) => i.kind == kind)) ...[
            Text(kind.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const SizedBox(height: 8),
            for (final item in shown.where((i) => i.kind == kind))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.asset(
                      item.thumb,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(child: Text(item.emoji)),
                    ),
                  ),
                ),
                title: Text(item.name),
                subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: owned.contains(item.id)
                    ? const Chip(label: Text('所持済み', style: TextStyle(fontSize: 11)), backgroundColor: Color(0xFFE8F5E9))
                    : SizedBox(
                        width: 90,
                        child: ElevatedButton(
                          onPressed: coins >= item.coinCost ? () => _confirm(context, ref, item) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('🪙${item.coinCost}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                        ),
                      ),
              ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }

  void _confirm(BuildContext context, WidgetRef ref, DecorItem item) {
    // 連打による二重課金を防ぐ
    var busy = false;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('${item.name} を購入？'),
          content: Text('${item.description}\n\n${item.coinCost}コインを使います。'),
          actions: [
            TextButton(onPressed: busy ? null : () => Navigator.pop(ctx), child: const Text('キャンセル')),
            ElevatedButton(
              onPressed: busy
                  ? null
                  : () async {
                      setDialogState(() => busy = true);
                      final ok = await ref.read(coinProvider.notifier).spendCoins(item.coinCost);
                      if (ok) {
                        await ref.read(purchasedItemsProvider.notifier).purchase(item.id);
                      }
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                          content: Text(ok ? '${item.name}を購入しました！' : 'コインが足りません'),
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    },
              child: const Text('購入する'),
            ),
          ],
        ),
      ),
    );
  }
}
