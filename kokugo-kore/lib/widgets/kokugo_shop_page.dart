import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_core/shared_core.dart' hide kAccentGreen, kTextDark, kTextMuted;

import '../data/kokugo_characters.dart';
import '../providers/character_provider.dart';
import '../providers/purchased_items_provider.dart';
import '../providers/avatar_unlock_provider.dart';
import '../theme/app_theme.dart';
import 'character_unlock_dialog.dart';

bool _isEquippable(AppShopItem item) => item.kind != ShopItemKind.emoji;

String _currentSeason() {
  final m = DateTime.now().month;
  if (m >= 3 && m <= 5) return 'spring';
  if (m >= 6 && m <= 8) return 'summer';
  if (m >= 9 && m <= 11) return 'autumn';
  return 'winter';
}

/// 国語コレ版コインショップ（キャラ画像対応）
class KokugoShopPage extends StatelessWidget {
  final List<BaseCharacter> characters;
  final List<AppShopItem> exchangeItems;
  final Map<String, List<AppShopItem>> seasonalItems;
  final List<AvatarModel> coinUnlockAvatars;

  const KokugoShopPage({
    super.key,
    required this.characters,
    required this.exchangeItems,
    required this.seasonalItems,
    required this.coinUnlockAvatars,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              Text('コレショップ'),
              Spacer(),
              CoinBalanceWidget(),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.auto_awesome, size: 18), text: 'キャラ育成'),
              Tab(icon: Icon(Icons.pets, size: 18), text: 'アバター'),
              Tab(icon: Icon(Icons.event, size: 18), text: '期間限定'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CharacterLevelUpTab(characters: characters),
            _AvatarTab(avatars: coinUnlockAvatars),
            _SeasonalTab(seasonalItems: seasonalItems),
          ],
        ),
      ),
    );
  }
}

class _CharacterLevelUpTab extends ConsumerWidget {
  final List<BaseCharacter> characters;

  const _CharacterLevelUpTab({required this.characters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charStates = ref.watch(characterStateProvider);
    final coins = ref.watch(coinProvider).totalCoins;

    final unlocked = characters
        .where((c) => charStates[c.id]?.isUnlocked ?? false)
        .toList();

    if (charStates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (unlocked.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📖', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text('まだキャラクターがいないよ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextDark)),
              const SizedBox(height: 8),
              const Text('クイズをといてキャラクターをゲットしよう！',
                  style: TextStyle(color: kTextMuted, fontSize: 13),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/learn'),
                child: const Text('学習をはじめる'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: const Text(
            '🪙 コインでキャラクターを育てよう！',
            style: TextStyle(fontSize: 12, height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.82,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: unlocked.length,
          itemBuilder: (ctx, i) {
            final c = unlocked[i];
            final state =
                charStates[c.id] ?? const CharacterState(isUnlocked: true);
            return _KokugoLevelUpCard(
                character: c, state: state, currentCoins: coins);
          },
        ),
      ],
    );
  }
}

class _KokugoLevelUpCard extends ConsumerWidget {
  final BaseCharacter character;
  final CharacterState state;
  final int currentCoins;

  const _KokugoLevelUpCard(
      {required this.character,
      required this.state,
      required this.currentCoins});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;
    final nextLevel = state.level + 1;
    final cost = state.nextLevelCost;
    final canAfford = cost != null && currentCoins >= cost;
    final lvMaxImage = kKokugoCharactersLvMax[character.id];
    final displayImage =
        state.isMaxLevel && lvMaxImage != null ? lvMaxImage : character.imageAsset;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: state.hasSparkle
            ? BorderSide(color: Colors.amber.shade400, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                if (displayImage != null)
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(displayImage, fit: BoxFit.contain),
                  )
                else
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(character.emoji,
                          style: const TextStyle(fontSize: 40))),
                if (state.hasSparkle)
                  const Text('✨', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(character.name,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kTextDark),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => Container(
                  width: 12,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i < state.level
                        ? Colors.amber
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(state.levelLabel,
                style: TextStyle(
                    fontSize: 11,
                    color: state.isMaxLevel
                        ? Colors.amber.shade700
                        : kTextMuted,
                    fontWeight: state.isMaxLevel
                        ? FontWeight.bold
                        : FontWeight.normal)),
            const Spacer(),
            if (state.isMaxLevel)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🎁', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 4),
                    Text('スタンプ券獲得!',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            else if (cost != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canAfford
                      ? () => _showLevelUpDialog(context, ref, nextLevel, cost)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canAfford ? primary : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Lv.$nextLevel に\n$cost コイン',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showLevelUpDialog(BuildContext context, WidgetRef ref, int nextLevel, int cost) {
    // StatefulBuilderのbuilder関数はrebuildのたびに再実行されるため、
    // busyフラグはbuilderの外（showDialog呼び出しのスコープ）に置く必要がある。
    var busy = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text('${character.name} をレベルアップ？'),
            content: Text('Lv.$nextLevel に上げるのに $cost コイン必要です'),
            actions: [
              TextButton(
                  onPressed: busy ? null : () => Navigator.pop(ctx),
                  child: const Text('キャンセル')),
              ElevatedButton(
                  // 連打による二重課金（コインの二重消費）を防ぐガード。
                  onPressed: busy
                      ? null
                      : () async {
                          setDialogState(() => busy = true);
                          final error = await ref
                              .read(characterStateProvider.notifier)
                              .levelUp(character.id);
                          if (error == null) {
                            await ref
                                .read(featuredCharacterProvider.notifier)
                                .setFeatured(character.id);
                          }
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            if (error != null) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                            }
                          }
                          if (error == null && context.mounted) {
                            await showCharacterLevelUpDialog(
                              context,
                              character: character,
                              newLevel: nextLevel,
                            );
                          }
                        },
                  child: const Text('アップグレード')),
            ],
          );
        },
      ),
    );
  }
}

