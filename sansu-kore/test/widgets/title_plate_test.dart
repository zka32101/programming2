import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/widgets/title_plate.dart';

void main() {
  testWidgets('TitlePlate shows long name without overflow', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
          body: Center(
              child: TitlePlate(name: 'とてもとてもながいしょうごうめい')))),
    );
    expect(find.text('とてもとてもながいしょうごうめい'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
