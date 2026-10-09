import 'package:eigo_kore/features/shop/decor/title_items.dart';
import 'package:eigo_kore/screens/home_screen.dart';
import 'package:eigo_kore/widgets/title_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('称号は8個・IDは重複せず、5個がコイン(100〜500)・3個が達成型', () {
    expect(kTitleDefs.length, 8);
    expect(kTitleDefs.map((t) => t.id).toSet().length, 8);
    final coin = kTitleDefs.where((t) => t.isPurchasable).toList();
    expect(coin.length, 5);
    expect(coin.every((t) => t.coinCost >= 100 && t.coinCost <= 500), true);
    expect(kTitleDefs.where((t) => !t.isPurchasable).length, 3);
  });

  test('達成型の判定(境界値)', () {
    final streak = titleDefById('title_streak7')!;
    final lv = titleDefById('title_lv10')!;
    final badge = titleDefById('title_badge5')!;
    expect(isAchievementMet(streak, const TitleStats(streakDays: 6)), false);
    expect(isAchievementMet(streak, const TitleStats(streakDays: 7)), true);
    expect(isAchievementMet(lv, const TitleStats(level: 9)), false);
    expect(isAchievementMet(lv, const TitleStats(level: 10)), true);
    expect(isAchievementMet(badge, const TitleStats(badgeCount: 4)), false);
    expect(isAchievementMet(badge, const TitleStats(badgeCount: 5)), true);
  });

  test('コイン型は所持で使え、達成型は所持に関係なく達成が必要', () {
    final buy = titleDefById('title_abc')!;
    expect(isTitleAvailable(buy, const TitleStats(), {}), false);
    expect(isTitleAvailable(buy, const TitleStats(), {'title_abc'}), true);
    final streak = titleDefById('title_streak7')!;
    expect(isTitleAvailable(streak, const TitleStats(), {'title_streak7'}), false);
    expect(isTitleAvailable(streak, const TitleStats(streakDays: 7), {}), true);
  });

  test('保存IDの解決: 未選択・不明・使えないものは null', () {
    expect(resolveActiveTitle(null, const TitleStats(), {}), isNull);
    expect(resolveActiveTitle('nope', const TitleStats(), {}), isNull);
    expect(resolveActiveTitle('title_abc', const TitleStats(), {}), isNull);
    expect(resolveActiveTitle('title_abc', const TitleStats(), {'title_abc'})?.name, 'ABCマスター');
  });

  test('鍵つき表示用の条件文', () {
    expect(titleDefById('title_streak7')!.conditionText, '7日れんぞくでがくしゅう');
    expect(titleDefById('title_lv10')!.conditionText, 'レベル10になる');
    expect(titleDefById('title_badge5')!.conditionText, 'バッジを5個ゲット');
  });

  testWidgets('TitlePlate: 画像の上に称号名、長い名前でも溢れない', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: TitlePlate(name: 'とてもとてもながいしょうごうのなまえ'))),
    ));
    expect(find.text('とてもとてもながいしょうごうのなまえ'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(tester.getSize(find.byType(TitlePlate)).width, 110);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ホーム: 達成済みの称号を選んでいるとプレートが出る/未選択では出ない', (tester) async {
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    Future<void> pump(Map<String, Object> prefs) async {
      SharedPreferences.setMockInitialValues(prefs);
      await tester.pumpWidget(UncontrolledProviderScope(
        container: ProviderContainer(),
        child: const MaterialApp(home: HomeScreen()),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      tester.takeException(); // 既存のテスト用フォント起因の数px溢れは対象外
    }

    await pump({});
    expect(find.byType(TitlePlate), findsNothing);

    await pump({'decor_title': 'title_streak7', 'streak_days': 7});
    expect(find.byType(TitlePlate), findsOneWidget);
    expect(find.text('まいにちえいご'), findsOneWidget);
  });
}
