import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kokugo_characters.dart';
import '../providers/progress_provider.dart';
import '../widgets/kokugo_character_collection.dart';

/// 国語コレ版キャラクター図鑑（LvMAX 画像対応）
class CharacterScreen extends ConsumerWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalStages =
        ref.watch(progressProvider).clearedStageIds.length;
    return KokugoCharacterCollectionPage(
      characters: kKokugoCharacters,
      totalStagesCleared: totalStages,
    );
  }
}
