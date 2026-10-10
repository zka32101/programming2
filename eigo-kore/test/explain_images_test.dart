import 'dart:io';
import 'package:eigo_kore/data/explain_images.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registered explain image assets exist', () {
    expect(allExplainImagePaths.length, 29);
    for (final p in allExplainImagePaths) {
      expect(File(p).existsSync(), isTrue, reason: p);
    }
  });

  test('lookup', () {
    expect(explainImageForStage('stage_1'), contains('stage_1_greetings'));
    expect(explainImageForStage('stage_65'), contains('directions'));
    expect(explainImageForStage('stage_2'), isNull);
    expect(explainImageForStage('conv_1'), isNull);
    expect(explainImageForConversation('conv_12'), contains('birthday'));
    expect(explainImageForConversation('conv_3'), isNull);
    expect(explainImageForConversation('stage_1'), isNull);
  });
}
