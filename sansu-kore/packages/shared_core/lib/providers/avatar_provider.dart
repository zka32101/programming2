import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/avatar_model.dart';

const _unlockedPrefix = 'avatar_unlocked_';

class AvatarState {
  final Set<String> unlockedIds;

  const AvatarState({required this.unlockedIds});

  bool isUnlocked(String avatarId) => unlockedIds.contains(avatarId);

  AvatarState copyWith({Set<String>? unlockedIds}) =>
      AvatarState(unlockedIds: unlockedIds ?? this.unlockedIds);
}

class AvatarNotifier extends Notifier<AvatarState> {
  @override
  AvatarState build() {
    final initialFree = {'kuroneko', 'ahiru', 'inu', 'kitsune'};
    return AvatarState(unlockedIds: initialFree);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedSet = <String>{'kuroneko', 'ahiru', 'inu', 'kitsune'};

    // SharedPreferences から有料・コイン解放分を読み込む
    for (final avatar in allAvatars) {
      final isUnlocked = prefs.getBool('$_unlockedPrefix${avatar.id}') ?? false;
      if (isUnlocked) {
        unlockedSet.add(avatar.id);
      }
    }

    state = AvatarState(unlockedIds: unlockedSet);
  }

  /// コイン消費でアバターを解放
  /// 戻り値: true = 成功、false = コイン不足
  Future<bool> unlockWithCoins(String avatarId) async {
    final avatar = allAvatars.firstWhere(
      (a) => a.id == avatarId,
      orElse: () => throw Exception('Avatar not found: $avatarId'),
    );

    if (avatar.unlockType != AvatarUnlockType.coin || avatar.coinCost == null) {
      throw Exception('Avatar is not coin-unlockable');
    }

    if (state.isUnlocked(avatarId)) {
      throw Exception('Avatar already unlocked');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_unlockedPrefix$avatarId', true);

    state = state.copyWith(
      unlockedIds: {...state.unlockedIds, avatarId},
    );
    return true;
  }

  /// プレミアム購入でアバターを解放
  Future<void> unlockWithPremium(String avatarId) async {
    final avatar = allAvatars.firstWhere(
      (a) => a.id == avatarId,
      orElse: () => throw Exception('Avatar not found: $avatarId'),
    );

    if (avatar.unlockType != AvatarUnlockType.premium) {
      throw Exception('Avatar is not premium');
    }

    if (state.isUnlocked(avatarId)) {
      throw Exception('Avatar already unlocked');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_unlockedPrefix$avatarId', true);

    state = state.copyWith(
      unlockedIds: {...state.unlockedIds, avatarId},
    );
  }

  /// 解放可能な全アバターを取得
  List<AvatarModel> getUnlockedAvatars() =>
      allAvatars.where((a) => state.isUnlocked(a.id)).toList();

  /// ロック中のアバターを取得
  List<AvatarModel> getLockedAvatars() =>
      allAvatars.where((a) => !state.isUnlocked(a.id)).toList();
}

final avatarProvider = NotifierProvider<AvatarNotifier, AvatarState>(
  AvatarNotifier.new,
);
