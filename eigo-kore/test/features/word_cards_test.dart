import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/features/word_cards/word_card_data.dart';
import 'package:eigo_kore/features/word_cards/word_cards_screen.dart';

void main() {
  test('animal data has 12 unique cards with webp paths', () {
    expect(animalWordCards.length, 12);
    expect(animalWordCards.map((c) => c.english).toSet().length, 12);
    for (final c in animalWordCards) {
      expect(c.image, 'assets/word_cards/${c.english}.webp');
      expect(c.japanese, isNotEmpty);
    }
  });

  test('all cards: 39 unique, categories, assets exist', () {
    expect(allWordCards.length, 39);
    expect(allWordCards.map((c) => c.english).toSet().length, 39);
    expect(fruitWordCards.every((c) => c.category == 'くだもの'), isTrue);
    expect(vehicleWordCards.every((c) => c.category == 'のりもの'), isTrue);
    expect(foodWordCards.every((c) => c.category == 'たべもの'), isTrue);
    expect(schoolWordCards.every((c) => c.category == 'がっきゅうのどうぐ'), isTrue);
    for (final c in allWordCards) {
      expect(File(c.image).existsSync(), isTrue, reason: c.image);
    }
  });

  testWidgets('flip, navigate, finish on small screen', (t) async {
    t.view.physicalSize = const Size(320, 480);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: WordCardsScreen(enableTts: false)));
    expect(find.text('1/39'), findsOneWidget);
    expect(find.text('ねこ'), findsOneWidget);
    await t.tap(find.byKey(const Key('flipCard')));
    await t.pump();
    expect(find.text('cat'), findsOneWidget);
    await t.tap(find.byKey(const Key('nextBtn')));
    await t.pump();
    expect(find.text('2/39'), findsOneWidget);
    expect(find.text('いぬ'), findsOneWidget);
    for (var i = 0; i < 38; i++) {
      await t.tap(find.byKey(const Key('nextBtn')));
      await t.pump();
    }
    expect(find.byKey(const Key('rewardSticker')), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
