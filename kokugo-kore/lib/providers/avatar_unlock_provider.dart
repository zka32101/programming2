import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import 'purchased_items_provider.dart';

/// ローカルアバター unlock ロジック
/// - 最初の4つのアバターは無料（デフォルト）
/// - 5番目以降はショップで購入が必要
class AvatarUnlockNotifier extends StateNotifier<Map<String, bool>> {
  final Ref ref;

  // allAvatars（shared_core）の実際の id と一致させる。
  // 以前はここに存在しない架空の id（avatar_panda 等）が入っており、
  // 本来無料のはずの ahiru/inu/kitsune までロックされたままになっていた。
  static const List<String> _freeAvatarIds = [
    'kuroneko',
    'ahiru',
    'inu',
    'kitsune',
  ];

  // ショップで購入が必要なアバター ID リスト（5番目以降・全12種）
  static const List<String> _paidAvatarIds = [
    'honhon',
    'panda',
    'raion',
    'koala',
    'tora',
    'usagi',
    'kaeru',
    'buta',
    'kirin',
    'kangaroo',
    'arai_guma',
    'namakemono',
  ];

  AvatarUnlockNotifier(this.ref) : super({});

  /// アバターがアンロック済みかどうかを判定
  bool isAvatarUnlocked(String avatarId) {
    // 無料アバターはデフォルトでアンロック
    if (_freeAvatarIds.contains(avatarId)) {
      return true;
    }

    // 有料アバターはショップで購入している場合のみアンロック
    final purchasedItemsState = ref.read(purchasedItemsProvider);
    return purchasedItemsState.ownedItemIds.contains(avatarId);
  }

  /// 全アバターのアンロック状態を更新
  void refreshUnlockStatus() {
    final unlockStatus = <String, bool>{};
    for (final avatar in allAvatars) {
      unlockStatus[avatar.id] = isAvatarUnlocked(avatar.id);
    }
    state = unlockStatus;
  }
}

final avatarUnlockProvider = StateNotifierProvider<AvatarUnlockNotifier, Map<String, bool>>(
  (ref) => AvatarUnlockNotifier(ref),
);

/// 無料アバターのみを取得
List<AvatarModel> getFreeAvatars() {
  return allAvatars.where((a) => AvatarUnlockNotifier._freeAvatarIds.contains(a.id)).toList();
}

/// 有料アバターのみを取得
List<AvatarModel> getPaidAvatars() {
  return allAvatars.where((a) => AvatarUnlockNotifier._paidAvatarIds.contains(a.id)).toList();
}
