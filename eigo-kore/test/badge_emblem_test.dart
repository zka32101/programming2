import 'dart:io';

import 'package:eigo_kore/models/badge_model.dart' as app;
import 'package:eigo_kore/widgets/badge_emblem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/models/badge_model.dart' as core;

void main() {
  test('英語の対応表の全バッジ(本体12+shared_core内29)に意匠があり、画像ファイルが存在する', () {
    final ids = <String>{
      ...app.eigoBadges.map((b) => b.id),
      ...core.allBadges.map((b) => b.id),
    };
    expect(app.eigoBadges.length, 12);
    expect(core.allBadges.length, 29);
    expect(ids.length, 41);
    for (final id in ids) {
      final name = BadgeEmblem.emblemOf(id);
      expect(name, isNotNull, reason: id);
      expect(File('assets/badges/badge_$name.webp').existsSync(), true,
          reason: '$id -> $name');
    }
  });

  testWidgets('対応のあるバッジは画像、ないバッジは絵文字で出る', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Column(children: [
          BadgeEmblem(badgeId: 'streakWeek', fallbackEmoji: '🔥'),
          BadgeEmblem(badgeId: 'unknown_badge', fallbackEmoji: '🔥'),
        ]),
      ),
    ));
    await tester.pump();
    expect(find.byType(Image), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
