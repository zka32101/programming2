import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/widgets/parental_gate.dart';

Future<bool?> _open(WidgetTester tester) async {
  bool? result;
  await tester.pumpWidget(MaterialApp(
    home: Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () async => result = await requireParentalGate(context),
          child: const Text('open'),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return result;
}

int _answer(WidgetTester tester) {
  final q = tester.widgetList<Text>(find.byType(Text)).map((t) => t.data ?? '').firstWhere((d) => d.contains(' + '));
  final m = RegExp(r'(\d+) \+ (\d+)').firstMatch(q)!;
  return int.parse(m.group(1)!) + int.parse(m.group(2)!);
}

void main() {
  testWidgets('正解を入れると通れる', (tester) async {
    await _open(tester);
    await tester.enterText(find.byType(TextField), '${_answer(tester)}');
    await tester.tap(find.text('つぎへ'));
    await tester.pumpAndSettle();
    expect(find.text('🔒 保護者の方へ確認'), findsNothing);
  });

  testWidgets('間違いでは通れず、やめるでも通れない', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async => result = await requireParentalGate(context),
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '${_answer(tester) + 1}');
    await tester.tap(find.text('つぎへ'));
    await tester.pumpAndSettle();
    expect(result, false);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('やめる'));
    await tester.pumpAndSettle();
    expect(result, false);
  });
}
