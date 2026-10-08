import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/features/shop/decor/decor_items.dart';
import 'package:kokugo_kore/features/shop/decor/decor_provider.dart';
import 'package:kokugo_kore/features/shop/decor/decor_screen.dart';
import 'package:kokugo_kore/features/shop/decor/decor_scope.dart';
import 'package:kokugo_kore/features/shop/decor/decor_shop_tab.dart';
import 'package:kokugo_kore/providers/purchased_items_provider.dart';
import 'package:shared_core/shared_core.dart' show coinProvider;
import 'package:shared_preferences/shared_preferences.dart';

/// 所持品(purchased_shop_items)・コイン・保存済みのきせかえを入れて、読み込み済みのコンテナを返す。
Future<ProviderContainer> _container({
  Map<String, Object> prefs = const {},
  Set<String> owned = const {},
  int coins = 0,
}) async {
  SharedPreferences.setMockInitialValues({
    ...prefs,
    if (owned.isNotEmpty) 'purchased_shop_items': owned.toList(),
    'total_coins': coins,
  });
  final c = ProviderContainer();
  addTearDown(c.dispose);
  c.read(decorProvider); // 生成時の自動読み込みを走らせる
  await c.read(purchasedItemsProvider.notifier).load();
  await c.read(coinProvider.notifier).load();
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return c;
}

