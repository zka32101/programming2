import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/data/explain_images.dart';
import 'package:sansu_kore/data/stage_data.dart';

void main() {
  test('all explain image assets exist', () {
    for (final p in allExplainImagePaths()) {
      expect(File(p).existsSync(), isTrue, reason: p);
    }
  });

  test('mapped stages exist and resolve', () {
    expect(explainImageForStage(1, 1), contains('g1_tashizan'));
    expect(explainImageForStage(1, 6), isNull);
    const expected = {
      '1-3': 'g1_tashizan2', '1-4': 'g1_tashizan3', '1-5': 'g1_kurisage',
      '2-1': 'g2_kakezan', '2-4': 'g2_kakezan', '2-5': 'g2_hissan',
      '2-6': 'g2_hissan', '3-6': 'g3_shousuu', '3-13': 'g3_shousuu',
      '5-5': 'g5_tsubun', '5-7': 'g5_baisuu',
    };
    expected.forEach((k, v) {
      final p = k.split('-');
      expect(explainImageForStage(int.parse(p[0]), int.parse(p[1])),
          contains(v), reason: k);
    });
    expect(explainImageForGuide('かけ算（乗法）の仕組み'), contains('g2_kakezan'));
    expect(explainImageForGuide('小数（しょうすう）の計算'), contains('g3_shousuu'));
    final keys = getAllStages().map((s) => '${s.grade}-${s.stageNumber}').toSet();
    for (var g = 1; g <= 6; g++) {
      for (var n = 1; n <= 20; n++) {
        if (explainImageForStage(g, n) != null) {
          expect(keys.contains('$g-$n'), isTrue, reason: '$g-$n');
        }
      }
    }
  });
}
