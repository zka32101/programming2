import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/data/kokugo_characters.dart';
import 'package:kokugo_kore/widgets/kokugo_character_collection.dart';

// ナクちゃん(naku)は Lv.2 以降の画像が未制作(assets/character_levels に1枚のみ)。制作できたらここから外す。
const _knownMissing = {'naku'};

void main() {
  test('キャラのレベル画像(Lv.2 の表情3枚)が、全キャラ分そろっている', () {
    final missing = <String>[];
    for (final c in kKokugoCharacters) {
      if (_knownMissing.contains(c.id)) continue;
      final base = kLevelImageBase[c.id];
      expect(base, isNotNull, reason: '${c.id} が kLevelImageBase に無い');
      for (var i = 1; i <= 3; i++) {
        final path = 'assets/character_levels/${base}_lv2_$i.jpg';
        if (!File(path).existsSync()) missing.add(path);
      }
    }
    expect(missing, isEmpty);
  });
}
