import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/models/friend_model.dart';
import 'package:kokugo_kore/providers/friend_provider.dart';
import 'package:kokugo_kore/screens/ranking_screen.dart';

/// RankingScreen は「友達ランキング」のみを表示する画面
/// （全体/学年別/開始月別タブとモックデータは廃止済み）。
class _FakeFriendNotifier extends FriendNotifier {
  _FakeFriendNotifier(List<Friend> initial) {
    state = initial;
  }
}

Friend _friend(String id, String name, int grade, int score, double acc) =>
    Friend(
      userId: id,
      displayName: name,
      profileImageUrl: '',
      grade: grade,
      addedDate: DateTime(2026, 4, 1),
      isOnline: false,
      totalScore: score,
      averageAccuracy: acc,
    );

Widget _app({List<Friend> friends = const [], ThemeMode mode = ThemeMode.light}) {
  return ProviderScope(
    overrides: [
      friendListProvider.overrideWith((ref) => _FakeFriendNotifier(friends)),
    ],
    child: MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: mode,
      home: const RankingScreen(),
    ),
  );
}

void main() {
  final friends = [
    _friend('a', '山田 花子', 3, 120, 0.8),
    _friend('b', '田中 太郎', 4, 300, 0.95),
    _friend('c', '佐藤 次郎', 2, 50, 0.5),
  ];

  group('RankingScreen Widget Tests', () {
    testWidgets('shows title and the friend tab only', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('ランキング'), findsWidgets);
      expect(find.text('👥 友達'), findsOneWidget);
      // 旧フィルタータブは存在しない
      expect(find.text('すべて'), findsNothing);
      expect(find.text('学年別'), findsNothing);
      expect(find.text('開始月別'), findsNothing);
      expect(find.text('学年×開始月'), findsNothing);
    });

    testWidgets('shows empty state when there are no friends', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('まだ友達がいません'), findsOneWidget);
      expect(find.text('友達を招待する'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('lists friends sorted by score descending', (tester) async {
      await tester.pumpWidget(_app(friends: friends));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('田中 太郎'), findsOneWidget);
      expect(find.text('山田 花子'), findsOneWidget);
      expect(find.text('佐藤 次郎'), findsOneWidget);

      final top = tester.getTopLeft(find.text('田中 太郎')).dy;
      final mid = tester.getTopLeft(find.text('山田 花子')).dy;
      final low = tester.getTopLeft(find.text('佐藤 次郎')).dy;
      expect(top, lessThan(mid));
      expect(mid, lessThan(low));
    });

    testWidgets('shows rank badges and scores', (tester) async {
      await tester.pumpWidget(_app(friends: friends));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('300'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('shows grade and accuracy for each friend', (tester) async {
      await tester.pumpWidget(_app(friends: friends));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('4年生 • 正答率 95%'), findsOneWidget);
      expect(find.text('3年生 • 正答率 80%'), findsOneWidget);
      expect(find.text('2年生 • 正答率 50%'), findsOneWidget);
    });

    testWidgets('friend list is scrollable', (tester) async {
      await tester.pumpWidget(_app(friends: friends));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.byType(RankingScreen), findsOneWidget);
    });

    testWidgets('has privacy settings action', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byTooltip('名前の公開設定'), findsOneWidget);
    });

    testWidgets('dark mode support', (tester) async {
      await tester.pumpWidget(_app(friends: friends, mode: ThemeMode.dark));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(RankingScreen), findsOneWidget);
      expect(find.text('田中 太郎'), findsOneWidget);
    });
  });
}
