import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/providers/badge_definitions.dart';
import 'package:kokugo_kore/providers/badge_time_definitions.dart';
import 'package:kokugo_kore/widgets/badge_emblem.dart';
import 'package:shared_core/shared_core.dart' show getBadgesForSubject;

void main() {
  test('国語の全バッジ(統一+独自)に共通意匠の対応があり、画像ファイルが存在する', () {
    final ids = <String>{
      ...getBadgesForSubject('kokugo').map((b) => b.id),
      ...challengeBadgeDefinitions.keys,
      ...socialBadgeDefinitions.keys,
      ...milestoneBadgeDefinitions.keys,
      ...timeBadgeDefinitions.keys,
    };
    for (final id in ids) {
      final name = BadgeEmblem.emblemOf(id);
      expect(name, isNotNull, reason: id);
      expect(File('assets/badges/badge_$name.webp').existsSync(), true,
          reason: '$id -> $name');
    }
    expect(ids.length, 47);
  });

  testWidgets('対応のあるバッジは画像、ないバッジは絵文字で出る', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Column(children: [
          BadgeEmblem(badgeId: 'streak_3days', fallbackEmoji: '🔥'),
          BadgeEmblem(badgeId: 'unknown_badge', fallbackEmoji: '🔥'),
        ]),
      ),
    ));
    await tester.pump();
    expect(find.byType(Image), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
