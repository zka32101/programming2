import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_core/shared_core.dart' show AvatarModel, allAvatars;

const _selectedAvatarKey = 'selected_avatar_id';
const _defaultAvatarId = 'kuroneko';

/// ホーム画面・設定画面で表示する「選択中のアバター」。
/// 実際の解放状態は shared_core の avatarProvider が管理し、
/// このプロバイダーはユーザーが選んだ「今使うアバター」だけを保持する。
class SelectedAvatarNotifier extends Notifier<AvatarModel> {
  @override
  AvatarModel build() => allAvatars.firstWhere((a) => a.id == _defaultAvatarId);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_selectedAvatarKey) ?? _defaultAvatarId;
    final avatar = allAvatars.firstWhere(
      (a) => a.id == savedId,
      orElse: () => allAvatars.first,
    );
    state = avatar;
  }

  Future<void> select(String avatarId) async {
    final avatar = allAvatars.firstWhere(
      (a) => a.id == avatarId,
      orElse: () => allAvatars.first,
    );
    state = avatar;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedAvatarKey, avatar.id);
  }
}

final selectedAvatarProvider =
    NotifierProvider<SelectedAvatarNotifier, AvatarModel>(
        SelectedAvatarNotifier.new);
