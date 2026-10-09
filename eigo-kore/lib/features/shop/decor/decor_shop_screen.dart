import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show CoinBalanceWidget, ShopItemTile, coinProvider, inventoryProvider;
import 'decor_items.dart';
import 'decor_scope.dart';
import 'decor_screen.dart';
import 'title_items.dart';

String _season() {
  final m = DateTime.now().month;
  if (m >= 3 && m <= 5) return 'spring';
  if (m >= 6 && m <= 8) return 'summer';
  if (m >= 9 && m <= 11) return 'autumn';
  return 'winter';
}

/// 英語コレ！のきせかえショップ。キャラ図鑑と同じコイン（coinProvider）で、
/// 背景・フレーム・エフェクトを買う。常設と、いまの季節の商品を出す。
///
/// 課金用の shop_screen.dart（コイン購入・ブースター・サブスク）とは別物で、
/// 現実のお金は使わない。
class DecorShopScreen extends ConsumerStatefulWidget {
  const DecorShopScreen({super.key, this.season});

  /// テスト用。null なら今日の日付から決める。
  final String? season;

  @override
  ConsumerState<DecorShopScreen> createState() => _DecorShopScreenState();
}

class _DecorShopScreenState extends ConsumerState<DecorShopScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(coinProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final owned = ref.watch(inventoryProvider);
    final coins = ref.watch(coinProvider).totalCoins;
    final now = widget.season ?? _season();
    final shown = [for (final i in kDecorItems) if (i.season == null || i.season == now) i];

    return Scaffold(
      backgroundColor: DecorScope.pageBg(context, const Color(0xFFF7F9FC)),
      appBar: AppBar(
        title: const Row(children: [Text('きせかえショップ'), Spacer(), CoinBalanceWidget()]),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DecorScreen())),
            icon: const Icon(Icons.palette_outlined),
            label: const Text('買ったきせかえをえらぶ'),
          ),
          const SizedBox(height: 12),
          for (final kind in DecorKind.values)
            if (shown.any((i) => i.kind == kind)) ...[
              Text(kind.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (final item in shown.where((i) => i.kind == kind))
                ShopItemTile(
                  item: item.toShopItem(),
                  isOwned: owned.contains(item.id),
                  currentCoins: coins,
                  onPurchase: () => _purchase(item.id, item.name, item.description, item.coinCost),
                ),
              const SizedBox(height: 12),
            ],
          const Text('しょうごう', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('ホームの名前の下にひょうじできるよ。たっせいでもらえるしょうごうは「きせかえ」でえらべるよ。',
              style: TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 8),
          for (final t in kTitleDefs.where((t) => t.isPurchasable))
            ShopItemTile(
              item: t.toShopItem(),
              isOwned: owned.contains(t.id),
              currentCoins: coins,
              onPurchase: () => _purchase(t.id, t.name, t.description, t.coinCost),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _purchase(String id, String name, String description, int cost) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$name を買う？'),
        content: Text('$description\n\n$costコインを使うよ。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('やめる')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('買う')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final err = await ref.read(inventoryProvider.notifier).purchase(id, cost);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? '$name をゲット！')));
  }
}
