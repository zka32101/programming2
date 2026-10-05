import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eigo_kore/data/eigo_characters.dart';
import 'package:eigo_kore/providers/character_provider.dart';
import 'package:eigo_kore/screens/character_collection_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('8体・画像ファイルが全て存在・レベルで画像が切り替わる', () {
    expect(kEigoCharacters.length, 8);
    for (final c in kEigoCharacters) {
      expect(File(c.imageAsset!).existsSync(), true, reason: c.id);
      for (final l in [2, 3, 5]) {
        expect(File(c.levelImages![l]!).existsSync(), true,
            reason: '${c.id} $l');
      }
      expect(c.imageAssetForLevel(1), c.imageAsset);
      expect(c.imageAssetForLevel(2), contains('_lv2'));
      expect(c.imageAssetForLevel(4), contains('_lv3'));
      expect(c.imageAssetForLevel(5), contains('_lvmax'));
    }
  });

  test('コイン不足の案内文', () {
    expect(coinShortageMessage(30, 50), contains('あと20コイン'));
    expect(coinShortageMessage(50, 50), isNull);
  });

  test('レベルアップ: 不足は失敗、足りれば上がり永続化される', () async {
    SharedPreferences.setMockInitialValues({});
    final c = ProviderContainer(overrides: [
      characterStateProvider.overrideWith(CharacterNotifier.new),
    ]);
    c.read(characterStateProvider);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await c.read(coinProvider.notifier).load();
    final n = c.read(characterStateProvider.notifier);
    expect(await n.levelUp('char_001'), contains('コインが足りません'));
    await c.read(coinProvider.notifier).addCoins(150);
    expect(await n.levelUp('char_001'), isNull);
    expect(await n.levelUp('char_001'), isNull);
    expect(c.read(characterStateProvider)['char_001']!.level, 3);
    expect(c.read(coinProvider).totalCoins, 0);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('eigo_char_states'), contains('"level":3'));
  });
}
