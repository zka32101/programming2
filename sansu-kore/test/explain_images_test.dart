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
