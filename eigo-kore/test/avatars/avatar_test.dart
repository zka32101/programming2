import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/models/avatar_model.dart';
import 'package:eigo_kore/widgets/avatar_view.dart';

void main() {
  test('16 animal avatars: first 4 free, the other 12 cost coins', () {
    expect(allAvatarIcons.length, 16);
    expect(allAvatarIcons.where((a) => a.isDefault).length, 4);
    expect(allAvatarIcons.take(4).every((a) => a.isDefault), isTrue);
    expect(allAvatarIcons.skip(4).every((a) => !a.isDefault && a.price > 0), isTrue);
    expect(allAvatarIcons.first.imageAsset, 'assets/avatars/avatar_1.jpg');
  });

  test('legacy emoji avatars resolve to the animal avatars', () {
    expect(AvatarView.resolve('👧')?.id, 'avatar_1');
    expect(AvatarView.resolve('👶')?.id, 'avatar_4');
    expect(AvatarView.resolve('avatar_9')?.id, 'avatar_9');
    expect(AvatarView.resolve('🎀'), isNull); // 旧ショップ絵文字は文字のまま表示
  });

  testWidgets('AvatarView shows text for unknown emoji', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AvatarView('🎀', size: 40))));
    expect(find.text('🎀'), findsOneWidget);
  });
}
