import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sansu_kore/data/customization_shop_items.dart';
import 'package:sansu_kore/features/shop/decor/decor_items.dart';
import 'package:sansu_kore/features/shop/decor/decor_provider.dart';
import 'package:sansu_kore/features/shop/decor/decor_screen.dart';
import 'package:sansu_kore/features/shop/decor/decor_scope.dart';
import 'package:sansu_kore/providers/character_provider.dart';
import 'package:sansu_kore/screens/shop_screen.dart';
import 'package:shared_core/shared_core.dart' show characterStateProvider, inventoryProvider;
import 'package:shared_preferences/shared_preferences.dart';

/// 所持品(shared_inventory)と保存済みのきせかえを SharedPreferences に入れて、読み込み済みのコンテナを返す。
Future<ProviderContainer> _container({Map<String, Object> prefs = const {}, Set<String> owned = const {}}) async {
  SharedPreferences.setMockInitialValues({
    ...prefs,
    if (owned.isNotEmpty) 'shared_inventory': jsonEncode(owned.toList()),
  });
  final c = ProviderContainer();
  addTearDown(c.dispose);
  c.read(inventoryProvider);
  c.read(decorProvider); // 生成時の自動読み込みを走らせる
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

  test('算数の既存の商品(テーマ色・背景・称号)とIDが重ならない', () {
    final existing = {for (final i in kCustomizationShopItems) i.id};
    for (final i in kDecorItems) {
      expect(existing.contains(i.id), false, reason: '既存と重複: ${i.id}');
    }
  });

  test('常設と季節に分かれる(季節は4つ、空の季節がない)', () {
    expect(decorExchangeItems().every((e) => e.coinCost >= 200), true);
    final seasonal = decorSeasonalItems();
    expect(seasonal.keys.toSet(), {'spring', 'summer', 'autumn', 'winter'});
    expect(decorExchangeItems().length + seasonal.values.fold<int>(0, (a, b) => a + b.length), kDecorItems.length);
  });

  test('持っていないきせかえはつけられない', () async {
    final c = await _container();
    final ok = await c.read(decorProvider.notifier).equip(decorItemById('bg_space')!);
    expect(ok, false);
    expect(c.read(decorProvider).background, isNull);
  });

  test('持っているきせかえをつけて、保存され、はずせる', () async {
    final c = await _container(owned: {'bg_space', 'frame_star'});
    final n = c.read(decorProvider.notifier);
    expect(await n.equip(decorItemById('bg_space')!), true);
    expect(await n.equip(decorItemById('frame_star')!), true);
    expect(c.read(activeDecorProvider).background, 'bg_space');
    expect(c.read(activeDecorProvider).frame, 'frame_star');
    final p = await SharedPreferences.getInstance();
    expect(p.getString('decor_background'), 'bg_space');

    await n.unequip(DecorKind.background);
    expect(c.read(activeDecorProvider).background, isNull);
    expect(p.getString('decor_background'), isNull);
    expect(c.read(activeDecorProvider).frame, 'frame_star');
  });

  test('保存されたきせかえは、次に開いたときも復元される', () async {
    final c = await _container(owned: {'bg_sansu'}, prefs: {'decor_background': 'bg_sansu'});
    expect(c.read(activeDecorProvider).background, 'bg_sansu');
  });

  test('保存されていても、持っていない・種類が違うIDは無視される', () async {
    final c = await _container(prefs: {'decor_background': 'bg_snow', 'decor_frame': 'bg_space', 'decor_effect': 'unknown'});
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
              seen = DecorScope.pageBg(context, const Color(0xFFFDF6F0));
              return const SizedBox();
            }),
          ),
        );
    await tester.pumpWidget(probe(false));
    expect(seen, const Color(0xFFFDF6F0));
    await tester.pumpWidget(probe(true));
    expect(seen, Colors.transparent);
  });

  testWidgets('きせかえ画面: 何も持っていなければ案内を出し、持っていればえらんでつけられる', (tester) async {
    final c = (await tester.runAsync(() => _container(owned: {'bg_space', 'bg_deepsea'})))!;
    await tester.pumpWidget(UncontrolledProviderScope(container: c, child: const MaterialApp(home: DecorScreen())));
    await tester.pump();
    expect(find.text('背景'), findsOneWidget);
    expect(find.text('宇宙の背景'), findsOneWidget);
    await tester.tap(find.text('宇宙の背景'));
    await tester.pump();
    expect(c.read(activeDecorProvider).background, 'bg_space');
    expect(find.text('✓ 宇宙の背景'), findsOneWidget);
    await tester.tap(find.text('なし').first);
    await tester.pump();
    expect(c.read(activeDecorProvider).background, isNull);

    final empty = (await tester.runAsync(() => _container()))!;
    await tester.pumpWidget(UncontrolledProviderScope(container: empty, child: const MaterialApp(home: DecorScreen())));
    await tester.pump();
    expect(find.textContaining('まだきせかえをもっていないよ'), findsOneWidget);
  });

  testWidgets('DecorBackdrop: 背景つきなら絵と膜を敷き、なければ子だけ', (tester) async {
    final c = (await tester.runAsync(() => _container(owned: {'bg_space'})))!;
    Widget app() => UncontrolledProviderScope(
          container: c,
          child: MaterialApp(builder: (context, child) => DecorBackdrop(child: child!), home: const Scaffold(body: Text('こんにちは'))),
        );
    await tester.pumpWidget(app());
    await tester.pump();
    expect(find.byType(Image), findsNothing);
    await tester.runAsync(() => c.read(decorProvider.notifier).equip(decorItemById('bg_space')!));
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('こんにちは'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('背景つきのときだけ、上端に暗い帯(ステータスバー用)と見出しの白地が出る', (tester) async {
    final c = (await tester.runAsync(() => _container(owned: {'bg_space'})))!;
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
    await tester.runAsync(() => c.read(decorProvider.notifier).equip(decorItemById('bg_space')!));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const ValueKey('decor_status_scrim')), findsOneWidget);
    expect(DecorScope.chipBg(inner).a > 0.5, true);
  });

  testWidgets('DecorFrame: 28px のアバターにはフレームが出る(ホーム上部のアバター)', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: DecorScope(hasBackground: false, frameAsset: 'assets/shop/frame_star.webp', child: DecorFrame(size: 28, child: SizedBox())),
    ));
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('波エフェクト: 画面高の12%以下・半透明で、タップを通し、下の内容を隠さない', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final c = (await tester.runAsync(() => _container(owned: {'effect_waves'})))!;
    await tester.runAsync(() => c.read(decorProvider.notifier).equip(decorItemById('effect_waves')!));
    var taps = 0;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        builder: (context, child) => DecorBackdrop(child: child!),
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(onPressed: () => taps++, child: const Text('した')),
          ),
        ),
      ),
    ));
    await tester.pump();
    await tester.pump();
    final fx = find.byKey(const ValueKey('decor_waves_opacity'));
    expect(fx, findsOneWidget);
    expect(tester.widget<Opacity>(fx).opacity, lessThanOrEqualTo(0.6));
    expect(tester.getSize(find.ancestor(of: fx, matching: find.byType(SizedBox)).first).height, lessThanOrEqualTo(800 * 0.12 + 0.01));
    await tester.tap(find.text('した'));
    expect(taps, 1);
  });

  testWidgets('ショップ交換所: 最下段の購入ボタンが「きせかえ」ボタンの上までスクロールできる', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(ProviderScope(
      overrides: [characterStateProvider.overrideWith(CharacterNotifier.new)],
      child: const MaterialApp(home: Scaffold(body: ShopScreen())),
    ));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('交換所'));
    await tester.pumpAndSettle();
    final sc = tester.state<ScrollableState>(find.byType(Scrollable).last);
    for (var i = 0; i < 5; i++) {
      sc.position.jumpTo(sc.position.maxScrollExtent);
      await tester.pumpAndSettle();
    }
    await tester.pumpAndSettle();
    final fabTop = tester.getTopLeft(find.byType(FloatingActionButton)).dy;
    final lastBottom = tester.getBottomLeft(find.byType(ElevatedButton).last).dy;
    expect(lastBottom, lessThanOrEqualTo(fabTop), reason: '最下段のボタンがFABに隠れる');
    expect(kShopFabClearance, greaterThanOrEqualTo(56 + 16));
  });
}
