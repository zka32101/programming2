import 'dart:convert';

import 'package:eigo_kore/models/user_profile.dart';
import 'package:eigo_kore/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserProfile _p(String id, String name) => UserProfile(
      id: id,
      name: name,
      grade: 3,
      avatar: 'A',
      createdAt: DateTime(2026, 1, 1),
      lastAccessedAt: DateTime(2026, 1, 1),
    );

Future<void> _setPrefs(List<UserProfile> ps, {String? current}) async {
  SharedPreferences.setMockInitialValues({
    if (ps.isNotEmpty)
      'eigo_kore_profiles': jsonEncode(ps.map((p) => p.toJson()).toList()),
    if (current != null) 'eigo_kore_current_user_id': current,
  });
}

Future<String> _run(WidgetTester tester) async {
  await tester.pumpWidget(ProviderScope(
    child: MaterialApp(
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const Scaffold(body: Text('HOME')),
        '/profile-select': (_) => const Scaffold(body: Text('SELECT')),
      },
    ),
  ));
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  return find.text('HOME').evaluate().isNotEmpty
      ? '/home'
      : find.text('SELECT').evaluate().isNotEmpty
          ? '/profile-select'
          : 'none';
}

void main() {
  testWidgets('プロフィール1人+現在ID保存済み → /home', (tester) async {
    await _setPrefs([_p('a', 'はな')], current: 'a');
    expect(await _run(tester), '/home');
  });

  testWidgets('プロフィール1人+現在ID無し → /home かつ保存される', (tester) async {
    await _setPrefs([_p('a', 'はな')]);
    expect(await _run(tester), '/home');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('eigo_kore_current_user_id'), 'a');
  });

  testWidgets('プロフィール2人+現在ID無し → /profile-select', (tester) async {
    await _setPrefs([_p('a', 'はな'), _p('b', 'たろう')]);
    expect(await _run(tester), '/profile-select');
  });

  testWidgets('プロフィール0人 → /profile-select', (tester) async {
    await _setPrefs([]);
    expect(await _run(tester), '/profile-select');
  });
}
