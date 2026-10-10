import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eigo_kore/reward_assets.dart';
import 'package:eigo_kore/utils/study_dates.dart';
import 'package:eigo_kore/widgets/streak_calendar.dart';

void main() {
  test('appendStudyDate: dedupe, sorted, trimmed to 180 days', () {
    final today = DateTime(2026, 10, 10);
    var l = appendStudyDate(['2026-10-09'], today);
    expect(l, ['2026-10-09', '2026-10-10']);
    l = appendStudyDate(l, today);
    expect(l.length, 2);
    final old = ['2026-04-01', '2026-04-15', '2026-10-01'];
    final t = appendStudyDate(old, today);
    expect(t.contains('2026-04-01'), isFalse); // 180日より前
    expect(t.contains('2026-04-15'), isTrue); // 177日前
    expect(t.last, '2026-10-10');
  });

  test('backfillStudyDates fills N days ending at last day', () {
    expect(backfillStudyDates(3, DateTime(2026, 3, 1)),
        ['2026-02-27', '2026-02-28', '2026-03-01']);
    expect(backfillStudyDates(0, DateTime(2026, 3, 1)), isEmpty);
    expect(backfillStudyDates(5, null), isEmpty);
    expect(backfillStudyDates(500, DateTime(2026, 10, 10)).length, 180);
  });

  test('milestoneDays marks 7th and 14th consecutive day', () {
    final s = <DateTime>{
      for (var i = 0; i < 15; i++) DateTime(2026, 9, 1 + i),
      DateTime(2026, 9, 20), // 途切れて 1 日目
    };
    final m = milestoneDays(s);
    expect(m, {DateTime(2026, 9, 7), DateTime(2026, 9, 14)});
  });

  test('recordStudyDay backfills once then appends', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await recordStudyDay(prefs, DateTime(2026, 10, 10, 15), streak: 3);
    expect(prefs.getStringList(studyDatesKey),
        ['2026-10-08', '2026-10-09', '2026-10-10']);
    await recordStudyDay(prefs, DateTime(2026, 10, 10, 20), streak: 3);
    expect(prefs.getStringList(studyDatesKey)!.length, 3);
    await recordStudyDay(prefs, DateTime(2026, 10, 12), streak: 1);
    expect(prefs.getStringList(studyDatesKey)!.last, '2026-10-12');
  });

  test('bonusStickerAssets boundaries', () {
    expect(bonusStickerAssets(), isEmpty);
    expect(bonusStickerAssets(firstAttempt: true), [contains('sticker_rocket')]);
    expect(bonusStickerAssets(personalBest: true), [contains('trophy_blue')]);
    expect(bonusStickerAssets(firstPerfect: true), [contains('rainbow_star')]);
    expect(
        bonusStickerAssets(
            firstAttempt: true, personalBest: true, firstPerfect: true),
        hasLength(2));
  });

  test('reward assets exist on disk', () {
    for (final f in [
      'calendar_frame', 'stamp_ring_rainbow', 'stamp_coin',
      'sticker_rocket', 'sticker_trophy_blue', 'sticker_rainbow_star',
    ]) {
      expect(File('assets/reward/$f.webp').existsSync(), isTrue, reason: f);
    }
  });

  testWidgets('StreakCalendar has no overflow at 320px', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StreakCalendar(
              month: DateTime(2026, 8),
              studiedDays: {
                for (var i = 0; i < 20; i++) DateTime(2026, 8, 1 + i),
              },
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('31'), findsOneWidget);
    expect(find.byKey(const Key('cal_coin_7')), findsOneWidget);
    expect(find.byKey(const Key('cal_ring_8')), findsOneWidget);
  });
}
