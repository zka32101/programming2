import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' hide progressProvider;
import '../data/eigo_characters.dart';
import '../providers/progress_provider.dart';

/// コインが足りない時のやさしい案内文（足りていれば null）。
String? coinShortageMessage(int coins, int cost) {
  if (coins >= cost) return null;
  return 'あと${cost - coins}コイン たりないよ！\n'
      'レッスンをクリアするとコインがもらえるよ。';
}

/// 英語コレ！キャラクター図鑑画面（8体・レベルアップ対応）。
///
/// 状態・コスト消費は shared_core の [characterStateProvider]
/// （Lv1→2→3→4→MAX、コスト 50/100/200/500 コイン）に委譲する。
/// 画像は Lv2 / Lv3(Lv4も同じ) / MAX で切り替わる。
class CharacterCollectionScreen extends ConsumerStatefulWidget {
  const CharacterCollectionScreen({super.key});

  @override
  ConsumerState<CharacterCollectionScreen> createState() =>
      _CharacterCollectionScreenState();
}

class _CharacterCollectionScreenState
    extends ConsumerState<CharacterCollectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(coinProvider.notifier).load();
      final cleared = ref.read(progressProvider).clearedStages.length;
      await ref.read(characterStateProvider.notifier).checkUnlocks(cleared);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cleared =
        ref.watch(progressProvider.select((p) => p.clearedStages.length));
    final states = ref.watch(characterStateProvider);
    final coins = ref.watch(coinProvider).totalCoins;
    final got = kEigoCharacters
        .where((c) => (states[c.id]?.isUnlocked ?? false) || cleared >= c.unlockAt)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('キャラクター図鑑')),
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 6),
                Text('$coins コイン',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('ゲット $got/${kEigoCharacters.length}',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemCount: kEigoCharacters.length,
              itemBuilder: (context, i) {
                final c = kEigoCharacters[i];
                final st = states[c.id] ?? const CharacterState();
                final unlocked = st.isUnlocked || cleared >= c.unlockAt;
                return _CharacterTile(
                  character: c,
                  state: st,
                  unlocked: unlocked,
                  cleared: cleared,
                  onTap: unlocked
                      ? () => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (_) =>
                                _CharacterDetailSheet(characterId: c.id),
                          )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  final BaseCharacter character;
  final CharacterState state;
  final bool unlocked;
  final int cleared;
  final VoidCallback? onTap;
  const _CharacterTile({
    required this.character,
    required this.state,
    required this.unlocked,
    required this.cleared,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      character.imageAssetForLevel(state.level) ?? character.imageAsset!,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: unlocked && state.isMaxLevel
              ? Border.all(color: Colors.amber, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    unlocked
                        ? img
                        : ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: Opacity(opacity: 0.4, child: img)),
                    if (!unlocked)
                      Center(
                        child: Text(
                            'あと${character.unlockAt - cleared}ステージで\nゲット！',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(unlocked ? character.name : '？？？',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (unlocked) ...[
                    const SizedBox(width: 6),
                    Text(state.levelLabel,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: state.isMaxLevel
                                ? Colors.amber.shade800
                                : Theme.of(context).colorScheme.primary)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterDetailSheet extends ConsumerWidget {
  final String characterId;
  const _CharacterDetailSheet({required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kEigoCharacters.firstWhere((e) => e.id == characterId);
    final st = ref.watch(characterStateProvider)[c.id] ??
        const CharacterState(isUnlocked: true);
    final coins = ref.watch(coinProvider).totalCoins;
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                c.imageAssetForLevel(st.level) ?? c.imageAsset!,
                width: 220,
                height: 220,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('${c.emoji} ${c.name}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text('担当：${c.subject}',
                style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ),
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 5; i++)
                  Container(
                    width: 16,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i < st.level ? Colors.amber : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(st.levelLabel,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            st.isMaxLevel ? Colors.amber.shade800 : primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (st.level >= 4) ...[
            const Text('📖 バックストーリー',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(c.backstory, style: const TextStyle(height: 1.7)),
          ] else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [
                Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Lv.4 でバックストーリーが解放されるよ！',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ]),
            ),
          const SizedBox(height: 20),
          if (st.isMaxLevel)
            Center(
              child: Text('✨ MAXレベル！',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade800)),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmAndLevelUp(context, ref, c, st, coins),
                icon: const Icon(Icons.upgrade, size: 18),
                label: Text(
                    'Lv.${st.level + 1} にそだてる（${st.nextLevelCost}コイン）'),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _confirmAndLevelUp(BuildContext context, WidgetRef ref,
    BaseCharacter c, CharacterState st, int coins) async {
  final next = st.level + 1;
  final cost = kLevelUpCost[next]!;
  final messenger = ScaffoldMessenger.of(context);
  final shortage = coinShortageMessage(coins, cost);
  if (shortage != null) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('コインがたりないよ'),
        content: Text('Lv.$next には $costコイン いるよ（いま $coinsコイン）。\n\n$shortage'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('わかった')),
        ],
      ),
    );
    return;
  }
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('${c.name}を Lv.$next にする？'),
      content: Text('${kLevelUpFeatureDesc[next] ?? ''}\n\n'
          '$costコインを使うよ（いま $coinsコイン）'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('やめる')),
        ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('そだてる')),
      ],
    ),
  );
  if (ok != true) return;
  final err = await ref.read(characterStateProvider.notifier).levelUp(c.id);
  messenger.showSnackBar(SnackBar(
      content: Text(err ??
          (next >= 5
              ? '✨ ${c.name}が MAX レベルになったよ！'
              : '${c.name}が Lv.$next になったよ！'))));
}
