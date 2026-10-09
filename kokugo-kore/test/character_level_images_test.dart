import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/data/kokugo_characters.dart';
import 'package:kokugo_kore/widgets/kokugo_character_collection.dart';

const _knownMissing = <String>{};

void main() {
  test('キャラのレベル画像(Lv.2 の表情・Lv.3 のポーズ各3枚)が、全キャラ分そろっている', () {
    final missing = <String>[];
    for (final c in kKokugoCharacters) {
      if (_knownMissing.contains(c.id)) continue;
      final base = kLevelImageBase[c.id];
      expect(base, isNotNull, reason: '${c.id} が kLevelImageBase に無い');
      for (final lv in ['lv2', 'lv3']) {
        for (var i = 1; i <= 3; i++) {
          final path = 'assets/character_levels/${base}_${lv}_$i.jpg';
          if (!File(path).existsSync()) missing.add(path);
        }
      }
    }
    expect(missing, isEmpty);
  });
}
