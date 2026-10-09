import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/screens/result_screen.dart';
import 'package:sansu_kore/widgets/badge_display_widget.dart';
import 'package:shared_core/models/badge_model.dart';

Widget _host(List<BadgeModel> badges) => MaterialApp(
      home: Builder(
        builder: (c) => ElevatedButton(
          onPressed: () => showNewBadgeDialogIfAny(c, badges),
          child: const Text('go'),
        ),
      ),
    );

void main() {
  testWidgets('新バッジありでダイアログが出てバリア/ボタンで閉じる', (t) async {
    await t.pumpWidget(_host([allBadges.first]));
    await t.tap(find.text('go'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 600));
    expect(find.byType(NewBadgeDialog), findsOneWidget);
    await t.tapAt(const Offset(2, 2));
    await t.pumpAndSettle();
    expect(find.byType(NewBadgeDialog), findsNothing);
  });

  testWidgets('新バッジなしなら何も出ない', (t) async {
    await t.pumpWidget(_host([]));
    await t.tap(find.text('go'));
    await t.pumpAndSettle();
    expect(find.byType(NewBadgeDialog), findsNothing);
  });
}