class _ExchangeTab extends ConsumerWidget {
  final List<AppShopItem> items;

  const _ExchangeTab({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = items.map((e) => e.category).toSet().toList();
    final purchased = ref.watch(purchasedItemsProvider);
    final coins = ref.watch(coinProvider).totalCoins;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: categories.map((cat) {
        final catItems = items.where((e) => e.category == cat).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cat,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
            const SizedBox(height: 8),
            ...catItems.map((item) {
              final owned = purchased.ownedItemIds.contains(item.id);
              final canAfford = coins >= item.coinCost;
              final equippable = owned && _isEquippable(item);
              final equipped = equippable
                  ? ref.watch(equippedItemsProvider
                      .select((s) => s.equippedByCategory[item.category] == item.id))
                  : false;
              return ListTile(
                leading: item.assetPath != null
                    ? SizedBox(
                        width: 28,
                        height: 28,
                        child: SvgPicture.asset(item.assetPath!, fit: BoxFit.contain),
                      )
                    : Text(item.emoji, style: const TextStyle(fontSize: 28)),
                title: Text(item.name),
                subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: owned
                    ? (equippable
                        ? _EquipButton(item: item, equipped: equipped)
                        : const Chip(
                            label: Text('所持済み', style: TextStyle(fontSize: 11)),
                            backgroundColor: Color(0xFFE8F5E9),
                          ))
                    : SizedBox(
                        width: 90,
                        child: ElevatedButton(
                          onPressed: canAfford
                              ? () => _confirmPurchase(context, ref, item)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('🪙${item.coinCost}',
                              style: const TextStyle(fontSize: 11, color: Colors.white)),
                        ),
                      ),
              );
            }),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  void _confirmPurchase(BuildContext context, WidgetRef ref, AppShopItem item) {
    // 連打による二重課金（コインの二重消費）を防ぐガード
    // （builderの外に置き、StatefulBuilderのrebuildで初期化されないようにする）。
    var busy = false;
    showDialog(
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

class _SeasonalTab extends ConsumerWidget {
  final Map<String, List<AppShopItem>> seasonalItems;

  const _SeasonalTab({required this.seasonalItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final season = _currentSeason();
    final items = seasonalItems[season] ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kPrimaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kPrimaryColor.withAlpha(80)),
          ),
          child: Text(
            '🌍 現在は ${_getSeasonName(season)} の期間限定アイテムが登場中！',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('現在のシーズンにはアイテムがありません',
                  style: TextStyle(color: kTextMuted)),
            ),
          )
        else
          ...items.map((item) {
            return ListTile(
              leading: Text(item.emoji, style: const TextStyle(fontSize: 28)),
              title: Text(item.name),
              subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          }),
      ],
    );
  }

  String _getSeasonName(String season) {
    switch (season) {
      case 'spring': return '春';
      case 'summer': return '夏';
      case 'autumn': return '秋';
      default: return '冬';
    }
  }
}

class _AvatarTab extends ConsumerWidget {
  final List<AvatarModel> avatars;

  const _AvatarTab({required this.avatars});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUnlock = ref.watch(avatarUnlockProvider);
    final coins = ref.watch(coinProvider).totalCoins;

    // Separate locked and unlocked avatars
    final unlocked = avatars.where((a) => avatarUnlock[a.id] ?? false).toList();
    final locked = avatars.where((a) => !(avatarUnlock[a.id] ?? false)).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade300),
          ),
          child: const Text(
            '🎭 コインでアバターをゲット！\n'
            'プロフィールに表示するアイコンを選ぼう',
            style: TextStyle(fontSize: 12, height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        if (unlocked.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✨ 所持中',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryColor)),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: unlocked.length,
                itemBuilder: (ctx, i) {
                  final avatar = unlocked[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade400, width: 2),
                    ),
                    child: Center(
                      child: AvatarImage(avatar: avatar, size: 44),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        const Text('🔒 ロック中',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextDark)),
        const SizedBox(height: 8),
        if (locked.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text('すべてのアバターをゲットしました！', style: TextStyle(color: kTextMuted)),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: locked.length,
            itemBuilder: (ctx, i) {
              final avatar = locked[i];
              final cost = avatar.coinCost ?? 0;
              final canAfford = coins >= cost;
              return GestureDetector(
                onTap: canAfford
                    ? () => _confirmUnlock(context, ref, avatar)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: canAfford ? Colors.amber.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: canAfford ? Colors.amber.shade400 : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AvatarImage(avatar: avatar, size: 44, opacity: 0.4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock, color: Colors.grey, size: 18),
                          const SizedBox(height: 2),
                          Text(
                            '🪙$cost',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: canAfford ? Colors.amber.shade700 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _confirmUnlock(BuildContext context, WidgetRef ref, AvatarModel avatar) {
    final cost = avatar.coinCost ?? 0;
    // 連打による二重課金（コインの二重消費）を防ぐガード。
    var busy = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
        title: Text('${avatar.name} をゲット？'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarImage(avatar: avatar, size: 64),
            const SizedBox(height: 12),
            Text('${avatar.name}をゲットします\n$cost コイン必要です',
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: busy ? null : () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: busy
                ? null
                : () async {
              setDialogState(() => busy = true);
              final ok = await ref.read(coinProvider.notifier).spendCoins(cost);
              if (ok && ctx.mounted) {
                // ローカルの購入アイテム追跡に追加
                await ref.read(purchasedItemsProvider.notifier).purchase(avatar.id);
                // shared_core の avatarProvider にも通知（共存性のため）
                await ref.read(avatarProvider.notifier).unlockWithCoins(avatar.id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text('${avatar.name}をゲットしました！✨'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('コインが足りません'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('ゲットする'),
          ),
        ],
        ),
      ),
    );
  }
}

/// 所持済み・装着可能なアイテム（テーマ・フレーム等）の
/// 「装着する / 解除する」ボタン。
class _EquipButton extends ConsumerWidget {
  final AppShopItem item;
  final bool equipped;

  const _EquipButton({required this.item, required this.equipped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 90,
      child: ElevatedButton(
        onPressed: () {
          final notifier = ref.read(equippedItemsProvider.notifier);
          if (equipped) {
            notifier.unequip(item.category);
          } else {
            notifier.equip(item.category, item.id);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: equipped ? Colors.grey.shade300 : kPrimaryColor,
          foregroundColor: equipped ? kTextDark : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(equipped ? '解除する' : '装着する',
            style: const TextStyle(fontSize: 11)),
      ),
    );
  }
}
