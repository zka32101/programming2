import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sansu_kore/providers/profile_avatar_provider.dart';
import 'package:sansu_kore/screens/profile_selection_screen.dart';
import 'package:sansu_kore/widgets/avatar_picker_grid.dart';

Widget _picker(
    {required Set<String> owned,
    String selected = 'kuroneko',
    required List<String> picked,
    required List<String> locked}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        height: 600,
        child: AvatarPickerGrid(
          unlockedIds: owned,
          selectedId: selected,
          onSelect: (a) => picked.add(a.id),
          onLockedTap: (a) => locked.add(a.id),
        ),
      ),
    ),
  );
}

void main() {
  const free4 = {'kuroneko', 'ahiru', 'inu', 'kitsune'};

  testWidgets('free 4 selectable, others locked and not selectable',
      (tester) async {
    final picked = <String>[], locked = <String>[];
    await tester.pumpWidget(_picker(owned: free4, picked: picked, locked: locked));
    expect(find.byKey(const ValueKey('locked_ahiru')), findsNothing);
    expect(find.byKey(const ValueKey('locked_honhon')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('avatar_ahiru')));
    expect(picked, ['ahiru']);
    await tester.tap(find.byKey(const ValueKey('locked_honhon')), warnIfMissed: false);
    expect(picked, ['ahiru']);
    expect(locked, ['honhon']);
  });

  testWidgets('purchased avatar is selectable', (tester) async {
    final picked = <String>[], locked = <String>[];
    await tester.pumpWidget(
        _picker(owned: {...free4, 'honhon'}, picked: picked, locked: locked));
    await tester.tap(find.byKey(const ValueKey('avatar_honhon')));
    expect(picked, ['honhon']);
  });

  testWidgets('currently selected locked avatar is preserved as owned',
      (tester) async {
    final picked = <String>[], locked = <String>[];
    await tester.pumpWidget(
        _picker(owned: free4, selected: 'tora', picked: picked, locked: locked));
    expect(find.byKey(const ValueKey('avatar_tora')), findsOneWidget);
    expect(find.byKey(const ValueKey('locked_tora')), findsNothing);
  });

  testWidgets('profile row shows avatar image widget, not initial',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'profile_avatar_ids': '{"p1":"ahiru"}',
    });
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: ProfileAvatar(profileId: 'p1', name: 'てすと')),
      ),
    ));
    await tester.pump();
    final container = ProviderScope.containerOf(
        tester.element(find.byType(ProfileAvatar)));
    await container.read(profileAvatarProvider.notifier).load();
    await tester.pump();
    final w = tester.widget<AvatarWidget>(find.byType(AvatarWidget));
    expect(w.avatar.id, 'ahiru');
    expect(find.text('て'), findsNothing);
  });
}
