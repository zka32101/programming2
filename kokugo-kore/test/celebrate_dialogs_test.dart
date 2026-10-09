import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/shared_core.dart';
import 'package:kokugo_kore/widgets/badge_achievement_notification.dart';
import 'package:kokugo_kore/widgets/character_unlock_dialog.dart';

const _badge = BadgeModel(
  id: 'test_badge',
  emoji: '🎯',
  title: 'テストバッジ',
  description: 'せつめい',
  category: BadgeCategory.streak,
  requiredCount: 1,
);

Widget _host(Widget Function(BuildContext) onTap) => MaterialApp(
      home: Builder(
        builder: (c) => Scaffold(
          body: Center(
            child: ElevatedButton(onPressed: () => onTap(c), child: const Text('open')),
          ),
        ),
      ),
    );

void main() {
  Future<void> setSmall(WidgetTester t) async {
    t.view.physicalSize = const Size(320, 480);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
  }

  testWidgets('badge dialog single shows celebrate art, no overflow', (t) async {
    await setSmall(t);
    await t.pumpWidget(_host((c) {
      showBadgeAchievementDialog(c, [_badge], displayDuration: const Duration(minutes: 1));
      return const SizedBox();
    }));
    await t.tap(find.text('open'));
    await t.pump(const Duration(seconds: 1));
    await t.pump(const Duration(seconds: 1));
    expect(find.text('おめでとう！'), findsOneWidget);
    expect(find.text('テストバッジ'), findsOneWidget);
    expect(find.text('すごい！'), findsOneWidget);
    expect(t.takeException(), isNull);
    await t.ensureVisible(find.text('すごい！'));
    await t.tap(find.text('すごい！'));
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    expect(find.text('おめでとう！'), findsNothing);
  });

  testWidgets('badge dialog multiple, no overflow', (t) async {
    await setSmall(t);
    await t.pumpWidget(_host((c) {
      showBadgeAchievementDialog(c, [_badge, _badge], displayDuration: const Duration(minutes: 1));
      return const SizedBox();
    }));
    await t.tap(find.text('open'));
    await t.pump(const Duration(seconds: 1));
    expect(find.text('おめでとう！'), findsOneWidget);
    expect(find.text('完璧です！'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('level up dialog shows art and Lv text, no overflow', (t) async {
    await setSmall(t);
    const ch = BaseCharacter(
      id: 'x', name: 'テスト', emoji: '🐱', tier: 1, unlockAt: 0,
      subject: '漢字', backstory: '', stampPhrases: [], appSubject: Subject.kokugo,
    );
    await t.pumpWidget(_host((c) {
      showCharacterLevelUpDialog(c, character: ch, newLevel: 3);
      return const SizedBox();
    }));
    await t.tap(find.text('open'));
    await t.pump(const Duration(seconds: 1));
    expect(find.text('レベルアップ！'), findsOneWidget);
    expect(find.text('Lv.2 → Lv.3'), findsOneWidget);
    expect(t.takeException(), isNull);
    await t.tap(find.text('うれしい！'));
    await t.pump(const Duration(seconds: 1));
    expect(find.text('レベルアップ！'), findsNothing);
  });
}
