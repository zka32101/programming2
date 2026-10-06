import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_core/shared_core.dart' show AvatarModel, allAvatars;

const _profileAvatarsKey = 'profile_avatar_ids';

/// プロフィールID -> アバターID。プロフィール一覧で各プロフィールのアバターを出すために保持する。
class ProfileAvatarNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileAvatarsKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      state = decoded.map((k, v) => MapEntry(k, v as String));
    } catch (_) {}
  }

  Future<void> setAvatar(String profileId, String avatarId) async {
    state = {...state, profileId: avatarId};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileAvatarsKey, jsonEncode(state));
  }

  /// 保存が無い/不明なIDなら null。
  AvatarModel? avatarFor(String profileId) {
    final id = state[profileId];
    if (id == null) return null;
    for (final a in allAvatars) {
      if (a.id == id) return a;
    }
    return null;
  }
}

final profileAvatarProvider =
    NotifierProvider<ProfileAvatarNotifier, Map<String, String>>(
        ProfileAvatarNotifier.new);
