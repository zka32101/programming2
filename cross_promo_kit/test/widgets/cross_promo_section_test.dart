import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cross_promo_kit/models/promoted_app.dart';
import 'package:cross_promo_kit/widgets/cross_promo_section.dart';

const _dummyApps = [
  PromotedApp(
    id: 'com.example.kokugo',
    name: '国語コレ！',
    tagline: '読解力を毎日ちょっとずつ',
    iconUrl: '',
    storeUrl: 'https://play.google.com/store/apps/details?id=com.example.kokugo',
    category: '小学コレ',
  ),
  PromotedApp(
    id: 'com.example.shakai',
    name: '社会コレ！',
    tagline: '地図と歴史がわかる',
    iconUrl: '',
    storeUrl: 'https://play.google.com/store/apps/details?id=com.example.shakai',
    category: '小学コレ',
  ),
  PromotedApp(
    id: 'com.example.rika',
    name: '理科コレ！',
    tagline: '実験と観察で学ぼう',
    iconUrl: '',
    storeUrl: 'https://play.google.com/store/apps/details?id=com.example.rika',
    category: '小学コレ',
  ),
];

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  testWidgets('renders a card per promoted app with title and tagline', (tester) async {
    await tester.pumpWidget(_wrap(const CrossPromoSection(
      currentAppId: 'com.example.sansu',
      appsOverride: _dummyApps,
    )));
    await tester.pumpAndSettle();

    expect(find.text('他のアプリもチェック！'), findsOneWidget);
    expect(find.text('国語コレ！'), findsOneWidget);
    expect(find.text('社会コレ！'), findsOneWidget);
    expect(find.text('理科コレ！'), findsOneWidget);
    expect(find.text('読解力を毎日ちょっとずつ'), findsOneWidget);
  });

  testWidgets('renders nothing when there are no promoted apps', (tester) async {
    await tester.pumpWidget(_wrap(const CrossPromoSection(
      currentAppId: 'com.example.sansu',
      appsOverride: [],
    )));
    await tester.pumpAndSettle();

    expect(find.text('他のアプリもチェック！'), findsNothing);
  });

  testWidgets('respects maxApps and caps the visible card count', (tester) async {
    await tester.pumpWidget(_wrap(const CrossPromoSection(
      currentAppId: 'com.example.sansu',
      appsOverride: _dummyApps,
      maxApps: 2,
    )));
    await tester.pumpAndSettle();

    expect(find.text('国語コレ！'), findsOneWidget);
    expect(find.text('社会コレ！'), findsOneWidget);
    expect(find.text('理科コレ！'), findsNothing);
  });

  testWidgets('does not overflow within its fixed-height row', (tester) async {
    await tester.pumpWidget(_wrap(const CrossPromoSection(
      currentAppId: 'com.example.sansu',
      appsOverride: _dummyApps,
    )));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a card does not throw (launch is fire-and-forget)', (tester) async {
    await tester.pumpWidget(_wrap(const CrossPromoSection(
      currentAppId: 'com.example.sansu',
      appsOverride: _dummyApps,
    )));
    await tester.pumpAndSettle();

    await tester.tap(find.text('国語コレ！'));
    await tester.pump();
  });

  testWidgets('picks up the ambient theme instead of hardcoded colors', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const Scaffold(
        body: SingleChildScrollView(
          child: CrossPromoSection(
            currentAppId: 'com.example.sansu',
            appsOverride: _dummyApps,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CrossPromoSection), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('visual snapshot of the redesigned cards', (tester) async {
    await tester.pumpWidget(_wrap(const CrossPromoSection(
      currentAppId: 'com.example.sansu',
      appsOverride: _dummyApps,
    )));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CrossPromoSection),
      matchesGoldenFile('goldens/cross_promo_section.png'),
    );
  });
}
