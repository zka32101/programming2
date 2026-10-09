import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/data/explain_images.dart';

void main() {
  test('explain image assets exist', () {
    for (final id in kExplainImages.values) {
      expect(File('assets/illustrations/explain_$id.webp').existsSync(), isTrue,
          reason: id);
    }
    expect(kExplainImages.length, 27);
  });

  test('lookup handles furigana and variants', () {
    expect(explainImageFor('猿も木から落ちる（さるもきからおちる）'),
        endsWith('explain_proverb_saru_ki.webp'));
    expect(explainImageFor('井の中の蛙大海を知らず'),
        endsWith('explain_proverb_inonaka_kawazu.webp'));
    expect(explainImageFor('足（あし）を引（ひ）っ張（ぱ）る'),
        endsWith('explain_idiom_ashi_hipparu.webp'));
    expect(explainImageFor('一石二鳥'), endsWith('explain_yoji_isseki_nicho.webp'));
    expect(explainImageFor('七転び八起き'), isNull);
  });
}
