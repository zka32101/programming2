import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:shared_core/shared_core.dart' hide kTextDark, kTextMuted;

import '../data/kokugo_characters.dart';
import '../theme/app_theme.dart';

class KokugoCharacterCollectionPage extends ConsumerStatefulWidget {
  final List<BaseCharacter> characters;
  final int totalStagesCleared;

  const KokugoCharacterCollectionPage({
    super.key,
    required this.characters,
    required this.totalStagesCleared,
  });

  @override
  ConsumerState<KokugoCharacterCollectionPage> createState() =>
      _KokugoCharacterCollectionPageState();
}

class _KokugoCharacterCollectionPageState
    extends ConsumerState<KokugoCharacterCollectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(characterStateProvider.notifier)
          .checkUnlocks(widget.totalStagesCleared);
    });
  }

  @override
  void didUpdateWidget(KokugoCharacterCollectionPage old) {
    super.didUpdateWidget(old);
    if (old.totalStagesCleared != widget.totalStagesCleared) {
      ref
          .read(characterStateProvider.notifier)
          .checkUnlocks(widget.totalStagesCleared);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final charStates = ref.watch(characterStateProvider);

    final unlocked = widget.characters
        .where((c) => charStates[c.id]?.isUnlocked ?? false)
        .toList();
    final locked = widget.characters
        .where((c) => !(charStates[c.id]?.isUnlocked ?? false))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('キャラクター'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatBar(
              primary: primary,
              unlocked: unlocked.length,
              total: widget.characters.length,
              stagesCleared: widget.totalStagesCleared,
            ),
            const SizedBox(height: 20),
            if (unlocked.isNotEmpty) ...[
              _SectionLabel(
                  text: 'ゲット済みキャラ (${unlocked.length}体)', icon: '✅'),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: unlocked.length,
                itemBuilder: (ctx, i) {
                  final c = unlocked[i];
                  return _CharacterCard(
                    character: c,
                    state: charStates[c.id] ??
                        const CharacterState(isUnlocked: true),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
            if (locked.isNotEmpty) ...[
              _SectionLabel(
                  text: 'ロック中のキャラ (${locked.length}体)', icon: '🔒'),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: locked.length,
                itemBuilder: (ctx, i) => _LockedCard(
                  character: locked[i],
                  currentStages: widget.totalStagesCleared,
                ),
              ),
            ],
            if (charStates.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final Color primary;
  final int unlocked, total, stagesCleared;

  const _StatBar({
    required this.primary,
    required this.unlocked,
    required this.total,
    required this.stagesCleared,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? unlocked / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withAlpha(30), primary.withAlpha(10)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withAlpha(60)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'コレクション', value: '$unlocked / $total体'),
              _StatItem(label: 'クリアステージ', value: '$stagesCleared'),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: kTextMuted, height: 1.2)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: kTextDark)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text, icon;
  const _SectionLabel({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14, color: kTextDark)),
        ],
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final BaseCharacter character;
  final CharacterState state;

  const _CharacterCard({required this.character, required this.state});

  @override
  Widget build(BuildContext context) {
    final lvMaxImage = kKokugoCharactersLvMax[character.id];
    final displayImage =
        state.isMaxLevel && lvMaxImage != null ? lvMaxImage : character.imageAsset;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: state.hasSparkle
              ? Border.all(color: Colors.amber.shade400, width: 2)
              : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                        style: const TextStyle(fontSize: 34)),
                  ),
                if (state.hasSparkle)
                  const Text('✨', style: TextStyle(fontSize: 10)),
              ],
            ),
            const SizedBox(height: 4),
            Text(character.name,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kTextDark),
                textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(state.levelLabel,
                style: TextStyle(
                    fontSize: 10,
                    color: state.isMaxLevel
                        ? Colors.amber.shade700
                        : kTextMuted,
                    fontWeight: state.isMaxLevel
                        ? FontWeight.bold
                        : FontWeight.normal)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: i < state.level
                        ? Colors.amber.shade400
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _CharacterDetailSheet(
          character: character, state: state),
    );
  }
}

class _CharacterDetailSheet extends StatelessWidget {
  final BaseCharacter character;
  final CharacterState state;

