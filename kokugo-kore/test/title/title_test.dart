import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/features/shop/decor/decor_shop_tab.dart';
import 'package:kokugo_kore/features/shop/title/title_data.dart';
import 'package:kokugo_kore/features/shop/title/title_provider.dart';
import 'package:kokugo_kore/providers/purchased_items_provider.dart';
import 'package:kokugo_kore/widgets/title_plate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('称号の定義と判定', () {
    test('8個・買う5個と達成3個・IDは dc_ で重複なし・価格は100〜500', () {
      expect(kTitleDefs.length, 8);
      expect(kTitleDefs.where((t) => t.isPurchasable).length, 5);
      expect(kTitleDefs.where((t) => !t.isPurchasable).length, 3);
      final ids = <String>{};
      for (final t in kTitleDefs) {
        expect(t.id.startsWith('dc_title_'), true);
        expect(ids.add(t.id), true);
        if (t.isPurchasable) expect(t.coinCost, inInclusiveRange(100, 500));
      }
    });

    test('達成の称号はしきい値ちょうどで解放される', () {
      final kanji = titleById('dc_title_kanji')!;
      expect(isTitleAchieved(kanji, const TitleStats(kanjiCorrect: 99)), false);
      expect(isTitleAchieved(kanji, const TitleStats(kanjiCorrect: 100)), true);
      final yomi = titleById('dc_title_yomitori')!;
      expect(isTitleAchieved(yomi, const TitleStats(readingCorrect: 49)), false);
      expect(isTitleAchieved(yomi, const TitleStats(readingCorrect: 50)), true);
      final takara = titleById('dc_title_takara')!;
      expect(isTitleAchieved(takara, const TitleStats(badgeCount: 9)), false);
      expect(isTitleAchieved(takara, const TitleStats(badgeCount: 10)), true);
    });

    test('買う称号は所持しているときだけ使え、達成では解放されない', () {
      final kana = titleById('dc_title_kana')!;
      const rich = TitleStats(badgeCount: 99, kanjiCorrect: 999, readingCorrect: 999);
      expect(isTitleAvailable(kana, rich, {}), false);
      expect(isTitleAvailable(kana, rich, {'dc_title_kana'}), true);
      final kanji = titleById('dc_title_kanji')!;
      expect(isTitleAvailable(kanji, rich, {}), true);
    });

    test('未解放の条件文が出る・不明IDは null', () {
      expect(titleById('dc_title_kanji')!.conditionText, '漢字の正解を100かい');
      expect(titleById('dc_title_takara')!.conditionText, 'バッジを10こ');
      expect(titleById('nope'), isNull);
      expect(titleById(null), isNull);
    });
  });

  group('選択の保存', () {
    Future<ProviderContainer> make(Map<String, Object> prefs) async {
      SharedPreferences.setMockInitialValues(prefs);
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(titleSelectionProvider);
      await c.read(purchasedItemsProvider.notifier).load();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return c;
    }

    test('持っていない称号は選べない', () async {
      final c = await make({});
      final ok = await c.read(titleSelectionProvider.notifier).select(titleById('dc_title_kana')!);
      expect(ok, false);
      expect(c.read(activeTitleProvider), isNull);
    });

    test('買った称号を選ぶと保存され、再起動後も出る。外すと消える', () async {
      final c = await make({'purchased_shop_items': ['dc_title_kana']});
      expect(await c.read(titleSelectionProvider.notifier).select(titleById('dc_title_kana')!), true);
      expect(c.read(activeTitleProvider)?.name, 'かなのたつじん');
      final c2 = await make({'purchased_shop_items': ['dc_title_kana'], 'decor_title': 'dc_title_kana'});
      expect(c2.read(activeTitleProvider)?.id, 'dc_title_kana');
      await c2.read(titleSelectionProvider.notifier).clear();
      expect(c2.read(activeTitleProvider), isNull);
    });

    test('持っていない保存値は無視する', () async {
      final c = await make({'decor_title': 'dc_title_mahou'});
      expect(c.read(activeTitleProvider), isNull);
    });
  });

  group('TitlePlate', () {
    testWidgets('幅110・長い名前でも overflow しない', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: TitlePlate(name: 'ことばのまほうつかいのだいおうさま', width: 110))),
      ));
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TitlePlate)).width, 110);
      expect(find.text('ことばのまほうつかいのだいおうさま'), findsOneWidget);
    });
  });

  group('ショップの称号区分', () {
    testWidgets('8個が並び、未解放の達成称号には鍵と条件が出る', (tester) async {
      SharedPreferences.setMockInitialValues({'total_coins': 1000});
      await tester.binding.setSurfaceSize(const Size(400, 3000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const ProviderScope(
        child: MaterialApp(home: Scaffold(body: DecorShopTab(season: 'spring'))),
      ));
      await tester.pumpAndSettle();
      for (final t in kTitleDefs) {
        expect(find.byKey(ValueKey('title_row_${t.id}')), findsOneWidget, reason: t.id);
      }
      expect(find.byKey(const ValueKey('title_lock')), findsNWidgets(3));
      expect(find.textContaining('🔒 漢字の正解を100かい'), findsOneWidget);
    });
  });
}
