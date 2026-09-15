import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileAvatarState {
  final Map<String, String> selectedAvatars;

  const ProfileAvatarState({this.selectedAvatars = const {}});

  String getSelectedAvatar(String profileId) => selectedAvatars[profileId] ?? 'kuroneko';

  ProfileAvatarState withAvatar(String profileId, String avatarId) =>
      ProfileAvatarState(
        selectedAvatars: Map.from(selectedAvatars)..[profileId] = avatarId,
      );
}

class ProfileAvatarNotifier extends Notifier<ProfileAvatarState> {
  static const _key = 'profile_selected_avatars';

  @override
  ProfileAvatarState build() => const ProfileAvatarState();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json != null) {
      final map = Map<String, String>.from(jsonDecode(json) as Map);
      state = ProfileAvatarState(selectedAvatars: map);
    }
  }

  Future<void> setSelectedAvatar(String profileId, String avatarId) async {
    final prefs = await SharedPreferences.getInstance();
    final next = state.withAvatar(profileId, avatarId);
    await prefs.setString(_key, jsonEncode(next.selectedAvatars));
    state = next;
  }
}

final profileAvatarProvider = NotifierProvider<ProfileAvatarNotifier, ProfileAvatarState>(
  ProfileAvatarNotifier.new,
);
