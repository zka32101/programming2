import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import '../providers/selected_avatar_provider.dart';
import '../theme/app_theme.dart';

/// アバター選択画面。
/// 最初の4種類は無料、それ以外はコインで解放して使用できる。
class AvatarSelectionScreen extends ConsumerStatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  ConsumerState<AvatarSelectionScreen> createState() =>
      _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState
    extends ConsumerState<AvatarSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(avatarProvider.notifier).load();
      ref.read(selectedAvatarProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final avatarState = ref.watch(avatarProvider);
    final selected = ref.watch(selectedAvatarProvider);
    final coins = ref.watch(coinProvider).totalCoins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('アバターを選ぶ'),
        backgroundColor: kPrimaryColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: allAvatars.length,
        itemBuilder: (context, i) {
          final avatar = allAvatars[i];
          final isUnlocked = avatarState.isUnlocked(avatar.id);
          if (!isUnlocked) {
            return LockedAvatarWidget(
              avatar: avatar,
              onUnlock: () => _tryUnlock(context, avatar, coins),
            );
          }
          return AvatarWidget(
            avatar: avatar,
            isSelected: avatar.id == selected.id,
            onTap: () =>
                ref.read(selectedAvatarProvider.notifier).select(avatar.id),
          );
        },
      ),
    );
  }

  Future<void> _tryUnlock(
      BuildContext context, AvatarModel avatar, int coins) async {
    if (avatar.unlockType == AvatarUnlockType.premium) {
      Navigator.of(context).pushNamed('/upgrade');
      return;
    }
    if (avatar.unlockType != AvatarUnlockType.coin || avatar.coinCost == null) {
      return;
    }
    if (coins < avatar.coinCost!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('コインが足りません')),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${avatar.name} を解放する？'),
        content: Text('🪙 ${avatar.coinCost} コイン消費します'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('やめる')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('解放する！')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref.read(coinProvider.notifier).spendCoins(avatar.coinCost!);
    if (!ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('コインが足りません')),
        );
      }
      return;
    }
    await ref.read(avatarProvider.notifier).unlockWithCoins(avatar.id);
    await ref.read(selectedAvatarProvider.notifier).select(avatar.id);
  }
}
