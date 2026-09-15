import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show matchmakingHandlersProvider, matchHandlersProvider;

import '../services/kokugo_matchmaking_service.dart';
import 'profile_provider.dart';

final List<Override> kokugoMultiplayerProviderOverrides = [
  matchmakingHandlersProvider.overrideWithValue(KokugoMatchmakingService.matchmakingHandlers),
  matchHandlersProvider.overrideWithValue(KokugoMatchmakingService.matchHandlers),
];

/// マルチプレイで使う自分の userId / displayName。
///
/// referral_provider 等、既存のマルチプレイ以外の機能と同じく
/// `profileProvider` の現在のプロフィール（[UserProfile.id] / [UserProfile.name]）を
/// そのまま使う。プロフィール未選択時は null。
class KokugoPlayerIdentity {
  final String userId;
  final String displayName;
  final int grade;

  const KokugoPlayerIdentity({
    required this.userId,
    required this.displayName,
    required this.grade,
  });
}

final kokugoPlayerIdentityProvider = Provider<KokugoPlayerIdentity?>((ref) {
  final profile = ref.watch(profileProvider).currentProfile;
  if (profile == null) return null;
  return KokugoPlayerIdentity(
    userId: profile.id,
    displayName: profile.name,
    grade: profile.grade,
  );
});
