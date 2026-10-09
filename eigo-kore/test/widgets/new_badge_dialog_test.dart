import 'package:eigo_kore/models/badge_model.dart';
import 'package:eigo_kore/widgets/new_badge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(List<BadgeModel> badges) => MaterialApp(
      home: Builder(
        builder: (c) => Scaffold(
          body: TextButton(
            onPressed: () => NewBadgeDialog.showIfAny(c, badges),
            child: const Text('open'),
          ),
        ),
      ),
    );

void main() {
  testWidgets('single badge shows celebration art, name, and closes', (t) async {
    await t.pumpWidget(_host([eigoBadges.first]));
    await t.tap(find.text('open'));
    await t.pump(const Duration(milliseconds: 600));
    expect(find.text('おめでとう！'), findsOneWidget);
    expect(find.textContaining('はじめの一歩'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(3));
    await t.tap(find.text('了解'));
    await t.pumpAndSettle();
    expect(find.text('おめでとう！'), findsNothing);
  });

  testWidgets('multiple badges list all names', (t) async {
    await t.pumpWidget(_host([eigoBadges[0], eigoBadges[1]]));
    await t.tap(find.text('open'));
    await t.pump(const Duration(milliseconds: 600));
    expect(find.textContaining('2 個'), findsOneWidget);
    expect(find.textContaining('単語マスター'), findsOneWidget);
  });

  testWidgets('empty list shows nothing', (t) async {
    await t.pumpWidget(_host(const []));
    await t.tap(find.text('open'));
    await t.pump(const Duration(milliseconds: 600));
    expect(find.text('おめでとう！'), findsNothing);
  });
}