void main() {
  test('商品の画像・サムネイルがすべて存在し、IDは重複しない', () {
    final ids = <String>{};
    for (final i in kDecorItems) {
      expect(ids.add(i.id), true, reason: '重複: ${i.id}');
      expect(File(i.asset).existsSync(), true, reason: i.asset);
      expect(File(i.thumb).existsSync(), true, reason: i.thumb);
    }
    expect(kDecorItems.length, 18);
  });

  test('国語の既存の背景テーマIDと重ならない', () {
    for (final i in kDecorItems) {
      expect(bgThemeColors.containsKey(i.id), false, reason: '既存と重複: ${i.id}');
    }
  });

  test('季節は4つあり、常設もある', () {
    expect({for (final i in kDecorItems) if (i.season != null) i.season}, {'spring', 'summer', 'autumn', 'winter'});
    expect(kDecorItems.where((i) => i.season == null).length, greaterThan(5));
    expect(kDecorItems.every((i) => i.coinCost >= 200), true);
  });

  test('持っていないきせかえはつけられない', () async {
    final c = await _container();
    final ok = await c.read(decorProvider.notifier).equip(decorItemById('dc_bg_space')!);
    expect(ok, false);
    expect(c.read(decorProvider).background, isNull);
  });

  test('持っているきせかえをつけて、保存され、はずせる', () async {
    final c = await _container(owned: {'dc_bg_space', 'dc_frame_star'});
    final n = c.read(decorProvider.notifier);
    expect(await n.equip(decorItemById('dc_bg_space')!), true);
    expect(await n.equip(decorItemById('dc_frame_star')!), true);
    expect(c.read(activeDecorProvider).background, 'dc_bg_space');
    expect(c.read(activeDecorProvider).frame, 'dc_frame_star');
    final p = await SharedPreferences.getInstance();
    expect(p.getString('decor_background'), 'dc_bg_space');

    await n.unequip(DecorKind.background);
    expect(c.read(activeDecorProvider).background, isNull);
    expect(p.getString('decor_background'), isNull);
    expect(c.read(activeDecorProvider).frame, 'dc_frame_star');
  });

  test('保存されたきせかえは、次に開いたときも復元される', () async {
    final c = await _container(owned: {'dc_bg_kokugo'}, prefs: {'decor_background': 'dc_bg_kokugo'});
    expect(c.read(activeDecorProvider).background, 'dc_bg_kokugo');
  });

  test('保存されていても、持っていない・種類が違うIDは無視される', () async {
    final c = await _container(
        prefs: {'decor_background': 'dc_bg_snow', 'decor_frame': 'dc_bg_space', 'decor_effect': 'unknown'});
    final a = c.read(activeDecorProvider);
    expect(a.background, isNull); // 持っていない
    expect(a.frame, isNull); // 種類が違う
    expect(a.effect, isNull); // 知らないID
  });

  testWidgets('背景をつけると、画面の背景色が透明になり、つけていなければ元の色のまま', (tester) async {
    Color? seen;
    Widget probe(bool bg) => MaterialApp(
          home: DecorScope(
            hasBackground: bg,
            child: Builder(builder: (context) {
              seen = DecorScope.pageBg(context, const Color(0xFFF5F5F5));
              return const SizedBox();
            }),
          ),
        );
    await tester.pumpWidget(probe(false));
    expect(seen, const Color(0xFFF5F5F5));
    await tester.pumpWidget(probe(true));
    expect(seen, Colors.transparent);
  });

  testWidgets('きせかえ画面: 何も持っていなければ案内を出し、持っていればえらんでつけられる', (tester) async {
    final c = (await tester.runAsync(() => _container(owned: {'dc_bg_space', 'dc_bg_ocean'})))!;
    await tester.pumpWidget(UncontrolledProviderScope(container: c, child: const MaterialApp(home: DecorScreen())));
    await tester.pump();
    expect(find.text('背景'), findsOneWidget);
    expect(find.text('宇宙の背景'), findsOneWidget);
    await tester.tap(find.text('宇宙の背景'));
    await tester.pump();
    expect(c.read(activeDecorProvider).background, 'dc_bg_space');
    expect(find.text('✓ 宇宙の背景'), findsOneWidget);
    await tester.tap(find.text('なし').first);
    await tester.pump();
    expect(c.read(activeDecorProvider).background, isNull);

    final empty = (await tester.runAsync(() => _container()))!;
    await tester.pumpWidget(UncontrolledProviderScope(container: empty, child: const MaterialApp(home: DecorScreen())));
    await tester.pump();
    expect(find.textContaining('まだきせかえをもっていないよ'), findsOneWidget);
  });

  testWidgets('ショップのきせかえタブ: コインが足りなければ買えず、足りれば買ってコインが減る', (tester) async {
    final poor = (await tester.runAsync(() => _container(coins: 100)))!;
    Widget app(ProviderContainer c) => UncontrolledProviderScope(
          container: c,
          child: const MaterialApp(home: Scaffold(body: DecorShopTab(season: 'spring'))),
        );
    await tester.pumpWidget(app(poor));
    await tester.pump();
    final btn = find.widgetWithText(ElevatedButton, '🪙200').first;
    expect(tester.widget<ElevatedButton>(btn).onPressed, isNull);

    final rich = (await tester.runAsync(() => _container(coins: 500)))!;
    await tester.pumpWidget(app(rich));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, '🪙200').first);
    await tester.pump();
    await tester.tap(find.text('購入する'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    expect(rich.read(coinProvider).totalCoins, 300);
    expect(rich.read(purchasedItemsProvider).ownedItemIds.length, 1);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('DecorBackdrop: 背景つきなら絵と膜を敷き、なければ子だけ', (tester) async {
    final c = (await tester.runAsync(() => _container(owned: {'dc_bg_space'})))!;
    Widget app() => UncontrolledProviderScope(
          container: c,
          child: MaterialApp(builder: (context, child) => DecorBackdrop(child: child!), home: const Scaffold(body: Text('こんにちは'))),
        );
    await tester.pumpWidget(app());
    await tester.pump();
    expect(find.byType(Image), findsNothing);
    await tester.runAsync(() => c.read(decorProvider.notifier).equip(decorItemById('dc_bg_space')!));
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('こんにちは'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('背景つきのときだけ、上端に暗い帯(ステータスバー用)と見出しの白地が出る', (tester) async {
    final c = (await tester.runAsync(() => _container(owned: {'dc_bg_space'})))!;
    late BuildContext inner;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        builder: (context, child) => DecorBackdrop(child: child!),
        home: Scaffold(body: Builder(builder: (ctx) {
          inner = ctx;
          return const Text('x');
        })),
      ),
    ));
    await tester.pump();
    expect(find.byKey(const ValueKey('decor_status_scrim')), findsNothing);
    expect(DecorScope.chipBg(inner), Colors.transparent);
    await tester.runAsync(() => c.read(decorProvider.notifier).equip(decorItemById('dc_bg_space')!));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const ValueKey('decor_status_scrim')), findsOneWidget);
    expect(DecorScope.chipBg(inner).a > 0.5, true);
  });

  testWidgets('DecorFrame: 28px のアバターにはフレームが出る(ホーム上部のアバター)', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: DecorScope(hasBackground: false, frameAsset: 'assets/shop/dc_frame_star.webp', child: DecorFrame(size: 28, child: SizedBox())),
    ));
    expect(find.byType(Image), findsOneWidget);
  });
}