  const _CharacterDetailSheet(
      {required this.character, required this.state});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final lvMaxImage = kKokugoCharactersLvMax[character.id];
    final displayImage =
        state.isMaxLevel && lvMaxImage != null ? lvMaxImage : character.imageAsset;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (ctx, scroll) => SingleChildScrollView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  if (displayImage != null)
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(displayImage, fit: BoxFit.contain),
                    )
                  else
                    Text(character.emoji,
                        style: const TextStyle(fontSize: 52)),
                  const SizedBox(height: 8),
                  Text(character.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: kTextDark)),
                  const SizedBox(height: 4),
                  Text(state.levelLabel,
                      style: TextStyle(
                          fontSize: 13,
                          color: state.isMaxLevel
                              ? Colors.amber.shade700
                              : kTextMuted,
                          fontWeight: state.isMaxLevel
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('テーマ',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
            const SizedBox(height: 4),
            Text(character.subject,
                style: const TextStyle(fontSize: 12, color: kTextDark)),
            const SizedBox(height: 16),
            Text('プロフィール',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
            const SizedBox(height: 4),
            Text(character.backstory,
                style: const TextStyle(
                    fontSize: 12, color: kTextDark, height: 1.6)),
            const SizedBox(height: 20),
            Text('レベル画像',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
            const SizedBox(height: 8),
            _LevelImageGallery(characterId: character.id, level: state.level),
            const SizedBox(height: 24),
            if (displayImage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _downloadImage(ctx, displayImage, character.name),
                  icon: const Icon(Icons.download),
                  label: const Text('画像をダウンロード'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context, String imagePath, String characterName) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ダウンロード中...'), duration: Duration(seconds: 1)),
      );

      await Gal.putImageBytes(
        (await DefaultAssetBundle.of(context).load(imagePath)).buffer.asUint8List(),
        name: '${characterName}_lvmax',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$characterName の画像をダウンロードしました'),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ダウンロード失敗: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// レベル画像ギャラリー（Lv.2-1～Lv.3-3, Lvmax）
class _LevelImageGallery extends StatelessWidget {
  final String characterId;
  final int level;

  const _LevelImageGallery({required this.characterId, required this.level});

  @override
  Widget build(BuildContext context) {
    // Lv.2, Lv.3, Lvmax の画像を表示
    // characterId は "01_honhon" 形式
    final charCode = characterId.split('_')[0];
    final charName = characterId.split('_').length > 1
        ? characterId.split('_')[1]
        : characterId;

    final images = <String>[];

    // Lv.2 の表情 3 種
    if (level >= 2) {
      for (int i = 1; i <= 3; i++) {
        images.add('assets/character_levels/${charCode}_${charName}_lv2_$i.jpg');
      }
    }

    // Lv.3 のポーズ 3 種
    if (level >= 3) {
      for (int i = 1; i <= 3; i++) {
        images.add('assets/character_levels/${charCode}_${charName}_lv3_$i.jpg');
      }
    }

    // Lvmax 画像
    if (level >= 5) {
      images.add('assets/character_levels/${charCode}_${charName}_lvmax.jpg');
    }

    if (images.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'このレベルではまだ画像がありません',
          style: TextStyle(fontSize: 12, color: kTextMuted),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final imagePath = images[index];
          return GestureDetector(
            onTap: () => _showFullImage(context, imagePath),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey.shade400, size: 24),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}

class _LockedCard extends StatelessWidget {
  final BaseCharacter character;
  final int currentStages;

  const _LockedCard({required this.character, required this.currentStages});

  @override
  Widget build(BuildContext context) {
    final isUnlocking = currentStages >= character.unlockAt;
    return GestureDetector(
      onTap: () => _showLockedDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(character.emoji,
                      style: const TextStyle(
                          fontSize: 34, color: Colors.grey)),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock,
                      size: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(character.name,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              'ステージ ${character.unlockAt}でゲット',
              style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (ctx, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Center(
                  child: Text(character.emoji,
                      style: const TextStyle(fontSize: 52))),
              const SizedBox(height: 8),
              Center(
                child: Text(character.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kTextDark)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: kPrimaryColor.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: kPrimaryColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'ステージ ${character.unlockAt} をクリアするとゲット！',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
